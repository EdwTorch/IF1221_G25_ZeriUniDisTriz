% skip
efek_aksi('skip') :-
    urutan_pemain(List, Idx),
    jml_pemain(Jml),
    
    next_giliran(Idx, TargetIdx, Jml),
    
    retractall(urutan_pemain(_,_)),
    assertz(urutan_pemain(List, TargetIdx)),
    
    nl, write('Pemain berikutnya kehilangan giliran.'), nl, !.

% plus 2
efek_aksi('plus_dua') :-
    urutan_pemain(List, Idx),
    jml_pemain(Jml),
    next_giliran(Idx, TargetIdx, Jml),
    get_idx(List, TargetPemain, TargetIdx),
    tambah_kartu(TargetPemain, 2),
    write('Pemain berikutnya mendapatkan 2 kartu dan kehilangan giliran.'), nl, 
    retractall(urutan_pemain(_,_)),assertz(urutan_pemain(List,TargetIdx)),!.

% reverse
efek_aksi('reverse') :-
    arah(Lama),
    retract(arah(Lama)),
    (Lama == 'kanan' ->
        assertz(arah('kiri'))
    ; assertz(arah('kanan'))), !.

% wild
efek_aksi('wild') :-
    write('Pilih warna: '), nl,
    write('1. Merah'), nl,
    write('2. Kuning'), nl,
    write('3. Hijau'), nl,
    write('4. Biru'), nl,
    read(WarnaPilihan),
    warna_pilihan(WarnaPilihan, Warna),
    
    retractall(warna_wild(_)),
    assertz(warna_wild(Warna)),
    
    format('Warna aktif sekarang adalah ~w.', [Warna]), nl, !.

% plus 4 wild
efek_aksi('plus_empat') :-
    urutan_pemain(List, Idx),
    get_idx(List, PemainSekarang, Idx),
    
    retractall(yg_keluarin_plus4(_)),
    assertz(yg_keluarin_plus4(PemainSekarang)),
    
    efek_aksi('wild'),
    assertz(efek('plus_empat')), !.
    
efek_aksi(_) :- !.

% helper warna pilihan
warna_pilihan(1, 'merah') :- !.
warna_pilihan('merah', 'merah') :- !.
warna_pilihan(2, 'kuning') :- !.
warna_pilihan('kuning', 'kuning') :- !.
warna_pilihan(3, 'hijau') :- !.
warna_pilihan('hijau', 'hijau') :- !.
warna_pilihan(4, 'biru') :- !.
warna_pilihan('biru', 'biru') :- !.

% Helper nambah kartu (plus 2, plus 4, plus 6)
tambah_kartu(_,0) :- !.
tambah_kartu(Pemain, Tambahan) :-
    random_ambilkartu(Element),ekstrak_kartu(Element,Warna,Jenis),  
    
    format('~w mendapatkan kartu: ~w-~w',[Pemain,Warna,Jenis]),nl,nl,
    
    kartu_tangan(Pemain, ListLama),
    insert_tail(ListLama, Element, ListBaru),
    
    retract(kartu_tangan(Pemain,_)),
    assertz(kartu_tangan(Pemain, ListBaru)),
    
    TambahanNow is Tambahan -1,
    tambah_kartu(Pemain, TambahanNow).