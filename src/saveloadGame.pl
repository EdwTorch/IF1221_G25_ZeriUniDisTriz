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

