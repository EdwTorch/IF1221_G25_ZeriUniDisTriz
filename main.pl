:- dynamic(giliran/1).
:- dynamic(kartu_tangan/2).
:- dynamic(discard_top/1).
:- dynamic(efek/1).
:- dynamic(jml_pemain/1).

:- include('utils_startgame').
startGame:- inputJml(Jml),assertz(jml_pemain(Jml)),write(Jml).
