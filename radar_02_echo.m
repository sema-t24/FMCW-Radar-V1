%---hinzufügen eines echos bzw einer verzögerung
clear;
close all;
clc;

%---konstanten
c = physconst('LightSpeed');

%---anforderungen in m
targetDistance = 100;
maxDistance = 200;
rangeResolution = 5;

%---chirp parameter
fStart = 100e3; %start bei 100 kHz
fEnd = 2e6; %ende bei 2 MHz
T = 100e-6; %chirp dauer
fs = 10e6; %abtastrate, 10 mil pro sekunde
N = round(fs * T);
t = 0:1/fs:T-1/fs;

%---signal erzeugen
tx = chirp(t,fStart,T,fEnd);

%---steigung
bandwidth = fEnd - fStart;
slope = bandwidth / T; %steigung

fprintf('Anzahl Samples: %d\n', N);
fprintf('Bandbreite: %.2f MHz\n', bandwidth / 1e6);
fprintf('Chirp-Steigung: %.2f GHz/s\n', slope / 1e9);

%---verzögerung
roundTripTime = 2 * targetDistance / c; %zeit für hin und zurück
delaySamples = round(roundTripTime * fs); % umwandlung der zeiteinheit in samples, mit aufrundung auf nächste ganzzahlige zahl.
                                          % da die vektoreinheiten samples ist und nicht ns

fprintf('Laufzeit: %.2f ns\n', roundTripTime * 1e9);
fprintf('Verzögerung: %d Samples\n', delaySamples);

%---signal mit verzögerung
rx = [zeros(1,delaySamples) tx(1:end-delaySamples)]; % rx ist ein neuer vektor bestehend aus zwei vektoren. 
                                                     % erster vektor ist ein vektor mit nullen mit der größe des delaysamples 
                                                     % und der zweite vektor ist das signal tx von 1 bis ende minus der größe der verzögerung
                                                     % (sprich bei delaysamples=3 werden die letzten drei signalgrößen entfernt). 
                                                     % das auschneiden der samples hinten ist der kompromiss zum hinzufügen der neuen größen am anfang also den nullen,
                                                     % sodass tx udn rx die selbe länge haben bzw vektorgröße 

%---plot
figure;
plot(t * 1e6, tx);
xlabel('Zeit in mikrosekunden');
ylabel('Amplitude')
title('Linearer Chirp');
hold on;
plot(t * 1e6, rx);
legend('Ausgesendetes Signal', 'Empfangenes Signal');
hold off;
grid on;