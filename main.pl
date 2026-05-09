:- dynamic(giliran/1).
:- dynamic(kartu_tangan/2).
:- dynamic(discard_top/1).
:- dynamic(efek/1).
:- dynamic(jml_pemain/1).
:- dynamic(nama_pemain/2).
:- dynamic(urutan_pemain/1).


:- include('utils_startgame').

startGame:- retractall(jml_pemain(_)),
inputJml(Jml),assertz(jml_pemain(Jml)),inputPemain(Jml,DaftarPemain),
copy(DaftarPemain,ListPemain),
kocokurutan(ListPemain,Jml,[],UrutanPemain),
nl,nl,
write('Setiap pemain mendapatkan 7 kartu acak'),
nl,nl,
get_head(UrutanPemain,Pemain1),
assertz(urutan_pemain(UrutanPemain)),
assertz(giliran(Pemain1)),
kartuangka(ListKartuAngka),
random_select_tanpadel(ListKartuAngka, 1,Element),
format('Kartu discard top: ~w',[Element]),
assertz(discard_top(Element))
nl,nl,
format('Giliran ~w',[Pemain1]),retractall(jml_pemain(Jml)). % nanti retract all nya dihapus biar ke save

