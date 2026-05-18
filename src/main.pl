:- dynamic(giliran/1).           % Menunjukan giliran siapa sekarang -> giliran(Pemain)
:- dynamic(kartu_tangan/2).      % Menunjukan kartu yang ada di tangan pemain -> kartu_tangan(Pemain, ListKartu)
:- dynamic(discard_top/1).       % Menunjukan kartu paling atas di menja -> discard_top(kartu(Warna, Jenis, normal/hide))
:- dynamic(efek/1).              % Menunjukan efek yang berlaku saat ini (plus 2, reverse, etc).
:- dynamic(jml_pemain/1). % menyimpan jumlah pemain saat ini
:- dynamic(urutan_pemain/2). % urutan_pemain(ListUrutan,IdxSaatini)
:- dynamic(game_started/0). % Menunjukkan state apakah game sudah dimulai.
:- dynamic(arah/1).             % arah kemana default ke kanan.
:- dynamic(list_uni/1).         % list orang yang pernah ngomon UNIIIIIIIIII
:- dynamic(warna_sebelumnya/1). % Menyimpan warna di meja sesaat SEBELUM diganti oleh kartu plus 4
:- dynamic(yg_keluarin_plus4/1).    % Menyimpan nama pemain yang mengeluarkan kartu plus 4
:- dynamic(warna_wild/1).       % Menyimpan warna aktif yang dipilih pemain setelah mengeluarkan kartu wild atau plus 4

% struktur kartu -> kartu(Warna, Jenis, normal/hide)
 
:- include('startGame_ambilKartu.pl').
:- include('cekInfo.pl').
:- include('endGame.pl'). 
:- include('lihatCommand.pl').
:- include('mainkanKartu.pl').
:- include('lihatKartu.pl').
:- include('saveloadGame.pl').
:- include('kartuaksi.pl').
:- include('tantang.pl').

% Kode StartGame Telah disanitasi
startGame:- retractall(jml_pemain(_)),retractall(urutan_pemain(_,_)), retractall(efek(_)), retractall(game_started),
    retractall(giliran(_)), retractall(discard_top(_)), retractall(kartu_tangan(_,_)), retractall(list_uni(_)),retractall(arah(_)),retractall(warna_sebelumnya(_)),retractall(yg_keluarin_plus4(_)),retractall(warna_wild(_)), % reset semua dynamic
    inputJml(Jml),assertz(jml_pemain(Jml)),inputPemain(Jml,DaftarPemain), assertz(arah('kanan')), assertz(list_uni([])),% input pemain dan Jumlah Pemain

    copy(DaftarPemain,ListPemain),     % Mengcopy Daftar Pemain ke ListPemain
    
    kocokurutan(ListPemain,Jml,[],UrutanPemain), % Mengocok Urutan Pemain ke dalam Variable UrutanPemain
    nl,nl,
    write('Setiap pemain mendapatkan 7 kartu acak'),
    simpan_kartu(UrutanPemain,UrutanPemain,Jml),
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
    format('Giliran ~w',[Pemain1]), !.

/*
Alur Ambil Kartu : 
Ngambil Kartu Secara Random (Lihat Rule nya di utils.pl), Lalu Ekstrak Warna dan Jenisnya
Baca Urutan Pemainnya, Informasikan Dia Dapat Kartu Apa, Tambah Ke List decknya (Belum Implement),
Setelah Itu Update Urutan Giliran dan Idx Urutan Pemain.
*/
% Ambil kartu untuk plus 2
ambilKartu :-
    efek('plus_dua'), !,
    giliran(Pemain),
    urutan_pemain(ListNama, Idx),
    jml_pemain(Jml),

    tambah_kartu(Pemain, 2),
    retract(efek('plus_dua')),

    next_giliran(Idx, NewestIdx, Jml),
    get_idx(ListNama, NextNama, NewestIdx),
    
    format('Giliran ~w',[NextNama]),nl,
    retractall(giliran(_)), assertz(giliran(NextNama)),
    retractall(urutan_pemain(_,_)), assertz(urutan_pemain(ListNama, NewestIdx)).

