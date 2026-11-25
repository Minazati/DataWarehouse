# LAPORAN MODUL 1 – UNIT 1.1
## Persiapan Source Layer dan Initial Data Profiling

**Studi Kasus:** Database Akademik Perguruan Tinggi  
**DBMS:** PostgreSQL  
**Schema:** `src`

---

## Identitas Laporan

| Identitas | Keterangan |
|---|---|
| Nama | ........................................................ |
| NIM | ........................................................ |
| Program Studi | ........................................................ |
| Kelas/Kelompok | ........................................................ |
| Modul | 1 |
| Unit | 1.1 |
| Tanggal Praktikum | ........................................................ |
| Dosen/Instruktur | ........................................................ |

## Tujuan Praktikum

Praktikum Unit 1.1 bertujuan menyiapkan source layer pada PostgreSQL, memuat dataset raw UADW v1.0, memverifikasi struktur dan jumlah data sumber, serta melakukan *initial profiling* untuk memperoleh gambaran awal karakteristik dataset akademik.

## Ketentuan Praktikum

1. Gunakan PostgreSQL dan schema `src`.
2. Pertahankan nilai raw sebagaimana tersedia pada file sumber.
3. Jangan melakukan proses cleaning, standardisasi, deduplikasi, `UPDATE`, atau `DELETE` terhadap isi raw source pada unit ini.
4. Sesuaikan path file CSV dengan lokasi dataset pada komputer masing-masing.
5. Untuk setiap aktivitas query, cantumkan query yang dijalankan, hasil eksekusi, dan interpretasi.
6. Apabila hasil aktual berbeda dari nilai acuan pada bahan praktikum, catat perbedaannya dan lakukan pemeriksaan; jangan mengubah data hanya agar hasilnya sama.

---

## 1. Verifikasi Environment PostgreSQL

Pada tahap ini dilakukan pemeriksaan awal terhadap perangkat lunak dan koneksi database yang digunakan untuk praktikum.

### 1.1 Memeriksa versi PostgreSQL

Query yang digunakan:

```sql
SELECT version();
```

**Hasil eksekusi:**

```text
[Tempelkan hasil query di sini]
```

**Interpretasi:**

................................................................................
................................................................................

### 1.2 Memeriksa database dan user aktif

Query yang digunakan:

```sql
SELECT
    current_database() AS database_aktif,
    current_user AS user_aktif;
```

**Hasil eksekusi:**

| database_aktif | user_aktif |
|---|---|
|  |  |

**Interpretasi:**

................................................................................
................................................................................

### 1.3 Memeriksa keberadaan schema `src`

Query yang digunakan:

```sql
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name = 'src';
```

**Hasil eksekusi:**

| schema_name |
|---|
|  |

**Status:** [ ] Schema ditemukan  [ ] Schema belum ditemukan

**Interpretasi:**

................................................................................
................................................................................

---

## 2. Membuat dan Memverifikasi Source Layer

Source layer menggunakan schema `src` untuk menyimpan data mentah (*raw source*). Sepuluh tabel yang digunakan pada praktikum ini adalah sebagai berikut.

| No. | Nama tabel | Peran data | Status pembuatan |
|---:|---|---|---|
| 1 | `src.program_studi` | Master/reference program studi |  |
| 2 | `src.semester` | Reference periode akademik |  |
| 3 | `src.mahasiswa` | Master mahasiswa |  |
| 4 | `src.dosen` | Master dosen |  |
| 5 | `src.mata_kuliah` | Master/reference mata kuliah |  |
| 6 | `src.krs` | Transaksi pengambilan mata kuliah |  |
| 7 | `src.nilai` | Hasil penilaian akademik |  |
| 8 | `src.aktivitas_lms` | Aktivitas mahasiswa pada LMS |  |
| 9 | `src.pembayaran` | Transaksi pembayaran |  |
| 10 | `src.kelulusan` | Data outcome kelulusan |  |

### 2.1 Membuat schema dan tabel

Tuliskan atau lampirkan DDL yang digunakan untuk membuat schema dan sepuluh tabel pada schema `src`. Struktur kolom harus mengikuti spesifikasi pada bahan praktikum.

**Script DDL yang digunakan:**

```sql
-- Tempelkan DDL pembuatan schema dan tabel di sini.
-- Pastikan seluruh tabel dibuat sesuai spesifikasi bahan praktikum.
```

**Bukti eksekusi / hasil:**

[Tempelkan tangkapan layar atau keluaran eksekusi DDL di sini]

