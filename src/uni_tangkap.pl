% FUNGSI UNI
uni(NomorUrut) :-
    giliran(Pemain),
    kartu_tangan(Pemain, ListKartu),

    panjang(0, JumlahKartu, ListKartu),             
    (   JumlahKartu == 2
    ->  true
    ;   write('Syarat tidak terpenuhi! Kartu di tanganmu tidak berjumlah 2.'), nl, fail
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
        write('Kartu tidak valid! Warna atau angkanya tidak cocok dengan kartu di meja.'), nl,
        fail
    ).

% FUNGSI TANGKAP 
tangkap(NamaTarget) :-
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
    assertz(kartu_tangan(NamaTarget, ListBaru)).

tangkap(_) :-                               % kalau gagal menangkap -> kena denda 1 kartu
    write('Gagal menangkap! Target aman atau kartunya tidak bersisa 1.'), nl,
    
    giliran(PemainSekarang),        % ambil status pemain sekarang lalu diberi denda
    format('Hukuman: ~w mendapatkan 1 kartu penalti karena salah tuduh!~n', [PemainSekarang]),
    random_ambilkartu(KartuPenalti),
    kartu_tangan(PemainSekarang, ListKartuLama),
    insert_tail(ListKartuLama, KartuPenalti, ListKartuBaru),
    retract(kartu_tangan(PemainSekarang, _)),
    assertz(kartu_tangan(PemainSekarang, ListKartuBaru)),
    
    fail.