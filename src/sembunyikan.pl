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

% Helper untuk mengganti elemen di dalam list berdasarkan indeks
replace_kartu([_|Tail], 0, New, [New|Tail]) :- !.
replace_kartu([Head|Tail], I, New, [Head|Result]) :-
    I > 0, I1 is I - 1, replace_kartu(Tail, I1, New, Result).

% Helper menghitung kartu yang berstatus normal
count_normal([], 0).
count_normal([kartu(_, _, normal)|Tail], N) :- 
    count_normal(Tail, N1), N is N1 + 1, !.
count_normal([kartu(_, _, hide)|Tail], N) :- 
    count_normal(Tail, N), !.