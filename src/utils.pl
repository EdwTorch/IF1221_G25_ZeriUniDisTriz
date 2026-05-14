% Rule Umum
insert_head(In,List,[In|List]).

copy(Isi,Isi).

% delete pada komponen pada index tertentu
del([_|Tail],0,Tail):-!.
del([Head|Tail],Index,[Head|Updatedtail]):- Index >0, Newindex is Index-1, del(Tail,Newindex,Updatedtail).

% Bisa Mengekstrak Element Maupun Idx dari Sebuah Komponen dalam List
get_idx([],_,-1).
get_idx([Head|Tail],Element,Idx):-
get_idxhelp([Head|Tail],Element,0,Idx).

get_idxhelp([],_,_,-1):-!.
get_idxhelp([Element|_],Element,Idx,Idx):-!.
get_idxhelp([Head|Tail],Element,Idxsaatini,Idx):-
Head\==Element, Nextidx is Idxsaatini+1, get_idxhelp(Tail,Element,Nextidx,Idx).

% Append di Belakang List
insert_tail([],In,[In]).
insert_tail([Pala|Sisa],Belakang,[Pala|Result]):- insert_tail(Sisa,Belakang,Result).

% Pengganti fungsi Length
panjang(Pjg,Pjg,[]).
panjang(Skrg,Pjg,[_|Tail]):- Lnjt is Skrg+1, panjang(Lnjt,Pjg,Tail).

% Penerapan Fungsi Random dengan Mengembalikan Listbaru (Tanpa Element yang dipilih), dan Element yang Dipilih
random_select(List, 1, Listbaru,Element) :-
        panjang(0,Length, List),
        random(0,Length,R),
        get_idx(List,Element,R),
        del(List,R,Listbaru),!. 

% Penerapan Fungsi Random Tanpa Menghaslkan Listbaru (dan Tidak menghapus Element yang terpilih). 
% Hanya menghasilkan element yang dipilih
random_select_tanpadel(List, 1,Element) :-
        panjang(0,Length, List),
        random(0,Length,R),
        get_idx(List,Element,R),!.

% mengambil head suatu list
get_head([Head|_],Head).



