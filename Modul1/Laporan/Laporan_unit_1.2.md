LAPORAN MODUL 1 UNIT 1.2
DATA PROFILING DAN DATA QUALITY ASSESSMENT
Petunjuk penggunaan: Template ini digunakan untuk mendokumentasikan pengerjaan 38 soal SQL pada database akademik UADW v1.0. Isi bagian bertanda [Isi ...], tempelkan query yang benar-benar dijalankan, lampirkan hasil eksekusi, lalu tuliskan interpretasi berdasarkan hasil tersebut. Nomor modul/unit dapat disesuaikan dengan susunan praktikum.

Identitas Laporan
Nama : [Isi nama lengkap]
NIM : [Isi NIM]
Program Studi : [Isi program studi]
Modul : 1
Unit : 1.2
Tanggal Praktikum : [Isi tanggal]
DBMS : PostgreSQL
Database : [Isi nama database]
Schema : src

Tujuan Praktikum
Setelah menyelesaikan praktikum ini, mahasiswa diharapkan mampu:

Melakukan profiling terhadap struktur dan ukuran dataset akademik.
Memeriksa kualitas data berdasarkan aspek uniqueness, completeness, validity, dan consistency.
Mengidentifikasi indikasi duplikasi pada tabel master maupun transaksi.
Memeriksa keterhubungan data antar-tabel (referential integrity).
Menyusun interpretasi berdasarkan hasil eksekusi query SQL tanpa langsung mengubah data sumber.
Ketentuan Pengerjaan
Gunakan PostgreSQL dan schema src.
Gunakan dataset UADW v1.0 yang disediakan pada praktikum.
Pertahankan data pada source layer dalam kondisi aslinya (raw data).
Praktikum ini berfokus pada pemeriksaan. Jangan melakukan UPDATE, DELETE, deduplikasi, atau standardisasi langsung pada tabel src.
Tempelkan query yang benar-benar dijalankan. Query boleh disesuaikan selama menghasilkan pemeriksaan yang diminta.
Sertakan hasil eksekusi. Untuk hasil berbentuk tabel, salin tabel hasil atau lampirkan tangkapan layar yang terbaca.
Interpretasi harus sesuai dengan hasil aktual. Jangan mengarang hasil atau menyimpulkan bahwa data harus dihapus hanya karena terindikasi duplikat.
Apabila query menghasilkan nol baris atau nilai 0, tuliskan maknanya dalam interpretasi.
1. Menyiapkan dan Memverifikasi Environment Praktikum
Pastikan perangkat kerja dan koneksi database tersedia sebelum melakukan profiling.

1.1 Memeriksa versi PostgreSQL
-- Jalankan query pemeriksaan versi PostgreSQL
select version();

Hasil eksekusi:

[Tempelkan hasil query atau tangkapan layar]

Keterangan:

[Isi versi PostgreSQL yang digunakan]

1.2 Memeriksa database dan user aktif
select
    current_database() as database_aktif,
    current_user as user_aktif;

Hasil eksekusi:

[Tempelkan hasil query atau tangkapan layar]

Keterangan:

Database aktif: [Isi hasil]
User aktif: [Isi hasil]
1.3 Memastikan schema src tersedia
select schema_name
from information_schema.schemata
where schema_name = 'src';

Hasil eksekusi:

[Tempelkan hasil query atau tangkapan layar]

Keterangan:

[Nyatakan apakah schema src ditemukan]

2. Profiling Struktur dan Ukuran Dataset
2.1 Soal 1 — Menghitung jumlah record setiap tabel
Tujuan pemeriksaan
Mengetahui jumlah record pada sepuluh tabel sumber database akademik.

Query SQL

-- Tempelkan query SQL untuk menghitung jumlah record seluruh tabel

Hasil eksekusi

Dataset	Jumlah Record
program_studi	[Isi]
semester	[Isi]
mahasiswa	[Isi]
dosen	[Isi]
mata_kuliah	[Isi]
krs	[Isi]
nilai	[Isi]
aktivitas_lms	[Isi]
pembayaran	[Isi]
kelulusan	[Isi]
Interpretasi

[Uraikan tabel dengan jumlah record terbanyak dan paling sedikit. Jelaskan gambaran umum ukuran dataset berdasarkan hasil query.]