**Catatan:** Perintah `DROP TABLE` dapat menghapus tabel beserta isinya. Gunakan hanya apabila memang diperlukan dalam persiapan praktikum dan pastikan tidak menghapus data yang masih dibutuhkan.

**Interpretasi:**

................................................................................
................................................................................

---

## 3. Mengimpor/Mengakses Raw Source

Dataset UADW v1.0 terdiri atas sepuluh file CSV. Data dimuat ke tabel yang sesuai dengan mempertahankan nilai raw, tanpa cleaning, standardisasi, atau deduplikasi.

### 3.1 Perintah impor CSV

Sesuaikan `/PATH/UADW_v1.0/` dengan lokasi dataset pada komputer masing-masing.

```sql
\copy src.program_studi FROM '/PATH/UADW_v1.0/01_raw_data/program_studi.csv' CSV HEADER ENCODING 'UTF8';
\copy src.semester      FROM '/PATH/UADW_v1.0/01_raw_data/semester.csv'      CSV HEADER ENCODING 'UTF8';
\copy src.mahasiswa     FROM '/PATH/UADW_v1.0/01_raw_data/mahasiswa.csv'     CSV HEADER ENCODING 'UTF8';
\copy src.dosen         FROM '/PATH/UADW_v1.0/01_raw_data/dosen.csv'         CSV HEADER ENCODING 'UTF8';
\copy src.mata_kuliah   FROM '/PATH/UADW_v1.0/01_raw_data/mata_kuliah.csv'   CSV HEADER ENCODING 'UTF8';
\copy src.krs           FROM '/PATH/UADW_v1.0/01_raw_data/krs.csv'           CSV HEADER ENCODING 'UTF8';
\copy src.nilai         FROM '/PATH/UADW_v1.0/01_raw_data/nilai.csv'         CSV HEADER ENCODING 'UTF8';
\copy src.aktivitas_lms FROM '/PATH/UADW_v1.0/01_raw_data/aktivitas_lms.csv' CSV HEADER ENCODING 'UTF8';
\copy src.pembayaran    FROM '/PATH/UADW_v1.0/01_raw_data/pembayaran.csv'    CSV HEADER ENCODING 'UTF8';
\copy src.kelulusan     FROM '/PATH/UADW_v1.0/01_raw_data/kelulusan.csv'     CSV HEADER ENCODING 'UTF8';
```

### 3.2 Catatan proses impor

| No. | File CSV | Tabel tujuan | Status impor | Jumlah baris yang dilaporkan saat impor | Catatan/error |
|---:|---|---|---|---:|---|
| 1 | `program_studi.csv` | `src.program_studi` |  |  |  |
| 2 | `semester.csv` | `src.semester` |  |  |  |
| 3 | `mahasiswa.csv` | `src.mahasiswa` |  |  |  |
| 4 | `dosen.csv` | `src.dosen` |  |  |  |
| 5 | `mata_kuliah.csv` | `src.mata_kuliah` |  |  |  |
| 6 | `krs.csv` | `src.krs` |  |  |  |
| 7 | `nilai.csv` | `src.nilai` |  |  |  |
| 8 | `aktivitas_lms.csv` | `src.aktivitas_lms` |  |  |  |
| 9 | `pembayaran.csv` | `src.pembayaran` |  |  |  |
| 10 | `kelulusan.csv` | `src.kelulusan` |  |  |  |

**Bukti proses impor:**

[Tempelkan tangkapan layar atau keluaran proses impor di sini]

**Interpretasi:** Jelaskan apakah seluruh file berhasil diimpor dan bagaimana Anda memastikan nilai raw tetap dipertahankan.

................................................................................
................................................................................

---

## 4. Menginventarisasi Tabel pada Schema `src`

Aktivitas ini bertujuan mengetahui seluruh *base table* yang tersedia pada schema `src` setelah proses pembuatan dan pemuatan data.

**Query SQL:**

