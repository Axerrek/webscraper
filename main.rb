# frozen_string_literal: true

require_relative 'classes/scraper'
require 'logger'
puts 'Enter the car brand you want to search for (e.g., BMW, Audi, Toyota):'
brand = gets.chomp.strip

link = case brand.downcase
       when 'bmw'
         'https://www.otomoto.pl/osobowe/bmw'
       when 'audi'
         'https://www.otomoto.pl/osobowe/audi'
       when 'toyota'
         'https://www.otomoto.pl/osobowe/toyota'
       when 'ford'
         'https://www.otomoto.pl/osobowe/ford'
       when 'mercedes'
         'https://www.otomoto.pl/osobowe/mercedes'
       else
         puts 'Brand not recognized. Please enter a valid car brand.'
         exit
       end
puts "Searching for #{brand.capitalize} cars at: #{link}"

logger = Logger.new('log.txt')


begin
  scraper = Scraper.new(link)

  products = scraper.scrape

  products.each do |product|
    puts "URL: #{product.url}"
    puts "Nazwa: #{product.name}"
    puts "Obraz: #{product.image}"
    puts "Cena: #{product.price} PLN"
    puts "Opis: #{product.description}"
    puts "Pojemność silnika: #{product.engine_capacity}"
    puts "Moc silnika: #{product.engine_power}"
    puts "Przebieg: #{product.mileage}"
    puts "Typ paliwa: #{product.fuel_type}"
    puts "Rodzaj skrzyni biegów: #{product.gearbox}"
    puts "Rocznik: #{product.year}"
    puts '----------------------------'
  end

  scraper.generate_csv(products)

  scraper.generate_pdf(products, brand)
rescue StandardError => e
  # Logowanie błędów do pliku log.txt
  logger.error("Wystąpił błąd: #{e.message}")
  logger.error(e.backtrace.join("\n"))
end