2.2 Soal 2 — Menghitung jumlah kolom setiap tabel
Tujuan pemeriksaan
Mengetahui jumlah kolom pada setiap tabel dalam schema src.

Query SQL

-- Tempelkan query SQL untuk menghitung jumlah kolom setiap tabel

Hasil eksekusi

Nama Tabel	Jumlah Kolom
program_studi	[Isi]
semester	[Isi]
mahasiswa	[Isi]
dosen	[Isi]
mata_kuliah	[Isi]
krs	[Isi]
nilai	[Isi]
aktivitas_lms	[Isi]
pembayaran	[Isi]
kelulusan	[Isi]
Interpretasi

[Bandingkan jumlah kolom antartabel. Sebutkan tabel dengan jumlah kolom terbanyak dan paling sedikit.]

3. Profiling Tabel Mahasiswa
3.1 Soal 3 — Mengukur keunikan NIM
Tujuan pemeriksaan
Mengetahui jumlah record mahasiswa, jumlah NIM unik, dan indikasi kelebihan record berdasarkan NIM.

Query SQL

-- Tempelkan query SQL untuk menghitung raw_rows, distinct_nim,
-- dan excess_duplicate_rows

Hasil eksekusi

Raw Rows	Distinct NIM	Excess Duplicate Rows
[Isi]	[Isi]	[Isi]
Interpretasi

[Jelaskan perbedaan jumlah record dan jumlah NIM unik. Apakah terdapat indikasi duplikasi? Hindari menyimpulkan bahwa record harus dihapus sebelum pemeriksaan lanjutan.]

3.2 Soal 4 — Mengidentifikasi kelompok NIM duplikat
Tujuan pemeriksaan
Menampilkan NIM yang muncul lebih dari satu kali beserta jumlah kemunculannya.

Query SQL

-- Tempelkan query SQL untuk menampilkan NIM yang muncul lebih dari satu kali

Hasil eksekusi

[Tempelkan tabel hasil query. Pastikan kolom NIM dan jumlah kemunculan terlihat.]

Interpretasi

Jumlah kelompok NIM duplikat: [Isi]
Jumlah kemunculan tertinggi: [Isi]
Catatan atau pola yang ditemukan: [Isi]
[Interpretasikan hasil. Apabila terdapat beberapa record dengan NIM sama, jelaskan bahwa perlu pemeriksaan atribut lain atau kemungkinan data historis sebelum menentukan tindakan.]

3.3 Soal 5 — Memeriksa kelengkapan kota asal mahasiswa
Tujuan pemeriksaan
Menghitung jumlah record dengan kota_asal_raw kosong, NULL, atau hanya berisi spasi.

Query SQL

-- Tempelkan query SQL untuk menghitung missing_kota

Hasil eksekusi

Missing Kota Asal
[Isi]
Interpretasi

[Nyatakan jumlah dan proporsi data kota asal yang belum terisi jika proporsi dapat dihitung. Jelaskan dampaknya terhadap analisis yang menggunakan informasi kota asal.]

3.4 Soal 6 — Distribusi mahasiswa berdasarkan program studi mentah
Tujuan pemeriksaan
Menampilkan frekuensi setiap label pada kolom prodi_raw.

Query SQL

-- Tempelkan query SQL distribusi prodi_raw

Hasil eksekusi

[Tempelkan tabel hasil query dengan kolom prodi_raw dan frekuensi.]

Interpretasi

[Identifikasi label yang paling banyak dan paling sedikit muncul. Catat variasi label yang tampak berbeda penulisannya tetapi mungkin merujuk pada program studi yang sama.]

3.5 Soal 7 — Menghitung variasi nama program studi
Tujuan pemeriksaan
Menghitung jumlah nilai berbeda pada kolom prodi_raw.

Query SQL

-- Tempelkan query SQL untuk menghitung distinct_raw_prodi

Hasil eksekusi

Jumlah Variasi prodi_raw
[Isi]
Interpretasi

[Interpretasikan jumlah variasi label. Bandingkan dengan jumlah program studi resmi jika hasil Soal 6 atau informasi tabel referensi tersedia.]

3.6 Soal 8 — Distribusi jenis kelamin mahasiswa
Tujuan pemeriksaan
Menampilkan setiap nilai jk_raw dan frekuensi kemunculannya.

Query SQL

