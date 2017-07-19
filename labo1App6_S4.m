%% labo 1 app6 S4
clear all
close all
clc

%% 1 filtre avec fenetr  e
borne1 = 275; %0.275*pi;
borne2 = 240;%0.24*pi;
borneMid = 1000-borne1-borne2; %2*pi - borne1 - borne2;
H = [ones(1,borne1) zeros(1,borneMid) ones(1,borne2) ones(1,borne1) zeros(1,borneMid) ones(1,borne2)];

%== carre

figure
subplot(4,1,1)
hold on
    plot(H)
    title('carre')
    h = ifftshift(ifft(H));
    absImp = abs(h);
    plot(absImp, 'g');


    Carr = [zeros(1,985) ones(1,31) zeros(1,984)];
    plot(Carr);
    fenCarre = h.*Carr;
    Y = abs(fft(h.*fenCarre));

    plot(Y);
hold off

%== triangle

subplot(4,1,2)
hold on
    plot(H)
    title('triangle')

    plot(absImp, 'g');
    Tri = [zeros(1,985) triang(31)' zeros(1,984)];;
    plot(Tri);

    fenTriang = h.*Tri;
    Y = abs(fft(fenTriang));
    plot(Y);
hold off

%+== hamming

subplot(4,1,3)
hold on
    plot(H)
    title('Hamming')

    plot(absImp, 'g');
    Hamm = [zeros(1,985) hamming(31)' zeros(1,984)];;
    plot(Hamm);
    fenHamm = h.*Hamm;
    Y = abs(fft(fenHamm));
    plot(Y);
hold off

%+== kaiser

subplot(4,1,4)
hold on
    plot(H)
    title('kaiser')

    plot(absImp, 'g');
    Kais = [zeros(1,985) kaiser(31)' zeros(1,984)];;
    plot(Kais);

    fenKaiser = h.*Kais;
    YKais = abs(fft(fenKaiser));
    plot(YKais);
hold off
%% num 1 delai de groupe
figure
subplot(4,1,1)
grpdelay(Carr(986:1016),1)
title('carre')

subplot(4,1,2)
grpdelay(Tri(986:1016),1)
title('triangle')

subplot(4,1,3)
grpdelay(Hamm(986:1016),1)
title('hamming')

subplot(4,1,4)
grpdelay(Kais(986:1016),1)
title('kaiser')
 
%% f)
%Q7.0
x = [1 zeros(1,1999)];
b = fenKaiser;

a = 1;
base =2; 
m = 7;
n = 0;
figure('name','Qmn')

subplot(4,2,1)
hold on 
    plot(H);
    rep = filter_Qmn(x,b,a,base,m,n);
    plot(abs(fft(rep)));
    title('Q7.0')
hold off

subplot(4,2,2)
hold on 
    plot(H);
    rep = filter_Qmn(x,b,a,base,6,1);
    plot(abs(fft(rep)));
    title('Q6.1')
hold off

subplot(4,2,3)
hold on 
    plot(H);
    rep = filter_Qmn(x,b,a,base,5,2);
    plot(abs(fft(rep)));
    title('Q5.2')
hold off

subplot(4,2,4)
hold on 
    plot(H);
    rep = filter_Qmn(x,b,a,base,4,3);
    plot(abs(fft(rep)));
    title('Q4.3')
hold off

subplot(4,2,5)
hold on 
    plot(H);
    rep = filter_Qmn(x,b,a,base,3,4);
    plot(abs(fft(rep)));
    title('Q3.4')
hold off

subplot(4,2,6)
hold on 
    plot(H);
    rep = filter_Qmn(x,b,a,base,2,5);
    plot(abs(fft(rep)));
    title('Q2.5')
hold off

subplot(4,2,7)
hold on 
    plot(H);
    rep = filter_Qmn(x,b,a,base,1,6);
    plot(abs(fft(rep)));
    title('Q1.6')
hold off

subplot(4,2,8)
hold on 
    plot(H);
    rep = filter_Qmn(x,b,a,base,0,7);
    plot(abs(fft(rep)));
    title('Q0.7')
hold off


%% 2 butter rouge, cheby1 vert, cheby 2 bleu, elliptique noir, Bessel jaune
figure
[a,b] = butter(2,0.4);
[c,d] = cheby1(2,0.5,0.4);
[e,f] = cheby2(2,1,0.4);
[g h] = ellip(2,0.5,20,0.4)
[i,j] = besself(2,0.4)

[aa,bb] = freqz(a,b)
[cc dd] = freqz(c,d);
[ee ff] = freqz(e,f);
[gg hh] = freqz(g,h);
[ii jj] = freqz(i,j);
subplot(3,1,1);
hold on

plot(abs(aa),'r');
plot(abs(cc),'g');
plot(abs(ee),'b');
plot(abs(gg),'Black');
plot(abs(ii),'y');

title('module')
hold off 

subplot(3,1,2);
hold on
plot(angle(aa),'r');
plot(angle(cc),'g');
plot(angle(ee),'b');
plot(angle(gg),'Black');
plot(angle(ii),'y');

title('phase')
hold off

subplot(3,1,3);
hold on
grpdelay(a,b);
grpdelay(c,d);
grpdelay(e,f);
grpdelay(g,h);
grpdelay(i,j);
title('delay');
hold off

%% num 4

[b,a] = butter(4,0.5);

freqz(b,a);
w = 2/1* tan(0.5*pi/2)

figure
[bs as] = butter(4,w,'s');
freqs(bs,as);

figure
[bz az] = bilinear(b,a,1);
freqz(bz,az);
figure
pzmap(bz,az)


%% num 5

b = [1 -3.6639 3.9061 1.6121 -6.6983 5.2760 -1.4400]
a = [1 -3.5540 4.3901 -1.0694 -2.3340 2.1401 -0.5666]

z =roots(b)
p =roots(a)

zplane(b,a);

%% C)
[H, Omega] = freqz(b,a);
figure
plot( Omega, db(abs(H)),'b')
hold on

b1 = poly(z(1)); 
a1 = poly(p(1));

b2= poly([z(2) z(3)]);
a2= poly([p(2)]);

b3= poly([z(4) z(5)]);
a3=poly([p(3) p(4)]);

b4=poly([z(6)]);
a4 = poly([p(5) p(6)]);

[H1, Omega] = freqz(b1,a1);
[H2, Omega] = freqz(b2,a2);
[H3, Omega] = freqz(b3,a3);
[H4, Omega] = freqz(b4,a4);
plot( Omega, db(abs(H1) .* abs(H2) .* abs(H3) .* abs(H4)),'r')
  
%% e)

seuil = 1000

b_Tr = round(b*seuil)/seuil;
a_Tr = round(a*seuil)/seuil;
b1_Tr = round(b1*seuil)/seuil;
a1_Tr = round(a1*seuil)/seuil;
b2_Tr = round(b2*seuil)/seuil;
a2_Tr = round(a2*seuil)/seuil;
b3_Tr = round(b3*seuil)/seuil;
a3_Tr = round(a3*seuil)/seuil;
b4_Tr = round(b4*seuil)/seuil;
a4_Tr = round(a4*seuil)/seuil;

[H_Tr, Omega] = freqz(b_Tr,a_Tr);
[H1_Tr, Omega] = freqz(b1_Tr,a1_Tr);
[H2_Tr, Omega] = freqz(b2_Tr,a2_Tr);
[H3_Tr, Omega] = freqz(b3_Tr,a3_Tr);
[H4_Tr, Omega] = freqz(b4_Tr,a4_Tr);

plot( Omega,db(abs(H_Tr)),'g')
plot(Omega,db(abs(H1_Tr).*abs(H2_Tr).*abs(H3_Tr).*abs(H4_Tr)),'k')

