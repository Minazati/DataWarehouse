# LAPORAN MODUL 1 UNIT 1.2

# DATA PROFILING DAN DATA QUALITY ASSESSMENT

---

## Identitas Laporan
## Identitas Laporan

| Identitas | Keterangan |
|---|---|
| Nama | Annisa Almaghvirah |
| NIM | 240306037 |
| Modul | 1 |
| Unit | 1.2 |
| Tanggal Praktikum | 5 November 2026 |
| DBMS| PostgreSQL |
| Database | uadw_lab |
| Schema | src |
---

## Tujuan Praktikum

Setelah menyelesaikan praktikum ini, mahasiswa diharapkan mampu:

1. Melakukan profiling terhadap struktur dan ukuran dataset akademik.
2. Memeriksa kualitas data berdasarkan aspek *uniqueness*, *completeness*, *validity*, dan *consistency*.
3. Mengidentifikasi indikasi duplikasi pada tabel master maupun transaksi.
4. Memeriksa keterhubungan data antar-tabel (*referential integrity*).
5. Menyusun interpretasi berdasarkan hasil eksekusi query SQL tanpa langsung mengubah data sumber.

## Ketentuan Pengerjaan

1. Menggunakan PostgreSQL dan schema `src` dengan dataset UADW v1.0.
2. Data pada source layer dipertahankan dalam kondisi asli (*raw data*).
3. Praktikum berfokus pada pemeriksaan: tidak ada `UPDATE`, `DELETE`, deduplikasi, atau standardisasi pada tabel `src`.
4. Seluruh query tersimpan pada file `SQL/modul_1_unit_1.2.sql` dan dijalankan melalui SQL Editor DBeaver.
5. Screenshot hasil eksekusi disisipkan pada bagian bukti masing-masing soal.

---

# 1. Menyiapkan dan Memverifikasi Environment Praktikum

### 1.1 Memeriksa versi PostgreSQL

```sql
SELECT version();
```

**Hasil eksekusi:**


![Gambar 27. Hasil SELECT version()](gambar/unit-1.2_01.png)


### 1.2 Memeriksa database dan user aktif

```sql
SELECT
    current_database() AS database_aktif,
    current_user      AS user_aktif;
```

**Hasil eksekusi:**


![Gambar 28. Hasil database dan user aktif](gambar/unit-1.2_02.png)


### 1.3 Memastikan schema `src` tersedia

```sql
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name = 'src';
```

**Hasil eksekusi:**


![Gambar 29. Hasil pemeriksaan schema src](gambar/unit-1.2_03.png)


---

# 2. Profiling Struktur dan Ukuran Dataset

## 2.1 Soal 1 — Menghitung jumlah record setiap tabel

**Tujuan pemeriksaan**  
Mengetahui jumlah record pada sepuluh tabel sumber database akademik.

**Query SQL**

```sql
SELECT 'program_studi' AS nama_dataset, COUNT(*) AS jumlah_record FROM src.program_studi
UNION ALL SELECT 'semester', COUNT(*) FROM src.semester
UNION ALL SELECT 'mahasiswa', COUNT(*) FROM src.mahasiswa
UNION ALL SELECT 'dosen', COUNT(*) FROM src.dosen
UNION ALL SELECT 'mata_kuliah', COUNT(*) FROM src.mata_kuliah
UNION ALL SELECT 'krs', COUNT(*) FROM src.krs
UNION ALL SELECT 'nilai', COUNT(*) FROM src.nilai
UNION ALL SELECT 'aktivitas_lms', COUNT(*) FROM src.aktivitas_lms
UNION ALL SELECT 'pembayaran', COUNT(*) FROM src.pembayaran
UNION ALL SELECT 'kelulusan', COUNT(*) FROM src.kelulusan;
```

**Hasil eksekusi**

![Gambar 30. Soal 1 – Jumlah record setiap tabel](gambar/unit-1.2_04.png)


**Interpretasi**

Berdasarkan hasil pemeriksaan, tabel aktivitas_lms memiliki jumlah data paling banyak, yaitu 200.356 record. Selanjutnya, tabel krs memiliki 57.025 record dan tabel nilai sebanyak 57.000 record. Sementara itu, jumlah data paling sedikit terdapat pada tabel program_studi sebanyak 6 record dan semester sebanyak 8 record. Perbedaan jumlah tersebut menunjukkan bahwa tabel transaksi memiliki volume data lebih besar dibandingkan tabel referensi. Selain itu, terdapat selisih 25 record antara tabel KRS dan nilai yang perlu diperiksa lebih lanjut terkait kemungkinan adanya data ganda.

## 2.2 Soal 2 — Menghitung jumlah kolom setiap tabel

**Tujuan pemeriksaan**  
Mengetahui jumlah kolom pada setiap tabel dalam schema `src`.

**Query SQL**

```sql
SELECT table_name AS nama_tabel, COUNT(*) AS jumlah_kolom
FROM information_schema.columns
WHERE table_schema = 'src'
GROUP BY table_name
ORDER BY table_name ASC;
```

**Hasil eksekusi**

![Gambar 31. Soal 2 – Jumlah kolom setiap tabel](gambar/unit-1.2_05.png)


**Interpretasi**

Hasil profiling menunjukkan bahwa jumlah kolom pada setiap tabel berbeda-beda, yaitu berkisar antara 5 sampai 11 kolom. Tabel mahasiswa memiliki struktur paling banyak dengan 11 kolom, sedangkan tabel program_studi hanya memiliki 5 kolom. Banyaknya atribut pada tabel mahasiswa menunjukkan bahwa tabel tersebut menyimpan informasi yang lebih beragam. Perbedaan struktur ini masih sesuai dengan fungsi masing-masing tabel dalam database akademik.

---

# 3. Profiling Tabel Mahasiswa

## 3.1 Soal 3 — Mengukur keunikan NIM

**Tujuan pemeriksaan**  
Mengetahui jumlah record mahasiswa, jumlah NIM unik, dan indikasi kelebihan record berdasarkan NIM.

**Query SQL**

```sql
SELECT
    COUNT(*) AS jumlah_seluruh_record,
    COUNT(DISTINCT nim) AS jumlah_nim_unik,
    COUNT(*) - COUNT(DISTINCT nim) AS indikasi_kelebihan_record_duplikat
FROM src.mahasiswa;
```

**Hasil eksekusi**

![Gambar 32. Soal 3 – Keunikan NIM mahasiswa](gambar/unit-1.2_06.png)


**Interpretasi**

Dari hasil perhitungan, diketahui bahwa jumlah seluruh data mahasiswa adalah 1.965 record, sedangkan jumlah NIM yang berbeda hanya 1.950. Dengan demikian, terdapat selisih 15 record yang menunjukkan adanya NIM dengan kemunculan lebih dari satu kali. Kondisi ini menandakan bahwa kolom NIM belum sepenuhnya memenuhi aspek uniqueness. Pemeriksaan lebih lanjut diperlukan untuk mengetahui apakah pengulangan tersebut merupakan duplikasi data atau memiliki alasan tertentu.

## 3.2 Soal 4 — Mengidentifikasi NIM duplikat

**Tujuan pemeriksaan**  
Menampilkan NIM yang muncul lebih dari satu kali beserta jumlah kemunculannya.

**Query SQL**

```sql
SELECT nim, COUNT(*) AS jumlah_kemunculan
FROM src.mahasiswa
GROUP BY nim
HAVING COUNT(*) > 1
ORDER BY jumlah_kemunculan DESC, nim ASC;
```

**Hasil eksekusi**

![Gambar 33. Soal 4 – NIM duplikat (bagian 1 dari 2)](gambar/unit-1.2_07.png)

![Gambar 34. Soal 4 – NIM duplikat (bagian 2 dari 2)](gambar/unit-1.2_08.png)


