:- dynamic(giliran/1).           % Menunjukan giliran siapa sekarang -> giliran(Pemain)
:- dynamic(kartu_tangan/2).      % Menunjukan kartu yang ada di tangan pemain -> kartu_tangan(Pemain, ListKartu)
:- dynamic(discard_top/1).       % Menunjukan kartu paling atas di menja -> discard_top(kartu(Warna, Jenis, normal/hide))
:- dynamic(efek/1).              % Menunjukan efek yang berlaku saat ini (skip, reverse, etc), note: belum diimplementasiin (masih placeholder)
:- dynamic(jml_pemain/1). % menyimpan jumlah pemain saat ini
:- dynamic(urutan_pemain/2). % urutan_pemain(ListUrutan,IdxSaatini)
:- dynamic(game_started/0). % Menunjukkan state apakah game sudah dimulai.
% struktur kartu -> kartu(Warna, Jenis, normal/hide)
 
:- include('utils.pl').
:- include('cekInfo.pl').
% :- include('endGame.pl'). % masih bermasalah

startGame:- retractall(jml_pemain(_)),retractall(urutan_pemain(_,_)),retractall(giliran(_)),
inputJml(Jml),assertz(jml_pemain(Jml)),inputPemain(Jml,DaftarPemain),
copy(DaftarPemain,ListPemain),
kocokurutan(ListPemain,Jml,[],UrutanPemain),
nl,nl,
write('Setiap pemain mendapatkan 7 kartu acak'),
nl,nl,
get_head(UrutanPemain,Pemain1),
assertz(giliran(Pemain1)),
assertz(game_started),
get_idx(UrutanPemain,Pemain1,Idx),
assertz(urutan_pemain(UrutanPemain,Idx)),
random_discardpile(Element),
ekstrak_kartu(Element,Warna,Angka),
format('Kartu discard top: ~w-~w',[Warna,Angka]),
assertz(discard_top(Element)),
nl,nl,
format('Giliran ~w',[Pemain1]). % nanti retract all nya dihapus biar ke save


ambilKartu:-
random_ambilkartu(Element),ekstrak_kartu(Element,Warna,Jenis), urutan_pemain(ListNama,Idx),
get_idx(ListNama,Nama,Idx),jml_pemain(Jml), 
format('~w mendapatkan kartu: ~w-~w',[Nama,Warna,Jenis]),nl,nl,
NewIdx is Idx +1, (NewIdx>Jml -> NewestIdx is 1;NewestIdx is NewIdx),
get_idx(ListNama,NextNama,NewestIdx),
format('Giliran ~w',[NextNama]),nl,
retractall(urutan_pemain(_,_)), retract(giliran(_)),assertz(giliran(NextNama)),
assertz(urutan_pemain(ListNama,NewestIdx)).