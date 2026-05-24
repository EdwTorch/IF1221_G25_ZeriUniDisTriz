% Helper untuk mengganti elemen di dalam list berdasarkan indeks
replace_kartu([_|Tail], 0, New, [New|Tail]) :- !.
replace_kartu([Head|Tail], I, New, [Head|Result]) :-
    I > 0, I1 is I - 1, replace_kartu(Tail, I1, New, Result).

% Helper menghitung kartu yang berstatus normal
count_normal([], 0).
count_normal([kartu(_, _, normal)|Tail], N) :- 
    count_normal(Tail, N1), N is N1 + 1, !.
count_normal([kartu(_, _, hide)|Tail], N) :- 
    count_normal(Tail, N), !.