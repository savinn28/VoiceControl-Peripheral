% ============================
% ÎNCĂRCARE SEMNAL TEST
% ============================

T = load('test_vocala.txt');       % vocala rostită recent
T = double(T(:));                  % conversie în coloană

% ============================
% ÎNCĂRCARE ETICHETE VOCALE
% ============================

etichete.A = load('eticheta_A.txt');
etichete.E = load('eticheta_E.txt');
etichete.I = load('eticheta_I.txt');
etichete.O = load('eticheta_O.txt');
etichete.U = load('eticheta_U.txt');

% Conversie în vectori coloană
campuri = fieldnames(etichete);
for i = 1:length(campuri)
    etichete.(campuri{i}) = double(etichete.(campuri{i})(:));
end

% ============================
% PARAMETRI
% ============================

nr_perioade = 3;
esantioane_per_perioada = 200;
lungime_fereastra = nr_perioade * esantioane_per_perioada;

% Extragem o fereastră centrală din semnalul T
start_T = round(length(T)/2 - lungime_fereastra/2);
end_T = start_T + lungime_fereastra - 1;
T_window = T(start_T:end_T);

% ============================
% CALCUL SCORURI XCORR & DTW
% ============================

vocale = fieldnames(etichete);
scoruri_xcorr = zeros(length(vocale), 1);
scoruri_dtw   = zeros(length(vocale), 1);
paths = cell(length(vocale), 1);

for i = 1:length(vocale)
    vocala = vocale{i};
    ET = etichete.(vocala);

    % Extragem din eticheta o fereastra de lungime similara
    start_ET = round(length(ET)/2 - lungime_fereastra/2);
    end_ET = start_ET + lungime_fereastra - 1;

    if start_ET > 0 && end_ET <= length(ET)
        ET_window = ET(start_ET:end_ET);

        % Cross-correlation
        [xc, ~] = xcorr(T_window, ET_window, 'coeff');
        scoruri_xcorr(i) = max(xc);

        % Dynamic Time Warping
        [scoruri_dtw(i), paths{i}] = simple_dtw(T_window, ET_window);
    else
        scoruri_xcorr(i) = -Inf;
        scoruri_dtw(i) = Inf;
        paths{i} = [];
    end
end

% ============================
% DECIZIE FINALĂ: după DTW
% ============================

[~, idx_dtw] = min(scoruri_dtw);
vocala_recunoscuta = vocale{idx_dtw};
ET_final = etichete.(vocala_recunoscuta);

% Extragem fereastra pentru afisare
start_ET = round(length(ET_final)/2 - lungime_fereastra/2);
ET_window = ET_final(start_ET : start_ET + lungime_fereastra - 1);

% Aliniere DTW pe baza path-ului
path = paths{idx_dtw};
ET_warped = NaN(size(T_window));
for k = 1:size(path,1)
    ET_warped(path(k,1)) = ET_window(path(k,2));
end

% ============================
% GRAFIC SUPRAPUNERE (DTW)
% ============================

figure;
plot(T_window, 'b', 'LineWidth', 1.5); hold on;
plot(ET_warped, 'r', 'LineWidth', 1.5);
legend('Semnal Test', ['Etichetă "', vocala_recunoscuta, '" (DTW aliniată)']);
xlabel('Index eșantion');
ylabel('Valoare ADC');
title(['Aliniere DTW: vocala "', vocala_recunoscuta, '"']);
grid on;

% ============================
% AFIȘARE SCORURI
% ============================

fprintf("\nScoruri de corelație maximă (XCORR):\n");
for i = 1:length(vocale)
    fprintf("  %s: %.4f\n", vocale{i}, scoruri_xcorr(i));
end

fprintf("\nDistanțe DTW:\n");
for i = 1:length(vocale)
    fprintf("  %s: %.2f\n", vocale{i}, scoruri_dtw(i));
end

fprintf("\nVocala recunoscută (DTW): %s\n", vocala_recunoscuta);