Hasil query menampilkan **15 baris** (15 NIM), masing-masing muncul 2 kali.


**Interpretasi**

Hasil pengelompokan menunjukkan terdapat 15 NIM yang tercatat lebih dari satu kali. Setiap NIM tersebut muncul sebanyak dua kali. Berdasarkan pemeriksaan atribut lainnya, data yang berulang memiliki isi yang sama sehingga mengarah pada duplikasi identik (exact duplicate). Temuan ini perlu dicatat sebagai masalah kualitas data, tetapi belum dilakukan penghapusan karena praktikum masih berada pada tahap profiling.


## 3.3 Soal 5 — Memeriksa kelengkapan kota asal mahasiswa

**Tujuan pemeriksaan**  
Menghitung jumlah record dengan `kota_asal_raw` kosong, `NULL`, atau hanya berisi spasi.

**Query SQL**

```sql
SELECT COUNT(*) AS jumlah_kota_asal_kosong
FROM src.mahasiswa
WHERE kota_asal_raw IS NULL
   OR BTRIM(kota_asal_raw) = '';

```

**Hasil eksekusi**

![Gambar 35. Soal 5 – Kelengkapan kota asal](gambar/unit-1.2_09.png)


**Interpretasi**

Berdasarkan hasil query, ditemukan 30 record mahasiswa yang belum memiliki informasi kota asal. Jumlah tersebut setara dengan sekitar 1,53% dari keseluruhan 1.965 record mahasiswa. Walaupun persentasenya tidak terlalu besar, data kosong tetap dapat memengaruhi analisis berdasarkan wilayah asal mahasiswa. Oleh karena itu, kelengkapan atribut ini perlu diperhatikan pada proses pengolahan data berikutnya.

## 3.4 Soal 6 — Distribusi mahasiswa berdasarkan program studi (prodi_raw)

**Tujuan pemeriksaan**  
Menampilkan frekuensi setiap label pada kolom `prodi_raw`.

**Query SQL**

```sql
SELECT prodi_raw, COUNT(*) AS jumlah_mahasiswa
FROM src.mahasiswa
GROUP BY prodi_raw
ORDER BY jumlah_mahasiswa DESC, prodi_raw;
```

**Hasil eksekusi**

![Gambar 36. Soal 6 – Distribusi prodi_raw (bagian 1 dari 3)](gambar/unit-1.2_10.png)

![Gambar 37. Soal 6 – Distribusi prodi_raw (bagian 2 dari 3)](gambar/unit-1.2_11.png)

![Gambar 38. Soal 6 – Distribusi prodi_raw (bagian 3 dari 3)](gambar/unit-1.2_12.png)


**Interpretasi**

Hasil pengelompokan memperlihatkan bahwa terdapat 30 bentuk penulisan program studi, sementara data referensi hanya menyediakan 6 nama program studi resmi. Sebanyak 1.530 record menggunakan enam label yang sesuai dengan nama resmi, sedangkan 435 record lainnya menggunakan variasi penulisan yang berbeda. Variasi tersebut dapat berupa singkatan, perbedaan penggunaan huruf kapital, maupun penyebutan nama program studi yang berbeda. Hal ini menunjukkan bahwa penulisan atribut program studi belum seragam.

## 3.5 Soal 7 — Menghitung variasi penulisan program studi

**Tujuan pemeriksaan**  
Menghitung jumlah nilai berbeda pada kolom `prodi_raw`.

**Query SQL**

```sql
SELECT COUNT(DISTINCT prodi_raw) AS jumlah_variasi_nama_prodi
FROM src.mahasiswa
WHERE prodi_raw IS NOT NULL
  AND BTRIM(prodi_raw) <> '';
```

**Hasil eksekusi**

![Gambar 39. Soal 7 – Variasi penulisan program studi](gambar/unit-1.2_13.png)


**Interpretasi**

Dari hasil query diperoleh sebanyak 30 nilai program studi yang berbeda. Jumlah tersebut lebih banyak dibandingkan enam program studi yang tersedia pada tabel referensi. Artinya, terdapat 24 variasi label tambahan yang belum sesuai dengan penamaan resmi. Perbedaan ini perlu diperhatikan karena dapat menyebabkan data dari program studi yang sama terbaca sebagai kategori yang berbeda ketika dilakukan analisis.

## 3.6 Soal 8 — Distribusi jenis kelamin (jk_raw)

**Tujuan pemeriksaan**  
Menampilkan setiap nilai `jk_raw` dan frekuensi kemunculannya.

**Query SQL**

```sql
SELECT jk_raw, COUNT(*) AS jumlah_mahasiswa
FROM src.mahasiswa
GROUP BY jk_raw
ORDER BY jumlah_mahasiswa DESC, jk_raw;
```

**Hasil eksekusi**

![Gambar 40. Soal 8 – Distribusi jk_raw](gambar/unit-1.2_14.png)


**Interpretasi**

Hasil pemeriksaan menunjukkan terdapat enam bentuk nilai pada kolom jenis kelamin, yaitu L, P, Laki-laki, Perempuan, M, dan F. Nilai-nilai tersebut kemungkinan merepresentasikan dua kategori yang sama, tetapi ditulis menggunakan kode dan istilah yang berbeda. Sebanyak 437 record atau sekitar 22,2% menggunakan bentuk selain kode standar L dan P. Kondisi ini memperlihatkan perlunya penyamaan format kategori agar pengelompokan data menjadi lebih konsisten.

## 3.7 Soal 9 — Distribusi status mahasiswa (status_raw)

**Tujuan pemeriksaan**  
Menampilkan variasi nilai `status_raw` dan jumlah record pada setiap status.

**Query SQL**

```sql
SELECT status_raw, COUNT(*) AS jumlah_record
FROM src.mahasiswa
GROUP BY status_raw
ORDER BY jumlah_record DESC, status_raw;
```

**Hasil eksekusi**

![Gambar 39. Soal 9 – Distribusi status_raw](gambar/unit-1.2_15.png)


**Interpretasi**

Berdasarkan hasil pengelompokan, ditemukan enam variasi penulisan status mahasiswa yang sebenarnya mewakili tiga kategori, yaitu Aktif, Lulus, dan Cuti. Perbedaan tersebut disebabkan oleh penggunaan huruf kapital yang tidak seragam serta adanya spasi tambahan pada beberapa nilai. Terdapat 43 record yang menggunakan penulisan berbeda dari bentuk standar. Dengan demikian, data status mahasiswa masih memerlukan pemeriksaan dan penyeragaman agar tidak menghasilkan kategori yang terpisah.

## 3.8 Soal 10 — Distribusi kode program studi (kode_prodi_raw)

**Tujuan pemeriksaan**  
Menampilkan nilai `kode_prodi_raw` dan frekuensi kemunculannya.

**Query SQL**

```sql
SELECT kode_prodi_raw, COUNT(*) AS jumlah_mahasiswa
FROM src.mahasiswa
GROUP BY kode_prodi_raw
ORDER BY jumlah_mahasiswa DESC, kode_prodi_raw;
```

**Hasil eksekusi**

![Gambar 40. Soal 10 – Distribusi kode_prodi_raw (bagian 1 dari 3)](gambar/unit-1.2_16.png)

![Gambar 41. Soal 10 – Distribusi kode_prodi_raw (bagian 2 dari 3)](gambar/unit-1.2_17.png)

![Gambar 42. Soal 10 – Distribusi kode_prodi_raw (bagian 3 dari 3)](gambar/unit-1.2_18.png)


Nilai yang ditulis dengan tanda kutip memiliki spasi di depan/belakang.

**Interpretasi**

