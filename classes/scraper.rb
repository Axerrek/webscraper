# frozen_string_literal: true
require 'nokogiri'
require 'httparty'
require 'wicked_pdf'
require 'csv'
require_relative 'product'

# == Klasa odpowiedzialna za scrapowanie danych z podanych stron internetowych
#
# Klasa `Scraper` służy do pobierania i przetwarzania informacji o produktach z różnych stron internetowych.
# Używa biblioteki `HTTParty` do pobierania treści stron oraz `Nokogiri` do parsowania HTML.
# Scrapowane dane są następnie przetwarzane i mogą być zapisywane do pliku CSV.
#
# Przykład użycia:
#
#
#   scraper = Scraper.new('https://example.com/products', 3)
#   products = scraper.scrape
#   scraper.generate_csv(products)
class Scraper
  ## Utworzenie obiektu scraper, który wyszukuje produkty
  #   @base_url = base_url # link strony do przeglądania
  #   @pages = pages       # ilość stron, do przeszukiwania
  def initialize(base_url, pages = 2)
    @base_url = base_url
    @pages = pages
  end

  # Pobiera i przetwarza dane produktów ze stron internetowych
  def scrape
    products = []

    (1..@pages).each do |page|
      url = page == 1 ? @base_url : "#{@base_url}?page=#{page}"
      response = HTTParty.get(url, headers: {
        'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36'
      })

      document = Nokogiri::HTML(response.body)
      html_products = document.xpath('//article[@data-highlighted="true"]')

      html_products.each do |html_product|
        url_element = html_product.at_xpath('.//h1//a')
        url = url_element ? url_element['href'] : 'No URL'

        image_element = html_product.at_xpath('.//div//img')
        image = image_element ? image_element['src'] : 'No Image'
        image = image.gsub(/;s=320x240$/, '') if image != 'No Image'

        name_element = html_product.at_xpath('.//h1//a')
        name = name_element ? name_element.text.strip : 'No Name'

        price_element = html_product.at_xpath('.//h3')
        price = price_element ? price_element.text.strip : 'No Price'

        description_element = html_product.at_xpath('.//p')
        description = description_element ? description_element.text.strip : 'No Description'

        engine_info = description.split(' • ')
        engine_capacity, engine_power = engine_info

        mileage_element = html_product.at_xpath('.//dd[@data-parameter=\'mileage\']')
        mileage = mileage_element ? mileage_element.text.strip : 'Unknown'
        fuel_type_element = html_product.at_xpath('.//dd[@data-parameter=\'fuel_type\']')
        fuel_type = fuel_type_element ? fuel_type_element.text.strip : 'Unknown'
        gearbox_element = html_product.at_xpath('.//dd[@data-parameter=\'gearbox\']')
        gearbox = gearbox_element ? gearbox_element.text.strip : 'Unknown'
        year_element = html_product.at_xpath('.//dd[@data-parameter=\'year\']')
        year = year_element ? year_element.text.strip : 'Unknown'

        product = Product.new(
          url: url,
          image: image,
          name: name,
          price: price,
          description: description,
          engine_capacity: engine_capacity,
          engine_power: engine_power,
          mileage: mileage,
          fuel_type: fuel_type,
          gearbox: gearbox,
          year: year
        )
        products.push(product)
      end
    end
    products
  end

  # Generuje plik CSV z danymi produktów
  def generate_csv(products, filename = 'products.csv')
    CSV.open(filename, 'wb') do |csv|
      csv << ['URL', 'Image', 'Name', 'Price', 'Description', 'Engine Capacity', 'Engine Power', 'Mileage', 'Fuel Type', 'Gearbox', 'Year']
      products.each do |product|
        csv << [
          product.url,
          product.image,
          product.name,
          product.price,
          product.description,
          product.engine_capacity,
          product.engine_power,
          product.mileage,
          product.fuel_type,
          product.gearbox,
          product.year
        ]
      end
    end
  end

  # Generuje plik PDF z danymi produktów
  def generate_pdf(products, brand)
    css_file = File.read('styles/style.css')
    pdf_html = "<html><meta charset='UTF-8'><head><style>#{css_file}</style></head><body>"
    pdf_html += "<h1>Wyszukiwane auta marki: #{brand}<br> ilość przeszukiwanych stron: #{@pages}</h1>"
    products.each do |product|
      pdf_html += "<div class='product'>"
      pdf_html += "<div class='left'><img src='#{product.image}' alt='Zdjęcie produktu'></div>"
      pdf_html += "<div class='right'><div class='info'>"
      pdf_html += "<h2>#{product.name}</h2><div class='price-and-description'>"
      pdf_html += "<p class='price'>Cena: #{product.price} PLN</p>"
      pdf_html += '</div></div><h3>Opis:</h3>'
      pdf_html += "<p>#{product.description}</p><dl class='details-list'>"
      pdf_html += "<div><dt>Rok:</dt><dd>#{product.year}</dd></div>"
      pdf_html += "<div><dt>Przebieg:</dt><dd>#{product.mileage} km</dd></div>"
      pdf_html += "<div><dt>Pojemność silnika:</dt><dd>#{product.engine_capacity}</dd></div>"
      pdf_html += "<div><dt>Moce silnika:</dt><dd>#{product.engine_power} KM</dd></div>"
      pdf_html += "<div><dt>Typ paliwa:</dt><dd>#{product.fuel_type}</dd></div>"
      pdf_html += "<div><dt>Skrzynia biegów:</dt><dd>#{product.gearbox}</dd></div></dl>"
      pdf_html += "<a href='#{product.url}' class='more-info'>Więcej informacji</a></div></div>"
    end
    pdf_html += '</body></html>'
    pdf = WickedPdf.new.pdf_from_string(pdf_html)
    File.open('products.pdf', 'wb') do |file|
      file.write(pdf)
    end
  end
end
