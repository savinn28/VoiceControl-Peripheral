%d = scorul final (costul minim de deformare intre cele douz semnale)
%path = lista de potriviri (indexi corespondenti intre s si t) pentru a le alinia cat mai bine

function [d, path] = simple_dtw(s, t)
    ns = length(s);
    nt = length(t);

    D = inf(ns+1, nt+1);
    D(1,1) = 0;

    for i = 2:ns+1
        for j = 2:nt+1
            cost = abs(s(i-1) - t(j-1));
            D(i,j) = cost + min([D(i-1,j), D(i,j-1), D(i-1,j-1)]);
        end
    end

    d = D(end,end);  


    % path - calea optima de aliniere calculata de algoritmul DTW, adica ce element 
    % din semnalul test corespunde fiecarui element din eticheta vocala, tinand cont 
    % de diferentele de durata, intindere sau decalaj.
    i = ns + 1;
    j = nt + 1;
    path = [];

    while i > 1 && j > 1
        path = [ [i-1, j-1]; path ];  
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

    path = [[1,1]; path];
end
