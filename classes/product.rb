# frozen_string_literal: true

# Klasa reprezentująca produkt z wszystkimi potrzebnymi informacjami do zakupu.
class Product
  # URL produktu
  attr_accessor :url
  # Obraz produktu
  attr_accessor :image
  # Nazwa produktu
  attr_accessor :name
  # Cena produktu
  attr_accessor :price
  # Opis produktu
  attr_accessor :description
  # Pojemność silnika (w cm³)
  attr_accessor :engine_capacity
  # Moc silnika (w KM)
  attr_accessor :engine_power
  # Przebieg (w km)
  attr_accessor :mileage
  # Rodzaj paliwa
  attr_accessor :fuel_type
  # Skrzynia biegów
  attr_accessor :gearbox
  # Rok produkcji
  attr_accessor :year

  # Utworzenie nowego produktu - konstruktor
  #   @url = url                          # link prowadzący do strony zakupu produktu
  #   @image = image                      # obraz produktu
  #   @name = name                        # nazwa produktu
  #   @price = price                      # cena
  #   @description = description          # opis produktu
  #   @engine_capacity = engine_capacity  # pojemność silnika
  #   @engine_power = engine_power        # moc silnika [KM]
  #   @mileage = mileage                  # przebieg
  #   @fuel_type = fuel_type              # typ paliwa
  #   @gearbox = gearbox                  # skrzynia biegów (manualna/automat)
  #   @year = year                        # rocznik
  def initialize(url:, image:, name:, price:, description:,
                 engine_capacity:, engine_power:, mileage:,
                 fuel_type:, gearbox:, year:)
    @url = url
    @image = image
    @name = name
    @price = price
    @description = description
    @engine_capacity = engine_capacity
    @engine_power = engine_power
    @mileage = mileage
    @fuel_type = fuel_type
    @gearbox = gearbox
    @year = year
  end
end
