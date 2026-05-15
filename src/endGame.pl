:- include('utils.pl').

% Rule poin per jenis kartu
poin_kartu(Jenis, Poin) :- integer(Jenis), Poin is Jenis, !.
poin_kartu(skip, 10) :- !.
poin_kartu(reverse, 10) :- !.
poin_kartu(plus_dua, 10) :- !.
poin_kartu(wild, 20) :- !.
poin_kartu(plus_empat, 20) :- !.
poin_kartu(mimic, 20) :- !.

% Rule penggabungan list kartu untuk penjabaran
% Dua list digabungkan menjadi satu list
sambung_dua([], List, List).
sambung_dua([Kartu|Sisa], List, [Kartu|Hasil]) :- sambung_dua(Sisa, List, Hasil).
% Tiga list diubah jadi ascii lalu digabungkan menjadi satu list melalui rekurens
sambung_tiga(Satu, Dua, Tiga, Hasil) :-
    (cek_list(Satu) -> List1 = Satu ; name(Satu, List1)),
    (cek_list(Dua) -> List2 = Dua ; name(Dua, List2)),
    (cek_list(Tiga) -> List3 = Tiga ; name(Tiga, List3)),
    sambung_dua(List1, List2, Temp),
    sambung_dua(Temp, List3, Hasil).

% Rule menjabarkan perhitungan
jabarkan_kartu([], [], [], 0).
jabarkan_kartu([kartu(Warna, Jenis, _)], Deskripsi, PoinStr, Poin) :-
    poin_kartu(Jenis, Poin),
    sambung_tiga(Warna, "-", Jenis, Deskripsi),
    name(Poin, PoinStr), !.
jabarkan_kartu([kartu(Warna, Jenis, _)|Sisa], DeskripsiTotal, PoinStrTotal, Total) :-
    poin_kartu(Jenis, Poin),
    jabarkan_kartu(Sisa, SisaDeskripsi, SisaPoinStr, SisaTotal),
    Total is Poin + SisaTotal,
    sambung_tiga(Warna, "-", Jenis, DeskripsiAwal),
    sambung_tiga(DeskripsiAwal, " + ", SisaDeskripsi, DeskripsiTotal),
    name(Poin, PoinStr),
    sambung_tiga(PoinStr, " + ", SisaPoinStr, PoinStrTotal).

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
        kartu_tangan(Pemain1, Kartu1), length(Kartu1, L1),
        kartu_tangan(Pemain2, Kartu2), length(Kartu2, L2),
        (L1 < L2 -> true ; L1 > L2 -> fail ;
            urutan_pemain(DaftarUrutan),
            get_idx(DaftarUrutan, Pemain1, Idx1),
            get_idx(DaftarUrutan, Pemain2, Idx2),
            Idx1 < Idx2)).

% Rule sorting pemain dengan membandingkan
sort_pemain(DaftarUrutan, SortedList) :-
    tukar_sort(DaftarUrutan, TempList), !,
    sort_pemain(TempList, SortedList).
sort_pemain(SortedList, SortedList).

tukar_sort([Pemain1, Pemain2|Sisa], [Pemain2, Pemain1|Sisa]) :-
    bandingkan_pemain(Result, Pemain1, Pemain2),
    Result = (>), !.
tukar_sort([Pemain|Sisa], [Pemain|HasilSisa]) :-
    tukar_sort(Sisa, HasilSisa).

% Rule utama endGame
endGame :-
    giliran(Pemenang),
    format('Permainan selesai! ~w menghabiskan semua kartunya!~n~n', [Pemenang]),
    write('Berikut perhitungan poin sisa kartu:'), nl,
    urutan_pemain(DaftarPemain),
    tampilkan_perhitungan(DaftarPemain), nl,
    sort_pemain(DaftarPemain, SortedList),
    write('Urutan pemenang:'), nl,
    tampilkan_peringkat(SortedList, 1),
    get_head(SortedList, Juara1),
    format('~nSelamat, ~w menjadi pemenang!~n', [Juara1]),
    retractall(game_started).

% Helper menampilkan
tampilkan_perhitungan([]).
tampilkan_perhitungan([PemainSekarang|SisaPemain]) :-
    kartu_tangan(PemainSekarang, ListKartuTangan),
    (ListKartuTangan == [] ->
        format('~w: kartu habis = 0 poin~n', [PemainSekarang]) ;
        jabarkan_kartu(ListKartuTangan, DeskripsiKartu, PoinStr, TotalPoin),
        format('~w: ~s = ~s = ~d poin~n', [PemainSekarang, DeskripsiKartu, PoinStr, TotalPoin])),
    tampilkan_perhitungan(SisaPemain).
tampilkan_peringkat([], _).
tampilkan_peringkat([PemainSekarang|SisaPemain], N) :-
    total_poin_pemain(PemainSekarang, Poin),
    format('~d. ~w (~d poin)~n', [N, PemainSekarang, Poin]),
    N1 is N + 1,
    tampilkan_peringkat(SisaPemain, N1).