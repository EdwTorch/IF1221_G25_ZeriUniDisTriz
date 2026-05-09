lihatKartu :-
    giliran(Pemain),
    (kartu_tangan(Pemain, ListKartu) ->
        write('Berikut kartu yang anda miliki.'), nl,
        print_list_kartu(ListKartu, 1) ;
        write('Data kartu tidak ditemukan!'), nl), !.

print_list_kartu([],_).
print_list_kartu([kartu(Warna, Jenis, hide)|T], Order) :-
    write(Order), write('. '),
    write(Warna), write('-'), write(Jenis),
    write(' (disembunyikan)'), nl,
    NextOrder is Order + 1,
    print_list_kartu(T, NextOrder).

print_list_kartu([kartu(Warna, Jenis, normal)|T], Order) :-
    write(Order), write('. '),
    write(Warna), write('-'), write(Jenis), nl,
    NextOrder is Order + 1,
    print_list_kartu(T, NextOrder).