% Mengecek apakah pemain bisa mainkanKartu 
valid_play([kartu(W,_,_)|_], WarnaNow, _) :- W == WarnaNow, !.
valid_play([kartu(_,J,_)|_], _, JenisNow) :- 
    J == JenisNow, 
    J \== 'plus_dua', 
    J \== 'plus_empat', 
    J \== 'wildcard', !.
valid_play([kartu('hitam',J,_)|_], _, JenisNow) :- 
    J \== JenisNow, !.
valid_play([_|Tail], WarnaNow, JenisNow) :- valid_play(Tail, WarnaNow, JenisNow).