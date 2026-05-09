cekInfo :-
    discard_top(kartu(Warna, Jenis, _)),
    write('Kartu discard top: '), write(Warna), write('-'), write(Jenis), nl,
    list_pemain(L),
    write('Urutan pemain: '), print_list(L), nl,
    write('Informasi pemain: '), nl,
    print_info_pemain(L), !.

print_list([H]) :- write(H), !.
print_list([H|T]) :-
    write(H), write(', '), print_list(T).

print_info_pemain([]).
print_info_pemain([Pemain|T]) :-
    kartu_tangan(Pemain, KartuTangan),
    length(KartuTangan, JmlKartu),
    write('- '), write(Pemain), write(': '), write(JmlKartu), write(' kartu'), nl,
    print_info_pemain(T).