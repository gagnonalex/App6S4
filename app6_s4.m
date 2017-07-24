clear all
close all
clc

% RIF multicadence
% -------------------------------------------------------------------------
[s1, fe1] = audioread('signal_A.wav');
[s2, fe2] = audioread('signal_B.wav');

desired_freq = 8000;

plot(abs(fft(s1,fe1)));

rif_filter = rif_lowpass();

s1_filtered = filter(rif_filter, s1);
s1_down = downsample(s1_filtered, fe1/desired_freq);

figure
plot(abs(fft(s1_filtered, desired_freq)));

% RII Butterworth
% -------------------------------------------------------------------------
%% Banc de filtre 
fe = 8000;
% determiner les 6 raies spectrales très franches
spectre = abs(fft(s1_down, fe_down));
plot(spectre);

spectre_positif = spectre(1:(length(spectre)/2));
[peaks freqs]= findpeaks(spectre_positif);


% Sort them in descending order to find the largest ones.
[sortedValues sortedIndexes] = sort((peaks), 'descend');
originalLocations = freqs(sortedIndexes);

raies_spectrales = [ zeros(1,6) ; zeros(1,6) ]';


for k = 1 : min([6, length(sortedValues)])
    fprintf(1, 'Peak #%d = %d, at location %d\n', ...
    k, sortedValues(k), originalLocations(k));
    %matrix(row, column)
    raies_spectrales(k,1) =sortedValues(k) ; % premiere colonne = amplitude
    raies_spectrales(k,2) =originalLocations(k) ; % deuxieme colonne = freqs normalise sur 1(pi)
    
end

text(raies_spectrales(:,2)+.02,raies_spectrales(:,1),num2str((1:numel(raies_spectrales(:,1)))'))

%normalise les frequences
 raies_spectrales(:,2) = raies_spectrales(:,2)./fe*2
%% design des filtre passe-bande
delta = 1/160;

hold on 
[b1 a1] = butter(2,[raies_spectrales(1,2)-delta,raies_spectrales(1,2)+delta],'bandpass');
fvtool(b1,a1);   
title(['butter laissant passer ', num2str(raies_spectrales(1,2)*fe/2),' Hz']);


[b2 a2] = butter(2,[raies_spectrales(2,2)-delta,raies_spectrales(2,2)+delta],'bandpass');
fvtool(b2,a2); 
title(['butter laissant passer ', num2str(raies_spectrales(2,2)*fe/2),' Hz']);


[b3 a3]= butter(2,[raies_spectrales(3,2)-delta,raies_spectrales(3,2)+delta],'bandpass');
fvtool(b3,a3); 
title(['butter laissant passer ', num2str(raies_spectrales(3,2)*fe/2),' Hz']);


[b4 a4] = butter(2,[raies_spectrales(4,2)-delta,raies_spectrales(4,2)+delta],'bandpass');
fvtool(b4,a4); 
title(['butter laissant passer ', num2str(raies_spectrales(4,2)*fe/2),' Hz']);


[b5 a5] = butter(2,[raies_spectrales(5,2)-delta,raies_spectrales(5,2)+delta],'bandpass');
fvtool(b5,a5); 
title(['butter laissant passer ', num2str(raies_spectrales(5,2)*fe/2),' Hz']);


[b6 a6] = butter(2,[raies_spectrales(6,2)-delta,raies_spectrales(6,2)+delta],'bandpass');
fvtool(b6,a6); 
title(['butter laissant passer ', num2str(raies_spectrales(6,2)*fe/2),' Hz']);


s1 = filter(b1,a1,result);
plot(abs(fft(s1, fe_down)));
hold off