Hasil query menunjukkan terdapat 24 variasi penulisan kode program studi, sedangkan tabel referensi hanya memiliki enam kode resmi. Kode IF merupakan nilai yang paling sering ditemukan dengan jumlah 336 record. Selain itu, terdapat 208 record yang penulisannya berbeda dari kode referensi, yaitu karena tambahan spasi sebanyak 136 record dan penggunaan huruf kecil sebanyak 72 record. Setelah dilakukan pemeriksaan menggunakan konsep TRIM dan UPPER, seluruh kode dapat dicocokkan dengan kode resmi.

## 3.9 Soal 11 — Nama program studi tidak sesuai standar

**Tujuan pemeriksaan**  
Menghitung record mahasiswa dengan `prodi_raw` yang tidak cocok persis dengan `program_studi.nama_prodi`.

**Query SQL**

```sql
SELECT COUNT(*) AS jumlah_prodi_tidak_ditemukan
FROM src.mahasiswa m
WHERE m.prodi_raw IS NOT NULL
  AND BTRIM(m.prodi_raw) <> ''
  AND NOT EXISTS (
      SELECT 1
      FROM src.program_studi p
      WHERE p.nama_prodi = m.prodi_raw
```

**Hasil eksekusi**

![Gambar 43. Soal 11 – Nama program studi tidak sesuai standar](gambar/unit-1.2_19.png)


**Interpretasi**

Dari hasil pemeriksaan, sebanyak 435 record mahasiswa memiliki nama program studi yang tidak sama persis dengan data pada tabel referensi. Jumlah tersebut mencakup sekitar 22,1% dari keseluruhan data mahasiswa. Ketidaksesuaian dapat terjadi karena penggunaan singkatan, perbedaan kapitalisasi, penambahan spasi, atau variasi nama lainnya. Oleh sebab itu, diperlukan pencocokan lebih lanjut untuk memastikan setiap variasi penulisan dapat dihubungkan dengan program studi yang benar.

## 3.10 Soal 12 — Variasi format tanggal masuk

**Tujuan pemeriksaan**  
Mengelompokkan `tanggal_masuk_raw` berdasarkan format `YYYY-MM-DD`, `DD/MM/YYYY`, `DD-Mon-YYYY`, dan `OTHER`.

**Query SQL**

```sql
WITH klasifikasi AS (
    SELECT
        CASE
            WHEN tanggal_masuk_raw ~ '^\d{4}-\d{2}-\d{2}$'        THEN 'YYYY-MM-DD'
            WHEN tanggal_masuk_raw ~ '^\d{2}/\d{2}/\d{4}$'        THEN 'DD/MM/YYYY'
            WHEN tanggal_masuk_raw ~ '^\d{2}-[A-Za-z]{3}-\d{4}$'   THEN 'DD-Mon-YYYY'
            ELSE 'OTHER'
        END AS format_tanggal
    FROM src.mahasiswa
)
SELECT
    f.format_tanggal,
    COUNT(k.format_tanggal) AS jumlah_record
FROM (VALUES ('YYYY-MM-DD'), ('DD/MM/YYYY'), ('DD-Mon-YYYY'), ('OTHER')) AS f(format_tanggal)
LEFT JOIN klasifikasi k ON k.format_tanggal = f.format_tanggal
GROUP BY f.format_tanggal
ORDER BY jumlah_record DESC;
```

**Hasil eksekusi**

![Gambar 44. Soal 12 – Variasi format tanggal masuk](gambar/unit-1.2_20.png)


**Interpretasi**

Hasil klasifikasi menunjukkan bahwa sebagian besar data tanggal masuk menggunakan format YYYY-MM-DD, yaitu sebanyak 1.429 record atau sekitar 72,7%. Sementara itu, format DD/MM/YYYY ditemukan sebanyak 346 record dan DD-Mon-YYYY sebanyak 190 record. Tidak ditemukan data yang termasuk kategori OTHER. Meskipun seluruh data mengikuti salah satu pola yang diperiksa, penggunaan beberapa format sekaligus dapat menyulitkan proses pengolahan tanggal. Selain itu, kesesuaian pola belum menjamin bahwa tanggal tersebut benar-benar valid.

---

# 4. Profiling Tabel KRS

## 4.1 Soal 13 — Jumlah record KRS vs krs_id unik

**Tujuan pemeriksaan**  
Membandingkan jumlah seluruh record KRS dengan jumlah `krs_id` yang unik.

**Query SQL**

```sql
SELECT
    COUNT(*) AS jumlah_seluruh_record_krs,
    COUNT(DISTINCT krs_id) AS jumlah_krs_id_unik
FROM src.krs;
```

**Hasil eksekusi**

![Gambar 45. Soal 13 – Record KRS vs krs_id unik](gambar/unit-1.2_21.png)

**Interpretasi**

Berdasarkan hasil perhitungan, tabel KRS mempunyai 57.025 record dengan jumlah krs_id unik sebanyak 57.000. Terdapat perbedaan sebanyak 25 record antara kedua jumlah tersebut. Hal ini menjadi indikasi bahwa beberapa ID KRS digunakan pada lebih dari satu baris. Dengan demikian, keunikan identitas record pada tabel KRS masih perlu diperiksa lebih lanjut.


## 4.2 Soal 14 — Duplikasi pengambilan mata kuliah (nim, kode_mk, semester_id)

**Tujuan pemeriksaan**  
Menemukan kombinasi `nim`, `kode_mk`, dan `semester_id` yang muncul lebih dari satu kali pada tabel KRS.

**Query SQL**

```sql
SELECT nim, kode_mk, semester_id, COUNT(*) AS jumlah_kemunculan
FROM src.krs
GROUP BY nim, kode_mk, semester_id
HAVING COUNT(*) > 1
ORDER BY jumlah_kemunculan DESC, nim, kode_mk, semester_id;
```

**Hasil eksekusi**

![Gambar 46. Soal 14 – Duplikasi pengambilan mata kuliah (bagian 1 dari 3)](gambar/unit-1.2_22.png)

![Gambar 47. Soal 14 – Duplikasi pengambilan mata kuliah (bagian 2 dari 3)](gambar/unit-1.2_23.png)

![Gambar 48. Soal 14 – Duplikasi pengambilan mata kuliah (bagian 3 dari 3)](gambar/unit-1.2_24.png)


Hasil query menampilkan **25 kombinasi** `nim + kode_mk + semester_id`, masing-masing dengan `jumlah` = 2.


**Interpretasi**

Hasil pengelompokan data menemukan 25 kombinasi NIM, kode mata kuliah, dan semester yang muncul sebanyak dua kali. Setelah diperiksa, baris-baris tersebut memiliki atribut yang sama, termasuk nilai krs_id. Kondisi ini menunjukkan adanya indikasi penggandaan data yang identik. Jika digunakan langsung dalam analisis, data tersebut berpotensi menyebabkan jumlah peserta mata kuliah dan perhitungan SKS menjadi lebih besar dari kondisi sebenarnya.

## 4.3 Soal 15 — Kelebihan record KRS akibat duplikasi

**Tujuan pemeriksaan**  
Menghitung total record yang melebihi satu record pada setiap kelompok duplikat.

**Query SQL**

```sql
SELECT COALESCE(SUM(jumlah_kemunculan - 1), 0) AS total_kelebihan_record_duplikat
FROM (
    SELECT COUNT(*) AS jumlah_kemunculan
    FROM src.krs
    GROUP BY nim, kode_mk, semester_id
    HAVING COUNT(*) > 1
) AS kelompok_duplikat;
```

**Hasil eksekusi**

![Gambar 49. Soal 15 – Kelebihan record KRS akibat duplikasi](gambar/unit-1.2_25.png)


**Interpretasi**

