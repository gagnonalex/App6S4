% Jérôme Martel marj2430
% Michaël Deslauriers-Roy desm1927

close all;
clear;
clc;

%% Informations génériques
[raw_audio,fe] = audioread('signal_B.wav');
raw_size = length(raw_audio);
new_fe = 8000;
dsample_rate = fe/new_fe;
dsampled_size = raw_size / dsample_rate;

%% Filtre RIF multicadence
[rif_filter, coeffs] = rif_lowpass();
% On applique un filtrage de 1%6 des coefficients sur les 1%6 échantillons
% du signal
s1_filtered = filter(coeffs(1:6:end), 1, raw_audio(1:6:end)) + filter(coeffs(2:6:end), 1, raw_audio(2:6:end)) + filter(coeffs(3:6:end), 1, raw_audio(3:6:end)) + filter(coeffs(4:6:end), 1, raw_audio(4:6:end)) + filter(coeffs(5:6:end), 1, raw_audio(5:6:end)) + filter(coeffs(6:6:end), 1, raw_audio(6:6:end));
filtered_audio_dsampled = s1_filtered(8:end);

debug_plot = 0;
if debug_plot == 1
  figure(1)
  plot(-1:2/initial_filter_size:1-1/initial_filter_size,filtre_ideal);
  title('Filtre idéal dans le domaine fréquentiel')
  figure(2)
  plot(-initial_filter_size/2:initial_filter_size/2-1,filtre_ideal_imp);
  title('Filtre idéal dans le domaine temporel')
  figure(3)
  plot(0:window_size-1, filtre_realisable_temp);
  title('Filtre fenêtré réalisable dans le domaine temporel')
  figure(4)
  subplot(3,1,1)
  plot(0:fe/window_size:fe-window_size, abs(filtre_realisable));
  title('Amplitude des fréquences du filtre RIF réalisable')
  subplot(3,1,2)
  plot(0:fe/window_size:fe-window_size, angle(filtre_realisable));
  title('Phases des fréquences du filtre RIF réalisable')
  subplot(3,1,3)
  asd = 0:fe/length(delais_groupe):fe-1;
  plot(0:fe/length(delais_groupe):fe-1, delais_groupe);
  title('Délais de groupe du filtre RIF réalisable')
end

debug_plot = 0;
if debug_plot == 1
  figure(10)
  plot(0:fe/length(raw_audio):fe-fe/length(raw_audio),abs(fft(raw_audio)));
  title('Signal brut dans le domaine fréquentiel')
  figure(11)
  plot(0:fe/6/length(filtered_audio_dsampled):fe/6-fe/6/length(filtered_audio_dsampled),abs(fft(filtered_audio_dsampled)));
  title('Signal filtré et sous-échantillonné dans le domaine fréquentiel')
end
%% Design du filtre Chebyshev
% on a un filtre chebyshev1 de type passe-bande ordre 1 avec une une bande de transition de 120 et une
% atténuation des ripples de 1dB.
new_new_fe = new_fe / 2;
[cheb500B , cheb500A ] = cheby1(1,1,[(1*500-50)/new_new_fe (1*500+70)/new_new_fe]);
[cheb1000B, cheb1000A] = cheby1(1,1,[(2*500-50)/new_new_fe (2*500+70)/new_new_fe]);
[cheb1500B, cheb1500A] = cheby1(1,1,[(3*500-50)/new_new_fe (3*500+70)/new_new_fe]);
[cheb2000B, cheb2000A] = cheby1(1,1,[(4*500-50)/new_new_fe (4*500+70)/new_new_fe]);
[cheb2500B, cheb2500A] = cheby1(1,1,[(5*500-50)/new_new_fe (5*500+70)/new_new_fe]);
[cheb3000B, cheb3000A] = cheby1(1,1,[(6*500-50)/new_new_fe (6*500+70)/new_new_fe]);
% Filtrage de nos signaux avec le banc de filtre
trame1 = filter(cheb500B , cheb500A , filtered_audio_dsampled);
trame2 = filter(cheb1000B, cheb1000A, filtered_audio_dsampled);
trame3 = filter(cheb1500B, cheb1500A, filtered_audio_dsampled);
trame4 = filter(cheb2000B, cheb2000A, filtered_audio_dsampled);
trame5 = filter(cheb2500B, cheb2500A, filtered_audio_dsampled);
trame6 = filter(cheb3000B, cheb3000A, filtered_audio_dsampled);

debug_plot = 0;
if debug_plot == 1
  cheb1000freq = freqz(cheb1000B,cheb1000A);
  figure(201)
  subplot(3,1,1)
  plot(abs(fft(filtered_audio_dsampled)))
  subplot(3,1,2)
  plot(10*log(abs(cheb1000freq)))
  subplot(3,1,3)
  plot(abs(fft(trame2)))
end

%  figure(101)
%  freqz(cheb500B,cheb500A);
%  hold on;
%  freqz(cheb1000B,cheb1000A);
%  hold on;
%  freqz(cheb1500B,cheb1500A);
%  hold on;
%  freqz(cheb2000B,cheb2000A);
%  hold on;
%  freqz(cheb2500B,cheb2500A);
%  hold on;
%  freqz(cheb3000B,cheb3000A);
%  hold on;
%  lines = findall(gcf,'type','line');
%  lines(1).Color = 'red';
%  lines(2).Color = 'green';
%  lines(3).Color = 'cyan';
%  lines(4).Color = 'magenta';
%  lines(5).Color = 'black';
%  lines(6).Color = 'blue';
%  title('Réponse en fréquence des filtres');
 
