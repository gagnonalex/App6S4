clear all
close all
clc

[s1, fe] = audioread('signal_A.wav');
fe_down = 8000;
s1_down = downsample(s1, (fe/fe_down));


allo = rif_filter_design();
% freqz(allo);

result = filter(allo, s1_down);
% wvtool(result);

%% Banc de filtre 

%determiner les 6 raies spectrales très franches
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
    raies_spectrales(k,2) =originalLocations(k) ; % deuxieme colonne = freqs
    
end

text(raies_spectrales(:,2)+.02,raies_spectrales(:,1),num2str((1:numel(raies_spectrales(:,1)))'))

%% design des filtre passe-bande
delta = 1/16;
[a1 b1] = butter(2,raies_spectrales(1,2)-delta,raies_spectrales(1,2)+delta,'bandpass');
plot(butter(2,raies_spectrales(1,2)-delta,raies_spectrales(1,2)+delta,'bandpass'));

[a2 b2] = butter(2,raies_spectrales(1,2)-delta,raies_spectrales(1,2)+delta),'bandpass');
plot(

[a3 b3] = butter(2,raies_spectrales(1,2)-delta,raies_spectrales(1,2)+delta),'bandpass');
plot(

[a4 b4] = butter(2,raies_spectrales(1,2)-delta,raies_spectrales(1,2)+delta),'bandpass');
plot(

[a5 b5] = butter(2,raies_spectrales(1,2)-delta,raies_spectrales(1,2)+delta),'bandpass');
plot(

[a6 b6] = butter(2,raies_spectrales(1,2)-delta,raies_spectrales(1,2)+delta),'bandpass');
plot(nutter(2,raies_spectrales(1,2)-delta,raies_spectrales(1,2)+delta),'bandpass'););