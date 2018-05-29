function variance = varsb(wc,N)
% Calcul du vecteur contenant les variances * nb points
% des sous bandes pour une decomposition en ondelettes 2D
% On commence avec la sous bande d'approximation et on va en augmentant la frequence
% wc : coefficients d'ondelettes donnes par la fonction FWT2()
figure(5);
n=size(wc,1);
t=1:N;
t=2.^t;
taille=[n n./t]

j=1;
for i=1:N
    fprintf(1,'Niveau de res %d\n',i);
    fprintf(1,'Sous bande l/c [%d,%d,%d,%d]\n',taille(i+1)+1,taille(i),1,taille(i+1));
    tab=wc(taille(i+1)+1:taille(i),1:taille(i+1));
    variance(j) = std(tab(:))^2;
    moy(j) = mean(tab(:));
    hist(tab(:),50)
    j=j+1;
    pause;
    
    fprintf(1,'Sous bande l/c [%d,%d,%d,%d]\n',1,taille(i+1),taille(i+1)+1,taille(i));
    tab=wc(1:taille(i+1),taille(i+1)+1:taille(i));
    variance(j) = std(tab(:))^2;
    moy(j) = mean(tab(:));
    hist(tab(:),50)
    j=j+1;
    pause;
    
    fprintf(1,'Sous bande l/c [%d,%d,%d,%d]\n',taille(i+1)+1,taille(i),taille(i+1)+1,taille(i));
    tab=wc(taille(i+1)+1:taille(i),taille(i+1)+1:taille(i));
    variance(j) = std(tab(:))^2;
    moy(j) = mean(tab(:));
    hist(tab(:),50)
    j=j+1;
    pause;
    
    wc=wc(1:taille(i+1),1:taille(i+1));
end

if length(variance) ~= 3*N
    error('pb taille variance');
end

variance(3*N+1) = std(wc(:))^2;
moy(3*N+1) = mean(wc(:));
hist(wc(:),50)

variance
moy
