clear
close all
clc % Nettoyage de la console

n = 1024;
j = 4;
k = 2^(j-1);
maxPlot = 5; % Non utilisé, servait à subplot plus facilement
figure(1)
psi = MakeWavelet(j, k, 'Haar', [], 'Mother', n); % Ondelette Mère
phi = MakeWavelet(j, k, 'Haar', [], 'Father', n); % Ondelette Père
phi = phi*2^(log2(n)/2);
subplot(1,maxPlot,1);

plot(phi, 'r');
legend('Haar');
mof =  MakeONFilter('Haar'); %Filtre H0
fwt = FWT_PO(phi, 0, mof); % Les coefficients d'approximation
subplot(1,maxPlot,2), % Affichage des coefficients d'approximation
plot(fwt, 'b');
legend('FWT_PO(Haar)');

d = MakeWavelet(j, k, 'Daubechies', 4, 'Father', n);
d = d*2^(log2(n)/2);
subplot(1,maxPlot,3);
plot(d, 'g');
legend('Daubechies');

nfft = 256;
f = (0:nfft-1)/nfft;
y = fft(d, nfft);
subplot(1,maxPlot,4); % Finalement j'utilise le maxPlot
plot(f, abs(y));
legend('fft');

% Ramp
sig = MakeSignal('Ramp', n);
figure(2);
subplot(3,3,1);
plot(sig);
title('Signal 1024');


J = log2(n); 
jmax = 4;
L = log2(n)-jmax;
mof =  MakeONFilter('Daubechies', 4);

subplot(3, 3, 2)
wcRamp = FWT_PO(sig,L,mof);
plot(wcRamp);
title('Coef 1024');


rec = IWT_PO(wcRamp, L, mof);
subplot(3, 3, 3)
plot(rec);
title('Reconstruction 1024');

% Sig 2k48
sig2k = MakeSignal('Ramp', 2048);
sig2k = sig2k(1:1024);
subplot(3, 3, 4)
plot(sig2k);
title('Signal 2048');

% Coef 2k48
Jk = log2(2048); 
jmax = 4;
Lk = log2(2048)-jmax;
subplot(3, 3, 5)
wcRampk = FWT_PO(sig2k,Lk,mof);
plot(wcRampk);
title('Coef 2048');

% reconstruction 2k48
rec2k = IWT_PO(wcRampk, Lk, mof);
subplot(3, 3, 6)
plot(rec2k);
title('Reconstruction 2048');



% Transformée en Ondelette 2D
n = 256;
J = log2(n);
jmax = 4;
L = log2(n)-jmax;
mof =  MakeONFilter('Daubechies', 4);
title('Signal Lena');

fid = fopen('Lenna.raw', 'r'); % le .Raw a été téléchargé ici : https://github.com/FredGithub/ImageProcess/blob/master/res/img/lena.raw
lena = fread(fid,[256,256]);
lena = double(lena); % J'en avais besoin, dunno why

figure(3);
subplot(3, 3, 1)
plot(lena);
title('Lena');

% Les commentaires sont les Titles des plots :>
gLena = FWT2_PO(lena, L, mof);
subplot(3, 3, 2)
plot(gLena);
title('Coefs Lena Plot');


rLena = IWT2_PO(gLena, L, mof);
subplot(3, 3, 3)
plot(rLena);
title('Reconstruction Lena plot');


subplot(3, 3, 4);
imagesc(mof);
title('Réponse impultionnelle Daubechies');

subplot(3, 3, 5);
imagesc(gLena);
title('Coefs Lena imagesc');


subplot(3, 3, 6);
imagesc(rLena);
title('Reconstruction Lena imagesc');




figure(4)
[qmf, dqmf] = MakeBSFilter('Villasenor', 1);

subplot(3, 3, 1);
imagesc(qmf);
title('Villasenor Filter H0');

subplot(3, 3, 2);
imagesc(dqmf);
title('Villasenor filter G0');

subplot(3, 3, 4);

jmax = 3;
L = log2(256)-jmax;
ddo = FWT2_SBS(lena, L, qmf, dqmf);
plot(ddo);
title('Plot Décomposition Villasenor');
subplot(3, 3, 5);
ddo2 = FWT2_SBS(lena, L, qmf, dqmf);
plot(ddo2);
title('Imagesc De la décomposition Villasenor');

subplot(3, 3, 7);
ddo3 = IWT2_SBS(ddo2, L, qmf, dqmf);
imagesc(lena);
title('Lena de base');

subplot(3, 3, 8);
ddo3 = IWT2_SBS(ddo2, L, qmf, dqmf);
imagesc(ddo3);
title('Lena reconstruite');

moyenne = mean(ddo3(:));
fprintf('Moyenne des sous bandes est de : %f\n', moyenne)


varsb(ddo2, jmax);

figure(6);
subplot(1,2,1);
imagesc(lena);
subplot(1,2,2);

xT = SoftThresh(ddo2, 100);
imagesc(IWT2_SBS(xT, L, qmf, dqmf))


fprintf('norm lena : %f\n', norm(lena));
fprintf('norm xT : %f\n', norm(xT));












