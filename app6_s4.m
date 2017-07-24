clear all
close all
clc

% RIF multicadence
% -------------------------------------------------------------------------
[s1, fe1] = audioread('signal_A.wav');
[s2, fe2] = audioread('signal_B.wav');

desired_freq = 8000;

% plot(abs(fft(s1,fe1)));

rif_filter = rif_lowpass();

s1_filtered = filter(rif_filter, s1);
s1_down = downsample(s1_filtered, fe1/desired_freq);

figure
plot(abs(fft(s1_filtered, desired_freq)));