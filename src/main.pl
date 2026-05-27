:- dynamic(giliran/1).           % Menunjukan giliran siapa sekarang -> giliran(Pemain)
:- dynamic(kartu_tangan/2).      % Menunjukan kartu yang ada di tangan pemain -> kartu_tangan(Pemain, ListKartu)
:- dynamic(discard_top/1).       % Menunjukan kartu paling atas di menja -> discard_top(kartu(Warna, Jenis, normal/hide))
:- dynamic(efek/1).              % Menunjukan efek yang berlaku saat ini (plus 2, reverse, etc).
:- dynamic(jml_pemain/1).        % menyimpan jumlah pemain saat ini
:- dynamic(urutan_pemain/2).     % urutan_pemain(ListUrutan,IdxSaatini)
:- dynamic(game_started/0).      % Menunjukkan state apakah game sudah dimulai.
:- dynamic(arah/1).              % arah kemana default ke kanan.
:- dynamic(list_uni/1).          % list orang yang pernah ngomon UNIIIIIIIIII
:- dynamic(warna_sebelumnya/1).  % Menyimpan warna di meja sesaat SEBELUM diganti oleh kartu plus 4
:- dynamic(jenis_sebelumnya/1).  % Menyimpan jenis di meja sesaat SEBELUM diganti oleh kartu plus 4
:- dynamic(yg_keluarin_plus4/1). % Menyimpan nama pemain yang mengeluarkan kartu plus 4
:- dynamic(warna_wild/1).        % Menyimpan warna aktif yang dipilih pemain setelah mengeluarkan kartu wild atau plus 4
:- dynamic(reverse_pemain/1).    % Menyimpan list urutan pemain yang direverse
:- dynamic(nama_file/1).
:- dynamic(warna_wild_sebelumnya/1).
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
:- include('sembunyikan.pl').
:- include('utils.pl').


% =============================== startGame ===============================
% Kode StartGame Telah disanitasi
startGame:- retractall(jml_pemain(_)),retractall(urutan_pemain(_,_)), retractall(efek(_)), retractall(game_started),
    retractall(giliran(_)), retractall(discard_top(_)), retractall(kartu_tangan(_,_)), retractall(list_uni(_)),retractall(arah(_)),
    retractall(warna_sebelumnya(_)),retractall(yg_keluarin_plus4(_)),retractall(warna_wild(_)), retractall(reverse_pemain(_)), % reset semua dynamic
    
    randomize,
    inputJml(Jml),assertz(jml_pemain(Jml)),inputPemain(Jml,DaftarPemain), assertz(arah('kanan')), assertz(list_uni([])),% input pemain dan Jumlah Pemain

    copy(DaftarPemain,ListPemain),     % Mengcopy Daftar Pemain ke ListPemain
    
    kocokurutan(ListPemain,Jml,[],UrutanPemain), % Mengocok Urutan Pemain ke dalam Variable UrutanPemain
    nl,nl,
    write('Setiap pemain mendapatkan 7 kartu acak'),
    simpan_kartu(UrutanPemain,UrutanPemain,Jml),
    nl,nl,
    
    reverse_list(UrutanPemain, ReversedPemain),
    assertz(reverse_pemain(ReversedPemain)),
    
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


