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
s1 = [s1; zeros(42,1)];
s1_filtered = filter(rif_filter, s1);
s1_filtered = s1_filtered(43:end);
s1_down = downsample(s1_filtered, fe1/desired_freq);

figure
plot(abs(fft(s1_filtered, desired_freq)));


% RII Butterworth
% -------------------------------------------------------------------------
%% Banc de filtre 
fe = 8000;
% determiner les 6 raies spectrales très franches

spectre = abs(fft(s1_down, desired_freq));

plot(0:8000-1,spectre);

spectre_positif = spectre(1:(length(spectre)/2));
[peaks freq]= findpeaks(spectre_positif);


% Sort them in descending order to find the largest ones.
[sortedValues sortedIndexes] = sort((peaks), 'descend');
originalLocations = freq(sortedIndexes);

raies_spectrales = [ zeros(1,6) ; zeros(1,6) ]';


for k = 1 : min([6, length(sortedValues)])
    fprintf(1, 'Peak #%d = %d, at location %d\n', ...
    k, sortedValues(k), originalLocations(k)- 1 ); % on soustrait un car on doit partir a 0 

    %matrix(row, column)
    raies_spectrales(k,1) =sortedValues(k) ; % premiere colonne = amplitude
    raies_spectrales(k,2) =originalLocations(k) ; % deuxieme colonne = freqs normalise sur 1(pi)
    
end

text(raies_spectrales(:,2)+.02,raies_spectrales(:,1),num2str((1:numel(raies_spectrales(:,1)))'))

%normalise les frequences
 raies_spectrales(:,2) = raies_spectrales(:,2)./fe*2
%% design des filtre passe-bande
delta = 107/fe*2;

hold on  % utiliser hold on et freqz pour superposer les filtres
[b1 a1] = butter(1,[raies_spectrales(1,2)-delta,raies_spectrales(1,2)+delta],'bandpass');
% fvtool(b1,a1);   
title(['butter laissant passer ', num2str(raies_spectrales(1,2)*fe/2),' Hz']);


[b2 a2] = butter(1,[raies_spectrales(2,2)-delta,raies_spectrales(2,2)+delta],'bandpass');
% fvtool(b2,a2); 
title(['butter laissant passer ', num2str(raies_spectrales(2,2)*fe/2),' Hz']);


[b3 a3]= butter(1,[raies_spectrales(3,2)-delta,raies_spectrales(3,2)+delta],'bandpass');
% fvtool(b3,a3); 
title(['butter laissant passer ', num2str(raies_spectrales(3,2)*fe/2),' Hz']);


[b4 a4] = butter(1,[raies_spectrales(4,2)-delta,raies_spectrales(4,2)+delta],'bandpass');
% fvtool(b4,a4); 
title(['butter laissant passer ', num2str(raies_spectrales(4,2)*fe/2),' Hz']);


[b5 a5] = butter(2,[raies_spectrales(5,2)-delta,raies_spectrales(5,2)+delta],'bandpass');
% fvtool(b5,a5); 
title(['butter laissant passer ', num2str(raies_spectrales(5,2)*fe/2),' Hz']);


[b6 a6] = butter(1,[raies_spectrales(6,2)-delta,raies_spectrales(6,2)+delta],'bandpass');
% fvtool(b6,a6); 
title(['butter laissant passer ', num2str(raies_spectrales(6,2)*fe/2),' Hz']);


%% bit checking ( 192 dwonsampled a 32 avec delai de groupe de 8 )

%%trouvwr graphiquement avec FDA = 12

rii_grp_delay = 12;
s1_down = [s1_down; zeros(rii_grp_delay,1)];

f1 = filter(b1,a1,s1_down);
f1 = f1(rii_grp_delay+1:end);

f2 = filter(b2,a2,s1_down);
f2 = f2(rii_grp_delay+1:end);

f3 = filter(b3,a3,s1_down);
f3 = f3(rii_grp_delay+1:end);

f4 = filter(b4,a4,s1_down);
f4 = f4(rii_grp_delay+1:end);

f5 = filter(b5,a5,s1_down);
f5 = f5(rii_grp_delay+1:end);

f6 = filter(b6,a6,s1_down);
f6 = f6(rii_grp_delay+1:end);

%Init tableau de la loop
image_bits=[0];
tab_bit_1 = [0];

cpt=0;
seuil = 0.03;
bond = 31;
nuage_bits1 = [zeros(1, length(f1)/32)];
nuage_bits2 = [zeros(1, length(f1)/32)];
nuage_bits3 = [zeros(1, length(f1)/32)];
nuage_bits4 = [zeros(1, length(f1)/32)];
nuage_bits5 = [zeros(1, length(f1)/32)];
nuage_bits6 = [zeros(1, length(f1)/32)];

for index = 1:32:length(f1)-bond
    cpt=cpt+1;
   bit1 = 0;
   bit2 = 0;
   bit3 = 0;
   bit4 = 0;
   bit5 = 0;
   bit6 = 0;   
   
mean_bit1 = mean(abs((f1(index:index+bond).*triang(32))));
if((mean_bit1>=seuil));
    bit1=1;
end

mean_bit2 = mean(abs((f2(index:index+bond).*triang(32))));
if((mean_bit2>=seuil));
    bit2=1;
end

mean_bit3 = mean(abs((f3(index:index+bond).*triang(32))));
if((mean_bit3>=seuil));
    bit3=1;
end

mean_bit4 = mean(abs((f4(index:index+bond).*triang(32))));
if((mean_bit4>=seuil));
    bit4=1;
end

mean_bit5 = mean(abs((f5(index:index+bond).*triang(32))));
if((mean_bit5>=seuil));
    bit5=1;
end

mean_bit6 = mean(abs((f6(index:index+bond).*triang(32))));
if((mean_bit6>=seuil));
    bit6=1;
end

nuage_bits1(cpt) = mean_bit1;
nuage_bits2(cpt) = mean_bit2;
nuage_bits3(cpt) = mean_bit3;
nuage_bits4(cpt) = mean_bit4;
nuage_bits5(cpt) = mean_bit5;
nuage_bits6(cpt) = mean_bit6;


a= [bit6 bit5 bit4 bit3 bit2 bit1];
image_bits(cpt) = bi2de(a);        
end
% determiner les seuils 
figure
subplot(3,2,1)
plot(nuage_bits1,'o');
title('bit1');
subplot(3,2,2)
plot(nuage_bits2,'o');
title('bit2');
subplot(3,2,3)
plot(nuage_bits3,'o');
title('bit3');
subplot(3,2,4)
plot(nuage_bits4,'o');
title('bit4');
subplot(3,2,5)
plot(nuage_bits5,'o');
title('bit5');
subplot(3,2,6)
plot(nuage_bits6,'o');
title('bit6');
% nuage_bits2
% nuage_bits3
% nuage_bits4
% nuage_bits5
% nuage_bits6

image_resolution = reshape(image_bits,[128,128]);
figure
imshow(image_resolution,[0 63]);