-- Tempelkan query SQL distribusi jk_raw

Hasil eksekusi

[Tempelkan tabel hasil query dengan kolom jk_raw dan frekuensi.]

Interpretasi

[Identifikasi variasi label jenis kelamin. Jelaskan apakah ada indikasi perbedaan kode atau penulisan untuk kategori yang kemungkinan sama. Jangan melakukan standardisasi pada tabel raw.]

3.7 Soal 9 — Distribusi status mahasiswa
Tujuan pemeriksaan
Menampilkan variasi nilai status_raw dan jumlah record pada setiap status.

Query SQL

-- Tempelkan query SQL distribusi status_raw

Hasil eksekusi

[Tempelkan tabel hasil query dengan kolom status_raw dan frekuensi.]

Interpretasi

[Uraikan status yang ditemukan dan frekuensi masing-masing. Catat nilai yang kosong atau label yang perlu diklarifikasi jika ditemukan.]

3.8 Soal 10 — Distribusi kode program studi
Tujuan pemeriksaan
Menampilkan nilai kode_prodi_raw dan frekuensi kemunculannya.

Query SQL

-- Tempelkan query SQL distribusi kode_prodi_raw

Hasil eksekusi

[Tempelkan tabel hasil query dengan kolom kode_prodi_raw dan frekuensi.]

Interpretasi

[Identifikasi kode program studi yang paling banyak digunakan. Catat kode yang kosong, tidak lazim, atau perlu dibandingkan dengan tabel referensi.]

3.9 Soal 11 — Mengidentifikasi nama program studi yang tidak sesuai standar
Tujuan pemeriksaan
Menghitung record mahasiswa dengan prodi_raw yang tidak memiliki kecocokan persis pada program_studi.nama_prodi.

Query SQL

-- Tempelkan query SQL untuk menghitung non_standard_prodi_rows

Hasil eksekusi

Non-standard Prodi Rows
[Isi]
Interpretasi

[Uraikan jumlah record yang tidak cocok dengan nama program studi resmi. Jelaskan bahwa ketidakcocokan persis dapat disebabkan variasi penulisan, singkatan, spasi, atau nilai yang memang tidak dikenal; diperlukan pemeriksaan lebih lanjut untuk memastikan penyebabnya.]

3.10 Soal 12 — Mengidentifikasi variasi format tanggal masuk
Tujuan pemeriksaan
Mengelompokkan tanggal_masuk_raw berdasarkan format YYYY-MM-DD, DD/MM/YYYY, DD-Mon-YYYY, dan OTHER.

Query SQL

-- Tempelkan query SQL untuk mengelompokkan format tanggal masuk

Hasil eksekusi

Format Tanggal	Jumlah Record
YYYY-MM-DD	[Isi]
DD/MM/YYYY	[Isi]
DD-Mon-YYYY	[Isi]
OTHER	[Isi]
Interpretasi

[Identifikasi format yang paling banyak digunakan. Jelaskan apakah ditemukan lebih dari satu format dan berapa record yang masuk kategori OTHER. Ingat bahwa pemeriksaan pola format belum tentu membuktikan tanggal kalender valid.]

4. Profiling Tabel KRS
4.1 Soal 13 — Membandingkan jumlah record KRS dengan KRS unik
Tujuan pemeriksaan
Membandingkan jumlah seluruh record KRS dengan jumlah krs_id yang unik.

Query SQL

-- Tempelkan query SQL untuk menghitung raw_rows dan distinct_krs_id

Hasil eksekusi

Raw Rows	Distinct KRS ID
[Isi]	[Isi]
Interpretasi

[Nyatakan apakah jumlah record sama dengan jumlah KRS ID unik. Jika berbeda, jelaskan indikasi duplikasi berdasarkan krs_id.]

4.2 Soal 14 — Mengidentifikasi duplikasi pengambilan mata kuliah
Tujuan pemeriksaan
Menemukan kombinasi nim, kode_mk, dan semester_id yang muncul lebih dari satu kali pada tabel KRS.

Query SQL

-- Tempelkan query SQL untuk menemukan duplikasi grain KRS

Hasil eksekusi

[Tempelkan tabel hasil query. Kolom minimal: nim, kode_mk, semester_id, dan jumlah.]

Interpretasi

