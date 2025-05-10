function [d, path] = simple_dtw(s, t)
    ns = length(s);
    nt = length(t);

    % Inițializare matrice DTW
    D = inf(ns+1, nt+1);
    D(1,1) = 0;

    % Populare matrice
    for i = 2:ns+1
        for j = 2:nt+1
            cost = abs(s(i-1) - t(j-1));
            D(i,j) = cost + min([D(i-1,j), D(i,j-1), D(i-1,j-1)]);
        end
    end

    d = D(end,end);  % distanța totală DTW

    % ==========================
    % RECONSTRUCȚIE PATH
    % ==========================
    i = ns + 1;
    j = nt + 1;
    path = [];

    while i > 1 && j > 1
        path = [ [i-1, j-1]; path ];  % salvează perechea (index în s, index în t)
        [~, idx] = min([D(i-1,j-1), D(i-1,j), D(i,j-1)]);
        switch idx
            case 1
                i = i - 1;
                j = j - 1;
            case 2
                i = i - 1;
            case 3
                j = j - 1;
        end
    end

    % Adaugă punctul de start
    path = [[1,1]; path];
end