% =============================== ambilKartu ===============================
/*
Alur Ambil Kartu : 
Ngambil Kartu Secara Random (Lihat Rule nya di utils.pl), Lalu Ekstrak Warna dan Jenisnya
Baca Urutan Pemainnya, Informasikan Dia Dapat Kartu Apa, Tambah Ke List decknya,
Setelah Itu Update Urutan Giliran dan Idx Urutan Pemain.
*/
% Ambil kartu untuk plus 2
ambilKartu :-
    (game_started -> true; write('Maaf Fitur ini tidak dapat digunakan jika belum startGame atau loadGame'),!,fail),
    efek('plus_dua'), !,
    giliran(Pemain),
    urutan_pemain(ListNama, Idx),
    jml_pemain(Jml),

    list_uni(ListUnii),
    get_idx(ListUnii,Pemain,IdxUni),
    (IdxUni =\= -1 -> del(ListUnii,IdxUni,ListBaruUnii),
        retractall(list_uni(_)),
        assertz(list_uni(ListBaruUnii))
    ;true),

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
    
    list_uni(ListUnii),
    get_idx(ListUnii,Pemain,IdxUni),
    (IdxUni =\= -1 -> del(ListUnii,IdxUni,ListBaruUnii),
        retractall(list_uni(_)),
        assertz(list_uni(ListBaruUnii))
    ;true),

    tambah_kartu(Pemain, 4),
    retract(efek('plus_empat')),
    retractall(warna_wild_sebelumnya(_)),

    next_giliran(Idx, NewestIdx, Jml),
    get_idx(ListNama, NextNama, NewestIdx),

    format('Giliran ~w',[NextNama]),nl,
    
    retractall(giliran(_)), assertz(giliran(NextNama)),
    retractall(urutan_pemain(_,_)), assertz(urutan_pemain(ListNama, NewestIdx)).

% Ambil kartu biasa
ambilKartu:-
    random_ambilkartu(Element),ekstrak_kartu(Element,Warna,Jenis), urutan_pemain(ListNama,Idx), 
    get_idx(ListNama,Nama,Idx),jml_pemain(Jml), list_uni(ListUnii),
    
    format('~w mendapatkan kartu: ~w-~w',[Nama,Warna,Jenis]),nl,nl,

    get_idx(ListUnii,Nama,IdxUni),
    (IdxUni =\= -1 -> del(ListUnii,IdxUni,ListBaruUnii),
        retractall(list_uni(_)),
        assertz(list_uni(ListBaruUnii))
    ;true),
    
    kartu_tangan(Nama,KartuLama),
    insert_tail(KartuLama,Element,KartuBaru),
    retract(kartu_tangan(Nama,_)),
    
    assertz(kartu_tangan(Nama,KartuBaru)),
    next_giliran(Idx,NewestIdx,Jml),
    get_idx(ListNama,NextNama,NewestIdx),
    
    format('Giliran ~w',[NextNama]),nl,
    
    retractall(urutan_pemain(_,_)), retractall(giliran(_)),assertz(giliran(NextNama)),
    assertz(urutan_pemain(ListNama,NewestIdx)). 


% =============================== cekInfo ===============================
cekInfo :-
    (game_started -> true; write('Maaf Fitur ini tidak dapat digunakan jika belum startGame atau loadGame'),fail),
    discard_top(kartu(WarnaTeratas, JenisTeratas, _)), 
    
    write('Kartu discard top: '), write(WarnaTeratas), write('-'), write(JenisTeratas), nl,
    
    urutan_pemain(DaftarPemain,_),
    reverse_pemain(Reversed),
    write('Urutan pemain: '), 
    (arah('kanan') -> print_list_pemain(DaftarPemain), nl
    ; print_list_pemain(Reversed), nl),
    
    write('Informasi pemain: '), nl,
    
    print_info_pemain(DaftarPemain), !.