Jumlah kombinasi yang terindikasi duplikat: [Isi]
Jumlah kemunculan tertinggi untuk satu kombinasi: [Isi]
Pola atau catatan penting: [Isi]
[Jelaskan temuan berdasarkan kombinasi atribut. Pertimbangkan kemungkinan kelas berbeda, perubahan status, atau riwayat transaksi sebelum menyebutnya sebagai duplikasi yang harus dihapus.]

4.3 Soal 15 — Menghitung kelebihan record KRS akibat duplikasi
Tujuan pemeriksaan
Menghitung total record yang melebihi satu record pada setiap kelompok kombinasi NIM, mata kuliah, dan semester yang duplikat.

Query SQL

-- Tempelkan query SQL untuk menghitung excess_duplicate_krs

Hasil eksekusi

Excess Duplicate KRS
[Isi]
Interpretasi

[Jelaskan arti angka kelebihan record. Contoh prinsip perhitungan: kelompok dengan tiga record memiliki dua record berlebih. Jangan menyamakan jumlah record berlebih dengan jumlah kelompok duplikat.]

5. Profiling Tabel Nilai
5.1 Soal 16 — Menghitung nilai angka yang kosong
Tujuan pemeriksaan
Menghitung record dengan nilai_angka kosong, NULL, atau hanya berisi spasi.

Query SQL

-- Tempelkan query SQL untuk menghitung missing_nilai_angka

Hasil eksekusi

Missing Nilai Angka
[Isi]
Interpretasi

[Jelaskan jumlah nilai angka yang belum tersedia dan kemungkinan dampaknya terhadap analisis nilai.]

5.2 Soal 17 — Mengidentifikasi nilai angka di luar rentang valid
Tujuan pemeriksaan
Menghitung nilai angka di luar rentang 0–100. Nilai kosong tidak dihitung sebagai nilai di luar rentang pada pemeriksaan ini.

Query SQL

-- Tempelkan query SQL untuk menghitung invalid_nilai_angka

Hasil eksekusi

Invalid Nilai Angka
[Isi]
Interpretasi

[Jelaskan apakah ditemukan nilai di bawah 0 atau di atas 100. Jika hasilnya 0, nyatakan bahwa tidak ditemukan nilai di luar rentang pada pemeriksaan ini.]

5.3 Soal 18 — Menghitung statistik deskriptif nilai mahasiswa
Tujuan pemeriksaan
Menghitung jumlah nilai valid, nilai minimum, maksimum, dan rata-rata untuk nilai angka dalam rentang 0–100.

Query SQL

-- Tempelkan query SQL untuk menghitung statistik nilai valid

Hasil eksekusi

Valid Rows	Minimum	Maksimum	Rata-rata
[Isi]	[Isi]	[Isi]	[Isi]
Interpretasi

[Uraikan rentang dan rata-rata nilai. Interpretasikan secara deskriptif saja; jangan menyimpulkan kualitas pembelajaran hanya berdasarkan statistik ini.]

5.4 Soal 19 — Memeriksa konsistensi nilai angka dengan nilai huruf
Tujuan pemeriksaan
Menghitung record dengan ketidaksesuaian antara nilai_angka dan nilai_huruf berdasarkan aturan konversi berikut.

Nilai Angka	Nilai Huruf
85–100	A
80–<85	AB
75–<80	B
70–<75	BC
60–<70	C
50–<60	D
0–<50	E
Query SQL

-- Tempelkan query SQL untuk menghitung letter_mismatch

Hasil eksekusi

Letter Mismatch
[Isi]
Interpretasi

[Jelaskan jumlah record yang nilai hurufnya tidak sesuai dengan hasil konversi nilai angka. Jika ditemukan ketidaksesuaian, sebutkan bahwa record perlu ditelusuri lebih lanjut.]

5.5 Soal 20 — Memeriksa konsistensi nilai angka dengan status kelulusan
Tujuan pemeriksaan
Menghitung record dengan ketidaksesuaian antara nilai_angka dan status_lulus, dengan ketentuan nilai minimal 60 dinyatakan Lulus, sedangkan nilai di bawah 60 dinyatakan Tidak Lulus.

Query SQL

-- Tempelkan query SQL untuk menghitung status_mismatch

Hasil eksekusi

Status Mismatch
[Isi]
Interpretasi

