:- dynamic(giliran/1).           % Menunjukan giliran siapa sekarang -> giliran(Pemain)
:- dynamic(kartu_tangan/2).      % Menunjukan kartu yang ada di tangan pemain -> kartu_tangan(Pemain, ListKartu)
:- dynamic(discard_top/1).       % Menunjukan kartu paling atas di menja -> discard_top(kartu(Warna, Jenis, normal/hide))
:- dynamic(efek/1).              % Menunjukan efek yang berlaku saat ini (skip, reverse, etc), note: belum diimplementasiin (masih placeholder)
:- dynamic(jml_pemain/1). % menyimpan jumlah pemain saat ini
:- dynamic(urutan_pemain/2). % urutan_pemain(ListUrutan,IdxSaatini)
:- dynamic(game_started/0). % Menunjukkan state apakah game sudah dimulai.
:- dynamic(arah/1).             % arah kemana default ke kanan.
:- dynamic(list_uni/1).         % list orang yang pernah ngomon UNIIIIIIIIII
% struktur kartu -> kartu(Warna, Jenis, normal/hide)
 
:- include('startGame_ambilKartu.pl').
:- include('cekInfo.pl').
:- include('endGame.pl'). 
:- include('lihatCommand.pl').
:- include('mainkanKartu.pl').
:- include('lihatKartu.pl').
:- include('saveloadGame.pl').

% Kode StartGame Telah disanitasi, kecuali input nama (memang belum bisa disanitasi)
startGame:- retractall(jml_pemain(_)),retractall(urutan_pemain(_,_)), retractall(efek(_)), retractall(game_started),
retractall(giliran(_)), retractall(discard_top(_)), retractall(kartu_tangan(_,_)),  % reset semua dynamic
inputJml(Jml),assertz(jml_pemain(Jml)),inputPemain(Jml,DaftarPemain), assertz(arah('kanan')), assertz(list_uni([]))% input pemain dan Jumlah Pemain
copy(DaftarPemain,ListPemain),     % Mengcopy Daftar Pemain ke ListPemain
kocokurutan(ListPemain,Jml,[],UrutanPemain), % Mengocok Urutan Pemain ke dalam Variable UrutanPemain
nl,nl,
write('Setiap pemain mendapatkan 7 kartu acak'),
simpan_kartu(UrutanPemain,UrutanPemain,Jml),
/*kartu_awalpemain(DaftarKartuSemua,Jml),
simpan_kartu_pemain(UrutanPemain,DaftarKartuSemua),*/ % belum bisa (Stack Overflow)
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
format('Giliran ~w',[Pemain1]).

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
kartu_tangan(Nama,KartuLama),
insert_tail(KartuLama,Element,KartuBaru),
retract(kartu_tangan(Nama,_)),
assertz(kartu_tangan(Nama,KartuBaru)),
NewIdx is Idx +1, (NewIdx>=Jml -> NewestIdx is (NewIdx mod Jml) ;NewestIdx is NewIdx),
get_idx(ListNama,NextNama,NewestIdx),
format('Giliran ~w',[NextNama]),nl,
retractall(urutan_pemain(_,_)), retractall(giliran(_)),assertz(giliran(NextNama)),
assertz(urutan_pemain(ListNama,NewestIdx)). 

% Pengambilan Kartu belum dimasukkan ke dalam list kartu milik Pemain tersebut, dan belum bisa ganti giliran

cekInfo :-
    discard_top(kartu(WarnaTeratas, JenisTeratas, _)),
    write('Kartu discard top: '), write(WarnaTeratas), write('-'), write(JenisTeratas), nl,
    urutan_pemain(DaftarPemain,_),
    write('Urutan pemain: '), print_list_pemain(DaftarPemain), nl,
    write('Informasi pemain: '), nl,
    print_info_pemain(DaftarPemain), !.

lihatCommand :-
    discard_top(kartu(WarnaNow, JenisNow, _)),
    giliran(Pemain),
    kartu_tangan(Pemain, ListKartu),
    write('Aksi utama yang tersedia:'), nl,
    (JenisNow == draw_four ->
        write('1. ambilKartu'), nl,
        write('2. tantang'), nl
        ; JenisNow == draw_two ->
            write('1. ambilKartu'), nl
        ; (valid_play(ListKartu, WarnaNow, JenisNow) ->
            write('1. mainkanKartu()'), nl,
            write('2. ambilKartu'), nl
        ; write('1. ambilKartu'), nl)),
    nl,
    write('Aksi pendukung yang tersedia:'), nl,
    write('1. lihatCommand'), nl,
    write('2. lihatKartu'), nl,
    write('3. cekInfo'), nl, !.

lihatKartu :-
    giliran(Pemain),
    (kartu_tangan(Pemain, ListKartu) ->
        write('Berikut kartu yang anda miliki.'), nl,
        print_list_kartu(ListKartu, 1) ;
        write('Data kartu tidak ditemukan!'), nl), !. 

