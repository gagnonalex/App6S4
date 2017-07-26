clear all
close all
clc

base = 2;
m = 4;
n = 2;

L = 100;
b = [1 -1 1];
a = [1 0 0.9];
Hz = tf(b,a)

figure
freqz(b,a)
figure
zplane(b,a)

x = 10*rand(1,L);
y = filter(b,a,x);
yt = filter_Qmn(x,b,a,base,m,n);
err = y-yt;
eqm = mean(err.^2)
figure
hold on
plot(y,'k')
plot(yt,'b')
plot(err,'r')

x = 10*ones(1,200);
y = filter(b,a,x);
yt = filter_Qmn(x,b,a,base,m,n);
err = y-yt;
eqm = mean(err.^2)
figure
hold on
plot(y,'k')
plot(yt,'b')
plot(err,'r')

x = 10*sin(100*(1:L));
y = filter(b,a,x);
yt = filter_Qmn(x,b,a,base,m,n);
err = y-yt;
eqm = mean(err.^2)
figure
hold on
plot(y,'k')
plot(yt,'b')
plot(err,'r')