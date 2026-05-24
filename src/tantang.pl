% cek punya yg cocok gak si tersangka
cek_kecocokkan([kartu(Warna, _, _)|_], WarnaMeja, _) :- Warna \== hitam, Warna == WarnaMeja, !.
cek_kecocokkan([kartu(_, Jenis, _)|_], _, JenisMeja) :- Jenis \== wildcard, Jenis \== plus_empat, Jenis == JenisMeja, !.
cek_kecocokkan([_|Sisa], WarnaMeja, JenisMeja) :- cek_kecocokkan(Sisa, WarnaMeja, JenisMeja).