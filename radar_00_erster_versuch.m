%---erster radar versuch
clear;
close all;
clc;

%---konstanten
c = physconst('LightSpeed');

%---anforderungen in m
targetDistance = 1.0;
maxDistance = 2.0;
rangeResolution = 0.05;

%---bandwidth
bandwidth = c / (2 * rangeResolution);

fprintf('Benötigte Bandbreite: %.2f GHz/n', bandwidth / 1e9);

%---echo laufzeit
roundTripTime = 2 * targetDistance / c;

fprintf('Zielentfernung: %.2f m/n', targetDistance);
fprintf('Hin- und Rücklaufzeit: %.3f s', roundTripTime);

%---entfernung berechnen
estimatedDistance = c * roundTripTime / 2;

fprintf('geschätzte Entfernung: %.2f', estimatedDistance);

%---signal erzeugen
rangeAxis = 0:rangeResolution:maxDistance;

radarSignal = zeros(size(rangeAxis));

%---index bestimmen
[~,targetIndex] = min(abs(rangeAxis-targetDistance));

radarSignal(targetIndex) = 1;

%---rauschen
noiseLevel = 0.03
measuredSignal = radarSignal + noiseLevel * randn(size(radarSignal));

%---peak suchen
[peakValue,detectedIndex] = max(measuredSignal);
detectedDistance = rangeAxis(detectedIndex);

fprintf('Erkannte Entfernung: %.2f m/n', detectedDistance);

%---plot
figure;
plot(rangeAxis,measuredSignal, 'o-');
xlabel('Entfernung in m');
ylabel('Normierte Signalstärke')
title('Entfernungsmessung');
grid on;