Berdasarkan hasil perhitungan, terdapat 25 record tambahan yang berasal dari kelompok data duplikat. Setiap kelompok memiliki dua baris, sehingga hanya satu baris yang menjadi kelebihan pada masing-masing kelompok. Hasil ini sesuai dengan selisih jumlah seluruh record KRS dan jumlah krs_id unik pada pemeriksaan sebelumnya. Kedua pemeriksaan tersebut memberikan hasil yang saling mendukung mengenai adanya duplikasi pada tabel KRS.

---

# 5. Profiling Tabel Nilai

## 5.1 Soal 16 — Nilai angka kosong

**Tujuan pemeriksaan**  
Menghitung record dengan `nilai_angka` kosong, `NULL`, atau hanya berisi spasi.

**Query SQL**

```sql
SELECT COUNT(*) AS jumlah_nilai_angka_kosong
FROM src.nilai
WHERE nilai_angka IS NULL;
```

**Hasil eksekusi**

![Gambar 50. Soal 16 – Nilai angka kosong](gambar/unit-1.2_26.png)


**Interpretasi**

Hasil query memperlihatkan bahwa terdapat 20 record pada tabel nilai yang tidak mempunyai nilai angka. Pada baris yang sama, atribut nilai huruf juga tidak terisi. Data tersebut menunjukkan adanya informasi hasil penilaian yang belum lengkap. Apabila digunakan untuk menghitung rata-rata atau indikator akademik lainnya, record tersebut perlu diperlakukan secara khusus agar tidak memengaruhi hasil analisis.

## 5.2 Soal 17 — Nilai angka di luar rentang 0-100

**Tujuan pemeriksaan**  
Menghitung nilai angka di luar rentang 0–100 (nilai kosong tidak dihitung).

**Query SQL**

```sql
SELECT COUNT(*) AS jumlah_nilai_di_luar_rentang
FROM src.nilai
WHERE nilai_angka IS NOT NULL
  AND (nilai_angka < 0 OR nilai_angka > 100);
```

**Hasil eksekusi**

![Gambar 51. Soal 17 – Nilai angka di luar rentang 0–100](gambar/unit-1.2_27.png)


**Interpretasi**

Ditemukan 12 record yang memiliki nilai angka di luar batas penilaian 0 sampai 100. Rinciannya terdiri atas enam nilai negatif dan enam nilai yang melebihi 100. Nilai paling rendah adalah -18, sedangkan nilai paling tinggi mencapai 106. Kondisi tersebut tidak sesuai dengan aturan rentang nilai yang digunakan sehingga perlu ditelusuri untuk mengetahui apakah terjadi kesalahan pencatatan atau faktor lainnya.


## 5.3 Soal 18 — Statistik deskriptif nilai valid

**Tujuan pemeriksaan**  
Menghitung jumlah nilai valid, minimum, maksimum, dan rata-rata untuk nilai angka dalam rentang 0–100.

**Query SQL**

```sql
SELECT
    COUNT(*) AS jumlah_record_nilai_valid,
    MIN(nilai_angka) AS nilai_terendah,
    MAX(nilai_angka) AS nilai_tertinggi,
    AVG(nilai_angka) AS nilai_rata_rata
FROM src.nilai
WHERE nilai_angka BETWEEN 0 AND 100;
```

**Hasil eksekusi**

![Gambar 52. Soal 18 – Statistik deskriptif nilai valid (bagian 1 dari 2)](gambar/unit-1.2_28.png)

![Gambar 53. Soal 18 – Statistik deskriptif nilai valid (bagian 2 dari 2)](gambar/unit-1.2_29.png)


Jumlah valid = 57.000 − 20 (kosong) − 12 (di luar rentang 0–100) = 56.968. Sebagai pembanding, tanpa filter rentang nilai berkisar −18 sampai 106 (rata-rata 77,39) sehingga outlier memperlebar rentang.

**Interpretasi**

Setelah hanya mengambil nilai dalam rentang 0–100, diperoleh 56.968 record yang memenuhi kriteria valid. Nilai terendah yang ditemukan adalah 34,8 dan nilai tertinggi mencapai 100,0, dengan rata-rata sebesar 77,40. Hasil tersebut memberikan gambaran umum mengenai persebaran nilai mahasiswa. Jika dibandingkan dengan rata-rata tanpa penyaringan, perbedaannya sangat kecil karena jumlah nilai yang berada di luar rentang relatif sedikit.

## 5.4 Soal 19 — Konsistensi nilai angka dan nilai huruf

**Tujuan pemeriksaan**  
Menghitung record dengan ketidaksesuaian antara `nilai_angka` dan `nilai_huruf` berdasarkan aturan konversi pada soal.

**Query SQL**

```sql
WITH nilai_valid AS (
    SELECT
        nilai_id,
        NULLIF(TRIM(nilai_angka::text), '')::numeric AS angka,
        TRIM(nilai_huruf) AS huruf
    FROM src.nilai
)
SELECT COUNT(*) AS letter_mismatch FROM nilai_valid
WHERE angka BETWEEN 0 AND 100
  AND huruf IS DISTINCT FROM CASE
        WHEN angka >= 85 THEN 'A'
        WHEN angka >= 80 THEN 'AB'
        WHEN angka >= 75 THEN 'B'
        WHEN angka >= 70 THEN 'BC'
        WHEN angka >= 60 THEN 'C'
        WHEN angka >= 50 THEN 'D'
        ELSE 'E'
      END;
```

**Hasil eksekusi**

![Gambar 54. Soal 19 – Konsistensi nilai angka dan nilai huruf](gambar/unit-1.2_30.png)


**Interpretasi**

Pemeriksaan menggunakan aturan konversi nilai menunjukkan adanya 20 record yang memiliki perbedaan antara nilai angka dan nilai huruf. Sebagai contoh, nilai 68,2 seharusnya masuk kategori C, tetapi tercatat D. Contoh lainnya adalah nilai 82,8 yang tercatat B, padahal berdasarkan aturan pemeriksaan seharusnya AB. Temuan ini menunjukkan bahwa hubungan antara nilai angka dan nilai huruf belum sepenuhnya konsisten dan perlu dibandingkan kembali dengan ketentuan penilaian resmi.

## 5.5 Soal 20 — Konsistensi nilai angka dan status kelulusan

**Tujuan pemeriksaan**  
Menghitung record dengan ketidaksesuaian antara `nilai_angka` dan `status_lulus` (≥ 60 = Lulus, < 60 = Tidak Lulus).

**Query SQL**

```sql
WITH nilai_valid AS (
    SELECT
        NULLIF(TRIM(nilai_angka::text), '')::numeric AS angka,
        TRIM(status_lulus) AS status_lulus
    FROM src.nilai
)
SELECT COUNT(*) AS status_mismatch
FROM nilai_valid
WHERE angka BETWEEN 0 AND 100
  AND ( (angka >= 60 AND status_lulus IS DISTINCT FROM 'Lulus')
     OR (angka <  60 AND status_lulus IS DISTINCT FROM 'Tidak Lulus') );
```

**Hasil eksekusi**

![Gambar 55. Soal 20 – Konsistensi nilai angka dan status kelulusan](gambar/unit-1.2_31.png)


Sebagai pembanding, pemeriksaan **nilai_huruf vs status_lulus** pada profiling awal menemukan 17 record tidak konsisten. Pemeriksaan tersebut berbasis huruf sehingga berbeda dengan soal ini yang berbasis nilai angka.

**Interpretasi**

Hasil pemeriksaan menghasilkan angka 0, yang berarti tidak ditemukan record dengan status kelulusan yang bertentangan dengan nilai angkanya pada rentang valid. Seluruh data dengan nilai minimal 60 memiliki status Lulus, sedangkan nilai di bawah 60 tercatat Tidak Lulus. Hal ini menunjukkan bahwa atribut status kelulusan sudah sesuai dengan aturan yang digunakan dalam pemeriksaan. Namun, hasil tersebut belum membuktikan bahwa seluruh atribut penilaian sudah benar karena masih terdapat ketidaksesuaian pada nilai huruf.