% Ambil kartu untuk plus 4
ambilKartu :-
    efek('plus_empat'), !,
    giliran(Pemain),
    urutan_pemain(ListNama, Idx),
    jml_pemain(Jml),

    tambah_kartu(Pemain, 4),
    retract(efek('plus_empat')),

    next_giliran(Idx, NewestIdx, Jml),
    get_idx(ListNama, NextNama, NewestIdx),

    format('Giliran ~w',[NextNama]),nl,
    
    retractall(giliran(_)), assertz(giliran(NextNama)),
    retractall(urutan_pemain(_,_)), assertz(urutan_pemain(ListNama, NewestIdx)).

ambilKartu:-
    random_ambilkartu(Element),ekstrak_kartu(Element,Warna,Jenis), urutan_pemain(ListNama,Idx), 
    get_idx(ListNama,Nama,Idx),jml_pemain(Jml), 
    
    format('~w mendapatkan kartu: ~w-~w',[Nama,Warna,Jenis]),nl,nl,
    
    kartu_tangan(Nama,KartuLama),
    insert_tail(KartuLama,Element,KartuBaru),
    retract(kartu_tangan(Nama,_)),
    
    assertz(kartu_tangan(Nama,KartuBaru)),
    next_giliran(Idx,NewestIdx,Jml),
    get_idx(ListNama,NextNama,NewestIdx),
    
    format('Giliran ~w',[NextNama]),nl,
    
    retractall(urutan_pemain(_,_)), retractall(giliran(_)),assertz(giliran(NextNama)),
    assertz(urutan_pemain(ListNama,NewestIdx)). 

% Pengambilan Kartu belum dimasukkan ke dalam list kartu milik Pemain tersebut, dan belum bisa ganti giliran

cekInfo :-
    discard_top(kartu(WarnaTeratas, JenisTeratas, _)), 
    % arah(ArahPermainan),
    
    write('Kartu discard top: '), write(WarnaTeratas), write('-'), write(JenisTeratas), nl,
    
    urutan_pemain(DaftarPemain,_),
    
    write('Urutan pemain: '), print_list_pemain(DaftarPemain), nl,
    %  write('Arah Permainan: '), write(Arah),nl, 
    write('Informasi pemain: '), nl,
    
    print_info_pemain(DaftarPemain), !.