[Jelaskan jumlah ketidaksesuaian yang ditemukan. Perhatikan bahwa kesimpulan ini mengikuti aturan kelulusan yang ditetapkan dalam soal.]

5.6 Soal 21 — Mengidentifikasi duplikasi record nilai
Tujuan pemeriksaan
Menampilkan kombinasi nim, kode_mk, dan semester_id yang tercatat lebih dari satu kali pada tabel nilai.

Query SQL

-- Tempelkan query SQL untuk mengidentifikasi duplikasi grain nilai

Hasil eksekusi

[Tempelkan tabel hasil query. Kolom minimal: nim, kode_mk, semester_id, dan jumlah.]

Interpretasi

[Jelaskan jumlah dan pola kelompok yang terindikasi duplikat. Pertimbangkan kemungkinan nilai revisi atau riwayat input sebelum memutuskan bahwa data merupakan duplikasi yang tidak sah.]

6. Pemeriksaan Referential Integrity pada KRS dan Nilai
6.1 Soal 22 — Memeriksa NIM KRS yang tidak terdaftar sebagai mahasiswa
Tujuan pemeriksaan
Menghitung record KRS dengan NIM yang tidak ditemukan pada tabel mahasiswa.

Query SQL

-- Tempelkan query SQL untuk menghitung krs_nim_tidak_terdaftar

Hasil eksekusi

KRS NIM Tidak Terdaftar
[Isi]
Interpretasi

[Jelaskan apakah seluruh NIM KRS memiliki pasangan di tabel mahasiswa. Jika ditemukan record tanpa pasangan, sebutkan sebagai indikasi masalah referensial yang perlu ditelusuri.]

6.2 Soal 23 — Memeriksa NIM pada tabel nilai yang tidak terdaftar sebagai mahasiswa
Tujuan pemeriksaan
Menghitung record nilai dengan NIM yang tidak ditemukan pada tabel mahasiswa.

Query SQL

-- Tempelkan query SQL untuk menghitung nim_tidak_terdaftar

Hasil eksekusi

NIM Tidak Terdaftar
[Isi]
Interpretasi

[Jelaskan hasil pemeriksaan hubungan tabel nilai dengan tabel mahasiswa.]

6.3 Soal 24 — Memeriksa kode mata kuliah yang tidak memiliki referensi
Tujuan pemeriksaan
Menghitung record nilai dengan kode_mk yang tidak ditemukan pada tabel mata_kuliah.

Query SQL

-- Tempelkan query SQL untuk menghitung orphan_nilai_mk

Hasil eksekusi

Orphan Nilai Mata Kuliah
[Isi]
Interpretasi

[Jelaskan apakah seluruh kode mata kuliah pada tabel nilai memiliki referensi yang sesuai.]

6.4 Soal 25 — Memeriksa semester nilai yang tidak memiliki referensi
Tujuan pemeriksaan
Menghitung record nilai dengan semester_id yang tidak ditemukan pada tabel semester.

Query SQL

-- Tempelkan query SQL untuk menghitung orphan_nilai_semester

Hasil eksekusi

Orphan Nilai Semester
[Isi]
Interpretasi

[Jelaskan apakah seluruh semester pada tabel nilai memiliki referensi yang sesuai.]

7. Profiling Aktivitas LMS
7.1 Soal 26 — Mengukur duplikasi aktivitas LMS
Tujuan pemeriksaan
Membandingkan jumlah seluruh record aktivitas LMS dengan jumlah lms_event_id unik.

Query SQL

-- Tempelkan query SQL untuk menghitung raw_rows,
-- distinct_event_id, dan duplicate_excess

Hasil eksekusi

Raw Rows	Distinct Event ID	Duplicate Excess
[Isi]	[Isi]	[Isi]
Interpretasi

[Jelaskan apakah terdapat indikasi duplikasi berdasarkan identitas event LMS.]

7.2 Soal 27 — Menganalisis distribusi tipe aktivitas LMS
Tujuan pemeriksaan
Menampilkan setiap tipe_event dan jumlah aktivitas pada masing-masing tipe.

Query SQL

-- Tempelkan query SQL distribusi tipe_event

Hasil eksekusi

[Tempelkan tabel hasil query dengan kolom tipe_event dan jumlah.]

Interpretasi

