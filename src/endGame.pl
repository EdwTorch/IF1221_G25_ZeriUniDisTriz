% Rule poin per jenis kartu
poin_kartu(Jenis, Poin) :- integer(Jenis), Poin is Jenis, !.
poin_kartu(Jenis, 10) :- member(Jenis, [skip, reverse, draw_two]), !.
poin_kartu(Jenis, 20) :- member(Jenis, [wild, wild_draw_four, mimic]), !.

% Rule menjabarkan perhitungan
jabarkan_kartu([], "", "", 0).
jabarkan_kartu([kartu(W, J, _)], Deskripsi, PoinStr, P) :-
    poin_kartu(J, P),
    atomic_list_concat([W, '-', J], Deskripsi),
    atom_number(PoinStr, P), !.
jabarkan_kartu([kartu(W, J, _)|T], Deskripsi, PoinStr, Total) :-
    poin_kartu(J, P),
    jabarkan_kartu(T, SisaD, SisaP, SisaTotal),
    Total is P + SisaTotal,
    atomic_list_concat([W, '-', J, ' + ', SisaD], Deskripsi),
    atomic_list_concat([P, ' + ', SisaP], PoinStr).

% Rule hitung total poin
total_poin_pemain(P, Total) :- kartu_tangan(P, K), hitung_list_poin(K, Total).
hitung_list_poin([], 0).
hitung_list_poin([kartu(_, J, _)|T], Total) :- poin_kartu(J, P), hitung_list_poin(T, S), Total is P + S.

% Rule peringkat
lebih_baik(P1, P2) :-
    total_poin_pemain(P1, Poin1),
    total_poin_pemain(P2, Poin2),
    (Poin1 < Poin2 -> true ; Poin1 > Poin2 -> fail ;
        kartu_tangan(P1, K1), length(K1, L1),
        kartu_tangan(P2, K2), length(K2, L2),
        (L1 < L2 -> true ; L1 > L2 -> fail ;
            urutan_pemain(List),
            nth1(Idx1, List, P1),
            nth1(Idx2, List, P2),
            Idx1 < Idx2)).

% Rule utama endGame
endGame :-
    giliran(Pemenang),
    format('Permainan selesai! ~w menghabiskan semua kartunya!~n~n', [Pemenang]),
    write('Berikut perhitungan poin sisa kartu:'), nl,
    urutan_pemain(L),
    tampilkan_perhitungan(L), nl,
    predsort(bandingkan_pemain, L, SortedL),
    write('Urutan pemenang:'), nl,
    tampilkan_peringkat(SortedL, 1),
    nth1(1, SortedL, Juara1),
    format('~nSelamat, ~w menjadi pemenang!~n', [Juara1]),
    retractall(game_started).

% Helper
tampilkan_perhitungan([]).
tampilkan_perhitungan([P|T]) :-
    kartu_tangan(P, K),
    (K == [] -> format('~w: kartu habis = 0 poin~n', [P]) ;
        jabarkan_kartu(K, D, PS, Tot),
        format('~w: ~w = ~w = ~w poin~n', [P, D, PS, Tot])),
    tampilkan_perhitungan(T).
bandingkan_pemain(Res, P1, P2) :- (lebih_baik(P1, P2) -> Res = < ; Res = >).
tampilkan_peringkat([], _).
tampilkan_peringkat([P|T], N) :-
    total_poin_pemain(P, Poin),
    format('~w. ~w (~w poin)~n', [N, P, Poin]),
    N1 is N + 1, tampilkan_peringkat(T, N1).