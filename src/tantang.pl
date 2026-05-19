% cek punya yg cocok gak si tersangka
cek_kecocokkan([kartu(Warna, _, _)|_], WarnaMeja, _) :- Warna \== hitam, Warna == WarnaMeja, !.
cek_kecocokkan([kartu(_, Jenis, _)|_], _, JenisMeja) :- Jenis \== wildcard, Jenis \== plus_empat, Jenis == JenisMeja, !.
cek_kecocokkan([_|Sisa], WarnaMeja, JenisMeja) :- cek_kecocokkan(Sisa, WarnaMeja, JenisMeja).

tantang :-
    efek('plus_empat'),
    yg_keluarin_plus4(Tersangka),
    urutan_pemain(List, Idx),
    get_idx(List, Penantang, Idx),

    write('Tantangan dilakukan!'), nl,
    write('Memeriksa kartu '), write(Tersangka), write('...'), nl,

    warna_sebelumnya(WarnaLama),
    jenis_sebelumnya(JenisLama),

    kartu_tangan(Tersangka, ListKartu),
    (cek_kecocokkan(ListKartu, WarnaLama, JenisLama) ->
        write('Tantangan berhasil!'),nl,
        format('Pemain ~w memiliki kartu yang cocok.', [Tersangka]), nl,
        format('Pemain ~w harus mengambil 4 kartu.', [Tersangka]), nl,
        
        tambah_kartu(Tersangka, 4),
        retract(efek('plus_empat')),
        format('Sekarang giliran ~w.', [Penantang]), nl ;
    
        write('Tantangan gagal!'), nl,
        format('~w tidak memiliki kartu yang cocok.', [Tersangka]), nl,
        format('~w mendapatkan 6 kartu acak.', [Penantang]), nl,
        
        tambah_kartu(Penantang, 6),
        retract(efek('plus_empat')),
        
        urutan_pemain(ListPemain, IdxPenantang),
        jml_pemain(Jml),
        
        next_giliran(IdxPenantang, IdxBaru, Jml),
        get_idx(ListPemain, PemainBaru, IdxBaru),
        
        retractall(giliran(_)), assertz(giliran(PemainBaru)),
        retractall(urutan_pemain(_,_)), assertz(urutan_pemain(ListPemain, IdxBaru)),
        format('Giliran ~w.', [PemainBaru])), !.