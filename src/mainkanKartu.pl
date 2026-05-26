% FUNGSI PEMBANTU 
% ambil kartu pada urutan ke-N
ambil_kartu_ke(1, [Kartu|_], Kartu) :- !.
ambil_kartu_ke(N, [_|Tail], Kartu) :-
    N > 1,
    N1 is N - 1,
    ambil_kartu_ke(N1, Tail, Kartu).


% cek validitas kartu
cek_validitas(kartu(Warna, Jenis, _), kartu(_, JenisAtas, _)) :-
    (JenisAtas == wildcard ; JenisAtas == plus_empat), !,  % --> valid jika kartu di atas adalah wildcard atau +4
    warna_wild(WarnaAktif),                                   % --> valid jika warna kartu yang dimainkan sesuai dengan warna yang dipilih pada wild
    (Warna == WarnaAktif; Jenis == plus_empat;Jenis == wildcard),
    \+ (Jenis == JenisAtas),
    retractall(warna_wild(_)).    % --> valid jika jenis kartu yang dimainkan adalah wildcard atau +4

cek_validitas(kartu(Warna, _, _), kartu(Warna, _, _)) :- !.    % --> valid jika warnanya sama
cek_validitas(kartu(_, Jenis, _), kartu(_, Jenis, _)) :- !.    % --> valid jika jenis atau angkanya sama
cek_validitas(kartu('hitam', _, _), _) :- !.                     % --> valid jika kartu yang dimainkan adalah kartu hitam