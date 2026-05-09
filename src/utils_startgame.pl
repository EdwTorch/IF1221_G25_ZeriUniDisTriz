% Rule Umum
insert_head(In,List,[In|List]).

copy(Isi,Isi).

del([_|Tail],0,Tail).
del([Head|Tail],Index,[Head|Updatedtail]):- Index >0, Newindex is Index-1, del(Tail,Newindex,Updatedtail).

get_idx([],_,-1).
get_idx([Head|Tail],Element,Idx):-
get_idxhelp([Head|Tail],Element,0,Idx).

get_idxhelp([Element|_],Element,Idx,Idx):-!.
get_idxhelp([Head|Tail],Element,Idxsaatini,Idx):-
Head\==Element, Nextidx is Idxsaatini+1, get_idxhelp(Tail,Element,Nextidx,Idx).

insert_tail([],In,[In]).
insert_tail([Pala|Sisa],Belakang,[Pala|Result]):- insert_tail(Sisa,Belakang,Result).

panjang(Pjg,Pjg,[]).
panjang(Skrg,Pjg,[_|Tail]):- Lnjt is Skrg+1, panjang(Lnjt,Pjg,Tail).
random_select(List, 1, Listbaru,Element) :-
        panjang(0,Length, List),
        random(0,Length,R),
        get_idx(List,Element,R),
        del(List,R,Listbaru),!. 
random_select_tanpadel(List, 1,Element) :-
        panjang(0,Length, List),
        random(0,Length,R),
        get_idx(List,Element,R),!.

get_head([Head|_],Head).

% fungsi input Jumlah Pemain
inputJml(Jml):- write('Masukkan jumlah pemain: '), read(InputJml), 
(isJmlPemainValid(InputJml)-> Jml is InputJml, nl;inputJml(Jml)).

isJmlPemainValid(Jml):- Jml>1, Jml<5,!.

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
(State =:=0->format('~w ~d: ',[MsgIn,NewIdx]);format('~w ',[MsgUlg])),
read(InputNama),
((searchPemain(Daftarskrg,InputNama)) ->
    NewIdx is Idx +1, JmlSisa is Jml -1, insert_head(InputNama,Daftarskrg,Daftarbaru),
    helperinputPemain(NewIdx,JmlSisa,Daftarbaru,DaftarPemain,0);
    helperinputPemain(Idx,Jml,Daftarskrg,DaftarPemain,1)).


% Rule untuk memilih secara acak urutan
kocokurutan(_,0,New,New).
kocokurutan(UrutanPemain,1,List,New):-
random_select(UrutanPemain,1,_,Dipilih), format('~w',[Dipilih]), insert_tail(List,Dipilih,Listbaru),kocokurutan(UrutanPemain,0,Listbaru,New).


kocokurutan(UrutanPemain,Jml,List,New):- random_select(UrutanPemain,1,NextUrutan,Dipilih),NewJml is Jml-1,
format('~w - ',[Dipilih]), insert_tail(List, Dipilih,Listbaru), kocokurutan(NextUrutan,NewJml, Listbaru,New).

% fakta kartu (List Kartu)
kartuangka(
    [
        'merah-0',
        'kuning-0',
        'hijau-0',
        'biru-0',
        'merah-1',
        'kuning-1',
        'hijau-1',
        'biru-1',
        'merah-2',
        'kuning-2',
        'hijau-2',
        'biru-2',
        'merah-3',
        'kuning-3',
        'hijau-3',
        'biru-3',
        'merah-4',
        'kuning-4',
        'hijau-4',
        'biru-4',
        'merah-5',
        'kuning-5',
        'hijau-5',
        'biru-5',
        'merah-6',
        'kuning-6',
        'hijau-6',
        'biru-6',
        'merah-7',
        'kuning-7',
        'hijau-7',
        'biru-7',
        'merah-8',
        'kuning-8',
        'hijau-8',
        'biru-8',
        'merah-9',
        'kuning-9',
        'hijau-9',
        'biru-9'
    ]).

kartuaksi(
    [
        'merah-skip',
        'kuning-skip',
        'hijau-skip',
        'biru-skip',
        'merah-reverse',
        'kuning-reverse',
        'hijau-reverse',
        'biru-reverse',
        'merah-draw2',
        'kuning-draw2',
        'hijau-draw2',
        'biru-draw2',
        'wild-card',
        'wild-card',
        'wild-card',
        'wild-card',
        'wild-card-plus4',
        'wild-card-plus4',
        'wild-card-plus4',
        'wild-card-plus4'
    ]
).

kartusemua(
    [
        'merah-0',
        'kuning-0',
        'hijau-0',
        'biru-0',
        'merah-1',
        'kuning-1',
        'hijau-1',
        'biru-1',
        'merah-2',
        'kuning-2',
        'hijau-2',
        'biru-2',
        'merah-3',
        'kuning-3',
        'hijau-3',
        'biru-3',
        'merah-4',
        'kuning-4',
        'hijau-4',
        'biru-4',
        'merah-5',
        'kuning-5',
        'hijau-5',
        'biru-5',
        'merah-6',
        'kuning-6',
        'hijau-6',
        'biru-6',
        'merah-7',
        'kuning-7',
        'hijau-7',
        'biru-7',
        'merah-8',
        'kuning-8',
        'hijau-8',
        'biru-8',
        'merah-9',
        'kuning-9',
        'hijau-9',
        'biru-9',
        'merah-skip',
        'kuning-skip',
        'hijau-skip',
        'biru-skip',
        'merah-reverse',
        'kuning-reverse',
        'hijau-reverse',
        'biru-reverse',
        'merah-draw2',
        'kuning-draw2',
        'hijau-draw2',
        'biru-draw2',
        'wild-card',
        'wild-card',
        'wild-card',
        'wild-card',
        'wild-card-plus4',
        'wild-card-plus4',
        'wild-card-plus4',
        'wild-card-plus4'
    ]
).