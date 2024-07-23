# Web Scraper

Web Scraper aplikacja napisania w Ruby, która umożliwia scrapowanie ogłoszeń samochodowych z wybranej strony internetowej - domyślnie otomoto.pl i generowanie raportów w formacie CSV i PDF.

## Funkcjonalności

- Wyszukiwanie ogłoszeń samochodowych według marki (BMW, Audi, Toyota, Ford, Mercedes).
- Scrapowanie danych z ogłoszeń samochodowych, w tym URL, zdjęcie, nazwa, cena, opis, pojemność silnika, moc silnika, przebieg, typ paliwa, rodzaj skrzyni biegów i rok produkcji.
- Generowanie raportów w formacie CSV i PDF.

## Wymagania

- Ruby 2.7 lub nowszy
- Gem `nokogiri`
- Gem `httparty`
- Gem `wicked_pdf`
- Gem `csv`

## Instalacja

1. Sklonuj repozytorium:

   ```bash
   git clone <URL_REPO>
2. Przejdź do katalogu
   ```bash
    cd <NAZWA_PROJEKTU>
3. Zainstaluj wymagane gemy:

bash

    bundle install
    ruby main.rb

Wprowadź markę samochodu, którą chcesz wyszukać, np. BMW, Audi, Toyota.

Aplikacja pobierze dane o samochodach z podanej strony internetowej i wygeneruje raporty:

    products.csv - plik CSV z danymi produktów.
    products.pdf - plik PDF z danymi produktów.


# Testy jednostkowe

Testy jednostkowe dla klasy Scraper można uruchomić za pomocą RSpec.

Uruchom testy:

    rspec

Przykładowe wyniki dla wygenerowanego PDF:

![image](https://github.com/user-attachments/assets/67fe15db-2b69-4b24-a8ec-a5833299336a)