## 5.6 Soal 21 — Duplikasi record nilai

**Tujuan pemeriksaan**  
Menampilkan kombinasi `nim`, `kode_mk`, `semester_id` yang tercatat lebih dari satu kali pada tabel nilai.

**Query SQL**

```sql
SELECT nim, kode_mk, semester_id, COUNT(*) AS jumlah_kemunculan
FROM src.nilai
GROUP BY nim, kode_mk, semester_id
HAVING COUNT(*) > 1
ORDER BY jumlah_kemunculan DESC, nim, kode_mk, semester_id;
```

**Hasil eksekusi**

![Gambar 56. Soal 21 – Duplikasi record nilai](gambar/unit-1.2_32.png)


Query menghasilkan **0 baris** (tidak ada kombinasi yang muncul lebih dari satu kali).

**Interpretasi**

Tidak ditemukan duplikasi pada tabel `nilai`: 57.000 record dengan 57.000 `nilai_id` unik, dan kombinasi `nim + kode_mk + semester_id` juga unik. Hasil nol tetap dicatat sebagai bukti bahwa key kandidat valid dan tidak ada indikasi nilai revisi ganda.

---

# 6. Pemeriksaan Referential Integrity pada KRS dan Nilai

## 6.1 Soal 22 — NIM KRS tidak terdaftar di mahasiswa

**Tujuan pemeriksaan**  
Menghitung record yang NIM pada tabel KRS tidak ditemukan pada tabel referensinya.

**Query SQL**

```sql
SELECT COUNT(*) AS krs_nim_tidak_terdaftar
FROM src.krs k
LEFT JOIN src.mahasiswa m ON k.nim = m.nim
WHERE m.nim IS NULL;
```

**Hasil eksekusi**

![Gambar 57. Soal 22 – NIM KRS tidak terdaftar](gambar/unit-1.2_33.png)


**Interpretasi**

Hasil pemeriksaan menghasilkan 0 record yang tidak memiliki pasangan pada tabel mahasiswa. Artinya, seluruh NIM yang digunakan dalam tabel KRS dapat ditemukan pada tabel induknya. Kondisi ini menunjukkan bahwa hubungan data mahasiswa dengan KRS sudah sesuai berdasarkan atribut NIM. Tidak ditemukan data yatim yang dapat menghambat proses penggabungan kedua tabel.


## 6.2 Soal 23 — NIM nilai tidak terdaftar di mahasiswa

**Tujuan pemeriksaan**  
Menghitung record yang NIM pada tabel nilai tidak ditemukan pada tabel referensinya.

**Query SQL**

```sql
SELECT COUNT(*) AS nim_tidak_terdaftar
FROM src.nilai n
LEFT JOIN src.mahasiswa m ON n.nim = m.nim
WHERE m.nim IS NULL;
```

**Hasil eksekusi**

![Gambar 58. Soal 23 – NIM nilai tidak terdaftar](gambar/unit-1.2_34.png)


**Interpretasi**

Hasilnya **0**: seluruh NIM pada tabel nilai memiliki pasangan pada tabel referensi. Tidak ditemukan record yatim (orphan) sehingga join aman. Integritas referensial pada relasi ini terpenuhi pada pemeriksaan ini.

## 6.3 Soal 24 — Kode MK nilai tidak ada di mata_kuliah

**Tujuan pemeriksaan**  
Menghitung record yang `kode_mk` pada tabel nilai tidak ditemukan pada tabel referensinya.

**Query SQL**

```sql
SELECT COUNT(*) AS orphan_nilai_mk
FROM src.nilai n
LEFT JOIN src.mata_kuliah mk ON n.kode_mk = mk.kode_mk
WHERE mk.kode_mk IS NULL;
```

**Hasil eksekusi**

![Gambar 59. Soal 24 – Kode MK nilai tidak terdaftar](gambar/unit-1.2_35.png)


**Interpretasi**

Hasilnya **0**: seluruh `kode_mk` pada tabel nilai memiliki pasangan pada tabel referensi. Tidak ditemukan record yatim (orphan) sehingga join aman. Integritas referensial pada relasi ini terpenuhi pada pemeriksaan ini.

## 6.4 Soal 25 — Semester nilai tidak ada di semester

**Tujuan pemeriksaan**  
Menghitung record yang `semester_id` pada tabel nilai tidak ditemukan pada tabel referensinya.

**Query SQL**

```sql
SELECT COUNT(*) AS orphan_nilai_semester
FROM src.nilai n
LEFT JOIN src.semester s ON n.semester_id = s.semester_id
WHERE s.semester_id IS NULL;
```

**Hasil eksekusi**

![Gambar 60. Soal 25 – Semester nilai tidak terdaftar](gambar/unit-1.2_36.png)


**Interpretasi**

Hasilnya **0**: seluruh `semester_id` pada tabel nilai memiliki pasangan pada tabel referensi. Tidak ditemukan record yatim (orphan) sehingga join aman. Integritas referensial pada relasi ini terpenuhi pada pemeriksaan ini.

---

# 7. Profiling Aktivitas LMS

## 7.1 Soal 26 — Duplikasi aktivitas LMS (lms_event_id)

**Tujuan pemeriksaan**  
Membandingkan jumlah seluruh record aktivitas LMS dengan jumlah `lms_event_id` unik.

**Query SQL**

```sql
SELECT
    COUNT(*)                          AS raw_rows,
    COUNT(DISTINCT lms_event_id)      AS distinct_event_id,
    COUNT(*) - COUNT(DISTINCT lms_event_id) AS duplicate_excess
FROM src.aktivitas_lms;
```

**Hasil eksekusi**

![Gambar 61. Soal 26 – Duplikasi aktivitas LMS](gambar/unit-1.2_37.png)


**Interpretasi**

Hasil perbandingan menunjukkan terdapat 30 record lebih banyak dibandingkan jumlah lms_event_id yang berbeda. Berdasarkan pemeriksaan lanjutan, seluruh record tambahan tersebut memiliki isi yang sama dengan baris lainnya. Hal ini mengindikasikan adanya duplikasi identik pada aktivitas LMS. Jika tidak diperhatikan, data tersebut dapat menyebabkan jumlah aktivitas dan perhitungan durasi penggunaan LMS menjadi lebih tinggi.

## 7.2 Soal 27 — Distribusi tipe aktivitas LMS

**Tujuan pemeriksaan**  
Menampilkan setiap `tipe_event` dan jumlah aktivitas pada masing-masing tipe.

**Query SQL**

```sql
SELECT
    tipe_event,
    COUNT(*) AS jumlah
FROM src.aktivitas_lms
GROUP BY tipe_event
ORDER BY jumlah DESC, tipe_event;
```

**Hasil eksekusi**

![Gambar 62. Soal 27 – Distribusi tipe aktivitas LMS](gambar/unit-1.2_38.png)


**Interpretasi**

Hasil pengelompokan menunjukkan bahwa aktivitas LMS terdiri atas lima jenis event. Aktivitas yang paling sering dilakukan adalah view_material dengan jumlah 56.040 record, sedangkan forum_post merupakan aktivitas dengan jumlah paling sedikit, yaitu 10.000 record. Tidak ditemukan perbedaan penulisan pada label tipe aktivitas. Komposisi ini memperlihatkan bahwa aktivitas membuka materi lebih banyak tercatat dibandingkan aktivitas berpartisipasi dalam forum.


## 7.3 Soal 28 — Skor kuis kosong pada quiz_attempt

