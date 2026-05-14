print_kartu_sisa([],_,_):-!.
print_kartu_sisa([HeadUrutan|TailUrutan],LoadGameFormat,SaveGameFormat):-
    kartu_tangan(HeadUrutan,KartuHead),
    format(SaveGameFormat,'Kartu_~w:~w',[HeadUrutan,KartuHead]),
    nl(SaveGameFormat),
    format(LoadGameFormat,'~w.',[KartuHead]),
    nl(LoadGameFormat),
    print_kartu_sisa(TailUrutan,LoadGameFormat,SaveGameFormat).

insert_txt(Nama,Hasil):-
    name(Nama,ListAscii),
    insert_tail(ListAscii,46,ListAscii1), % tambah .
    insert_tail(ListAscii1,116,ListAscii2), % tambah t
    insert_tail(ListAscii2,120,ListAscii3),
    insert_tail(ListAscii3,116,ListHasil),
    name(Hasil,ListHasil).

loadkartu(Jml,[HeadPemain|TailPemain],LoadFileFormat):-
loadkartuhelper(0,Jml,[HeadPemain|TailPemain],LoadFileFormat),!.

loadkartuhelper(_,_,[],_).
loadkartuhelper(Idx,Jml,[HeadPemain|TailPemain],LoadFileFormat):-
    Idx <Jml,
    read(LoadFileFormat,Kartu),
    assertz(kartu_tangan(HeadPemain,Kartu)),
    NewIdx is Idx+1,
    loadkartuhelper(NewIdx,Jml,TailPemain,LoadFileFormat).

/* LoadGame (kita input sendiri ga liat dari directory)
loadGame:-
    write('Masukkan nama file yang akan dimuat: '),
    read(Input),
    (nama_file(Input)-> write('ada'); write('Maaf Nama file yang anda masukkan tidak tersedia'),fail),
    retractall(jml_pemain(_)),retractall(urutan_pemain(_,_)), retractall(efek(_)), retractall(game_started),
    retractall(giliran(_)), retractall(discard_top(_)), retractall(kartu_tangan(_,_)), retractall(list_uni(_)),retractall(arah(_)),
    insert_txt(Input,LoadFileName),
    open(LoadFileName,read,LoadFileFormat),
    read(LoadFileFormat,UrutanPemain),
    read(LoadFileFormat,PemainNow),
    assertz(giliran(PemainNow)),
    get_idx(UrutanPemain,PemainNow,Idx),
    assertz(urutan_pemain(UrutanPemain,Idx)),
    read(LoadFileFormat,Warna),
    read(LoadFileFormat,Jenis),
    Element = kartu(Warna,Jenis,normal),
    assertz(discard_top(Element)),
    panjang(0,Pjg,UrutanPemain),
    loadkartu(Pjg,UrutanPemain,LoadFileFormat),
    read(LoadFileFormat,ArahPermainan),
    assertz(arah(ArahPermainan)),
    read(LoadFileFormat,ListUni),
    assertz(list_uni(ListUni)),
    format('Status permainan berhasil dimuat dari ~w.txt.',[Input]),
    format('Melanjutkan Giliran ~w.',[PemainNow]),close(LoadFileFormat).
*/



