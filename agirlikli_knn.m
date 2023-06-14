function error =agirlikli_knn(agirlik,egitim,test,komsu)

global data;
global class;

[egitim_,pb]=size(egitim);
[test_,~] =size(test);

uzaklik_dizisi=zeros(egitim_,test_);

for i=1:egitim_
    for j=1:test_
        for k=1:pb
            uzaklik_dizisi(i,j)=uzaklik_dizisi(i,j)+(agirlik(k)*(egitim(i,k)-test(j,k))^2);
        end
        uzaklik_dizisi(i,j)=sqrt(uzaklik_dizisi(i,j));
    end
end

test_etiket=zeros(test_,1);


dogru_sayi=0;
yanlis_sayi=0;

for i=1:test_
[siralanan,indeks]=sort(uzaklik_dizisi(:,i));


labels=unique(data.egitim_etiket);
siniflar=zeros(class,1);


for j=1:komsu

    indeks_=find(labels==data.egitim_etiket(indeks(j))); 
    siniflar(indeks_)=siniflar(indeks_)+1;


end
[~, boyut]=max(siniflar);
test_etiketi(i)=labels(boyut);



if(test_etiketi(i)==(data.test_etiket(i,1)))
    dogru_sayi=dogru_sayi+1;
else
    yanlis_sayi=yanlis_sayi+1;
end
end


error =(100*yanlis_sayi)/test_;



end