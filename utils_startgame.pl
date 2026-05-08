isJmlPemainValid(Jml):- Jml>1, Jml<5.

inputJml(Jml):- write('Masukkan jumlah pemain: '), read(InputJml), 
(isJmlPemainValid(InputJml)-> Jml is InputJml, nl;inputJml(Jml)).