```sql
SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema = 'src'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

**Hasil eksekusi:**

| table_schema | table_name |
|---|---|
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |

**Interpretasi:**

................................................................................
................................................................................

---

## 5. Verifikasi Jumlah Baris Lima Source Awal

Lima tabel master/reference awal yang diverifikasi adalah `program_studi`, `semester`, `mahasiswa`, `dosen`, dan `mata_kuliah`.

**Query SQL:**

```sql
SELECT 'program_studi' AS tabel, COUNT(*) AS jumlah_baris
FROM src.program_studi
UNION ALL
SELECT 'semester', COUNT(*) FROM src.semester
UNION ALL
SELECT 'mahasiswa', COUNT(*) FROM src.mahasiswa
UNION ALL
SELECT 'dosen', COUNT(*) FROM src.dosen
UNION ALL
SELECT 'mata_kuliah', COUNT(*) FROM src.mata_kuliah
ORDER BY tabel;
```

**Hasil eksekusi:**

| tabel | jumlah_baris |
|---|---:|
| `program_studi` |  |
| `semester` |  |
| `mahasiswa` |  |
| `dosen` |  |
| `mata_kuliah` |  |

**Interpretasi:** Bandingkan jumlah baris aktual dengan jumlah yang diharapkan berdasarkan dataset yang digunakan. Jelaskan apabila terdapat perbedaan.

................................................................................
................................................................................

---

## 6. Verifikasi Jumlah Baris Seluruh Sepuluh Source

Aktivitas ini memeriksa jumlah baris pada seluruh tabel sumber di schema `src`.

**Query SQL:**

```sql
SELECT 'program_studi' AS tabel, COUNT(*) AS jumlah_baris FROM src.program_studi
UNION ALL SELECT 'semester', COUNT(*) FROM src.semester
UNION ALL SELECT 'mahasiswa', COUNT(*) FROM src.mahasiswa
UNION ALL SELECT 'dosen', COUNT(*) FROM src.dosen
UNION ALL SELECT 'mata_kuliah', COUNT(*) FROM src.mata_kuliah
UNION ALL SELECT 'krs', COUNT(*) FROM src.krs
UNION ALL SELECT 'nilai', COUNT(*) FROM src.nilai
UNION ALL SELECT 'aktivitas_lms', COUNT(*) FROM src.aktivitas_lms
UNION ALL SELECT 'pembayaran', COUNT(*) FROM src.pembayaran
UNION ALL SELECT 'kelulusan', COUNT(*) FROM src.kelulusan
ORDER BY tabel;
```

**Hasil eksekusi:**

| Dataset | Jumlah baris aktual | Jumlah baris acuan (bila tersedia) | Status/catatan |
|---|---:|---:|---|
| `program_studi` |  | 6 |  |
| `semester` |  | 8 |  |
| `mahasiswa` |  | 1.965 |  |
| `dosen` |  | 96 |  |
| `mata_kuliah` |  | 208 |  |
| `krs` |  | 57.025 |  |
| `nilai` |  | 57.000 |  |
| `aktivitas_lms` |  | 200.356 |  |
| `pembayaran` |  | 9.500 |  |
| `kelulusan` |  | 347 |  |

**Interpretasi:** Jelaskan hasil verifikasi jumlah baris dan kemungkinan penyebab apabila jumlah aktual berbeda dari nilai acuan.

................................................................................
................................................................................

---

## 7. Verifikasi Jumlah Kolom Seluruh Source

Aktivitas ini bertujuan mengetahui jumlah kolom pada setiap tabel dalam schema `src`.

**Query SQL:**

```sql
SELECT
    table_name,
    COUNT(*) AS jumlah_kolom
FROM information_schema.columns
WHERE table_schema = 'src'
GROUP BY table_name
ORDER BY table_name;
```

**Hasil eksekusi:**

| table_name | jumlah_kolom |
|---|---:|
| `aktivitas_lms` |  |
| `dosen` |  |
| `kelulusan` |  |
| `krs` |  |
| `mahasiswa` |  |
| `mata_kuliah` |  |
| `nilai` |  |
| `pembayaran` |  |
| `program_studi` |  |
| `semester` |  |

**Interpretasi:**

................................................................................
................................................................................

---

## 8. Verifikasi Struktur Kolom Tabel Mahasiswa

Pemeriksaan dilakukan pada tabel `src.mahasiswa` untuk mengetahui urutan kolom, nama kolom, dan tipe data.

**Query SQL:**

```sql
SELECT
    ordinal_position,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'src'
  AND table_name = 'mahasiswa'
