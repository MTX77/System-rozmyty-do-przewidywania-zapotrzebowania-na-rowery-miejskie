# System Rozmyty do Przewidywania Zapotrzebowania na Rowery Miejskie

## **Opis projektu**
Projekt ten dotyczy opracowania systemu wnioskowania rozmytego, który na podstawie zmiennych wejściowych, takich jak pogoda, temperatura, wilgotność, prędkość wiatru, pora roku oraz godzina, przewiduje liczbę wypożyczeń rowerów miejskich. System został zrealizowany przy użyciu modelu Takagi-Sugeno z wykorzystaniem **ANFIS** (Adaptive Neuro-Fuzzy Inference System), który łączy logikę rozmytą z sieciami neuronowymi.

Opracowany model jest szczególnie przydatny w optymalizacji zarządzania flotą rowerów miejskich, pozwalając na przewidywanie zapotrzebowania w różnych lokalizacjach i czasie, co może poprawić dostępność rowerów oraz zredukować koszty operacyjne.

---

## **Funkcjonalności**
- Przewidywanie liczby wypożyczeń rowerów miejskich na podstawie danych pogodowych, godzinowych i sezonowych.
- Automatyczna generacja reguł rozmytych na podstawie danych treningowych przy użyciu modelu Takagi-Sugeno.
- Uczenie modelu z wykorzystaniem algorytmu ANFIS, który dostraja parametry funkcji przynależności oraz wagi reguł.
- Wizualizacja wyników, w tym:
  - Krzywa uczenia (zmniejszanie błędu w miarę epok treningowych).
  - Porównanie rzeczywistych i przewidywanych wartości.

---

## **Dane wejściowe**
Dane uczące pochodzą z bazy danych **Bike Sharing Demand Dataset** dostępnej na [Kaggle](https://www.kaggle.com/competitions/bike-sharing-demand/data). Przykładowe zmienne wejściowe:
- **Pogoda (weather)**: Kategoryczne warunki pogodowe (np. czyste niebo, deszcz, śnieg).
- **Pora roku (season)**: Wartości kategoryczne (1: wiosna, 2: lato, 3: jesień, 4: zima).
- **Temperatura (temp)**: Średnia temperatura w stopniach Celsjusza.
- **Wilgotność (humidity)**: Wilgotność względna w procentach.
- **Prędkość wiatru (windspeed)**: Mierzona w km/h.
- **Godzina (hour)**: Format 24-godzinny (0-23).

Zmienna wyjściowa to liczba wypożyczeń rowerów miejskich (`count`).

---

## **Technologie**
- **MATLAB**: Środowisko do budowy i analizy modeli wnioskowania rozmytego.
- **ANFIS**: Implementacja w MATLAB do generowania i trenowania systemów rozmytych.
- **Funkcje MATLAB**:
  - `readtable`: Wczytywanie danych z plików CSV.
  - `genfis1`: Generowanie początkowego systemu rozmytego.
  - Funkcje przetwarzania danych: normalizacja, podział na zbiory treningowe i testowe.

---

## **Wyniki**
- **Współczynnik determinacji (R²):** ~0.63 – wskazuje na umiarkowaną zgodność modelu z danymi rzeczywistymi.
- **Błąd średniokwadratowy (MSE):** ~12104.62 – obrazuje średni kwadrat różnic między rzeczywistymi a przewidywanymi wartościami liczby wypożyczeń.
- **Krzywa uczenia**: Wykazuje stabilizację błędu RMSE (~0.106 dla treningu i ~0.114 dla walidacji) po około 100 epokach.

---

## **Możliwości zastosowania**
- **Zarządzanie flotą rowerów miejskich**: Optymalizacja rozmieszczenia rowerów w stacjach i planowanie zasobów.
- **Planowanie serwisów**: Prognozy pozwalają na efektywne planowanie konserwacji.
- **Strategie marketingowe**: Identyfikacja okresów zwiększonego popytu.

---

## **Pliki projektu**
- **`dane_clean.csv`**: Oczyszczone dane wejściowe.
- **`anfis_model.m`**: Skrypt MATLAB do budowy, treningu i analizy modelu ANFIS.
- **`krzywa_uczenia.png`**: Krzywa uczenia ANFIS.
- **`porownanie_wartosci.png`**: Wykres porównujący rzeczywiste i przewidywane wartości.

---

## **Jak uruchomić?**
1. Pobierz projekt i pliki danych.
2. Uruchom środowisko MATLAB.
3. Wczytaj dane za pomocą skryptu:
   ```matlab
   data = readtable('dane_clean.csv');
   ```
4. Wykonaj skrypt `anfis_model.m`, aby trenować model i wizualizować wyniki.

---

## **Dalszy rozwój**
- Dodanie zmiennych demograficznych (np. gęstość zaludnienia).
- Integracja modelu z rzeczywistymi systemami wypożyczalni rowerów.
- Rozbudowa o dane czasowe (np. wydarzenia specjalne, dni świąteczne).

---

## **Źródła**
- [MathWorks - Dokumentacja ANFIS](https://www.mathworks.com/help/fuzzy/adaptive-neuro-fuzzy-inference-systems.html)
- [Kaggle - Bike Sharing Demand Dataset](https://www.kaggle.com/competitions/bike-sharing-demand/data)

---

**Data oddania:** 02.12.2024