mainkanKartu(NomorUrut) :-
    giliran(Pemain),                      % cek giliran 
    kartu_tangan(Pemain, ListKartu),
    urutan_pemain(ListNama,Idx),
    jml_pemain(Jml),

    (   ambil_kartu_ke(NomorUrut, ListKartu, KartuPilihan)      % ambil kartu dari list
    ->  true
    ;   write('Nomor urut tidak valid! Membatalkan aksi.'), nl, fail
    ),
    discard_top(KartuAtas),             %cek kartu teratas


    % Validasi kartu dimainkan
    (   cek_validitas(KartuPilihan, KartuAtas)
    ->  
        % jika valid
        KartuPilihan = kartu(Warna, Jenis, _),                             % warna jenis ditampilkan 
        format('~w memainkan kartu: ~w-~w~n', [Pemain, Warna, Jenis]), 
        IndexHapus is NomorUrut - 1,                                       % hapus kartu di tangan                   
        del(ListKartu, IndexHapus, ListBaru),                              % update kartu_tangan
        retract(kartu_tangan(Pemain, ListKartu)),
        assertz(kartu_tangan(Pemain, ListBaru)),
        retract(discard_top(KartuAtas)),                                   % update discard_top
        assertz(discard_top(kartu(Warna, Jenis, normal))),
        nl, write('--- Giliran Selesai ---'), nl,                          % ganti giliran
        NewIdx is Idx +1, (NewIdx>=Jml -> NewestIdx is (NewIdx mod Jml);NewestIdx is NewIdx),
        get_idx(ListNama,NextNama,NewestIdx),
        format('Giliran ~w',[NextNama]),nl,
        retractall(urutan_pemain(_,_)), retractall(giliran(_)),assertz(giliran(NextNama)),
        assertz(urutan_pemain(ListNama,NewestIdx)),
        write('(Catatan: Fungsi pindah giliran akan diintegrasikan nanti)'), nl
        
    ;   
        % jika tidak valid
        write('Kartu tidak valid! Warna atau angkanya tidak cocok dengan kartu di meja.'), nl,
        fail
    ).

    % 
% Rule utama endGame
endGame :-
    giliran(Pemenang),
    format('Permainan selesai! ~w menghabiskan semua kartunya!~n~n', [Pemenang]),
    write('Berikut perhitungan poin sisa kartu:'), nl,
    urutan_pemain(DaftarPemain,_),
    tampilkan_perhitungan(DaftarPemain), nl,
    predsort(bandingkan_pemain, DaftarPemain, SortedL),
    write('Urutan pemenang:'), nl,
    tampilkan_peringkat(SortedL, 1),
    nth1(1, SortedL, Juara1),
    format('~nSelamat, ~w menjadi pemenang!~n', [Juara1]),
    retractall(game_started).

saveGame:- 
    % list_uni(ListUni),
    urutan_pemain(Urutan,_),
    giliran(Nama),
    arah(ArahPermainan),
    discard_top(KartuAtas),
    ekstrak_kartu(KartuAtas,Warna,Jenis),
    write('Masukkan nama file penyimpanan: '),
    read(Input),
    atom_concat(Input, '.txt', SaveFileName),
    atom_concat(Input, 'loadgame.txt', LoadFileName),
    open(SaveFileName,write,SaveGameFormat),
    open(LoadFileName,write,LoadGameFormat),
    format(SaveGameFormat,'urutan_pemain: ~w',[Urutan]),
    nl(SaveGameFormat),
    format(LoadGameFormat,'~w.',[Urutan]),
    nl(LoadGameFormat),
    format(SaveGameFormat,'giliran:~w',[Nama]),
    nl(SaveGameFormat),
    format(LoadGameFormat,'~w.',[Nama]),
    nl(LoadGameFormat),
    format(SaveGameFormat,'discard_top:~w-~w',[Warna,Jenis]),
    nl(SaveGameFormat),
    format(LoadGameFormat,'~w.',[Warna]),
    nl(LoadGameFormat),
    format(LoadGameFormat,'~w.',[Jenis]),
    nl(LoadGameFormat),
    print_kartu_sisa(Urutan,LoadGameFormat,SaveGameFormat),
    format(SaveGameFormat,'arah_permainan:~w',[ArahPermainan]),
    nl(SaveGameFormat),
    format(LoadGameFormat,'~w.',[ArahPermainan]),
    nl(LoadGameFormat),
    format(SaveGameFormat,'warna_aktif:~w',[Warna]),
    nl(SaveGameFormat),
    format(SaveGameFormat,'status_UNI:~w',[ListUni]),
    nl(SaveGameFormat),
    format(LoadGameFormat,'~w.',[ListUni]),
    nl(LoadGameFormat),
    format('Status permainan berhasil disimpan ke ~w.txt.',[Input]),
    close(SaveGameFormat),
    close(LoadGameFormat).
    

    