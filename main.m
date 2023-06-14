clear all;
close all;
clc;
global data
global class


k=7;
esik_deger=0.8; 

fdbCase = 1;%2 or 3

Verileri_Oku( );


[error]=k_nn(data.egitim,data.test,k);
disp("knn hatası : " + error);

i=21;
performans_fdb=zeros(i,1);
count=zeros(i,1);
performans_knn_dizisi=zeros(i,1);
performans_fdb_son=zeros(i,1);

while i>0
    [BestX, BestF]=BWOFdb(data.egitim,data.test,k,fdbCase);
    performans_fdb(i)=BestF;
    [knn_hata_orani, sayac, train, test] =ozellik_cikarimi(BestX,data.egitim,data.test,k,esik_deger);
    count(i)=sayac;
    performans_knn_dizisi(i)=knn_hata_orani;
    disp("knn-hata:" + knn_hata_orani);
    [BestX, BestF]=BWOFdb(data.egitim,data.test,k,fdbCase);
    performans_fdb_son(i)=BestF;    
    i=i-1;
end
disp("----fdb-sos-knn----");
disp("En iyi: " + min(performans_fdb));
disp("En kötü: " + max(performans_fdb));
disp("Ortalama: " + mean(performans_fdb));
disp("Standart sapma: " + std(performans_fdb));
disp("");
disp("----Çıkarılacak nitelik sayısı----");
disp("Ortalama: " + mean(count));
disp("Ortanca: " + median(count));
disp("Standart sapma: " + std(count));
disp("");
disp("----boyut azaltma sonrası knn----");
disp("En iyi: " + min(performans_knn_dizisi));
disp("En kötü: " + max(performans_knn_dizisi));
disp("Ortalama: " + mean(performans_knn_dizisi));
disp("Standart sapma: " + std(performans_knn_dizisi));
disp("");
disp("----boyut azaltma sonrası fdb-sos-knn----");
disp("En iyi: " + min(performans_fdb_son));
disp("En kötü: " + max(performans_fdb_son));
disp("Ortalama: " + mean(performans_fdb_son));
disp("Standart sapma: " + std(performans_fdb_son));











