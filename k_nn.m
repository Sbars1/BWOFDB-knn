function error =k_nn(egitim,test,komsu)

global data;
global class;


[egitim_,pb]=size(egitim);
[test_,~] =size(test);


uzaklik_dizisi=zeros(egitim_,test_);

for i=1:egitim_
    for j=1:test_
        toplam=0;
        for k=1:pb
           toplam=toplam+(egitim(i,k)-test(j,k))^2;
        end
        uzaklik_dizisi(i,j)=sqrt(toplam);
    end
end

test_etiket=zeros(test_,1);


dogru=0;
yanlis=0;

for i=1:test_
[siralanan,indeks]=sort(uzaklik_dizisi(:,i));


labels=unique(data.egitim_etiket);
siniflar=zeros(class,1);

for j=1:komsu

    indeks_=find(labels==data.egitim_etiket(indeks(j)));
    siniflar(indeks_)=siniflar(indeks_)+1;

end
[~,b]=max(siniflar);
test_etiket(i)=labels(b);


if(test_etiket(i)==(data.test_etiket(i,1)))
    dogru=dogru+1;
else
    yanlis=yanlis+1;

end
end

error=((100*yanlis)/test_);

end