:- dynamic(giliran/1).           % Menunjukan giliran siapa sekarang -> giliran(Pemain)
:- dynamic(kartu_tangan/2).      % Menunjukan kartu yang ada di tangan pemain -> kartu_tangan(Pemain, ListKartu)
:- dynamic(discard_top/1).       % Menunjukan kartu paling atas di menja -> discard_top(kartu(Warna, Jenis, normal/hide))
:- dynamic(efek/1).              % Menunjukan efek yang berlaku saat ini (skip, reverse, etc), note: belum diimplementasiin (masih placeholder)
:- dynamic(jml_pemain/1).
:- dynamic(nama_pemain/2).
:- dynamic(urutan_pemain/1).
:- dynamic(game_started/0).
% struktur kartu -> kartu(Warna, Jenis, normal/hide)

:- include('utils_startgame').
:- include('cekInfo.pl').
:- include('endGame.pl').

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
assertz(game_started),
kartuangka(ListKartuAngka),
random_select_tanpadel(ListKartuAngka, 1,Element),
format('Kartu discard top: ~w',[Element]),
assertz(discard_top(Element)),
nl,nl,
format('Giliran ~w',[Pemain1]),retractall(jml_pemain(Jml)). % nanti retract all nya dihapus biar ke save
% Belum Disanitasi (Output di luar yang diperbolehkan) dan Belum bisa ambil kartu