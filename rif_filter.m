clear all
close all
clc

[s1, fe] = audioread('signal_A.wav');
fe_down = 8000;
s1_down = downsample(s1, (fe/fe_down));

test = abs(fft(s1_down, fe_down));
plot(test);
allo = rif_filter_design();
freqz(allo);

result = filter(allo, s1_down);
wvtool(result);