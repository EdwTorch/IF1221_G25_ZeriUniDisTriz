% Rule untuk output kartu
print_list_kartu([],_).

% Kartu disembunyikan
print_list_kartu([kartu(Warna, Jenis, hide)|Tail], Order) :-
    write(Order), write('. '),
    write(Warna), write('-'), write(Jenis),
    write(' (disembunyikan)'), nl,
    NextOrder is Order + 1,
    print_list_kartu(Tail, NextOrder).
    
% Kartu tidak disembunyikan
print_list_kartu([kartu(Warna, Jenis, normal)|Tail], Order) :-
    write(Order), write('. '),
    write(Warna), write('-'), write(Jenis), nl,
    NextOrder is Order + 1,
    print_list_kartu(Tail, NextOrder).