% =============================== lihatCommand ===============================
lihatCommand :-
    (game_started -> true; write('Maaf Fitur ini tidak dapat digunakan jika belum startGame atau loadGame'),fail),
    discard_top(kartu(WarnaNow, JenisNow, _)),
    giliran(Pemain),
    kartu_tangan(Pemain, ListKartu),
    
    write('Aksi utama yang tersedia:'), nl,
    ( (JenisNow == 'plus_empat', efek('plus_empat')) ->             % pemain mendapat +4
        write('1. ambilKartu'), nl,
        write('2. tantang'), nl,
        Count is 0
    ; (JenisNow == 'plus_dua', efek('plus_dua')) ->                 % pemain mendapat +2
        write('1. ambilKartu'), nl,
        Count is 0
    ; ((JenisNow == 'plus_empat' ; JenisNow == 'wildcard')) ->      % menyesuaikan warna aktif untuk kondisi +4 dan wildcard
        warna_wild(WarnaAktif),
        (valid_play(ListKartu, WarnaAktif, JenisNow) ->
            write('1. mainkanKartu(NomorUrut)'), nl,
            write('2. ambilKartu'), nl,
            write('3. tangkap(Pemain)'), nl,
            Count is 4
        ;   write('1. ambilKartu'), nl,
            write('2. tangkap(Pemain)'), nl,
            Count is 3
        )
    ; (valid_play(ListKartu, WarnaNow, JenisNow) ->             % pemain memiliki kartu yang cocok dengan discard top
        write('1. mainkanKartu(NomorUrut)'), nl,
        write('2. ambilKartu'), nl,
        write('3. tangkap(Pemain)'), nl,
        Count is 4
    ;   write('1. ambilKartu'), nl,                             % pemain tidak memiliki kartu yang cocok dengan discard top
        write('2. tangkap(Pemain)'), nl,
        Count is 3)),
    
    % untuk sembunyikan dan tampilkan
    ((\+ efek('plus_dua'), \+ efek('plus_empat')) ->
        panjang(0, JmlKartu, ListKartu),
        count_normal(ListKartu, JmlNormal),
        (JmlKartu > 1 ->
            format('~d. sembunyikanKartu(NomorUrut)~n', [Count]),
            Count1 is Count+1
        ; Count1 is Count),
        (JmlNormal \= JmlKartu ->
            format('~d. tampilkanKartu(NomorUrut)~n', [Count1])
        ; true)
    ; true),

    nl,
    write('Aksi pendukung yang tersedia:'), nl,
    write('1. lihatCommand'), nl,
    write('2. lihatKartu'), nl,
    write('3. cekInfo'), nl, !.


% =============================== lihatKartu ===============================
lihatKartu :-
    (game_started -> true; write('Maaf Fitur ini tidak dapat digunakan jika belum startGame atau loadGame'),fail),
    giliran(Pemain),
    (kartu_tangan(Pemain, ListKartu) ->
        write('Berikut kartu yang anda miliki.'), nl,
        print_list_kartu(ListKartu, 1) ;
        write('Data kartu tidak ditemukan!'), nl), !.


% =============================== mainkanKartu ===============================
mainkanKartu(NomorUrut) :-
    (game_started -> true; write('Maaf Fitur ini tidak dapat digunakan jika belum startGame atau loadGame'),fail),
    giliran(Pemain),                      % cek giliran 
    kartu_tangan(Pemain, ListKartu),
    urutan_pemain(ListNama,Idx),
    jml_pemain(Jml),

    % cek apakah pemain terkena efek plus (tidak bisa mainkanKartu)
    ((efek('plus_dua') ; efek('plus_empat')) -> write('Anda tidak dapat mainkanKartu saat giliran ini!'), nl, fail        % restriksi +2 dan +4
    ; true),

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
        discard_top(kartu(WarnaMeja, JenisMeja, _)),


        % Mencegah plus 2 berturut-turut
        (JenisMeja == 'plus_dua', Jenis == 'plus_dua' ->
            write('Kartu +2 tidak boleh dimainkan berturut-turut!'), nl, fail
        ; true),

        (Jenis == 'plus_empat' ->
            kartu(WarnaMeja, JenisMeja, _),
            retractall(warna_sebelumnya(_)),
            assertz(warna_sebelumnya(WarnaMeja)),
            retractall(jenis_sebelumnya(_)),
            assertz(jenis_sebelumnya(JenisMeja)),
            retractall(yg_keluarin_plus4(_)),
            assertz(yg_keluarin_plus4(Pemain))
        ;  retractall(warna_wild_sebelumnya(_)), true
        ),
        format('~w memainkan kartu: ~w-~w~n', [Pemain, Warna, Jenis]), 
        IndexHapus is NomorUrut - 1,                                       % hapus kartu di tangan                   
        del(ListKartu, IndexHapus, ListBaru),                              % update kartu_tangan
        retract(kartu_tangan(Pemain, _)),
        assertz(kartu_tangan(Pemain, ListBaru)),

        panjang(0,PjgList,ListBaru),
        (PjgList =:=0 -> endGame,!;nl),
        
        (Jenis \== wildcard, Jenis \== plus_empat ->
            retractall(warna_wild(_))
        ;   true
        ),

        efek_aksi(Jenis),
        (Jenis == 'skip' ->             % aksi skip
        urutan_pemain(_, NewIdx),
        next_giliran(NewIdx,NewestIdx,Jml),
        get_idx(ListNama, NextNama, NewestIdx)
        ; (
            (Jml =:= 2, Jenis =='reverse')-> efek_aksi('skip'), urutan_pemain(_, NewIdx), 
        next_giliran(NewIdx,NewestIdx,Jml),get_idx(ListNama, NextNama, NewestIdx)
        
        ;
        
        next_giliran(Idx, NewestIdx, Jml),        % urutan normal
        get_idx(ListNama, NextNama, NewestIdx))),

        retractall(discard_top(_)),
        assertz(discard_top(kartu(Warna, Jenis, normal))),
        retractall(giliran(_)),
        assertz(giliran(NextNama)),
        retractall(urutan_pemain(_,_)),
        assertz(urutan_pemain(ListNama, NewestIdx)),

        nl, write('--- Giliran Selesai ---'), nl,                          % ganti giliran
        format('Giliran ~w',[NextNama]),nl,!
        ;   
        % jika tidak valid
        write('Kartu tidak valid! Warna atau angkanya tidak cocok dengan kartu di meja.'), nl,
        fail
    ).


