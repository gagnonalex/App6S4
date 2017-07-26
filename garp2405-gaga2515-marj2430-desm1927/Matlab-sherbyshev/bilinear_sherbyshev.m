% Michaël Deslauriers-Roy desm1927
% Jérôme Martel marj2430
close all;
clear;
clc

Te = 1/8000;
thetaa = 1450*2*pi/8000;
thetab = 1570*2*pi/8000;
A = 1.965;

wa = 2/Te*tan(thetaa / 2);
wb = 2/Te*tan(thetab / 2);

%% Filtre Analogique

b1 = 0;
b2 = (wb-wa)*A;
b3 = 0;
b = [b1 b2 b3];

a1 = 1;
a2 = (wb-wa)*A;
a3 = wb*wa;
a = [a1 a2 a3];

b = b/a1;
a = a/a1;

figure(1)
freqs(b,a);
title('Amplitude des fréquences pour filtre analogique');
figure(2)
zplane(b,a);
title('Distribution des pôles et zéros pour filtre analogique');

%% Filtre Numérique

b1 = 2*(wb-wa)/Te*A;
b2 = 0*A;
b3 = -2*(wb-wa)/Te*A;
b = [b1 b2 b3];

a1 = 4/(Te^2) + wb*wa + 2*(wb-wa)/Te*A;
a2 = -8/(Te^2) + 2*wb*wa;
a3 = 4/(Te^2) + wb*wa - 2*(wb-wa)/Te*A;
a = [a1 a2 a3];

b = b/a1;
a = a/a1;

figure(3)
freqz(b,a);
title('Amplitude des fréquences pour filtre numérique');
figure(4)
zplane(b,a);
title('Distribution des pôles et zéros pour filtre numérique');


