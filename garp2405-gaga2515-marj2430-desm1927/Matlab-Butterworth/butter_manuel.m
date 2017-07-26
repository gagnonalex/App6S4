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

b1 = 2*(wb-wa)/Te;
b2 = -2*(wb-wa)/Te;
b = [b1 0 b2];

a1 = 4/(Te^2) + wb*wa + 2*(wb-wa)/Te;
a2 = -8/(Te^2) + 2*wb*wa;
a3 = 4/(Te^2) + wb*wa - 2*(wb-wa)/Te;
a = [a1 a2 a3];

freqz(b, a);




[b a] = butter(1, [thetaa/pi thetab/pi], 'bandpass');
figure
freqz(b, a);