% =============================== tantang ===============================
tantang :-
    (game_started -> true; write('Maaf Fitur ini tidak dapat digunakan jika belum startGame atau loadGame'),fail),

    efek('plus_empat'),
    yg_keluarin_plus4(Tersangka),
    urutan_pemain(List, Idx),
    get_idx(List, Penantang, Idx),

    write('Tantangan dilakukan!'), nl,
    write('Memeriksa kartu '), write(Tersangka), write('...'), nl,

    warna_sebelumnya(WarnaLama),
    jenis_sebelumnya(JenisLama),

    (JenisLama == wildcard-> retract(warna_sebelumnya(_)), warna_wild_sebelumnya(WarnaWild),
    kartu_tangan(Tersangka, ListKartu),
    (cek_kecocokkan(ListKartu, WarnaWild, JenisLama) ->
        write('Tantangan berhasil!'),nl,
        format('Pemain ~w memiliki kartu yang cocok.', [Tersangka]), nl,
        format('Pemain ~w harus mengambil 4 kartu.', [Tersangka]), nl,
        
        tambah_kartu(Tersangka, 4) ;
    
        write('Tantangan gagal!'), nl,
        format('~w tidak memiliki kartu yang cocok.', [Tersangka]), nl,
        format('~w mendapatkan 6 kartu acak.', [Penantang]), nl,
        
        tambah_kartu(Penantang, 6)),
        
        retract(efek('plus_empat')),
        urutan_pemain(ListPemain, IdxPenantang),
        jml_pemain(Jml),
        
        next_giliran(IdxPenantang, IdxBaru, Jml),
        get_idx(ListPemain, PemainBaru, IdxBaru),
        
        retractall(giliran(_)), assertz(giliran(PemainBaru)),retractall(warna_wild_sebelumnya(_)),
        retractall(urutan_pemain(_,_)), assertz(urutan_pemain(ListPemain, IdxBaru)),
        format('Giliran ~w.', [PemainBaru])), !
    
    ;
    kartu_tangan(Tersangka, ListKartu),
    (cek_kecocokkan(ListKartu, WarnaLama, JenisLama) ->
        write('Tantangan berhasil!'),nl,
        format('Pemain ~w memiliki kartu yang cocok.', [Tersangka]), nl,
        format('Pemain ~w harus mengambil 4 kartu.', [Tersangka]), nl,
        
        tambah_kartu(Tersangka, 4) ;
    
        write('Tantangan gagal!'), nl,
        format('~w tidak memiliki kartu yang cocok.', [Tersangka]), nl,
        format('~w mendapatkan 6 kartu acak.', [Penantang]), nl,
        
        tambah_kartu(Penantang, 6)),
        
        retract(efek('plus_empat')),
        urutan_pemain(ListPemain, IdxPenantang),
        jml_pemain(Jml),
        
        next_giliran(IdxPenantang, IdxBaru, Jml),
        get_idx(ListPemain, PemainBaru, IdxBaru),
        
        retractall(giliran(_)), assertz(giliran(PemainBaru)),
        retractall(urutan_pemain(_,_)), assertz(urutan_pemain(ListPemain, IdxBaru)),
        format('Giliran ~w.', [PemainBaru]), !.


