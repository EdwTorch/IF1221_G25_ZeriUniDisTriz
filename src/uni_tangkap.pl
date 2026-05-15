% FUNGSI UNI
uni(NomorUrut) :-
    giliran(Pemain),
    kartu_tangan(Pemain, ListKartu),
    length(ListKartu, JumlahKartu),     % cek kartu jumlahnya 2 atau engga
    (   JumlahKartu == 2
    ->  true
    ;   write('Syarat tidak terpenuhi! Kartu di tanganmu tidak berjumlah 2.'), nl, fail
    ),

    urutan_pemain(ListNama, Idx),        % bagian main.pl   
    jml_pemain(Jml),

    (   ambil_kartu_ke(NomorUrut, ListKartu, KartuPilihan)              % ambil kartu 
    ->  true
    ;   write('Nomor urut tidak valid! Membatalkan aksi.'), nl, fail
    ),
    discard_top(KartuAtas),

    (   cek_validitas(KartuPilihan, KartuAtas)          % validasi kartu
    ->  
        KartuPilihan = kartu(Warna, Jenis, _),          % jika valid
        format('~w teriak "UNI!" dan memainkan kartu: ~w-~w~n', [Pemain, Warna, Jenis]), 
        IndexHapus is NomorUrut - 1,
        del(ListKartu, IndexHapus, ListBaru),
        
        retract(kartu_tangan(Pemain, ListKartu)),       % update kartu sama discard top
        assertz(kartu_tangan(Pemain, ListBaru)),
        retract(discard_top(KartuAtas)),
        assertz(discard_top(kartu(Warna, Jenis, normal))),

        list_uni(ListAmanLama),
        ListAmanBaru = [Pemain | ListAmanLama],     % update list aman
        retract(list_uni(ListAmanLama)),
        assertz(list_uni(ListAmanBaru)),

        nl, write('- Giliran Selesai -'), nl,       %ganti giliran
        next_giliran(Idx, NewestIdx, Jml),
        get_idx(ListNama, NextNama, NewestIdx),
        format('Giliran ~w~n', [NextNama]),
        retractall(urutan_pemain(_,_)), retractall(giliran(_)),
        assertz(giliran(NextNama)),
        assertz(urutan_pemain(ListNama, NewestIdx))  
    ;   
        write('Kartu tidak valid! Warna atau angkanya tidak cocok dengan kartu di meja.'), nl,      %jika tidak valid
        fail
    ).


% FUNGSI TANGKAP
tangkap(NamaTarget) :-
    kartu_tangan(NamaTarget, ListKartu),     % dari list uni
    list_uni(ListAman),
    
    length(ListKartu, 1),           % cek syarat tangkap, yaitu kartu sisa 1 dan nama tidak ada di daftar aman
    \+ member(NamaTarget, ListAman),
    !, % biar ga pindah ke rule tangkap yang bawah jia dah terpenuhi

    format('Target tertangkap basah! ~w lupa bilang UNI!~n', [NamaTarget]), % jika tertangkap
    write('Hukuman: Tambah 2 kartu ke tangan.'), nl,
    
    random_ambilkartu(Kartu1),      % hukuman
    random_ambilkartu(Kartu2),

    insert_tail(ListKartu, Kartu1, TempList),      % masuk kartu ke list
    insert_tail(TempList, Kartu2, ListBaru),
    
    retract(kartu_tangan(NamaTarget, _)),           % update kartu target
    assertz(kartu_tangan(NamaTarget, ListBaru)).

tangkap(_) :-           % kalau penangkapan gagal 
    write('Gagal menangkap! Target aman atau kartunya tidak bersisa 1.'), nl,
    fail.