ORDER BY ordinal_position;
```

**Hasil eksekusi:**

| ordinal_position | column_name | data_type |
|---:|---|---|
| 1 |  |  |
| 2 |  |  |
| 3 |  |  |
| 4 |  |  |
| 5 |  |  |
| 6 |  |  |
| 7 |  |  |
| 8 |  |  |
| 9 |  |  |
| 10 |  |  |
| 11 |  |  |

**Interpretasi:** Jelaskan apakah struktur tabel dan tipe data telah sesuai dengan definisi source pada bahan praktikum.

................................................................................
................................................................................

---

## 9. Verifikasi Candidate Key Mahasiswa

NIM merupakan *candidate natural key* secara bisnis untuk mengidentifikasi mahasiswa. Keunikan NIM perlu diperiksa sebelum digunakan sebagai key.

**Query SQL:**

```sql
SELECT
    COUNT(*) AS raw_rows,
    COUNT(DISTINCT nim) AS distinct_nim,
    COUNT(*) - COUNT(DISTINCT nim) AS excess_duplicate_rows
FROM src.mahasiswa;
```

**Hasil eksekusi:**

| raw_rows | distinct_nim | excess_duplicate_rows |
|---:|---:|---:|
|  |  |  |

**Analisis:**

- Apakah jumlah seluruh baris sama dengan jumlah NIM unik? ........................................
- Apakah terdapat indikasi NIM duplikat? ................................................................
- Apakah hasil ini sudah cukup untuk memutuskan penghapusan record? Jelaskan. ........................

**Interpretasi:**

................................................................................
................................................................................

**Catatan:** Indikasi duplikasi belum membuktikan bahwa record harus dihapus. Perlu pemeriksaan lanjutan untuk mengetahui apakah record merupakan duplikasi atau data historis.

---

## 10. Mengetahui Rentang Angkatan Mahasiswa

Aktivitas ini bertujuan mengetahui tahun angkatan paling awal dan paling akhir yang tercatat pada tabel mahasiswa. Kolom `angkatan` disimpan sebagai teks sehingga dikonversi ke tipe integer sebelum dihitung.

**Query SQL:**

```sql
SELECT
    MIN(CAST(angkatan AS INTEGER)) AS angkatan_min,
    MAX(CAST(angkatan AS INTEGER)) AS angkatan_max
FROM src.mahasiswa;
```

**Hasil eksekusi:**

| angkatan_min | angkatan_max |
|---:|---:|
|  |  |

**Interpretasi:** Jelaskan rentang angkatan mahasiswa yang tercakup dalam dataset.

................................................................................
................................................................................

---

## 11. Memeriksa Data Kota Asal yang Kosong

Pemeriksaan dilakukan untuk mengetahui jumlah record mahasiswa yang tidak memiliki informasi kota asal pada kolom `kota_asal_raw`.

**Query SQL:**

```sql
SELECT COUNT(*) AS missing_kota
FROM src.mahasiswa
WHERE TRIM(COALESCE(kota_asal_raw, '')) = '';
```

**Hasil eksekusi:**

| missing_kota |
|---:|
|  |

**Interpretasi:** Sebutkan jumlah data kota asal yang kosong dan jelaskan dampaknya terhadap analisis persebaran daerah asal mahasiswa.

................................................................................
................................................................................

---

## 12. Menghitung Variasi Label Program Studi pada Mahasiswa

Pemeriksaan awal dilakukan untuk mengetahui jumlah variasi nilai pada kolom `prodi_raw`.

**Query SQL:**

```sql
SELECT COUNT(DISTINCT prodi_raw) AS distinct_prodi_raw
FROM src.mahasiswa;
```

**Hasil eksekusi:**

| distinct_prodi_raw |
|---:|
|  |

**Interpretasi:** Jelaskan apa yang ditunjukkan oleh jumlah variasi label tersebut. Apakah jumlah variasi sama dengan jumlah program studi resmi?

................................................................................
................................................................................

---

## 13. Menghitung Jumlah Program Studi pada Tabel Referensi

Tabel `src.program_studi` digunakan sebagai referensi program studi. Jumlah record pada tabel referensi dihitung untuk dibandingkan dengan variasi label pada `prodi_raw`.

**Query SQL:**

```sql
SELECT COUNT(*) AS canonical_programs
FROM src.program_studi;
```

**Hasil eksekusi:**

| canonical_programs |
|---:|
|  |

**Perbandingan:**

| Keterangan | Jumlah |
|---|---:|
| Variasi label `prodi_raw` |  |
| Record pada `src.program_studi` |  |

**Interpretasi:** Jelaskan apakah terdapat indikasi variasi representasi nama program studi pada data mahasiswa dibandingkan dengan tabel referensi.

................................................................................
................................................................................

---

## 14. Menampilkan Distribusi Label Program Studi Mentah

Pemeriksaan ini bertujuan mengetahui frekuensi kemunculan setiap label program studi pada kolom `prodi_raw`.

**Query SQL:**

```sql
SELECT
    prodi_raw,
    COUNT(*) AS jumlah
