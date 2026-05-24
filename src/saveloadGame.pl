print_kartu_sisa([],_).
print_kartu_sisa([HeadUrutan|TailUrutan],LoadGameFormat):-
    kartu_tangan(HeadUrutan,KartuHead),
    print_formated_kartu(KartuHead, ListKartuFormated),
    format(LoadGameFormat,'kartu(~q):~w.',[HeadUrutan,ListKartuFormated]),
    nl(LoadGameFormat),
    print_kartu_sisa(TailUrutan,LoadGameFormat).

print_formated_kartu(ListKartu,Hasil) :-
print_formated_kartu_helper(ListKartu,Hasil,[]).

print_formated_kartu_helper([],Hasil,Hasil):-!.
print_formated_kartu_helper([kartu(Warna, Jenis, hide)|TailKartu], Hasil, ListSementara) :-
    X = Warna-Jenis-hide,
    insert_tail(ListSementara,X,ListBaru),
    print_formated_kartu_helper(TailKartu,Hasil,ListBaru).
print_formated_kartu_helper([kartu(Warna, Jenis, normal)|TailKartu],Hasil,ListSementara):-
    X = Warna-Jenis,
    insert_tail(ListSementara,X,ListBaru),
    print_formated_kartu_helper(TailKartu,Hasil,ListBaru).


insert_txt(Nama,Hasil):-
    name(Nama,ListAscii),
    insert_tail(ListAscii,46,ListAscii1), % tambah .
    insert_tail(ListAscii1,116,ListAscii2), % tambah t
    insert_tail(ListAscii2,120,ListAscii3), % tambah x
    insert_tail(ListAscii3,116,ListHasil), % tambah t
    name(Hasil,ListHasil). % balikin ke text lagi

loadkartu(Jml,[HeadPemain|TailPemain],LoadFileFormat):-
loadkartuhelper(0,Jml,[HeadPemain|TailPemain],LoadFileFormat),!.

loadkartuhelper(_,_,[],_).
loadkartuhelper(Idx,Jml,[HeadPemain|TailPemain],LoadFileFormat):-
    Idx <Jml,
    readformat(LoadFileFormat,ListKartu),
    compound_formated_kartu(ListKartu,ListKartuBaru),
    assertz(kartu_tangan(HeadPemain,ListKartuBaru)),
    NewIdx is Idx+1,
    loadkartuhelper(NewIdx,Jml,TailPemain,LoadFileFormat).

compound_formated_kartu(ListKartu,FormatedListKartu):-
compound_formated_kartu_helper(ListKartu,[],FormatedListKartu).

compound_formated_kartu_helper([],FormatedListKartu,FormatedListKartu):- !.
compound_formated_kartu_helper([Warna-Jenis-hide|TailKartu], ListSementara, FormatedListKartu):-
    Element = kartu(Warna, Jenis, hide), 
    % ekstrak_kartu(Element,Warna,Jenis),
    insert_tail(ListSementara,Element,Listbaru),
    compound_formated_kartu_helper(TailKartu,Listbaru,FormatedListKartu).
compound_formated_kartu_helper([Warna-Jenis|TailKartu],ListSementara,FormatedListKartu):-
    Element = kartu(Warna, Jenis, normal), 
    % ekstrak_kartu(Element,Warna,Jenis),
    insert_tail(ListSementara,Element,Listbaru),
    compound_formated_kartu_helper(TailKartu,Listbaru,FormatedListKartu).