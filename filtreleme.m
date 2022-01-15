close all; clear; clc;
%Ses dosyasını işleme

[signal, y] = audioread('speech_dft_8kHz.wav');
signal = signal * 2;

%Filtre tasarlama
fpass = 2000; %hertz cinsinden kesme frekansı
fstop = 3000; %hertz cinsnden durdurma frekansı
Apass = 3; %dB cinsinden geçiş bandı
Astop = 100; %dB cinsinden durdurma frekansı
lowpass_filter = fdesign.lowpass('Fp,Fst,Ap,Ast',fpass,fstop,Apass,Astop,y);
fir_filter = design(lowpass_filter,'FIR');
disp('FIR Filter: ');
measure(fir_filter)
fir_order = length(fir_filter.Numerator);
disp(['Ordem minima: ',num2str(fir_order)]);

%filtreleme işlemi
fir_signal = filter(fir_filter,signal);

%% Sonuçlar
figure('name', 'Sinal no tempo');
time = (1:length(signal))./y;
fir_time = (1:length(fir_signal))./y;
subplot(2,1,1);
plot(time, signal);
ylabel('Ses');
xlabel('Zaman (Saniye)');
title('Orijinal sinyal');
subplot(2,1,2);
plot(fir_time,fir_signal);
ylabel('Ses');
xlabel('Zaman (Saniye)');
title(['FIR filtreyle filtrelenmiş sinyal ',num2str(fir_order)]);
%Spektrum Analizi

FTSignalAnalysis = fvtool(signal,1,fir_signal,1,'Fs',y);
legend(FTSignalAnalysis,'Original','Filtrelenmiş');
title('Ses Sinyali Spektrumu');
%Filtre Analizi
FTFilterAnalysis = fvtool(fir_filter,'Fs',y);
legend(FTFilterAnalysis,'FIR Filter');
title('Filtre Spektrumu');
%Sesin oynatılması
disp('Orijinal ses');
sound(signal, y);
pause(5);
disp('FIR filtre ile filtrelenmiş ses');
sound(fir_signal,y);
