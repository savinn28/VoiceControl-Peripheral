% ============================
% INCARCARE SEMNAL TEST
% ============================
T = load('test_vocala.txt');      
T = double(T(:));                  % conversie în coloană

% ============================
% PARAMETRI & FERESTRĂ CENTRALĂ
% ============================
nr_perioade = 7;
esantioane_per_perioada = 200;
lungime_fereastra = nr_perioade * esantioane_per_perioada;

start_T = round(length(T)/2 - lungime_fereastra/2);
end_T = start_T + lungime_fereastra - 1;
T_window = T(start_T:end_T);

fs = 45000; % rata de esantionare in Hz

% ============================
% ETAPA 2: FORMANTI F1 & F2
% ============================

% Calcul formanți pentru semnalul test
[F1_test, F2_test] = formanti(T_window, fs);

% Calcule pentru etichete
vocale = fieldnames(etichete);
distanta_formanti = zeros(length(vocale), 1);
F1_vect = zeros(length(vocale), 1);
F2_vect = zeros(length(vocale), 1);

for i = 1:length(vocale)
    vocala = vocale{i};
    ET = etichete.(vocala);

    % Extrage fereastră centrală din etichetă
    start_ET = round(length(ET)/2 - lungime_fereastra/2);
    ET_window = ET(start_ET : start_ET + lungime_fereastra - 1);

    % Formanți etichetă
    [F1_et, F2_et] = formanti(ET_window, fs);
    F1_vect(i) = F1_et;
    F2_vect(i) = F2_et;

    % Distanță euclidiană în spațiul formantic
    distanta_formanti(i) = sqrt((F1_et - F1_test)^2 + (F2_et - F2_test)^2);
end

% ============================
% DECIZIE FINALĂ (F1, F2)
% ============================
[~, idx_formanti] = min(distanta_formanti);
vocala_recunoscuta = vocale{idx_formanti};

fprintf("\n=== REZULTAT RECONOASTERE (F1/F2) ===\n");
fprintf("Vocala recunoscută: %s\n", vocala_recunoscuta);

% ============================
% DIAGRAMA FORMANȚI (spațiu F1-F2)
% ============================
figure;
hold on;
grid on;

% Culori pentru fiecare vocala
colors = lines(length(vocale));

% Afisare etichete (vocale din baza de date)
for i = 1:length(vocale)
    scatter(F1_vect(i), F2_vect(i), 100, colors(i,:), 'filled');
    text(F1_vect(i)+5, F2_vect(i), vocale{i}, 'FontSize', 12);
end

% Afisare semnal de test
scatter(F1_test, F2_test, 120, 'k', 'filled'); % punct negru pentru test
text(F1_test+5, F2_test, ['TEST → ' vocala_recunoscuta], 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');

% Setari grafic
xlabel('F1 (Hz)');
ylabel('F2 (Hz)');
title('Spațiu vocalic F1-F2');
set(gca, 'YDir', 'reverse'); % inversam axa Y - uzual in fonetica
legend([vocale; 'TEST'], 'Location', 'bestoutside');
axis tight;