% =============================== uni ===============================
uni(NomorUrut) :-
    (game_started -> true; write('Maaf Fitur ini tidak dapat digunakan jika belum startGame atau loadGame'),fail),
    
    giliran(Pemain),
    kartu_tangan(Pemain, ListKartu),
    jml_pemain(Jml),
    urutan_pemain(ListNama, Idx),
    panjang(0, JumlahKartu, ListKartu),             
    (   JumlahKartu == 2
    ->  true
    ;   write('Syarat tidak terpenuhi! Kartu di tanganmu tidak berjumlah 2.'), nl,
        format('~w mendapatkan penalti 1 kartu acak dan kehilangan giliran',[Pemain]), nl, random_ambilkartu(Kartu1),
        insert_tail(ListKartu,Kartu1,ListKartuBaru),retract(kartu_tangan(Pemain, _)),
        
        assertz(kartu_tangan(Pemain, ListKartuBaru)), next_giliran(Idx, NewestIdx, Jml),get_idx(ListNama, NextNama, NewestIdx),
    
        format('Giliran ~w',[NextNama]),nl,
        retractall(giliran(_)), assertz(giliran(NextNama)),
        retractall(urutan_pemain(_,_)), assertz(urutan_pemain(ListNama, NewestIdx)), fail

    ),

    urutan_pemain(ListNama, Idx),
    jml_pemain(Jml),

    (   ambil_kartu_ke(NomorUrut, ListKartu, KartuPilihan)
    ->  true
    ;   write('Nomor urut tidak valid! Membatalkan aksi.'), nl, fail
    ),
    discard_top(KartuAtas),

    (   cek_validitas(KartuPilihan, KartuAtas)
    ->  
        KartuPilihan = kartu(Warna, Jenis, _),
        format('~w teriak "UNI!" dan memainkan kartu: ~w-~w~n', [Pemain, Warna, Jenis]), 
        IndexHapus is NomorUrut - 1,
        del(ListKartu, IndexHapus, ListBaru),
        
        retract(kartu_tangan(Pemain, ListKartu)),
        assertz(kartu_tangan(Pemain, ListBaru)),
        retract(discard_top(KartuAtas)),
        assertz(discard_top(kartu(Warna, Jenis, normal))),

        list_uni(ListAmanLama),                     % untuk catat pemain ke daftar aman uni 
        ListAmanBaru = [Pemain | ListAmanLama],
        retract(list_uni(ListAmanLama)),
        assertz(list_uni(ListAmanBaru)),

        efek_aksi(Jenis),                       % untuk perpindahan giliran setelah berhasil lempar kartu
        (Jenis == 'skip' ->             
            urutan_pemain(_, NewestIdx),
            get_idx(ListNama, NextNama, NewestIdx)
        ;   next_giliran(Idx, NewestIdx, Jml),         
            get_idx(ListNama, NextNama, NewestIdx)
        ),
        
        retractall(giliran(_)),
        assertz(giliran(NextNama)),
        retractall(urutan_pemain(_,_)),
        assertz(urutan_pemain(ListNama, NewestIdx)),

        nl, write('--- Giliran Selesai ---'), nl,                          
        format('Giliran ~w~n',[NextNama])
        
    ;   
        write('Kartu tidak valid! Warna atau angkanya tidak cocok dengan kartu di meja.'), nl,fail
    ).


