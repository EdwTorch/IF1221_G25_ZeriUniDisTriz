/* cekInfo :-
    discard_top(kartu(WarnaTeratas, JenisTeratas, _)),
    write('Kartu discard top: '), write(WarnaTeratas), write('-'), write(JenisTeratas), nl,
    urutan_pemain(DaftarPemain),
    write('Urutan pemain: '), print_list_pemain(DaftarPemain), nl,
    write('Informasi pemain: '), nl,
    print_info_pemain(DaftarPemain), !. Dipindah ke Main */ 

print_list_pemain([Nama]) :-
    write(Nama), !.
print_list_pemain([Nama|SisaDaftar]) :-
    write(Nama), write(', '), print_list_pemain(SisaDaftar).

print_info_pemain([]).
print_info_pemain([NamaPemain|SisaPemain]) :-
    kartu_tangan(NamaPemain, ListKartuTangan),
    panjang(0,ListKartuTangan, JmlKartu),
    write('- '), write(NamaPemain), write(': '), write(JmlKartu), write(' kartu'), nl,
    print_info_pemain(SisaPemain).