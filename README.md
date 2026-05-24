# Tugas Besar IF1221 Logika Komputasional
> **Game "UNI" (UNO Official Parody) - GNU Prolog**

## Deskripsi Tubes UNIIII
UNI merupakan implementasi permainan kartu populer UNO yang diparodikan menjadi versinya tersendiri. Program ini dikembangkan menggunakan bahasa pemrograman GNU Prolog sebagai bagian dari ~~Tugas Besar~~ Praktikum IF1221 Logika Komputasional 2026.

Permainan ini menggunakan mayoritas peraturan utama di dalam UNO Official.
Permainan ini mendukung multiplayer sebanyak **2 hingga 4** pemain dengan sistem bergiliran. Setiap pemain dapat memainkan kartu sesuai warna atau jenis kartu yang berada pada bagian atas discard pile untuk menghabiskan seluruh kartu yang dimiliki.

Program mendukung berbagai fitur seperti mengambil kartu, memainkan kartu aksi, melakukan challenge, menyerukan UNI, menangkap pemain yang lupa menyebut UNI, melihat daftar command, melihat kartu yang dimiliki pemain, mengecek informasi permainan, hingga sistem penyimpanan dan pemuatan ulang permainan.

## Cara Mengoperasikan Program
Pastikan perangkat Anda telah terpasang compiler **GNU Prolog**.
Jika sudah, ikuti langkah-langkah berikut:
1. Clone repositori GitHub ini ke komputer lokal Anda:
```bash
git clone https://github.com/EdwTorch/IF1221_G25_ZeriUniDisTriz.git
cd IF1221_G25_ZeriUniDisTriz
```
3. Jalankan GNU Prolog dan langsung memuat file utama permainan:
```prolog
['main.pl'].
```
4. Mulai inisialisasi permainan di dalam shell GNU Prolog dengan perintah:
```prolog
startGame.
```

## Cara Bermain
1. Permainan dimulai menggunakan command **startGame.**
2. Program akan meminta:
- Jumlah pemain (2–4 pemain)
- Nama masing-masing pemain
3. Setelah semua pemain terdaftar:
- Urutan giliran akan diacak
- Setiap pemain mendapatkan 7 kartu
- Kartu pertama di meja ditentukan secara acak
4. Pada setiap giliran, pemain dapat melakukan:
- Tepat satu aksi utama (Memainkan kartu/mengambil kartu/melakukan tantang/menyerukan UNI/menangkap pemain lain)
- Aksi pendukung tanpa batas (Melihat kartu/melihat command/mengecek info)
5. Para pemain juga dapat menyimpan permainan ke dalam satu file untuk di-load jika mau dimainkan kembali
6. Permainan berakhir ketika terdapat pemain yang menghabiskan seluruh kartunya
7. Setelah permainan selesai:
- Program menghitung total poin setiap pemain
- Ranking pemain ditentukan berdasarkan total poin kartu tersisa paling kecil

## Struktur Repository
```text
├── src/
│   ├── main.pl
│   ├── startGame_ambilKartu.pl
│   ├── mainkanKartu.pl
│   ├── kartuaksi.pl
│   ├── sembunyikan.pl
│   ├── tantang.pl
│   ├── cekInfo.pl
│   ├── lihatKartu.pl
│   ├── lihatCommand.pl
│   ├── endGame.pl
│   ├── saveloadGame.pl
│   ├── utils.pl
│   └── a.txt
│
├── doc/
│   ├── Milestone1_G25.pdf
│   ├── Milestone2_G25.pdf
│   └── Laporan_G25.pdf
│
└── README.md
```

## Jenis Kartu
| Kartu | Deskripsi |
|---|---|
| Kartu Angka | Kartu biasa bernomor 0–9 |
| Reverse | Membalik arah giliran permainan |
| Skip | Melewati giliran pemain berikutnya |
| Draw Two (+2) | Pemain berikutnya mengambil 2 kartu |
| Wild Card | Mengganti warna permainan |
| Wild Draw Four (+4) | Mengganti warna dan memaksa pemain berikut mengambil 4 kartu atau menantang |

Setiap kartu selain wild card & wild draw four memiliki 4 warna, yaitu merah, kuning, hijau, dan biru.

## Fitur yang Tersedia
| Command | Fungsi |
|---|---|
| `startGame.` | Memulai permainan |
| `mainkanKartu(NomorUrutKartuDiTangan).` | Memainkan kartu |
| `ambilKartu.` | Mengambil kartu |
| `uni(NomorUrutKartuDiTangan).` | Bermain sambil menyerukan UNI |
| `tangkap(NamaPemain).` | Menangkap pemain yang lupa UNI |
| `tantang.` | Menantang penggunaan Wild Draw Four |
| `lihatKartu.` | Menampilkan kartu pemain |
| `cekInfo.` | Menampilkan informasi permainan |
| `lihatCommand.` | Menampilkan seluruh command |
| `saveGame.` | Menyimpan permainan |
| `loadGame.` | Memuat permainan |
| `sembunyikanKartu(NomorUrutKartuDiTangan).` | Menyembunyikan kartu agar tidak bisa dicek pemain lain |
| `tampilkanKartu(NomorUrutKartuDiTangan).` | Menampilkan kembali kartu yang sebelumnya disembunyikan |

## About 
Anggota G25 ZeriUniDisTriz :
| Nama | NIM |
|---|---|
| Theresia Estelina Ratu Udju | 13525088 |
| Edward Terrance Lie | 13525127 |
| Christabelcyne Costan | 13525141 |
| Natan Danuarta Ariel Wicaksana | 13525143 |