FROM src.mahasiswa
GROUP BY prodi_raw
ORDER BY prodi_raw;
```

**Hasil eksekusi:**

| prodi_raw | jumlah |
|---|---:|
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |

*Tambahkan baris sesuai jumlah hasil query.*

**Interpretasi:** Identifikasi label yang memiliki frekuensi terbesar dan catat variasi penulisan yang perlu diperiksa lebih lanjut.

................................................................................
................................................................................

---

## 15. Menampilkan Variasi Label Jenis Kelamin

Pemeriksaan dilakukan untuk mengetahui variasi representasi jenis kelamin pada kolom `jk_raw`.

**Query SQL:**

```sql
SELECT
    jk_raw,
    COUNT(*) AS jumlah
FROM src.mahasiswa
GROUP BY jk_raw
ORDER BY jk_raw;
```

**Hasil eksekusi:**

| jk_raw | jumlah |
|---|---:|
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |

*Tambahkan baris sesuai jumlah hasil query.*

**Interpretasi:** Jelaskan variasi label jenis kelamin yang ditemukan dan apakah diperlukan standardisasi pada tahap berikutnya.

................................................................................
................................................................................

---

## 16. Menampilkan Sampel Record Tabel Mahasiswa

Sampel record digunakan untuk memahami bentuk data dan nilai pada setiap kolom. Pemeriksaan dibatasi pada lima baris.

**Query SQL:**

```sql
SELECT *
FROM src.mahasiswa
LIMIT 5;
```

**Hasil eksekusi:**

[Tempelkan tabel hasil query atau tangkapan layar yang memperlihatkan lima record dan nama kolomnya.]

**Interpretasi:** Jelaskan informasi yang dapat dipahami dari sampel tersebut. Mengapa lima record ini belum cukup untuk menyimpulkan kualitas seluruh dataset?

................................................................................
................................................................................

---

## 17. Mengidentifikasi Source dengan Jumlah Baris Terbesar

Aktivitas ini bertujuan membandingkan ukuran seluruh tabel berdasarkan jumlah baris, kemudian menentukan source dengan jumlah record terbanyak.

**Query SQL:**

```sql
SELECT 'program_studi' AS source, COUNT(*) AS rows FROM src.program_studi
UNION ALL SELECT 'semester', COUNT(*) FROM src.semester
UNION ALL SELECT 'mahasiswa', COUNT(*) FROM src.mahasiswa
UNION ALL SELECT 'dosen', COUNT(*) FROM src.dosen
UNION ALL SELECT 'mata_kuliah', COUNT(*) FROM src.mata_kuliah
UNION ALL SELECT 'krs', COUNT(*) FROM src.krs
UNION ALL SELECT 'nilai', COUNT(*) FROM src.nilai
UNION ALL SELECT 'aktivitas_lms', COUNT(*) FROM src.aktivitas_lms
UNION ALL SELECT 'pembayaran', COUNT(*) FROM src.pembayaran
UNION ALL SELECT 'kelulusan', COUNT(*) FROM src.kelulusan
ORDER BY rows DESC;
```

**Hasil eksekusi:**

| source | rows |
|---|---:|
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |

**Source dengan jumlah baris terbanyak:** ........................................................

**Jumlah baris:** ........................................................

**Interpretasi:** Jelaskan tabel yang memiliki ukuran terbesar dan mengapa informasi ukuran source berguna dalam perencanaan pengolahan data.

................................................................................
................................................................................

---

## 18. Mengidentifikasi Indikasi Relasi Mahasiswa dengan Tabel Transaksi

Kolom `nim` terdapat pada tabel mahasiswa dan beberapa tabel transaksi/aktivitas akademik. Query berikut membandingkan jumlah NIM berbeda pada masing-masing tabel transaksi.

**Query SQL:**

```sql
SELECT 'krs' AS source,
       COUNT(DISTINCT nim) AS distinct_nim
