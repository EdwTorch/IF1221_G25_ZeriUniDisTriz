% Rule poin per jenis kartu
poin_kartu(Jenis, Poin) :- integer(Jenis), Poin is Jenis, !.
poin_kartu(Jenis, 10) :- member(Jenis, ['skip', 'reverse', 'plus_dua']), !.
poin_kartu(Jenis, 20) :- member(Jenis, ['wild', 'plus_empat', 'mimic']), !.

% Rule penggabungan list kartu untuk penjabaran
% Dua list digabungkan menjadi satu list
sambung_dua([], List, List).
sambung_dua([Kartu|Sisa], List, [Kartu|Hasil]) :- sambung_dua(Sisa, List, Hasil).
% Tiga list diubah jadi ascii lalu digabungkan menjadi satu list melalui rekurens
sambung_tiga(Satu, Dua, Tiga, Hasil) :-
    name(Satu, List1),
    name(Dua, List2),
    name(Tiga, List3),
    sambung_dua(List1, List2, Temp),
    sambung_dua(Temp, List3, Hasil).

% Rule menjabarkan perhitungan
jabarkan_kartu([], '', '', 0).
jabarkan_kartu([kartu(Warna, Jenis, _)], Deskripsi, PoinStr, Poin) :-
    poin_kartu(Jenis, Poin),
    sambung_tiga(Warna, '-', Jenis, Deskripsi),
    name(Poin, PoinStr), !.
jabarkan_kartu([kartu(Warna, Jenis, _)|Sisa], DeskripsiTotal, PoinStrTotal, Total) :-
    poin_kartu(Jenis, Poin),
    jabarkan_kartu(Sisa, SisaDeskripsi, SisaPoinStr, SisaTotal),
    Total is Poin + SisaTotal,
    sambung_tiga(Warna, '-', Jenis, DeskripsiAwal),
    sambung_tiga(DeskripsiAwal, ' + ', SisaDeskripsi, DeskripsiTotal),
    name(Poin, PoinStr),
    sambung_tiga(PoinStr, ' + ', SisaPoinStr, PoinStrTotal).

% Rule hitung total poin
total_poin_pemain(NamaPemain, TotalPoin) :-
    kartu_tangan(NamaPemain, Kartu),
    hitung_list_poin(Kartu, TotalPoin).

hitung_list_poin([], 0).
hitung_list_poin([kartu(_, JenisKartu, _)|SisaKartu], TotalPoin) :-
    poin_kartu(JenisKartu, Poin),
    hitung_list_poin(SisaKartu, SisaPoin),
    TotalPoin is Poin + SisaPoin.

% Rule peringkat
bandingkan_pemain(Result, Pemain1, Pemain2) :- 
    (lebih_baik(Pemain1, Pemain2) -> Result = (<) ; Result = (>)).

lebih_baik(Pemain1, Pemain2) :-
    total_poin_pemain(Pemain1, Poin1),
    total_poin_pemain(Pemain2, Poin2),
    (Poin1 < Poin2 -> true ; Poin1 > Poin2 -> fail ;
        kartu_tangan(Pemain1, Kartu1), panjang(0,Kartu1, L1),
        kartu_tangan(Pemain2, Kartu2), panjang(0,Kartu2, L2),
        (L1 < L2 -> true ; L1 > L2 -> fail ;
            urutan_pemain(DaftarUrutan),
            nth1(Idx1, DaftarUrutan, Pemain1),
            nth1(Idx2, DaftarUrutan, Pemain2),
            Idx1 < Idx2)).

% Rule utama endGame
endGame :-
    giliran(Pemenang),
    format('Permainan selesai! ~w menghabiskan semua kartunya!~n~n', [Pemenang]),
    write('Berikut perhitungan poin sisa kartu:'), nl,
    urutan_pemain(DaftarPemain),
    tampilkan_perhitungan(DaftarPemain), nl,
    predsort(bandingkan_pemain, DaftarPemain, SortedList),
    write('Urutan pemenang:'), nl,
    tampilkan_peringkat(SortedList, 1),
    nth1(1, SortedList, Juara1),
    format('~nSelamat, ~w menjadi pemenang!~n', [Juara1]),
    retractall(game_started).

% Helper menampilkan
tampilkan_perhitungan([]).
tampilkan_perhitungan([PemainSekarang|SisaPemain]) :-
    kartu_tangan(PemainSekarang, ListKartuTangan),
    (ListKartuTangan == [] -> format('~w: kartu habis = 0 poin~n', [PemainSekarang]) ;
        jabarkan_kartu(ListKartuTangan, DeskripsiKartu, PoinStr, TotalPoin),
        format('~w: ~s = ~s = ~d poin~n', [PemainSekarang, DeskripsiKartu, PoinStr, TotalPoin])),
    tampilkan_perhitungan(SisaPemain).
tampilkan_peringkat([], _).
tampilkan_peringkat([PemainSekarang|SisaPemain], N) :-
    total_poin_pemain(PemainSekarang, Poin),
    format('~d. ~w (~d poin)~n', [N, PemainSekarang, Poin]),
    N1 is N + 1,
    tampilkan_peringkat(SisaPemain, N1).