% figure(1000);
% grpdelay(cheb500B,cheb500A);
% hold on;
% grpdelay(cheb1000B,cheb1000A);
% hold on;
% grpdelay(cheb1500B,cheb1500A);
% hold on;
% grpdelay(cheb2000B,cheb2000A);
% hold on;
% grpdelay(cheb2500B,cheb2500A);
% hold on;
% grpdelay(cheb3000B,cheb3000A);
% title('Délais de groupe');


% figure(9999);
% zplane(cheb500B,cheb500A);
% title('Pôle et zéros 500Hz');
% figure(9998);
% zplane(cheb1000B,cheb1000A);
% title('Pôle et zéros 1000Hz');
% figure(9997);
% zplane(cheb1500B,cheb1500A);
% title('Pôle et zéros 1500Hz');
% figure(9996);
% zplane(cheb2000B,cheb2000A);
% title('Pôle et zéros 2000Hz');
% figure(9995);
% zplane(cheb2500B,cheb2500A);
% title('Pôle et zéros 2500Hz');
% figure(9994);
% zplane(cheb3000B,cheb3000A);
% title('Pôle et zéros 3000Hz');

%%Section traitement des bits de l'image
% information générique pour la suite
e_size = 32;
delais_cheb = 11;
index = floor(rand*10000);
index_range = delais_cheb+index*e_size:delais_cheb+e_size+index*e_size - 1;
echelle = 0:new_fe/e_size:new_fe-new_fe/e_size;

debug_plot = 0;
if debug_plot == 1
  figure(20)
  subplot(6,3,1)
  plot(trame1(index_range))
  ylim([-0.004 0.004])
  subplot(6,3,[2 3])
  plot(abs(fft(trame1(index_range))))
  ylim([0 0.05])
  
  subplot(6,3,4)
  plot(trame2(index_range))
  ylim([-0.004 0.004])
  subplot(6,3,[5 6])
  plot(abs(fft(trame2(index_range))))
  ylim([0 0.05])
  
  
  subplot(6,3,7)
  plot(trame3(index_range))
  ylim([-0.004 0.004])
  subplot(6,3,[8 9])
  plot(abs(fft(trame3(index_range))))
  ylim([0 0.05])
  
  
  subplot(6,3,10)
  plot(trame4(index_range))
  ylim([-0.004 0.004])
  subplot(6,3,[11 12])
  plot(abs(fft(trame4(index_range))))
  ylim([0 0.05])
  
  
  subplot(6,3,13)
  plot(trame5(index_range))
  ylim([-0.004 0.004])
  subplot(6,3,[14 15])
  plot(abs(fft(trame5(index_range))))
  ylim([0 0.05])
  
  
  subplot(6,3,16)
  plot(trame6(index_range))
  ylim([-0.004 0.004])
  subplot(6,3,[17 18])
  plot(abs(fft(trame6(index_range))))
  ylim([0 0.05])
end

% on recompose l'image ici en mettant au carré les valeurs de nos symbols
% et en les passant dans une fenêtre de hamming afin d'atténuer les
% transition de symbol.
champ_de_bits = [zeros(128) zeros(128) zeros(128) zeros(128) zeros(128) zeros(128)];
for index = 1:dsampled_size/e_size - 2 
   index_range = delais_cheb+index*e_size:delais_cheb+e_size+index*e_size - 1;
   champ_de_bits(rem(index,128)+1, floor(index/128)+1, 1)  = sum((trame1(index_range) .* hamming(e_size)).^2);
   champ_de_bits(rem(index,128)+1, floor(index/128)+1, 2)  = sum((trame2(index_range) .* hamming(e_size)).^2);
   champ_de_bits(rem(index,128)+1, floor(index/128)+1, 3)  = sum((trame3(index_range) .* hamming(e_size)).^2);
   champ_de_bits(rem(index,128)+1, floor(index/128)+1, 4)  = sum((trame4(index_range) .* hamming(e_size)).^2);
   champ_de_bits(rem(index,128)+1, floor(index/128)+1, 5)  = sum((trame5(index_range) .* hamming(e_size)).^2);
   champ_de_bits(rem(index,128)+1, floor(index/128)+1, 6)  = sum((trame6(index_range) .* hamming(e_size)).^2);
   
end

%Force les bits à une valeur binaire de 0 ou 1 selon un seuil 
mid_value = (min(min(champ_de_bits)) + max(max(champ_de_bits)))/2;
picture = zeros(128);
for i = 1:128
for j = 1:128
for k = 1:6
    if champ_de_bits(i,j,k)>mid_value(1,1,k)
        champ_de_bits(i,j,k) = 1;
    else
        champ_de_bits(i,j,k) = 0;
    end
end 
picture(i,j) = sum(squeeze(champ_de_bits(i,j,1:6))'.*[1 2 4 8 16 32]);
end 
end

picture = picture/max(max(picture));

figure(9001)
imshow(picture)