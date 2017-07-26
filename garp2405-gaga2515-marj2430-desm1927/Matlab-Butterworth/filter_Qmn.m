function [y] = filter_Qmn(x,b,a,base,m,n)

% Cette fonction permet de filter des donner en applicant un format d�sir� en nombre sign�.

% x    => Signal d'entr�e � filtrer
% y    => Signal de sortie filtr�
% b    => Polyn�me du num�rateur du filtre
% a    => Polyn�me du d�nominateur du filtre
% base => Base de repr�sentation
% m    => Nombre de chiffre entier (avant la virgule)
% n    => Nombre de chiffre fractionnaire (apr�s la virgule)

%  Ex : Q4,3 repr�sentation sur 8 bits (� 0000,000) => base = 2, m = 4 et n = 3

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