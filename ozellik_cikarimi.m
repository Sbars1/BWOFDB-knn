function [knn_performans,sayi,egitim,test]=ozellik_cikarimi(bestSolution,egitim,test,komsu,esik_deger)

[~,indeks]=size(bestSolution);

sayi=0;
i=indeks;

while i>0
    if(bestSolution(1,i)<esik_deger)
        egitim(:,i)=[];
        test(:,i)=[];
        sayi=sayi+1;
    end
    i=i-1;
end

[knn_performans]=k_nn(egitim,test,komsu);

end