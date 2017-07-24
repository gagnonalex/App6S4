clear all
close all
clc

[s1, fe] = audioread('signal_A.wav');
[s2, fe] = audioread('signal_B.wav');

desired_freq = 8000;

plot(abs(fft(s1,fe)));

rif_filter = rif_lowpass();

s1_filtered = filter(rif_filter, s1);
s1_down = downsample(s1_filtered, fe/desired_freq);

figure
plot(abs(fft(filtered_s1, desired_freq)));