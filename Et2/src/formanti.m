function [F1, F2] = formanti(s, fs)
    % Conversie si normalizare
    s = double(s(:));
    s = s - mean(s);
    s = s / max(abs(s));
    
    % Filtrare pentru eliminare zgomot joasa frecventa
    s = highpass(s, 70, fs); 
    s = s .* hamming(length(s));

    % FFT
    N_fft = 16384; % Rezolutie mai mare pentru o frecventa de 45kHz
    S = abs(fft(s, N_fft));
    f = (0:N_fft-1) * fs / N_fft;

    % Gasire F1 (300–900 Hz)
    F1_range = [300, 900];
    idx_F1_range = (f >= F1_range(1)) & (f <= F1_range(2));
    [~, local_idx_F1] = max(S(idx_F1_range));
    f1_vals = f(idx_F1_range);
    F1 = f1_vals(local_idx_F1);

    % Gasire F2 (900–3000 Hz)
    F2_range = [900, 3000];
    idx_F2_range = (f >= F2_range(1)) & (f <= F2_range(2));
    [~, local_idx_F2] = max(S(idx_F2_range));
    f2_vals = f(idx_F2_range);
    F2 = f2_vals(local_idx_F2);
end