**Tujuan pemeriksaan**  
Menghitung aktivitas `quiz_attempt` yang tidak memiliki skor pada `skor_kuis`.

**Query SQL**

```sql
SELECT COUNT(*) AS quiz_missing_score
FROM src.aktivitas_lms
WHERE tipe_event = 'quiz_attempt'
  AND (skor_kuis IS NULL OR TRIM(skor_kuis::text) = '');
```

**Hasil eksekusi**

![Gambar 63. Soal 28 – Skor kuis kosong pada quiz_attempt](gambar/unit-1.2_39.png)


**Interpretasi**

Hasil pemeriksaan menunjukkan bahwa tidak ada aktivitas quiz_attempt yang memiliki skor kuis kosong. Dengan kata lain, seluruh 40.321 record percobaan kuis telah dilengkapi informasi skor. Hal ini menunjukkan bahwa kelengkapan atribut skor pada jenis aktivitas tersebut sudah terpenuhi sehingga data dapat digunakan untuk analisis hasil kuis.


## 7.4 Soal 29 — Skor pada aktivitas selain kuis

**Tujuan pemeriksaan**  
Menghitung aktivitas selain `quiz_attempt` yang tetap memiliki nilai pada `skor_kuis`.

**Query SQL**

```sql
SELECT COUNT(*) AS nonquiz_with_score
FROM src.aktivitas_lms
WHERE tipe_event <> 'quiz_attempt'
  AND skor_kuis IS NOT NULL
  AND TRIM(skor_kuis::text) <> '';
```

**Hasil eksekusi**

![Gambar 64. Soal 29 – Skor pada aktivitas selain kuis](gambar/unit-1.2_40.png)


**Interpretasi**

Hasilnya **0**. Hal ini konsisten dengan profiling kolom: `skor_kuis` kosong pada 160.035 record, yang sama dengan total aktivitas non-kuis (56.040 + 50.136 + 43.859 + 10.000). Jadi skor hanya terisi pada `quiz_attempt` sesuai rancangan.

---

# 8. Profiling Tabel Pembayaran

## 8.1 Soal 30 — Nominal pembayaran negatif

**Tujuan pemeriksaan**  
Menghitung record pembayaran dengan `nominal_bayar` kurang dari nol.

**Query SQL**

```sql
SELECT COUNT(*) AS negative_payment
FROM src.pembayaran
WHERE nominal_bayar < 0;
```

**Hasil eksekusi**

![Gambar 65. Soal 30 – Nominal pembayaran negatif](gambar/unit-1.2_41.png)


**Interpretasi**

Ditemukan **5 record** bernominal negatif (nilai minimum −5.750.000), semuanya berstatus Lunas. Contoh: `PAY0001112` (tagihan 5.750.000, bayar −5.750.000). Transaksi ini perlu ditelusuri sesuai konteks pencatatan keuangan (apakah koreksi/refund atau kesalahan input) karena dapat membuat total pembayaran dan piutang salah hitung.

## 8.2 Soal 31 — Pembayaran positif tanpa tanggal bayar

**Tujuan pemeriksaan**  
Menghitung pembayaran bernominal positif tetapi `tanggal_bayar_raw` kosong.

**Query SQL**

```sql
SELECT COUNT(*) AS positive_payment_missing_date
FROM src.pembayaran
WHERE nominal_bayar > 0
  AND (tanggal_bayar_raw IS NULL OR TRIM(tanggal_bayar_raw) = '');
```

**Hasil eksekusi**

![Gambar 66. Soal 31 – Pembayaran positif tanpa tanggal bayar](gambar/unit-1.2_42.png)


**Interpretasi**

Hasil query menemukan 12 transaksi dengan nominal pembayaran positif tetapi tidak memiliki tanggal pembayaran. Dari jumlah tersebut, 10 transaksi berstatus Lunas dan dua lainnya berstatus Cicilan. Sementara itu, sebagian besar tanggal pembayaran yang kosong berasal dari transaksi Belum Lunas. Kondisi pada 12 transaksi tersebut perlu dikonfirmasi karena tanggal pembayaran merupakan informasi penting untuk mengetahui waktu terjadinya transaksi.

## 8.3 Soal 32 — Distribusi status pembayaran

**Tujuan pemeriksaan**  
Menampilkan jumlah record berdasarkan setiap nilai `status_pembayaran`.

**Query SQL**

```sql
SELECT status_pembayaran, COUNT(*) AS jumlah_record
FROM src.pembayaran
GROUP BY status_pembayaran
ORDER BY jumlah DESC, status_pembayaran;
```

**Hasil eksekusi**

![Gambar 67. Soal 32 – Distribusi status pembayaran](gambar/unit-1.2_43.png)


**Interpretasi**

Berdasarkan hasil pengelompokan, terdapat tiga kategori status pembayaran. Status Lunas menjadi kategori terbanyak dengan 7.962 record atau sekitar 83,8% dari total transaksi. Selanjutnya, terdapat 1.077 transaksi berstatus Cicilan dan 461 transaksi berstatus Belum Lunas. Hasil tersebut menunjukkan bahwa sebagian besar transaksi sudah diselesaikan, sedangkan sisanya masih dalam proses pembayaran atau belum dibayarkan.


---

# 9. Profiling Tabel Kelulusan

## 9.1 Soal 33 — Duplikasi data kelulusan

**Tujuan pemeriksaan**  
Membandingkan jumlah seluruh record kelulusan dengan jumlah NIM unik.

**Query SQL**

```sql
SELECT
    COUNT(*)                         AS raw_rows,
    COUNT(DISTINCT nim)              AS distinct_graduate_nim,
    COUNT(*) - COUNT(DISTINCT nim)   AS duplicate_excess
FROM src.kelulusan;
```

**Hasil eksekusi**

![Gambar 68. Soal 33 – Duplikasi data kelulusan](gambar/unit-1.2_44.png)


**Interpretasi**

Ada 2 NIM yang tercatat dua kali (contoh: `21SI0036` dan `21BD0005`); kedua baris identik penuh sehingga terindikasi duplikat persis. Konteks bisnis juga mendukung: satu mahasiswa seharusnya hanya lulus satu kali. Duplikasi ini dapat membuat jumlah lulusan dan rata-rata IPK bias.

## 9.2 Soal 34 — Status kelulusan tepat waktu

**Tujuan pemeriksaan**  
Menampilkan jumlah record berdasarkan setiap nilai `status_tepat_waktu`.

**Query SQL**

```sql
SELECT status_tepat_waktu, COUNT(*) AS jumlah_mahasiswa
FROM src.kelulusan
GROUP BY status_tepat_waktu
ORDER BY jumlah_mahasiswa DESC, status_tepat_waktu;
```

**Hasil eksekusi**

![Gambar 69. Soal 34 – Status kelulusan tepat waktu](gambar/unit-1.2_45.png)


**Interpretasi**

Seluruh 347 record kelulusan berstatus `Ya` (tepat waktu); tidak ada kategori tidak tepat waktu. Setelah dikurangi 2 baris duplikat (Soal 33), 345 mahasiswa unik semuanya tercatat tepat waktu (100%). Catatan pendukung: seluruh lulusan berasal dari angkatan 2021 dengan masa studi 46–47 bulan (308 orang 46 bulan, 39 orang 47 bulan). Karena hanya ada satu kategori, perbandingan tepat waktu vs tidak tepat waktu belum dapat dilakukan; hal ini perlu dikonfirmasi apakah mahasiswa terlambat memang belum lulus atau datanya tidak tercatat.

---

# 10. Pemeriksaan Relasi Antar-Tabel

## 10.1 Soal 35 — Aktivitas LMS dengan NIM tidak terdaftar

**Tujuan pemeriksaan**  
Menghitung record yang NIM pada aktivitas LMS tidak ditemukan pada tabel referensinya.

