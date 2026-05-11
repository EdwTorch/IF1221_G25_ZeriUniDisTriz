% FUNGSI PEMBANTU 
% ambil kartu pada urutan ke-N
ambil_kartu_ke(1, [Kartu|_], Kartu) :- !.
ambil_kartu_ke(N, [_|Tail], Kartu) :-
    N > 1,
    N1 is N - 1,
    ambil_kartu_ke(N1, Tail, Kartu).


% cek validitas kartu 
cek_validitas(kartu(Warna, _, _), kartu(Warna, _, _)) :- !.    % --> valid jika warnanya sama
cek_validitas(kartu(_, Jenis, _), kartu(_, Jenis, _)) :- !.    % --> valid jika jenis atau angkanya sama
cek_validitas(kartu(hitam, _, _), _) :- !.                     % --> valid jika kartu yang dimainkan adalah kartu hitam


% FUNGSI MAINKAN KARTU 
/* mainkanKartu(NomorUrut) :-
    giliran(Pemain),                      % cek giliran 
    kartu_tangan(Pemain, ListKartu),

    (   ambil_kartu_ke(NomorUrut, ListKartu, KartuPilihan)      % ambil kartu dari list
    ->  true
    ;   write('Nomor urut tidak valid! Membatalkan aksi.'), nl, fail
    ),
    discard_top(KartuAtas),             cek kartu teratas


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
        write('(Catatan: Fungsi pindah giliran akan diintegrasikan nanti)'), nl
        
    ;   
        % jika tidak valid
        write('Kartu tidak valid! Warna atau angkanya tidak cocok dengan kartu di meja.'), nl,
        fail
    ). */