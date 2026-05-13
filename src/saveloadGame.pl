print_kartu_sisa([],_,_):-!.
print_kartu_sisa([HeadUrutan|TailUrutan],LoadGameFormat,SaveGameFormat):-
    kartu_tangan(HeadUrutan,KartuHead),
    format(SaveGameFormat,'Kartu_~w:~w',[HeadUrutan,KartuHead]),
    nl(SaveGameFormat),
    format(LoadGameFormat,'~w.',[KartuHead]),
    nl(LoadGameFormat),
    print_kartu_sisa(TailUrutan,LoadGameFormat,SaveGameFormat).


