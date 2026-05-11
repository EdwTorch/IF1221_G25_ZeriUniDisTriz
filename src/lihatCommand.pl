% Rule utama lihatCommand
/* lihatCommand :-
    discard_top(kartu(WarnaNow, JenisNow, _)),
    giliran(Pemain),
    kartu_tangan(Pemain, ListKartu),
    write('Aksi utama yang tersedia:'), nl,
    (JenisNow == draw_four ->
        write('1. ambilKartu'), nl,
        write('2. tantang'), nl
        ; JenisNow == draw_two ->
            write('1. ambilKartu'), nl
        ; (valid_play(ListKartu, WarnaNow, JenisNow) ->
            write('1. mainkanKartu()'), nl,
            write('2. ambilKartu'), nl
        ; write('1. ambilKartu'), nl)),
    nl,
    write('Aksi pendukung yang tersedia:'), nl,
    write('1. lihatCommand'), nl,
    write('2. lihatKartu'), nl,
    write('3. cekInfo'), nl, !. */

% Mengecek apakah pemain bisa mainkanKartu 
valid_play([kartu(W,_,_)|_], WarnaNow, _) :- W == WarnaNow, !.
valid_play([kartu(_,J,_)|_], _, JenisNow) :- J == JenisNow, !.
valid_play([kartu(hitam,_,_)|_], _, _) :- !.
valid_play([_|Tail], WarnaNow, JenisNow) :- valid_play(Tail, WarnaNow, JenisNow).