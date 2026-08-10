%---verbesserung des chirpes aufgrund der schwachen deltaF auflösung
clear;
close all;
clc;

%---konstanten
c = physconst('LightSpeed');

%---anforderungen in m
targetDistance = 100;
maxDistance = 200;
rangeResolution = 79;

%---chirp parameter
fStart = 100e3; %start bei 100 kHz
fEnd = 2e6; %ende bei 2 MHz
T = 1e-3; %chirp dauer
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
rx = [zeros(1,delaySamples) tx(1:end-delaySamples)];

%---gemischtes signal
beat = tx .* rx;

%---fft des beat-signals
Y = fft(beat);

P2 = abs(Y/N); % da Y komplexe zahlen enthält wird nur der betrag bestimmt
P1 = P2(1:N/2+1); % nur positive frequenzen
P1(2:end-1) = 2*P1(2:end-1); % verdopplung der werte, normierung

%---frequenzachse erstellen
f = fs*(0:(N/2))/N; %dealta f, also abstände zwischen den bins

%---tiefpass filter
cutoffFrequency = 100e3; %grenzfrequenz, muss größer als die beat-frequenz sein
beatFiltered = lowpass(beat,cutoffFrequency,fs);

%---fft des gefilterten beat-signals
Y_Filtered = fft(beatFiltered);
P2_Filtered = abs(Y_Filtered/N);
P1_Filtered = P2_Filtered(1:N/2+1);
P1_Filtered(2:end-1) = 2*P1_Filtered(2:end-1);

%---entfernung bestimmen
[peakValue, peakIndex] = max(P1_Filtered); %wert und index des peaks sprich des objekts
beatFrequency = f(peakIndex); %frequenz des peaks
estimatedDistance = c * beatFrequency / (2 * slope); %berechnung der entfernung mithilfe der formel R=c*f_B/2*S

fprintf('Geschätzte Entfernung: %.2f m\n', estimatedDistance);  

%---plot
figure;
plot(t * 1e6, tx);
xlabel('Zeit in mikrosekunden');
ylabel('Amplitude')
title('Linearer Chirp');
hold on;
plot(t * 1e6, rx);
hold on;
plot(t * 1e6, beat);
legend('Ausgesendetes Signal', 'Empfangenes Signal', 'Beat-Signal');
hold off;
grid on;

figure;
plot(f/1000, P1);
xlim([0 100]);
xlabel('Frequenz in kHz');
ylabel('Amplitude');
title('Beat-Signal mit und ohen Tiefpass');
grid on;
hold on;
plot(f/1000,P1_Filtered);
hold off;
legend('Beat-Signal', 'gefiltertes Beat-Signal');

