function Verileri_Oku( )

global data
global class


data.egitim=table2array(readtable("extention.xlsx",'Range','B2:BD212'));
data.test=table2array(readtable("extention.xlsx",'Range','B212:BD304'));
data.egitim_etiket=table2array(readtable("extention.xlsx",'Range','A1:A212'));
data.test_etiket=table2array(readtable("extention.xlsx",'Range','A212:A304'));



label=unique(data.egitim_etiket);
sayi=findgroups(label);
class=size(sayi,1);

end
