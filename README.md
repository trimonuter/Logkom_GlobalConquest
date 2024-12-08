# Global Conquest: Battle for Supremacy
> Tugas ini kami buat untuk memenuhi persyaratan tugas dalam mata kuliah logika komputasional IF2121

Tugas yang kami kerjakan adalah sebuah game strategi sebagai seorang programmer yang ingin mendominasi dunia dengan menggunakan bahasa pemrograman deklaratif Prolog (GNU Prolog).

## Features
Game ini menampilkan alur permainan yang mirip dengan game Risk, di mana pemain berpartisipasi dan bermain secara bergiliran untuk mencapai tujuan permainan.
Berikut beberapa perintah yang dapat dipanggil dalam setiap giliran.

### Draft
Meletakkan tentara tambahan yang didapatkan oleh pemain pada awal giliran. Dilakukan dengan memilih wilayah tujuan dan jumlah tentara yang ingin dipindah. Peletakan tentara dapat dilakukan hingga semua tentara tambahan sudah diletakkan pada wilayah.

### Move
Pemindahan tentara dilakukan dengan memilih wilayah asal, jumlah tentara yang ingin dipindah, serta wilayah tujuan. Pemindahan tentara wajib menyisakan 1 tentara untuk menjaga wilayah yang dimiliki. Pemindahan tentara dapat dilakukan secara tak terbatas pada setiap giliran.

### Risk 
Risk card didapatkan dengan melempar dadu dan bersifat opsional. Pada setiap giliran, pemain hanya memiliki 1 kesempatan untuk mendapatkan risk card. Risk memiliki beberapa jenis seperti berikut:
1. **Ceasefire Order**:
   Pemain dapat memerintahkan seluruh lawan untuk gencatan senjata. Hingga giliran berikutnya, wilayah pemain tidak dapat diserang oleh lawan.

2. **Super Soldier Serum**:
   Seluruh pasukan pemain menerima suntikan serum tentara super. Hingga giliran berikutnya, semua hasil lemparan dadu saat menyerang dan bertahan akan bernilai 6.

3. **Auxiliary Troops**:
   Pemain mendapatkan bantuan tentara tambahan dari Perserikatan Bangsa. Pada giliran berikutnya, tentara tambahan yang didapatkan pemain akan bernilai 2 kali lipat.

4. **Rebellion**:
   Terjadi pemberontakan di wilayah pemain. Satu wilayah acak akan beralih kekuasaan menjadi milik lawan (secara acak).

5. **Disease Outbreak**:
    Seluruh wilayah pemain dilanda wabah penyakit. Semua hasil lemparan dadu saat menyerang dan bertahan hingga giliran berikutnya akan bernilai 1.

6. **Supply Chain Issue**:
    Terdapat masalah pada pengiriman tentara tambahan. Pemain tidak akan mendapatkan tentara tambahan pada giliran berikutnya.


### Attack 
Pemain dapat menyerang dengan memilih wilayah penyerang, menentukan jumlah tentara penyerang, dan memilih wilayah tetangga yang akan diserang. Hasil pertempuran antara 2 wilayah ditentukan dengan lemparan dadu. Penyerangan hanya dapat dilakukan sekali setiap giliran.
### EndTurn 
Giliran pemain diakhiri setelah perintah EndTurn dipanggil.

## Usage
1. `git clone https://github.com/GAIB21/tugas-besar-if2121-logika-komputasional-2023-santaidulugasih-hmin2.git`
2. Buka aplikasi GNU Prolog 
3. Ketik `consult('alamat direktori file main.pl').`
4. Ketik `start.`
   
## Contributors
| Nama | NIM |
| ------------- | ------------- |
| Shabrina Maharani  |  13522134  |
| Auralea Alvinia Syaikha  | 13522148  |
| Muhammad Roihan | 13522152 |
| Muhammad Rasheed Qais Tandjung | 13522158 |


