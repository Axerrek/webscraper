# frozen_string_literal: true

require 'spec_helper'
require_relative '../../classes/scraper'
require_relative '../../classes/product'
require 'csv'

RSpec.describe Scraper do
  describe '#generate_csv' do
    it 'creates a CSV file with product data' do
      scraper = Scraper.new('http://example.com')
      product = Product.new(
        url: 'http://example.com/product1',
        image: 'http://example.com/image1.jpg',
        name: 'Product 1',
        price: '$100',
        description: 'Engine: 2000cc • 150hp',
        engine_capacity: '2000cc',
        engine_power: '150hp',
        mileage: '10000',
        fuel_type: 'Petrol',
        gearbox: 'Manual',
        year: '2020'
      )
      scraper.generate_csv([product], 'spec/temp_products.csv')

      csv_content = CSV.read('spec/temp_products.csv', headers: true, encoding: 'UTF-8')
      expect(csv_content.size).to eq(1)
      row = csv_content.first
      expect(row['URL']).to eq('http://example.com/product1')
      expect(row['Image']).to eq('http://example.com/image1.jpg')
      expect(row['Name']).to eq('Product 1')
      expect(row['Price']).to eq('7 000')
      expect(row['Description']).to eq('Engine: 2000cc • 150KM')
      expect(row['Engine Capacity']).to eq('2000cc')
      expect(row['Engine Power']).to eq('150hp')
      expect(row['Mileage']).to eq('10000')
      expect(row['Fuel Type']).to eq('Petrol')
      expect(row['Gearbox']).to eq('Manual')
      expect(row['Year']).to eq('2020')
    end
  end
end