**Query SQL**

```sql
SELECT COUNT(*) AS orphan_lms_student
FROM src.aktivitas_lms a
LEFT JOIN src.mahasiswa m ON a.nim = m.nim
WHERE m.nim IS NULL;
```

**Hasil eksekusi**

![Gambar 70. Soal 35 – Aktivitas LMS dengan NIM tidak terdaftar](gambar/unit-1.2_46.png)


**Interpretasi**

Hasilnya **0**: seluruh NIM pada aktivitas LMS dapat dihubungkan dengan tabel induknya. Tidak ada orphan, sehingga relasi ini aman digunakan untuk join pada tahap berikutnya.

## 10.2 Soal 36 — Aktivitas LMS dengan kode MK tidak terdaftar

**Tujuan pemeriksaan**  
Menghitung record yang `kode_mk` pada aktivitas LMS tidak ditemukan pada tabel referensinya.

**Query SQL**

```sql
SELECT COUNT(*) AS orphan_lms_course
FROM src.aktivitas_lms a
LEFT JOIN src.mata_kuliah mk ON a.kode_mk = mk.kode_mk
WHERE mk.kode_mk IS NULL;
```

**Hasil eksekusi**

![Gambar 71. Soal 36 – Aktivitas LMS dengan kode MK tidak terdaftar](gambar/unit-1.2_47.png)


**Interpretasi**

Hasilnya **0**: seluruh `kode_mk` pada aktivitas LMS dapat dihubungkan dengan tabel induknya. Tidak ada orphan, sehingga relasi ini aman digunakan untuk join pada tahap berikutnya.

## 10.3 Soal 37 — Pembayaran dengan NIM tidak terdaftar

**Tujuan pemeriksaan**  
Menghitung record yang NIM pada pembayaran tidak ditemukan pada tabel referensinya.

**Query SQL**

```sql
SELECT COUNT(*) AS orphan_payment_student
FROM src.pembayaran p
LEFT JOIN src.mahasiswa m ON p.nim = m.nim
WHERE m.nim IS NULL;
```

**Hasil eksekusi**

![Gambar 72. Soal 37 – Pembayaran dengan NIM tidak terdaftar](gambar/unit-1.2_48.png)


**Interpretasi**

Hasilnya **0**: seluruh NIM pada pembayaran dapat dihubungkan dengan tabel induknya. Tidak ada orphan, sehingga relasi ini aman digunakan untuk join pada tahap berikutnya.

## 10.4 Soal 38 — Kelulusan dengan NIM tidak terdaftar

**Tujuan pemeriksaan**  
Menghitung record yang NIM pada kelulusan tidak ditemukan pada tabel referensinya.

**Query SQL**

```sql
SELECT COUNT(*) AS orphan_graduation_student
FROM src.kelulusan k
LEFT JOIN src.mahasiswa m ON k.nim = m.nim
WHERE m.nim IS NULL;
```

**Hasil eksekusi**

![Gambar 73. Soal 38 – Kelulusan dengan NIM tidak terdaftar](gambar/unit-1.2_49.png)


**Interpretasi**

Hasilnya **0**: seluruh NIM pada kelulusan dapat dihubungkan dengan tabel induknya. Tidak ada orphan, sehingga relasi ini aman digunakan untuk join pada tahap berikutnya.

---

---

# 11. Rekapitulasi Hasil Data Profiling dan Data Quality

| No. | Area Pemeriksaan | Indikator | Hasil | Status | Catatan Temuan |
|---:|---|---|---:|---|---|
| 1 | Dataset | Jumlah record setiap tabel | 10 tabel; terbesar `aktivitas_lms` 200.356 | Tidak ditemukan masalah | Tabel transaksi jauh lebih besar dari master/referensi |
| 2 | Dataset | Jumlah kolom setiap tabel | 5–11 kolom | Tidak ditemukan masalah | Struktur sesuai definisi source |
| 3 | Mahasiswa | Kelebihan record berdasarkan NIM | 15 | Perlu pemeriksaan | 1.965 baris vs 1.950 NIM unik; duplikat persis |
| 4 | Mahasiswa | Kelompok NIM duplikat | 15 | Perlu pemeriksaan | Masing-masing muncul 2 kali |
| 5 | Mahasiswa | Kota asal kosong | 30 (1,53%) | Perlu pemeriksaan | Sebaran wilayah tidak lengkap |
| 6 | Mahasiswa | Variasi label program studi | 30 label (6 resmi) | Perlu pemeriksaan | 24 label non-canonical; perlu mapping |
| 7 | Mahasiswa | Variasi label jenis kelamin | 6 label (2 konsep) | Perlu pemeriksaan | L, P, Laki-laki, Perempuan, M, F |
| 8 | Mahasiswa | Program studi tidak cocok dengan referensi | 435 (22,1%) | Perlu pemeriksaan | Singkatan, kapitalisasi, penulisan lain |
| 9 | Mahasiswa | Variasi format tanggal masuk | 3 format; OTHER 0 | Perlu pemeriksaan | 1.429 / 346 / 190 record |
| 10 | KRS | Kelebihan record berdasarkan KRS ID | 25 | Perlu pemeriksaan | 57.025 baris vs 57.000 `krs_id` unik |
| 11 | KRS | Duplikasi kombinasi NIM–MK–semester | 25 kombinasi | Perlu pemeriksaan | Identik penuh; muncul 2 kali |
| 12 | Nilai | Nilai angka kosong | 20 | Perlu pemeriksaan | `nilai_huruf` juga kosong pada baris yang sama |
| 13 | Nilai | Nilai angka di luar rentang | 12 | Perlu pemeriksaan | 6 negatif, 6 > 100 |
| 14 | Nilai | Statistik nilai valid | 56.968 valid; min 34,8; maks 100,0; rata-rata 77,40 | Tidak ditemukan masalah | Deskriptif; rentang valid 0–100 |
| 15 | Nilai | Ketidaksesuaian nilai angka dan huruf | 20 | Perlu pemeriksaan | Skala konversi pada soal |
| 16 | Nilai | Ketidaksesuaian nilai dan status lulus | 0 | Tidak ditemukan masalah | Berbasis nilai angka valid; pembanding huruf vs status = 17 |
| 17 | Nilai | Duplikasi kombinasi NIM–MK–semester | 0 | Tidak ditemukan masalah | Key unik |
| 18 | Referential integrity | NIM KRS tidak terdaftar | 0 | Tidak ditemukan masalah | Relasi aman |
| 19 | Referential integrity | NIM nilai tidak terdaftar | 0 | Tidak ditemukan masalah | Relasi aman |
| 20 | Referential integrity | Kode MK nilai tidak terdaftar | 0 | Tidak ditemukan masalah | Relasi aman |
| 21 | Referential integrity | Semester nilai tidak terdaftar | 0 | Tidak ditemukan masalah | Relasi aman |
| 22 | LMS | Kelebihan record berdasarkan event ID | 30 | Perlu pemeriksaan | 200.356 vs 200.326 unik; duplikat persis |
| 23 | LMS | Distribusi tipe aktivitas | 5 tipe | Tidak ditemukan masalah | Label bersih |
| 24 | LMS | Skor kuis kosong | 0 | Tidak ditemukan masalah | Seluruh `quiz_attempt` memiliki skor |
| 25 | LMS | Skor pada aktivitas non-kuis | 0 | Tidak ditemukan masalah | Sesuai rancangan |
| 26 | Pembayaran | Nominal pembayaran negatif | 5 | Perlu pemeriksaan | Semua berstatus Lunas |
| 27 | Pembayaran | Pembayaran positif tanpa tanggal | 12 | Perlu pemeriksaan | 10 Lunas + 2 Cicilan |
| 28 | Pembayaran | Distribusi status pembayaran | 3 status | Tidak ditemukan masalah | Lunas 7.962; Cicilan 1.077; Belum Lunas 461 |
| 29 | Kelulusan | Kelebihan record berdasarkan NIM | 2 | Perlu pemeriksaan | 347 baris vs 345 NIM unik |
| 30 | Kelulusan | Distribusi status tepat waktu | Ya = 347; kategori lain = 0 | Perlu pemeriksaan | Hanya satu kategori; perbandingan tepat vs terlambat belum bisa dilakukan |
| 31 | Relasi LMS | NIM aktivitas LMS tidak terdaftar | 0 | Tidak ditemukan masalah | Relasi aman |
| 32 | Relasi LMS | Kode MK aktivitas LMS tidak terdaftar | 0 | Tidak ditemukan masalah | Relasi aman |
| 33 | Relasi pembayaran | NIM pembayaran tidak terdaftar | 0 | Tidak ditemukan masalah | Relasi aman |
| 34 | Relasi kelulusan | NIM kelulusan tidak terdaftar | 0 | Tidak ditemukan masalah | Relasi aman |