[Identifikasi tipe aktivitas paling banyak dan paling sedikit. Jelaskan gambaran komposisi aktivitas berdasarkan hasil query.]

7.3 Soal 28 — Memeriksa kelengkapan skor kuis
Tujuan pemeriksaan
Menghitung aktivitas bertipe quiz_attempt yang tidak memiliki skor pada skor_kuis.

Query SQL

-- Tempelkan query SQL untuk menghitung quiz_missing_score

Hasil eksekusi

Quiz Missing Score
[Isi]
Interpretasi

[Jelaskan jumlah aktivitas kuis yang belum memiliki skor. Catat kemungkinan dampaknya terhadap analisis hasil kuis.]

7.4 Soal 29 — Mengidentifikasi skor pada aktivitas selain kuis
Tujuan pemeriksaan
Menghitung aktivitas selain quiz_attempt yang tetap memiliki nilai pada kolom skor_kuis.

Query SQL

-- Tempelkan query SQL untuk menghitung nonquiz_with_score

Hasil eksekusi

Nonquiz With Score
[Isi]
Interpretasi

[Jelaskan apakah terdapat skor pada tipe aktivitas selain kuis. Apabila ditemukan, perlu diperiksa apakah kondisi tersebut memang diperbolehkan oleh rancangan sistem LMS.]

8. Profiling Tabel Pembayaran
8.1 Soal 30 — Mengidentifikasi nominal pembayaran negatif
Tujuan pemeriksaan
Menghitung record pembayaran dengan nominal_bayar kurang dari nol.

Query SQL

-- Tempelkan query SQL untuk menghitung negative_payment

Hasil eksekusi

Negative Payment
[Isi]
Interpretasi

[Jelaskan apakah terdapat nominal pembayaran negatif. Jika ada, catat bahwa transaksi perlu ditelusuri sesuai konteks pencatatan keuangan.]

8.2 Soal 31 — Memeriksa tanggal pembayaran yang kosong
Tujuan pemeriksaan
Menghitung pembayaran dengan nominal positif tetapi tanggal_bayar_raw kosong, NULL, atau hanya berisi spasi.

Query SQL

-- Tempelkan query SQL untuk menghitung positive_payment_missing_date

Hasil eksekusi

Positive Payment Missing Date
[Isi]
Interpretasi

[Jelaskan jumlah transaksi pembayaran positif yang belum memiliki tanggal pembayaran.]

8.3 Soal 32 — Menganalisis distribusi status pembayaran
Tujuan pemeriksaan
Menampilkan jumlah record berdasarkan setiap nilai status_pembayaran.

Query SQL

-- Tempelkan query SQL distribusi status_pembayaran

Hasil eksekusi

[Tempelkan tabel hasil query dengan kolom status_pembayaran dan jumlah.]

Interpretasi

[Identifikasi status pembayaran yang paling banyak dan paling sedikit. Jelaskan distribusi berdasarkan data yang diperoleh, tanpa membuat asumsi di luar data.]

9. Profiling Tabel Kelulusan
9.1 Soal 33 — Memeriksa duplikasi data kelulusan
Tujuan pemeriksaan
Membandingkan jumlah seluruh record kelulusan dengan jumlah NIM unik.

Query SQL

-- Tempelkan query SQL untuk menghitung raw_rows,
-- distinct_graduate_nim, dan duplicate_excess

Hasil eksekusi

Raw Rows	Distinct Graduate NIM	Duplicate Excess
[Isi]	[Isi]	[Isi]
Interpretasi

[Jelaskan apakah terdapat lebih dari satu record kelulusan untuk NIM yang sama. Periksa konteks bisnis sebelum menganggapnya sebagai duplikasi yang tidak sah.]

9.2 Soal 34 — Menganalisis status kelulusan tepat waktu
Tujuan pemeriksaan
Menampilkan jumlah record berdasarkan setiap nilai status_tepat_waktu.

Query SQL

-- Tempelkan query SQL distribusi status_tepat_waktu

Hasil eksekusi

[Tempelkan tabel hasil query dengan kolom status_tepat_waktu dan jumlah.]

Interpretasi

[Uraikan jumlah mahasiswa pada masing-masing kategori status tepat waktu. Jika akan menghitung persentase, jelaskan dasar pembaginya.]

