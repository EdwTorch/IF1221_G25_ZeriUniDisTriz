% skip
efek_aksi('skip') :-
    urutan_pemain(List, Idx),
    jml_pemain(Jml),
    next_giliran(Idx, TargetIdx, Jml),
    next_giliran(TargetIdx, NextIdx, Jml),
    retract(urutan_pemain(_,_)),
    assertz(urutan_pemain(List, NextIdx)),
    get_idx(List, NamaTarget, TargetIdx),
    get_idx(List, NamaNext, NextIdx),
    nl, write('Pemain berikutnya kehilangan giliran.'), nl, !.

% plus 2
efek_aksi('plus_dua') :-
    assertz(efek('plus_dua')), !.

% reverse
efek_aksi('reverse') :-
    arah(Lama),
    retract(arah(Lama)),
    (Lama == 'kanan' ->
        assertz(arah('kiri'))
    ; assertz(arah('kanan'))), !.

efek_aksi(_) :- !.

% Helper nambah kartu (plus 2, plus 4, plus 6)
tambah_kartu(_,0) :- !.
tambah_kartu(Pemain, Tambahan) :-
    random_ambilkartu(Element),
    kartu_tangan(Pemain, ListLama),
    insert_tail(ListLama, Element, ListBaru),
    retract(kartu_tangan(Pemain,_)),
    assertz(kartu_tangan(Pemain, ListBaru)),
    TambahanNow is Tambahan -1,
    tambah_kartu(Pemain, TambahanNow).