% =============================== tangkap ===============================
tangkap(NamaTarget) :-
    (game_started -> true; write('Maaf Fitur ini tidak dapat digunakan jika belum startGame atau loadGame'),!,fail),
    kartu_tangan(NamaTarget, ListKartu),
    list_uni(ListAman),
    
    panjang(0, JumlahTarget, ListKartu),            % cek syarat penangkapan
    JumlahTarget == 1,
    get_idx(ListAman, NamaTarget, IdxAman),
    IdxAman == -1, % Target tidak ada di daftar aman (lupa teriak UNI)
    !, 
    format('Target tertangkap basah! ~w lupa bilang UNI!~n', [NamaTarget]),
    write('Hukuman: Tambah 2 kartu ke tangan.'), nl,
    
    random_ambilkartu(Kartu1),
    random_ambilkartu(Kartu2),
    insert_tail(ListKartu, Kartu1, TempList),
    insert_tail(TempList, Kartu2, ListBaru),
    retract(kartu_tangan(NamaTarget, _)),
    assertz(kartu_tangan(NamaTarget, ListBaru)),
    
    jml_pemain(Jml),
    urutan_pemain(ListNama, Idx),
    next_giliran(Idx, NewestIdx, Jml),
    get_idx(ListNama, NextNama, NewestIdx),
    
    format('Giliran ~w',[NextNama]),nl,
    retractall(giliran(_)), assertz(giliran(NextNama)),
    retractall(urutan_pemain(_,_)), assertz(urutan_pemain(ListNama, NewestIdx)). 

tangkap(_) :-                               % kalau gagal menangkap -> kena denda 1 kartu
    write('Gagal menangkap! Target aman atau kartunya tidak bersisa 1.'), nl,
    
    giliran(PemainSekarang),        % ambil status pemain sekarang lalu diberi denda
    format('Hukuman: ~w mendapatkan 1 kartu penalti karena salah tuduh!~n', [PemainSekarang]),
    random_ambilkartu(KartuPenalti),
    kartu_tangan(PemainSekarang, ListKartuLama),
    insert_tail(ListKartuLama, KartuPenalti, ListKartuBaru),
    retract(kartu_tangan(PemainSekarang, _)),
    assertz(kartu_tangan(PemainSekarang, ListKartuBaru)),
    
    jml_pemain(Jml),
    urutan_pemain(ListNama, Idx),
    next_giliran(Idx, NewestIdx, Jml),
    get_idx(ListNama, NextNama, NewestIdx),
    
    format('Giliran ~w',[NextNama]),nl,
    retractall(giliran(_)), assertz(giliran(NextNama)),
    retractall(urutan_pemain(_,_)), assertz(urutan_pemain(ListNama, NewestIdx)). 


% =============================== sembunyikanKartu ===============================
sembunyikanKartu(IdxKartu):-
    (game_started -> true; write('Maaf Fitur ini tidak dapat digunakan jika belum startGame atau loadGame'),nl,fail),
    ((efek('plus_dua') ; efek('plus_empat')) -> 
        write('Anda tidak dapat menyembunyikan kartu saat ini!'), nl, fail
    ; true),
    giliran(Pemain),
    kartu_tangan(Pemain, ListKartu),
    panjang(0, JmlKartu, ListKartu),
    
    (JmlKartu > 1 -> 
        (ambil_kartu_ke(IdxKartu, ListKartu, kartu(Warna, Jenis, Status)) ->
            (Status == 'hide' -> 
                write('Kartu tersebut memang sudah tersembunyi!'), nl, fail
            ;
                IdxK is IdxKartu - 1,
                replace_kartu(ListKartu, IdxK, kartu(Warna, Jenis, hide), Listbaru),
                retract(kartu_tangan(Pemain, _)),
                assertz(kartu_tangan(Pemain, Listbaru)),
                format('Kartu ~w-~w berhasil disembunyikan.~n', [Warna, Jenis]), nl,
                
                urutan_pemain(ListNama, CurrentIdx),
                panjang(0, JmlPemain, ListNama),
                
                next_giliran(CurrentIdx, NewestIdx, JmlPemain),
                get_idx(ListNama, NextNama, NewestIdx),
                format('Giliran ~w~n',[NextNama]),
                retractall(giliran(_)), assertz(giliran(NextNama)),
                retractall(urutan_pemain(_,_)), assertz(urutan_pemain(ListNama, NewestIdx)), !
            )
        ; write('Nomor urut kartu tidak valid!'), nl, fail)
    ; write('Tidak boleh menyembunyikan kartu karena hanya tersisa 1 kartu!.'), nl, fail).


