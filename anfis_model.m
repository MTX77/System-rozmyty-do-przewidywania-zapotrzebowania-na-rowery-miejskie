% 1. Wczytanie danych
data = readtable('D:\Studia\inzynieria_wiedzy\projekt\dane_clean.csv');

% 2. Wybór istotnych zmiennych wejściowych
% Usunięcie 'dayofweek', 'holiday', 'workingday'
selectedData = data(:, {'season', 'weather', 'temp', 'humidity', 'windspeed', 'hour', 'count'});

% 3. input i output
inputData = selectedData(:,1:end-1);
outputData = selectedData(:,end);

% 4. Normalizacja Danych
inputMin = min(inputData);
inputMax = max(inputData);

outputMin = min(outputData);
outputMax = max(outputData);

% Normalizacja wejść
inputNorm = (inputData - inputMin) ./ (inputMax - inputMin);

% Normalizacja wyjścia
outputNorm = (outputData - outputMin) ./ (outputMax - outputMin);

% Połączenie danych wejściowych i wyjściowych
anfisData = [inputNorm, outputNorm];

% 5. Podział Danych na Zestawy Treningowe i Testowe
numSamples = size(anfisData, 1);
randIndices = randperm(numSamples);

trainRatio = 0.9;
trainSize = round(trainRatio * numSamples);

trainData = anfisData(randIndices(1:trainSize), :);
testData = anfisData(randIndices(trainSize+1:end), :);

% Oddzielenie zmiennych wejściowych i wyjściowych
trainInputs = trainData(:, 1:end-1);
trainOutputs = trainData(:, end);

testInputs = testData(:, 1:end-1);
testOutputs = testData(:, end);

% Zmiana na macierze
trainInputsArray = table2array(trainInputs);
trainOutputsArray = table2array(trainOutputs);
testInputsArray = table2array(testInputs);
testOutputsArray = table2array(testOutputs);

% 6. Tworzenie Początkowego Systemu FIS z 'genfis'
numMFs = 2;
MFType = "trapmf";

% Generowanie FIS
initialFIS = genfis1([trainInputsArray, trainOutputsArray], numMFs, MFType);

% 8. Ustawienia ANFIS
anfisOptions = anfisOptions("InitialFIS", initialFIS, "EpochNumber", 100, "ValidationData", [testInputsArray, testOutputsArray], 'DisplayErrorValues', true, ...
 'DisplayStepSize', true, ...
 'DisplayFinalResults', true);

% Sprawdzenie liczby reguł
numRules = length(initialFIS.Rules);
fprintf('Liczba reguł: %d\n', numRules);

% 9. Trenowanie ANFIS
[trainedFIS, trainError, stepSize, chkFIS, chkError] = anfis([trainInputsArray, trainOutputsArray], anfisOptions);

% 10. Przewidywanie na Zestawie Testowym
predictedOutputsNorm = evalfis(trainedFIS, testInputsArray);

% Denormalizacja przewidywanych wartości
predictedCounts = predictedOutputsNorm * table2array((outputMax - outputMin)) + table2array(outputMin);

% Denormalizacja rzeczywistych wartości
actualCounts = testOutputsArray * table2array((outputMax - outputMin)) + table2array(outputMin);

% 11. Zapobieganie Ujemnym i Niecałkowitym Predykcjom
predictedCounts = round(predictedCounts);  % Zaokrąglenie do najbliższej liczby całkowitej
predictedCounts(predictedCounts < 0) = 0;   % Zapewnienie, że wartości są co najmniej 0

% 12. Ocena Dokładności Modelu
mse = mean((actualCounts - predictedCounts).^2);
fprintf('Błąd średniokwadratowy (MSE): %.2f\n', mse);

SS_res = sum((actualCounts - predictedCounts).^2);
SS_tot = sum((actualCounts - mean(actualCounts)).^2);
R2 = 1 - (SS_res / SS_tot);
fprintf('Współczynnik determinacji (R²): %.2f\n', R2);

% 13. Tworzenie tabeli porównawczej dla pierwszych 50 próbek
numDisplay = min(50, length(actualCounts));
results = table((1:numDisplay)', actualCounts(1:numDisplay), predictedCounts(1:numDisplay), ...
    'VariableNames', {'DataPoint', 'ActualCount', 'PredictedCount'});
disp(results);

% 14. Tworzenie wykresu porównawczego dla pierwszych 100 próbek
figure;
plot(1:numDisplay, actualCounts(1:numDisplay), 'bo-', 'LineWidth', 2, 'MarkerSize',8);
hold on;
plot(1:numDisplay, predictedCounts(1:numDisplay), 'rx-', 'LineWidth', 2, 'MarkerSize',8);
legend('Rzeczywiste', 'Przewidywane', 'Location', 'best');
xlabel('Numer Próbki');
ylabel('Liczba Wypożyczeń');
title('Porównanie Rzeczywistych i Przewidywanych Liczb Wypożyczeń (Pierwsze 50 Prób)');
grid on;
hold off;

% 15. Wizualizacja Krzywej Uczenia
figure;
plot(trainError, 'LineWidth', 2);
xlabel('Epoka');
ylabel('Błąd Średniokwadratowy');
title('Krzywa Uczenia ANFIS');
grid on;