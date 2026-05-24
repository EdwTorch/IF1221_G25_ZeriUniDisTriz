print_list_pemain([Nama]) :-
    write(Nama), !.
print_list_pemain([Nama|SisaDaftar]) :-
    write(Nama), write(', '), print_list_pemain(SisaDaftar).

print_info_pemain([]).
print_info_pemain([NamaPemain|SisaPemain]) :-
    kartu_tangan(NamaPemain, ListKartuTangan),
    count_normal(ListKartuTangan, JmlKartu),
    write('- '), write(NamaPemain), write(': '), write(JmlKartu), write(' kartu'), nl,
    print_info_pemain(SisaPemain).