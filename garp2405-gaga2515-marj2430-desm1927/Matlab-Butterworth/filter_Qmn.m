function [y] = filter_Qmn(x,b,a,base,m,n)

% Cette fonction permet de filter des donner en applicant un format désiré en nombre signé.

% x    => Signal d'entrée à filtrer
% y    => Signal de sortie filtré
% b    => Polynôme du numérateur du filtre
% a    => Polynôme du dénominateur du filtre
% base => Base de représentation
% m    => Nombre de chiffre entier (avant la virgule)
% n    => Nombre de chiffre fractionnaire (après la virgule)

%  Ex : Q4,3 représentation sur 8 bits (± 0000,000) => base = 2, m = 4 et n = 3

L = length(x);
xn = b;
yn = [-a(2:end)];
lxn = length(xn);
lyn = length(yn);
lxnyn = max([length(xn) length(yn)]);
y = zeros(1,L);
for i=1:L
    for k=1:lxnyn
        if i-k+1 > 0 & k <= lxn
            y(i) = y(i) + round( x(i-k+1)*xn(k) * base^n)/base^n;
            if abs(y(i)) > base^m
                y(i) = sign(y(i)) * base^m;
            end
        end
        if i-k > 0 & k <= lyn
            y(i) = y(i) + round( y(i-k)*yn(k) * base^n)/base^n;
            if abs(y(i)) > base^m
                y(i) = sign(y(i)) * base^m;
            end
        end
    end
end