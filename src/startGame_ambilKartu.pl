:- include('utils.pl').
:- dynamic(kartu_tangan/2).
:- dynamic(arah/1).
% fungsi input Jumlah Pemain
% Input Valid Jika Integer 2<=Jml<=4
inputJml(Jml):- write('Masukkan jumlah pemain: '), read(InputJml), 
(integer(InputJml)->(isJmlPemainValid(InputJml)-> Jml is InputJml, nl;
write('Input Error (Input Harus berada di range 2-4)'),nl,inputJml(Jml));
write('Input Error (Input Harus berbentuk integer)'),nl,inputJml(Jml)).

isJmlPemainValid(Jml):- Jml>1, Jml<5,!.

% Search Pemain Apakah Ada di dalam List, jika ada maka bernilai false
searchPemain([],_).
searchPemain([Head|_],Head):- fail.
searchPemain([Head|Tail],Nama):- Head\==Nama, searchPemain(Tail,Nama).

% Kalimat Input 
inputOrgMsg('Masukkan nama pemain ').
inputOrgUlg('Nama sudah digunakan. Masukan nama lain: ').

% Rule untuk Input Pemain

inputPemain(Jml,DaftarPemain):- helperinputPemain(0,Jml,[],DaftarPemain,0).

helperinputPemain(_,0,DaftarPemain,DaftarPemain,_).
helperinputPemain(Idx,Jml,Daftarskrg,DaftarPemain,State):-
Jml>0,
inputOrgMsg(MsgIn),
inputOrgUlg(MsgUlg),
NewIdx is Idx +1,
(State =:=0-> format('~w ~d: ',[MsgIn,NewIdx]);format('~w ',[MsgUlg])),
read(InputNama),
(atomic(InputNama), \+ (integer(InputNama)) -> ((searchPemain(Daftarskrg,InputNama)) ->
    NewIdx is Idx +1, JmlSisa is Jml -1, insert_head(InputNama,Daftarskrg,Daftarbaru),
    helperinputPemain(NewIdx,JmlSisa,Daftarbaru,DaftarPemain,0);
    helperinputPemain(Idx,Jml,Daftarskrg,DaftarPemain,1)); 
    write('Input harus berupa tipe atomic dengan kata yang diapit \'\' '),
    nl,
    helperinputPemain(Idx,Jml,Daftarskrg,DaftarPemain,1)).


% Rule untuk memilih secara acak urutan
kocokurutan(_,0,New,New).
kocokurutan(UrutanPemain,1,List,New):-
random_select(UrutanPemain,1,_,Dipilih), format('~w',[Dipilih]), insert_tail(List,Dipilih,Listbaru),kocokurutan(UrutanPemain,0,Listbaru,New).


kocokurutan(UrutanPemain,Jml,List,New):- random_select(UrutanPemain,1,NextUrutan,Dipilih),NewJml is Jml-1,
format('~w - ',[Dipilih]), insert_tail(List, Dipilih,Listbaru), kocokurutan(NextUrutan,NewJml, Listbaru,New).

% fakta kartu (List Kartu)
kartu('hijau',0,_).
kartu('hijau',1,_).
kartu('hijau',2,_).
kartu('hijau',3,_).
kartu('hijau',4,_).
kartu('hijau',5,_).
kartu('hijau',6,_).
kartu('hijau',7,_).
kartu('hijau',8,_).
kartu('hijau',9,_).
kartu('hijau','reverse',_).
kartu('hijau','skip',_).
kartu('hijau','plus_dua',_).
kartu('merah',0,_).
kartu('merah',1,_).
kartu('merah',2,_).
kartu('merah',3,_).
kartu('merah',4,_).
kartu('merah',5,_).
kartu('merah',6,_).
kartu('merah',7,_).
kartu('merah',8,_).
kartu('merah',9,_).
kartu('merah','reverse',_).
kartu('merah','skip',_).
kartu('merah','plus_dua',_).

kartu('biru',0,_).
kartu('biru',1,_).
kartu('biru',2,_).
kartu('biru',3,_).
kartu('biru',4,_).
kartu('biru',5,_).
kartu('biru',6,_).
kartu('biru',7,_).
kartu('biru',8,_).
kartu('biru',9,_).
kartu('biru','reverse',_).
kartu('biru','skip',_).
kartu('biru','plus_dua',_).

kartu('kuning',0,_).
kartu('kuning',1,_).
kartu('kuning',2,_).
kartu('kuning',3,_).
kartu('kuning',4,_).
kartu('kuning',5,_).
kartu('kuning',6,_).
kartu('kuning',7,_).
kartu('kuning',8,_).
kartu('kuning',9,_).
kartu('kuning','reverse',_).
kartu('kuning','skip',_).
kartu('kuning','plus_dua',_).

kartu('hitam','wildcard',_).
kartu('hitam','plus_empat',_).
warna_kartu_discardpile(['merah','kuning','hijau','biru']).
warna_kartu_ambilkartu(['merah','kuning','hijau','biru','hitam']).
jenis_kartu_discardpile([0,1,2,3,4,5,6,7,8,9]).
jenis_kartu_ambilkartu_bukanwild([0,1,2,3,4,5,6,7,8,9,'plus_dua','reverse','skip']).
jenis_kartu_wild(['plus_empat','wildcard']).

random_discardpile(Element):- 
warna_kartu_discardpile(ListWarna), jenis_kartu_discardpile(ListAngka),
random_select_tanpadel(ListWarna,1,Warna), random_select_tanpadel(ListAngka,1,Angka),
Element = kartu(Warna,Angka,_).

ekstrak_kartu(Element,Warna,Angka):-
Element = kartu(Warna,Angka,_).

random_ambilkartu(Element):-
warna_kartu_ambilkartu(ListWarna), jenis_kartu_ambilkartu_bukanwild(ListJenis),
jenis_kartu_wild(ListWild),
random_select_tanpadel(ListWarna,1,Warna),
(Warna == 'hitam' -> random_select_tanpadel(ListWild,1,Wild), Element = kartu(Warna,Wild,normal);
random_select_tanpadel(ListJenis,1,Jenis), Element = kartu(Warna,Jenis,normal)).

ambilkan_kartu7(DaftarKartu):-
ambil_kartu7help(DaftarKartu,[],7).

ambil_kartu7help(DaftarKartu,DaftarKartu,0).
ambil_kartu7help(DaftarKartu,ListKartu,JmlKartuSisa):-
NextJml is JmlKartuSisa -1, random_ambilkartu(Element),
insert_tail(ListKartu,Element,Listbaru), ambil_kartu7help(DaftarKartu,Listbaru,NextJml).


simpan_kartu([],_,_).
simpan_kartu([HeadUrutan|TailUrutan],Urut,Jml):-
    ambilkan_kartu7(Daftarkartu), assertz(kartu_tangan(HeadUrutan,Daftarkartu)),!,
    simpan_kartu(TailUrutan,Urut,Jml).

next_giliran(Idx,NewestIdx,Jml):-
arah(ArahSaatini),
(ArahSaatini == 'kanan'-> (NewIdx is Idx +1, (NewIdx>=Jml -> NewestIdx is (NewIdx mod Jml) ;NewestIdx is NewIdx));
NewIdx is Idx-1, (NewIdx<0 -> NewestIdx is (NewIdx mod Jml);NewestIdx is NewIdx)).

  