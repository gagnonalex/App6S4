clear all
close all
clc

%% RIF MULTICADENCE
% [s1, fe1] = audioread('signal_A.wav');
[s1, fe1] = audioread('signal_B.wav');

desired_freq = 8000;
 
plot(abs(fft(s1,fe1)));

[rif_filter, coeffs] = rif_lowpass();
s1 = [s1; zeros(42,1)];
s1_filtered = filter(coeffs(1:6:end), 1, s1(1:6:end)) + filter(coeffs(2:6:end), 1, s1(2:6:end)) + filter(coeffs(3:6:end), 1, s1(3:6:end)) + filter(coeffs(4:6:end), 1, s1(4:6:end)) + filter(coeffs(5:6:end), 1, s1(5:6:end)) + filter(coeffs(6:6:end), 1, s1(6:6:end));
s1_filtered = s1_filtered(8:end);
s1_down = s1_filtered;
%s1_filtered = filter(rif_filter, s1);
%s1_filtered = s1_filtered(43:end);
%s1_down = downsample(s1_filtered, fe1/desired_freq);

figure
plot(abs(fft(s1_filtered, desired_freq)));

%% RII Butterworth
peak_freqs = [500, 1000, 1500, 2000, 2500, 3000];
delta = 107;
butter_coeffs = zeros(12, 3);
butter_index = 1:2:12;

for index = butter_index
    freq_index = index/2 + 0.5;
    low_limit = peak_freqs(freq_index) - delta;
    low_limit = low_limit / desired_freq*2;
    
    high_limit = peak_freqs(freq_index) + delta;
    high_limit = high_limit / desired_freq*2;
    
    [b, a] = butter(1, [low_limit, high_limit], 'bandpass');
    butter_coeffs(index, :) = b;
    butter_coeffs(index+1, :) = a;
end

rii_group_delay = 12;
s1_down = [s1_down; zeros(rii_group_delay,1)];
for qmn = 1:2
    filter_index = 1:2:12;
    filtered_bits = zeros(6, 524288);

    for index = filter_index
        if qmn == 2
            m=0 ;% avant la virgule
            n= 8;% apres la viirgule 9 = presquee pareille, 10 = parfaitement
            temp = filter_Qmn(s1_down, butter_coeffs(index, :), butter_coeffs(index+1, :), 2, m, n);
        else
            temp = filter(butter_coeffs(index, :), butter_coeffs(index+1, :),s1_down);
        end
        temp = temp(rii_group_delay+1:end);
        filtered_bits((index/2 + 0.5), :) = temp;
    end

    sample_size = 32;
    sample_index = 1:sample_size:length(filtered_bits(1, :))-sample_size+1;
    mean_cloud_1 = [0];
    mean_cloud_2 = [0];
    mean_cloud_3 = [0];
    mean_cloud_4 = [0];
    mean_cloud_5 = [0];
    mean_cloud_6 = [0];
    image_bits = [0];

    for index = sample_index
        bits = zeros(1, 6);
        mean_value_1 = mean(abs(filtered_bits(1, index:index+sample_size-1).*triang(32)'));
        mean_value_2 = mean(abs(filtered_bits(2, index:index+sample_size-1).*triang(32)'));
        mean_value_3 = mean(abs(filtered_bits(3, index:index+sample_size-1).*triang(32)'));
        mean_value_4 = mean(abs(filtered_bits(4, index:index+sample_size-1).*triang(32)'));
        mean_value_5 = mean(abs(filtered_bits(5, index:index+sample_size-1).*triang(32)'));
        mean_value_6 = mean(abs(filtered_bits(6, index:index+sample_size-1).*triang(32)'));

        if mean_value_1 > 0.03
            bits(1) = 1;
        end
        if mean_value_2 > 0.027
            bits(2) = 1;
        end
        if mean_value_3 > 0.025
            bits(3) = 1;
        end
        if mean_value_4 > 0.019
            bits(4) = 1;
        end
        if mean_value_5 > 0.014
            bits(5) = 1;
        end
        if mean_value_6 > 0.01
            bits(6) = 1;
        end

        image_bits = [image_bits bi2de(bits)];

        %% Get Mean Clouds
        mean_cloud_1 = [mean_cloud_1 mean_value_1];
        mean_cloud_2 = [mean_cloud_2 mean_value_2];
        mean_cloud_3 = [mean_cloud_3 mean_value_3];
        mean_cloud_4 = [mean_cloud_4 mean_value_4];
        mean_cloud_5 = [mean_cloud_5 mean_value_5];
        mean_cloud_6 = [mean_cloud_6 mean_value_6];
    end
    image_bits = image_bits(2:end);

    image = reshape(image_bits,[128,128]);
    if qmn == 1
        image_butter = image;
    end
    figure
    imshow(image,[0 63]);

    %% Display Mean Clouds
    mean_cloud_1 = mean_cloud_1(2:end);
    mean_cloud_2 = mean_cloud_2(2:end);
    mean_cloud_3 = mean_cloud_3(2:end);
    mean_cloud_4 = mean_cloud_4(2:end);
    mean_cloud_5 = mean_cloud_5(2:end);
    mean_cloud_6 = mean_cloud_6(2:end);

    figure
    subplot(3,2,1)
    plot(mean_cloud_1, 'o')

    subplot(3,2,2)
    plot(mean_cloud_2, 'o')

    subplot(3,2,3)
    plot(mean_cloud_3, 'o')

    subplot(3,2,4)
    plot(mean_cloud_4, 'o')

    subplot(3,2,5)
    plot(mean_cloud_5, 'o')

    subplot(3,2,6)
    plot(mean_cloud_6, 'o')
end
%%
% PSNR =  20*log[ MAX/sqrt(MSE) ]
% MSEE = 1/m*n * somme(0 a m-1) * somme(0 a n-1)[I(i,j) - K(i,j)]^2  
% I = image sortie du butter 
% K = image de qmn
% m et n = dimension image
% MAX = valeur pixel max, ici = 2^6 = 63
m = 128;
n = m;
resultat_somme = 0;
MAX = 2^6;
for i= 1:m
   for j=1:n
       resultat_somme = resultat_somme + (image_butter(i,j) - image(i,j))^2;
   end   
end

MSE = 1/(m*n)* resultat_somme;
PSNR = 20*log(MAX/sqrt(MSE));

imwrite(image_butter, 'image1.png');
    
    
    