FROM src.krs
UNION ALL
SELECT 'nilai', COUNT(DISTINCT nim) FROM src.nilai
UNION ALL
SELECT 'aktivitas_lms', COUNT(DISTINCT nim) FROM src.aktivitas_lms
UNION ALL
SELECT 'pembayaran', COUNT(DISTINCT nim) FROM src.pembayaran
UNION ALL
SELECT 'kelulusan', COUNT(DISTINCT nim) FROM src.kelulusan;
```

**Hasil eksekusi:**

| source | distinct_nim |
|---|---:|
| `krs` |  |
| `nilai` |  |
| `aktivitas_lms` |  |
| `pembayaran` |  |
| `kelulusan` |  |

### 18.1 Catatan relasi awal

Berdasarkan kesamaan kolom `nim` dan konteks bisnis, lengkapi kandidat relasi berikut.

| Rel ID | Source A | Key A | Source B | Key B | Dugaan hubungan bisnis | Catatan/verifikasi lanjutan |
|---|---|---|---|---|---|---|
| REL01 | `mahasiswa` | `nim` | `krs` | `nim` | 1 mahasiswa : banyak KRS |  |
| REL02 | `mahasiswa` | `nim` | `nilai` | `nim` | 1 mahasiswa : banyak nilai |  |
| REL03 | `mahasiswa` | `nim` | `aktivitas_lms` | `nim` | 1 mahasiswa : banyak aktivitas LMS |  |
| REL04 | `mahasiswa` | `nim` | `pembayaran` | `nim` | 1 mahasiswa : banyak pembayaran |  |
| REL05 | `mahasiswa` | `nim` | `kelulusan` | `nim` | 1 mahasiswa : 0/1 outcome kelulusan secara bisnis |  |

**Interpretasi:** Jelaskan indikasi relasi yang dapat dikenali dari struktur dan hasil query. Tegaskan hal-hal yang masih perlu diverifikasi sebelum menyatakan integritas referensial telah terpenuhi.

................................................................................
................................................................................

---

## 19. Ringkasan Hasil Initial Profiling

Lengkapi tabel berikut berdasarkan hasil seluruh aktivitas Unit 1.1.

| No. | Aspek yang diperiksa | Temuan berdasarkan hasil query | Tindak lanjut yang disarankan |
|---:|---|---|---|
| 1 | Kesiapan environment PostgreSQL |  |  |
| 2 | Ketersediaan schema dan tabel |  |  |
| 3 | Keberhasilan impor dataset |  |  |
| 4 | Jumlah baris setiap source |  |  |
| 5 | Jumlah kolom setiap source |  |  |
| 6 | Keunikan NIM mahasiswa |  |  |
| 7 | Rentang angkatan |  |  |
| 8 | Kelengkapan kota asal |  |  |
| 9 | Variasi label program studi |  |  |
| 10 | Variasi label jenis kelamin |  |  |
| 11 | Ukuran source terbesar |  |  |
| 12 | Indikasi relasi antartabel |  |  |

---

## 20. Kesimpulan

Tuliskan kesimpulan berdasarkan hasil praktikum Unit 1.1. Kesimpulan sekurang-kurangnya mencakup:

1. Kesiapan environment dan keberhasilan pembuatan source layer.
2. Keberhasilan pemuatan sepuluh dataset raw.
3. Hasil verifikasi jumlah baris dan kolom source.
4. Karakteristik awal data mahasiswa yang ditemukan, seperti indikasi duplikasi, nilai kosong, dan variasi label.
5. Gambaran awal relasi antartabel yang perlu diverifikasi lebih lanjut.
6. Hal-hal yang akan menjadi fokus pemeriksaan pada unit praktikum berikutnya.

**Kesimpulan:**

................................................................................
................................................................................
................................................................................
................................................................................
................................................................................

---

## Lampiran Bukti Praktikum

Lampirkan bukti yang relevan dan terbaca, antara lain:

- [ ] Koneksi PostgreSQL dan informasi versi.
- [ ] Schema `src` dan daftar sepuluh tabel.
- [ ] Proses impor sepuluh file CSV.
- [ ] Hasil query verifikasi row count dan column count.
- [ ] Hasil query initial profiling mahasiswa.
- [ ] Hasil query ukuran source dan relasi awal.
- [ ] Bukti tambahan apabila terdapat kendala atau perbedaan hasil.

## Pernyataan Integritas Data

Saya menyatakan bahwa pada pelaksanaan Unit 1.1, pemeriksaan dilakukan terhadap raw source untuk keperluan persiapan dan *initial profiling*. Saya tidak melakukan cleaning, standardisasi, deduplikasi, `UPDATE`, atau `DELETE` terhadap isi raw source.

| Nama Mahasiswa | Tanggal | Tanda Tangan |
|---|---|---|
|  |  |  |