% =============================== tampilkanKartu ===============================
tampilkanKartu(NomorUrut) :-
    (game_started -> true; write('Maaf Fitur ini tidak dapat digunakan jika belum startGame atau loadGame'),nl,fail),
    ((efek('plus_dua') ; efek('plus_empat')) -> 
        write('Anda tidak dapat menampilkan kartu saat ini!'), nl, fail
    ; true),
    giliran(Pemain),
    kartu_tangan(Pemain, ListKartu),
    
    (ambil_kartu_ke(NomorUrut, ListKartu, kartu(Warna, Jenis, Status)) ->
        ( Status == 'normal' ->
            write('Kartu tersebut memang sudah ditampilkan!'), nl, fail
        ;   
            Index is NomorUrut - 1,
            replace_kartu(ListKartu, Index, kartu(Warna, Jenis, normal), ListBaru),
            retract(kartu_tangan(Pemain, _)),
            assertz(kartu_tangan(Pemain, ListBaru)),
            format('Kartu ~w-~w berhasil ditampilkan!~n', [Warna, Jenis]), nl,
            
            urutan_pemain(ListNama, CurrentIdx),
            panjang(0, JmlPemain, ListNama),
            
            next_giliran(CurrentIdx, NewestIdx, JmlPemain),
            get_idx(ListNama, NextNama, NewestIdx),
            format('Giliran ~w~n',[NextNama]),
            retractall(giliran(_)), assertz(giliran(NextNama)),
            retractall(urutan_pemain(_,_)), assertz(urutan_pemain(ListNama, NewestIdx)), !
        )
    ; write('Nomor urut kartu tidak valid!'), nl, fail ).


% =============================== endGame ===============================
endGame :-
    (game_started -> true; write('Maaf Fitur ini tidak dapat digunakan jika belum startGame atau loadGame'),fail),
    giliran(Pemenang),
    format('Permainan selesai! ~w menghabiskan semua kartunya!~n~n', [Pemenang]),
    write('Berikut perhitungan poin sisa kartu:'), nl,
    urutan_pemain(DaftarPemain,_),
    tampilkan_perhitungan(DaftarPemain), nl,
    sort_pemain(DaftarPemain, SortedList),
    write('Urutan pemenang:'), nl,
    tampilkan_peringkat(SortedList, 1),
    get_head(SortedList, Juara1),
    format('~nSelamat, ~w menjadi pemenang!~n', [Juara1]),
    retractall(game_started),exitGame.


% =============================== saveGame ===============================
saveGame:- 
    (game_started -> true; write('Maaf Fitur ini tidak dapat digunakan jika belum startGame atau loadGame'),fail),
    ((efek('plus_dua') ; efek('plus_empat')) -> write('Anda tidak dapat saveGame saat giliran ini!'), nl, fail
    ; true),
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


% =============================== loadGame ===============================
loadGame:-
    write('Masukkan nama file yang akan dimuat: '),
    read(Input),
    ((nama_file(Input)) -> true; write('Maaf Nama file yang anda masukkan tidak tersedia'),fail),

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
    
    reverse_list(UrutanPemain, ReversedPemain),
    assertz(reverse_pemain(ReversedPemain)),

    format('Status permainan berhasil dimuat dari ~w.txt.',[Input]),nl,
    format('Melanjutkan Giliran ~w.',[PemainNow]),close(LoadFileFormat),
    
    assertz(game_started),!.


% =============================== exitGame ===============================
exitGame:-  retractall(jml_pemain(_)),retractall(urutan_pemain(_,_)), retractall(efek(_)), retractall(game_started),
    retractall(giliran(_)), retractall(discard_top(_)), retractall(kartu_tangan(_,_)), retractall(list_uni(_)),retractall(arah(_)).