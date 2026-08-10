%---hinzufügen eines chirps
clear;
close all;
clc;

%---konstanten
c = physconst('LightSpeed');

%---anforderungen in m
targetDistance = 1.0;
maxDistance = 2.0;
rangeResolution = 0.05;

%---chirp parameter
fStart = 100e3; %start bei 100 kHz
fEnd = 2e6; %ende bei 2 MHz
T = 100e-6; %chirp dauer
fs = 10e6; %abtastrate, 10 mil pro sekunde
t = 0:1/fs:T-1/fs;

%---signal erzeugen
tx = chirp(t,fStart,T,fEnd);

%---steigung und co
N = round(fs * T);
bandwidth = fEnd - fStart;
slope = bandwidth / T; %steigung

fprintf('Anzahl Samples: %d\n', N);
fprintf('Bandbreite: %.2f MHz\n', bandwidth / 1e6);
fprintf('Chirp-Steigung: %.2f GHz/s\n', slope / 1e9);

%---plot
figure;
plot(t * 1e6, tx);
xlabel('Zeit in mikrosekunden');
ylabel('Amplitude')
title('Linearer Chirp');
grid on;