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

% Kode StartGame Telah disanitasi, kecuali input nama (memang belum bisa disanitasi)
startGame:- retractall(jml_pemain(_)),retractall(urutan_pemain(_,_)), retractall(efek(_)), retractall(game_started),
retractall(giliran(_)), retractall(discard_top(_)), retractall(kartu_tangan(_,_)),  % reset semua dynamic
inputJml(Jml),assertz(jml_pemain(Jml)),inputPemain(Jml,DaftarPemain), % input pemain dan Jumlah Pemain
copy(DaftarPemain,ListPemain),     % Mengcopy Daftar Pemain ke ListPemain
kocokurutan(ListPemain,Jml,[],UrutanPemain), % Mengocok Urutan Pemain ke dalam Variable UrutanPemain
nl,nl,
write('Setiap pemain mendapatkan 7 kartu acak'),
nl,nl,
get_head(UrutanPemain,Pemain1), % Ambil Pemain Pertama
assertz(giliran(Pemain1)),
assertz(game_started),
get_idx(UrutanPemain,Pemain1,Idx),
assertz(urutan_pemain(UrutanPemain,Idx)),
random_discardpile(Element),                % Ambil Kartu Random Untuk Kartu Awal di Dek
ekstrak_kartu(Element,Warna,Angka),         %  Mengambil Komponen Compound State
format('Kartu discard top: ~w-~w',[Warna,Angka]), 
assertz(discard_top(Element)),
nl,nl,
format('Giliran ~w',[Pemain1]), .

/*
Alur Ambil Kartu : 
Ngambil Kartu Secara Random (Lihat Rule nya di utils.pl), Lalu Ekstrak Warna dan Jenisnya
Baca Urutan Pemainnya, Informasikan Dia Dapat Kartu Apa, Tambah Ke List decknya (Belum Implement),
Setelah Itu Update Urutan Giliran dan Idx Urutan Pemain.
*/

ambilKartu:-
random_ambilkartu(Element),ekstrak_kartu(Element,Warna,Jenis), urutan_pemain(ListNama,Idx), 
get_idx(ListNama,Nama,Idx),jml_pemain(Jml), 
format('~w mendapatkan kartu: ~w-~w',[Nama,Warna,Jenis]),nl,nl,
NewIdx is Idx +1, (NewIdx>Jml -> NewestIdx is 1;NewestIdx is NewIdx),
get_idx(ListNama,NextNama,NewestIdx),
format('Giliran ~w',[NextNama]),nl,
retractall(urutan_pemain(_,_)), retractall(giliran(_)),assertz(giliran(NextNama)),
assertz(urutan_pemain(ListNama,NewestIdx)). 

% Pengambilan Kartu belum dimasukkan ke dalam list kartu milik Pemain tersebut