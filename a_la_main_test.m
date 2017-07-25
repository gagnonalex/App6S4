close all
clear all
clc

Te = 1/8000;
freq2 = 607;
freq1 = 393;
thetab = 2*pi*(freq2/8000);
thetaa = 2*pi*(freq1/8000);

wa = 2/Te*tan(thetaa/2);
wb = 2/Te*tan(thetab/2);

syms z;
b = 2*(wb-wa)*z^2/Te - 2*(wb-wa)/Te;
disp(sym2poly(b));

a = (4/Te^2) * (z^2-2*z+1) + wa*wb*(z^2+2*z+1) + (wb-wa)*(2/Te)*(z^2-1);

freqz(sym2poly(b), sym2poly(a));



[b a] = butter(1, [thetaa/pi thetab/pi], 'bandpass');
figure
freqz(b, a);