10. Pemeriksaan Relasi Antar-Tabel
10.1 Soal 35 — Memeriksa aktivitas LMS dengan NIM yang tidak terdaftar
Tujuan pemeriksaan
Menghitung record aktivitas LMS dengan NIM yang tidak ditemukan pada tabel mahasiswa.

Query SQL

-- Tempelkan query SQL untuk menghitung orphan_lms_student

Hasil eksekusi

Orphan LMS Student
[Isi]
Interpretasi

[Jelaskan apakah seluruh aktivitas LMS dapat dihubungkan dengan mahasiswa yang terdaftar.]

10.2 Soal 36 — Memeriksa aktivitas LMS dengan mata kuliah yang tidak terdaftar
Tujuan pemeriksaan
Menghitung record aktivitas LMS dengan kode_mk yang tidak ditemukan pada tabel mata kuliah.

Query SQL

-- Tempelkan query SQL untuk menghitung orphan_lms_course

Hasil eksekusi

Orphan LMS Course
[Isi]
Interpretasi

[Jelaskan apakah seluruh aktivitas LMS memiliki referensi mata kuliah yang ditemukan pada tabel master mata kuliah.]

10.3 Soal 37 — Memeriksa pembayaran dengan NIM yang tidak terdaftar
Tujuan pemeriksaan
Menghitung record pembayaran dengan NIM yang tidak ditemukan pada tabel mahasiswa.

Query SQL

-- Tempelkan query SQL untuk menghitung orphan_payment_student

Hasil eksekusi

Orphan Payment Student
[Isi]
Interpretasi

[Jelaskan apakah seluruh transaksi pembayaran terhubung dengan data mahasiswa.]

10.4 Soal 38 — Memeriksa data kelulusan dengan NIM yang tidak terdaftar
Tujuan pemeriksaan
Menghitung record kelulusan dengan NIM yang tidak ditemukan pada tabel mahasiswa.

Query SQL

-- Tempelkan query SQL untuk menghitung orphan_graduation_student

Hasil eksekusi

Orphan Graduation Student
[Isi]
Interpretasi

[Jelaskan apakah seluruh record kelulusan memiliki data induk mahasiswa.]

11. Rekapitulasi Hasil Data Profiling dan Data Quality
Isikan ringkasan hasil dari seluruh pemeriksaan. Kolom status dapat menggunakan kategori Tidak ditemukan masalah, Perlu pemeriksaan, atau Data belum cukup. Berikan status berdasarkan hasil dan konteks data, bukan berdasarkan dugaan.