---

**Catatan validasi:** angka pada tabel hasil dan interpretasi harus sama dengan keluaran query yang benar-benar dijalankan pada database praktikum. Jika hasil aktual berbeda, perbarui angka dan interpretasi terkait; jangan mempertahankan angka contoh.

# 12. Kesimpulan Praktikum

1. **Gambaran umum struktur dan ukuran dataset.**
  Dataset akademik UADW v1.0 terdiri dari beberapa tabel yang saling berhubungan, antara lain mahasiswa, KRS, nilai, program studi, semester, aktivitas LMS, pembayaran, dan kelulusan. Setiap tabel memiliki jumlah record dan atribut yang berbeda. Tabel aktivitas LMS memiliki jumlah data terbesar, yaitu 200.356 baris, sedangkan tabel program studi memiliki jumlah paling sedikit, yaitu 6 baris. Secara umum, struktur dataset sudah mendukung penyimpanan informasi akademik, tetapi masih ditemukan beberapa kondisi yang perlu diperiksa dari sisi kualitas data.

2. **Aspek kualitas data yang menunjukkan indikasi masalah.**
   Hasil pemeriksaan menunjukkan adanya beberapa masalah kualitas data, yaitu duplikasi record, nilai kosong (missing value), format data yang tidak seragam, perbedaan penulisan kategori, serta nilai yang tidak sesuai dengan rentang yang seharusnya. Contohnya, tabel mahasiswa memiliki 15 kelompok NIM duplikat dan 30 data kota yang kosong. Pada tabel nilai ditemukan 20 nilai numerik kosong dan 12 nilai di luar rentang 0–100. Selain itu, terdapat ketidaksesuaian penulisan program studi, jenis kelamin, status mahasiswa, kode program studi, serta format tanggal.

3. **Tabel dengan temuan paling banyak.**
   Tabel mahasiswa menjadi salah satu tabel yang perlu mendapat perhatian karena memiliki beberapa jenis permasalahan sekaligus, seperti NIM duplikat, data kota kosong, variasi nama program studi, ketidakkonsistenan kategori jenis kelamin dan status, serta perbedaan penulisan kode program studi dan format tanggal. Tabel nilai juga perlu diperiksa lebih lanjut karena terdapat nilai kosong, nilai di luar rentang yang valid, dan ketidaksesuaian antara nilai angka dengan nilai huruf. Sementara itu, tabel aktivitas LMS memiliki jumlah record terbesar dan ditemukan 30 baris duplikat, sehingga perlu diperiksa untuk memastikan setiap aktivitas tercatat dengan benar.

4. **Relasi antar-tabel yang tidak terpenuhi.**
   Berdasarkan pemeriksaan integritas referensial, tidak ditemukan data yatim (orphan records) pada relasi yang diuji. Pemeriksaan pada relasi mahasiswa, KRS, nilai, aktivitas LMS, pembayaran, dan kelulusan menunjukkan bahwa data yang diperiksa memiliki referensi yang sesuai dengan tabel terkait. Dengan demikian, hubungan antar-tabel pada aspek yang diuji dapat dikatakan sudah terpenuhi.

5. **Pemeriksaan lanjutan sebelum cleaning, standardisasi, atau deduplikasi.**
   Sebelum melakukan perbaikan data, diperlukan pemeriksaan lebih lanjut terhadap setiap record yang terindikasi bermasalah. Pemeriksaan tersebut meliputi validasi identitas mahasiswa yang duplikat, penelusuran penyebab nilai kosong dan nilai di luar rentang, pengecekan kesesuaian kategori dengan data referensi resmi, serta verifikasi format tanggal. Selain itu, perlu dipastikan terlebih dahulu aturan penentuan data yang dianggap benar agar proses cleaning, standardisasi, dan deduplikasi tidak menghilangkan informasi yang masih diperlukan. Seluruh pemeriksaan sebaiknya dilakukan tanpa mengubah data pada source layer.

## 12.1 Temuan Utama

1. Ditemukan duplikasi data identik pada empat tabel, yaitu mahasiswa sebanyak 15, KRS 25, LMS 30, dan kelulusan 2 baris berlebih, dengan total keseluruhan 72 baris. Kondisi ini dapat menimbulkan risiko *double counting* dalam pengolahan data.
2. Penulisan kategori pada tabel mahasiswa masih belum konsisten. Terdapat 30 variasi label untuk 6 program studi yang memengaruhi 435 record (22,1%), serta 6 variasi label untuk 2 jenis kelamin yang ditemukan pada 437 record (22,2%).
3. Data tanggal masih menggunakan tiga bentuk penulisan, yaitu `YYYY-MM-DD`, `DD/MM/YYYY`, dan `DD-Mon-YYYY`. Sekitar 27% data pada kolom `tanggal_masuk_raw` belum menggunakan format ISO.
4. Pada tabel `nilai` ditemukan 20 data nilai kosong, 12 nilai yang berada di luar batas 0–100, serta 20 data yang tidak sesuai antara nilai angka dan nilai huruf. Sementara itu, tabel `pembayaran` memiliki 5 transaksi dengan nominal negatif dan 12 transaksi bernilai positif yang belum memiliki tanggal pembayaran.
5. Hasil pemeriksaan menunjukkan bahwa seluruh relasi antar-tabel yang diuji tidak memiliki data *orphan* (0 data). Selain itu, seluruh lulusan yang tercatat, yaitu 347 record dari 345 mahasiswa unik, memiliki status lulus tepat waktu. Dengan demikian, tidak tersedia data mahasiswa terlambat sebagai pembanding.

## 12.2 Rekomendasi Pemeriksaan Lanjutan

1. Melakukan validasi data duplikat. Periksa kembali record yang terindikasi duplikat pada tabel mahasiswa, KRS, aktivitas LMS, dan kelulusan. Pastikan apakah duplikasi tersebut merupakan pencatatan berulang atau memang memiliki makna berbeda sebelum menentukan tindakan deduplikasi.
2. Memeriksa kelengkapan dan validitas nilai. Telusuri penyebab data kosong, nilai di luar rentang, nominal pembayaran negatif, serta transaksi tanpa tanggal. Pemeriksaan perlu dilakukan dengan membandingkan data terhadap sumber atau dokumen referensi yang tersedia.
3. Menyiapkan aturan standardisasi dan validasi data. Tentukan format penulisan yang konsisten untuk nama program studi, jenis kelamin, status mahasiswa, kode program studi, dan tanggal. Gunakan referensi resmi sebagai acuan, kemudian lakukan pengujian aturan tersebut pada salinan data atau tahap staging sebelum diterapkan pada proses cleaning berikutnya.