lihatCommand :-
    discard_top(kartu(WarnaNow, JenisNow, _)),
    giliran(Pemain),
    kartu_tangan(Pemain, ListKartu),
    
    write('Aksi utama yang tersedia:'), nl,
    (JenisNow == 'plus_empat', efek('plus_empat') ->
        write('1. ambilKartu'), nl,
        write('2. tantang'), nl
        ; JenisNow == 'plus_dua', efek('plus_dua') ->
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
    discard_top(KartuAtas),             % cek kartu teratas


    % Validasi kartu dimainkan
    (   cek_validitas(KartuPilihan, KartuAtas)
    ->  
        % jika valid
        KartuPilihan = kartu(Warna, Jenis, _),                             % warna jenis ditampilkan 
       (Jenis == 'plus_empat' ->
            ekstrak_kartu(KartuAtas, WarnaMeja, _),
            retractall(warna_sebelumnya(_)),
            assertz(warna_sebelumnya(WarnaMeja)) ; true),
        format('~w memainkan kartu: ~w-~w~n', [Pemain, Warna, Jenis]), 
        IndexHapus is NomorUrut - 1,                                       % hapus kartu di tangan                   
        del(ListKartu, IndexHapus, ListBaru),                              % update kartu_tangan
        retract(kartu_tangan(Pemain, ListKartu)),
        assertz(kartu_tangan(Pemain, ListBaru)),
        retract(discard_top(KartuAtas)),                                   % update discard_top
        assertz(discard_top(kartu(Warna, Jenis, normal))),

        efek_aksi(Jenis),
        (Jenis == 'skip' ->             % aksi skip
        urutan_pemain(_, NewestIdx),
        get_idx(ListNama, NextNama, NewestIdx)
        ; next_giliran(Idx, NewestIdx, Jml),        % urutan normal
        get_idx(ListNama, NextNama, NewestIdx)),
        retractall(giliran(_)),
        assertz(giliran(NextNama)),
        retractall(urutan_pemain(_,_)),
        assertz(urutan_pemain(ListNama, NewestIdx)),

        nl, write('--- Giliran Selesai ---'), nl,                          % ganti giliran
        format('Giliran ~w',[NextNama]),nl,
        
        write('(Catatan: Fungsi pindah giliran akan diintegrasikan nanti)'), nl
        
    ;   
        % jika tidak valid
        write('Kartu tidak valid! Warna atau angkanya tidak cocok dengan kartu di meja.'), nl,
        fail
    ).

 
% Rule utama endGame
endGame :-
    giliran(Pemenang),
    format('Permainan selesai! ~w menghabiskan semua kartunya!~n~n', [Pemenang]),
    write('Berikut perhitungan poin sisa kartu:'), nl,
    urutan_pemain(DaftarPemain),
    tampilkan_perhitungan(DaftarPemain), nl,
    sort_pemain(DaftarPemain, SortedList),
    write('Urutan pemenang:'), nl,
    tampilkan_peringkat(SortedList, 1),
    get_head(SortedList, Juara1),
    format('~nSelamat, ~w menjadi pemenang!~n', [Juara1]),
    retractall(game_started).

saveGame:- 
    list_uni(ListUni),
    urutan_pemain(Urutan,_),
    giliran(Nama),
    arah(ArahPermainan),
    discard_top(KartuAtas),
    ekstrak_kartu(KartuAtas,Warna,Jenis),

    write('Masukkan nama file penyimpanan: '),
    read(Input),
    insert_txt(Input,LoadFileName),
    assertz(nama_file(Input)),
    
    open(LoadFileName,write,LoadGameFormat),
    format(LoadGameFormat,'urutan_pemain: ~q.',[Urutan]),
    nl(LoadGameFormat),
    
    format(LoadGameFormat,'giliran:~q.',[Nama]),
    nl(LoadGameFormat),
    
    format(LoadGameFormat,'discard_top:~w-~w.',[Warna,Jenis]),
    nl(LoadGameFormat),
    
    format(LoadGameFormat,'warna_aktif:~w.',[Warna]),
    nl(LoadGameFormat),
    
    format(LoadGameFormat,'arah_permainan:~q.',[ArahPermainan]),
    nl(LoadGameFormat),
    
    (ListUni == []->format(LoadGameFormat,'status_UNI:~q.',[[]]);
    format(LoadGameFormat,'status_UNI:~q.',[ListUni])),
    nl(LoadGameFormat),

    print_kartu_sisa(Urutan,LoadGameFormat),

    format('Status permainan berhasil disimpan ke ~w.txt.',[Input]),
    
    close(LoadGameFormat),!.
    
loadGame:-
    directory_files('.',Files),
    write('Masukkan nama file yang akan dimuat: '),
    read(Input),
    insert_txt(Input,Inputtxt),
    get_idx(Files,Inputtxt,Index),
    ((Index =\= -1) -> nl; write('Maaf Nama file yang anda masukkan tidak tersedia'),fail),

    retractall(jml_pemain(_)),retractall(urutan_pemain(_,_)), retractall(efek(_)), retractall(game_started),
    retractall(giliran(_)), retractall(discard_top(_)), retractall(kartu_tangan(_,_)), retractall(list_uni(_)),retractall(arah(_)),
    
    insert_txt(Input,LoadFileName),
    open(LoadFileName,read,LoadFileFormat),
    readformat(LoadFileFormat,UrutanPemain),
    readformat(LoadFileFormat,PemainNow),
    
    assertz(giliran(PemainNow)),
    get_idx(UrutanPemain,PemainNow,Idx),
    assertz(urutan_pemain(UrutanPemain,Idx)),

    readformatdiscardtop(LoadFileFormat,Warna,Jenis), 
    Element = kartu(Warna,Jenis,normal),
    assertz(discard_top(Element)),
    
    readformat(LoadFileFormat,_), % warna aktif (g dipake)

    readformat(LoadFileFormat,ArahPermainan),
    assertz(arah(ArahPermainan)),
    readformat(LoadFileFormat,ListUni),
    
    assertz(list_uni(ListUni)),
    

    panjang(0,Pjg,UrutanPemain),
    assertz(jml_pemain(Pjg)),

    loadkartu(Pjg,UrutanPemain,LoadFileFormat),
    
    format('Status permainan berhasil dimuat dari ~w.txt.',[Input]),nl,
    format('Melanjutkan Giliran ~w.',[PemainNow]),close(LoadFileFormat),!.

% exits sementara
exita:-  retractall(jml_pemain(_)),retractall(urutan_pemain(_,_)), retractall(efek(_)), retractall(game_started),
    retractall(giliran(_)), retractall(discard_top(_)), retractall(kartu_tangan(_,_)), retractall(list_uni(_)),retractall(arah(_)).