No.	Area Pemeriksaan	Indikator	Hasil	Status	Catatan Temuan
1	Dataset	Jumlah record setiap tabel	[Isi]	[Isi]	[Isi]
2	Dataset	Jumlah kolom setiap tabel	[Isi]	[Isi]	[Isi]
3	Mahasiswa	Kelebihan record berdasarkan NIM	[Isi]	[Isi]	[Isi]
4	Mahasiswa	Kelompok NIM duplikat	[Isi]	[Isi]	[Isi]
5	Mahasiswa	Kota asal kosong	[Isi]	[Isi]	[Isi]
6	Mahasiswa	Variasi label program studi	[Isi]	[Isi]	[Isi]
7	Mahasiswa	Variasi label jenis kelamin	[Isi]	[Isi]	[Isi]
8	Mahasiswa	Program studi tidak cocok dengan referensi	[Isi]	[Isi]	[Isi]
9	Mahasiswa	Variasi format tanggal masuk	[Isi]	[Isi]	[Isi]
10	KRS	Kelebihan record berdasarkan KRS ID	[Isi]	[Isi]	[Isi]
11	KRS	Duplikasi kombinasi NIM–MK–semester	[Isi]	[Isi]	[Isi]
12	Nilai	Nilai angka kosong	[Isi]	[Isi]	[Isi]
13	Nilai	Nilai angka di luar rentang	[Isi]	[Isi]	[Isi]
14	Nilai	Statistik nilai valid	[Isi]	[Isi]	[Isi]
15	Nilai	Ketidaksesuaian nilai angka dan huruf	[Isi]	[Isi]	[Isi]
16	Nilai	Ketidaksesuaian nilai dan status lulus	[Isi]	[Isi]	[Isi]
17	Nilai	Duplikasi kombinasi NIM–MK–semester	[Isi]	[Isi]	[Isi]
18	Referential integrity	NIM KRS tidak terdaftar	[Isi]	[Isi]	[Isi]
19	Referential integrity	NIM nilai tidak terdaftar	[Isi]	[Isi]	[Isi]
20	Referential integrity	Kode MK nilai tidak terdaftar	[Isi]	[Isi]	[Isi]
21	Referential integrity	Semester nilai tidak terdaftar	[Isi]	[Isi]	[Isi]
22	LMS	Kelebihan record berdasarkan event ID	[Isi]	[Isi]	[Isi]
23	LMS	Distribusi tipe aktivitas	[Isi]	[Isi]	[Isi]
24	LMS	Skor kuis kosong	[Isi]	[Isi]	[Isi]
25	LMS	Skor pada aktivitas non-kuis	[Isi]	[Isi]	[Isi]
26	Pembayaran	Nominal pembayaran negatif	[Isi]	[Isi]	[Isi]
27	Pembayaran	Pembayaran positif tanpa tanggal	[Isi]	[Isi]	[Isi]
28	Pembayaran	Distribusi status pembayaran	[Isi]	[Isi]	[Isi]
29	Kelulusan	Kelebihan record berdasarkan NIM	[Isi]	[Isi]	[Isi]
30	Kelulusan	Distribusi status tepat waktu	[Isi]	[Isi]	[Isi]
31	Relasi LMS	NIM aktivitas LMS tidak terdaftar	[Isi]	[Isi]	[Isi]
32	Relasi LMS	Kode MK aktivitas LMS tidak terdaftar	[Isi]	[Isi]	[Isi]
33	Relasi pembayaran	NIM pembayaran tidak terdaftar	[Isi]	[Isi]	[Isi]
34	Relasi kelulusan	NIM kelulusan tidak terdaftar	[Isi]	[Isi]	[Isi]
Catatan: Rekap di atas merangkum indikator utama. Hasil distribusi dan statistik yang berbentuk beberapa baris tetap perlu disertakan pada bagian aktivitas masing-masing.

12. Kesimpulan Praktikum
Berdasarkan seluruh query dan hasil pemeriksaan yang telah dilakukan, tuliskan kesimpulan dengan menjawab pertanyaan berikut.

Bagaimana gambaran umum struktur dan ukuran dataset akademik yang diperiksa?

[Tulis kesimpulan]

Aspek kualitas data apa saja yang menunjukkan indikasi masalah?

[Tulis kesimpulan berdasarkan hasil aktual]

Tabel mana yang memiliki temuan paling banyak atau paling perlu diperiksa lebih lanjut? Jelaskan berdasarkan hasil.

[Tulis kesimpulan]

Apakah terdapat relasi antar-tabel yang tidak terpenuhi?

[Tulis kesimpulan]

Pemeriksaan lanjutan apa yang diperlukan sebelum melakukan cleaning, standardisasi, atau deduplikasi?

[Tulis kesimpulan]

12.1 Temuan Utama
Tuliskan maksimal lima temuan utama berdasarkan hasil praktikum.

[Temuan 1]
[Temuan 2]
[Temuan 3]
[Temuan 4]
[Temuan 5]
12.2 Rekomendasi Pemeriksaan Lanjutan
Tuliskan rekomendasi langkah pemeriksaan lanjutan. Pada tahap ini, rekomendasi tidak berarti langsung mengubah atau menghapus data pada source layer.

[Rekomendasi 1]
[Rekomendasi 2]
[Rekomendasi 3]
13. Lampiran
13.1 Bukti Eksekusi Query
[Tempelkan tangkapan layar DBeaver/pgAdmin atau bukti eksekusi lain yang relevan. Pastikan query dan hasil terbaca.]

13.2 Catatan Kendala Praktikum
No.	Kendala	Penyebab (jika diketahui)	Solusi yang Dilakukan
1	[Isi]	[Isi]	[Isi]
2	[Isi]	[Isi]	[Isi]
3	[Isi]	[Isi]	[Isi]
13.3 Referensi
Materi praktikum Modul 1 Unit 1.1 — persiapan environment dan source layer UADW v1.0.
Dataset UADW v1.0 yang disediakan untuk praktikum.
Dokumentasi PostgreSQL: [Tambahkan referensi yang digunakan, jika ada].
Akhir Laporan
