# LAPORAN MODUL 1 – UNIT 1.1
## Persiapan Source Layer dan Initial Data Profiling

**Studi Kasus:** Database Akademik Perguruan Tinggi  
**DBMS:** PostgreSQL  
**Schema:** `src`

---

## Identitas Laporan

| Identitas | Keterangan |
|---|---|
| Nama | Minazati Ifada |
| NIM | 240306035 |
| Program Studi | Teknologi Informasi |
| Kelas/Kelompok | A/4 |
| Modul | 1 |
| Unit | 1.1 |
| Tanggal Praktikum | 5 November 2026 |
| Dosen/Instruktur | Adam Bachtiar Maulachela S.Kom., M.MT. |

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
<img width="496" height="221" alt="image" src="https://github.com/user-attachments/assets/55a2c0bf-1e1b-411a-bb60-eba2417550a1" />
```

### 1.2 Memeriksa database dan user aktif

Query yang digunakan:

```sql
SELECT
    current_database() AS database_aktif,
    current_user AS user_aktif;
```

**Hasil eksekusi:**

<img width="413" height="253" alt="image" src="https://github.com/user-attachments/assets/371b7d8d-1f2d-4a37-9bcc-b19204fa2efc" />


### 1.3 Memeriksa keberadaan schema `src`

Query yang digunakan:

```sql
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name = 'src';
```

**Hasil eksekusi:**

<img width="428" height="247" alt="image" src="https://github.com/user-attachments/assets/b88cb8a3-d1e3-4d9a-8887-bf32e45849bc" />

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
--2. Membuat dan Memverivikasi Source Layer
---2.1 Membuat schema dan tabel
---- 1. Membuat schema src
CREATE SCHEMA IF NOT EXISTS src;

---- 2. Membuat sepuluh tabel sumber 
----- Membuat tabel program_studi
CREATE TABLE IF NOT EXISTS src.program_studi (
    kode_prodi TEXT,
    nama_prodi TEXT,
    fakultas TEXT,
    departemen TEXT,
    status TEXT
);

----- Membuat tabel semester
CREATE TABLE IF NOT EXISTS src.semester (
    semester_id TEXT,
    tahun_akademik TEXT,
    term TEXT,
    urutan_tahun INTEGER,
    tanggal_mulai TEXT,
    tanggal_selesai TEXT
);

----- Membuat tabel mahasiswa
CREATE TABLE IF NOT EXISTS src.mahasiswa (
    nim TEXT,
    nama TEXT,
    jk_raw TEXT,
    tanggal_lahir_raw TEXT,
    kota_asal_raw TEXT,
    kode_prodi_raw TEXT,
    prodi_raw TEXT,
    angkatan TEXT,
    tanggal_masuk_raw TEXT,
    status_raw TEXT,
    email_kampus TEXT
);

----- Membuat tabel dosen
CREATE TABLE IF NOT EXISTS src.dosen (
    nidn TEXT,
    nama_dosen TEXT,
    jk_raw TEXT,
    unit_prodi_raw TEXT,
    jabatan_akademik TEXT,
    tanggal_masuk_raw TEXT,
    status TEXT
);

----- Membuat tabel mata_kuliah
CREATE TABLE IF NOT EXISTS src.mata_kuliah (
    kode_mk TEXT,
    nama_mk TEXT,
    kode_prodi TEXT,
    sks INTEGER,
    semester_rekomendasi INTEGER,
    kategori TEXT,
    aktif TEXT
);

----- Membuat tabel krs
CREATE TABLE IF NOT EXISTS src.krs (
    krs_id TEXT,
    nim TEXT,
    kode_mk TEXT,
    semester_id TEXT,
    kelas TEXT,
    status_krs TEXT,
    tanggal_ambil_raw TEXT,
    sumber_sistem TEXT
);

----- Membuat tabel nilai
CREATE TABLE IF NOT EXISTS src.nilai (
    nilai_id TEXT,
    nim TEXT,
    kode_mk TEXT,
    semester_id TEXT,
    nilai_angka NUMERIC(6,2),
    nilai_huruf TEXT,
    status_lulus TEXT,
    tanggal_input_raw TEXT
);

----- 9. Membuat tabel aktivitas_lms
CREATE TABLE IF NOT EXISTS src.aktivitas_lms (
    lms_event_id TEXT,
    nim TEXT,
    kode_mk TEXT,
    semester_id TEXT,
    waktu_event TEXT,
    tipe_event TEXT,
    durasi_menit INTEGER,
    skor_kuis NUMERIC(6,2),
    platform TEXT
);

----- Membuat tabel pembayaran
CREATE TABLE IF NOT EXISTS src.pembayaran (
    pembayaran_id TEXT,
    nim TEXT,
    semester_id TEXT,
    tanggal_bayar_raw TEXT,
    nominal_tagihan BIGINT,
    nominal_bayar BIGINT,
    status_pembayaran TEXT,
    kanal TEXT
);

----- Membuat tabel kelulusan
CREATE TABLE IF NOT EXISTS src.kelulusan (
    kelulusan_id TEXT,
    nim TEXT,
    tanggal_lulus_raw TEXT,
    ipk_final NUMERIC(4,2),
    masa_studi_bulan INTEGER,
    predikat TEXT,
    status_tepat_waktu TEXT
);
```

**Bukti eksekusi / hasil:**

<img width="643" height="424" alt="image" src="https://github.com/user-attachments/assets/1b3fc9df-9dcf-4957-a115-20b8ba83cd41" />

<img width="642" height="408" alt="image" src="https://github.com/user-attachments/assets/246f5127-3305-4181-814e-4a9402b3c790" />



**Catatan:** Perintah `DROP TABLE` dapat menghapus tabel beserta isinya. Gunakan hanya apabila memang diperlukan dalam persiapan praktikum dan pastikan tidak menghapus data yang masih dibutuhkan.

**Interpretasi:** Schema src dan sepuluh tabel sumber dibuat sebagai wadah data mentah. Kolom dibuat mengikuti header CSV; atribut *_raw dan kategori bertipe teks agar nilai asli (termasuk format tanggal dan label yang beragam) tidak berubah saat dimuat, sedangkan kolom numerik (mis. nilai_angka, nominal_bayar) bertipe numerik.

---

## 3. Mengimpor/Mengakses Raw Source

Dataset UADW v1.0 terdiri atas sepuluh file CSV. Data dimuat ke tabel yang sesuai dengan mempertahankan nilai raw, tanpa cleaning, standardisasi, atau deduplikasi.

### 3.1 Perintah impor CSV melalui DBeaver

Sepuluh file CSV diimpor menggunakan fitur Import Data pada DBeaver karena praktikum dijalankan melalui DBeaver di Windows. Perintah \copy merupakan perintah khusus psql sehingga tidak dijalankan pada SQL Editor DBeaver.

Langkah impor yang dilakukan:

1. Klik kanan tabel tujuan pada schema src, lalu pilih Import Data.
2. Pilih sumber CSV dan tentukan file yang sesuai dari folder 01_raw_data.
3. Pastikan encoding UTF-8, delimiter koma, dan opsi header aktif.
4. Periksa preview serta pemetaan kolom sumber ke kolom tujuan.
5. Klik Proceed dan tunggu sampai proses selesai.

| No. | File CSV | Tabel Tujuan |
|-----|-----|-----|
| 1.  | program_studi.csv | src.program_studi |
| 2.  | semester.csv | src.semester |
| 3.  | mahasiswa.csv | src.mahasiswa |
| 4.  | dosen.csv | src.dosen |
| 5.  | mata_kuliah.csv	| src.mata_kuliah |
| 6.  | krs.csv	| src.krs |
| 7.  | nilai.csv | src.nilai |
| 8.  | aktivitas_lms.csv | src.aktivitas_lms |
| 9.  | pembayaran.csv | src.pembayaran |
| 10. | kelulusan.csv | src.kelulusan |

## Bukti proses impor: hasil verifikasi jumlah record pada masing-masing tabel setelah impor ditunjukkan pada Gambar 8 (lihat juga bagian 3.2 dan 6).

## 3.2 Catatan proses impor

| No. | File CSV | Tabel tujuan | Status impor | Jumlah baris yang dilaporkan saat impor | Catatan/error |
|---:|---|---|---|---:|---|
| 1 | `program_studi.csv` | `src.program_studi` | berhasil | 6 |  |
| 2 | `semester.csv` | `src.semester` | berhasil | 8 |  |
| 3 | `mahasiswa.csv` | `src.mahasiswa` | berhasil | 1.965 |  |
| 4 | `dosen.csv` | `src.dosen` | berhasil | 96 |  |
| 5 | `mata_kuliah.csv` | `src.mata_kuliah` | berhasil | 208 |  |
| 6 | `krs.csv` | `src.krs` | berhasil | 57.025 |  |
| 7 | `nilai.csv` | `src.nilai` | berhasil | 57.000 |  |
| 8 | `aktivitas_lms.csv` | `src.aktivitas_lms` | berhasil | 200.356 |  |
| 9 | `pembayaran.csv` | `src.pembayaran` | berhasil | 9.500 |  |
| 10 | `kelulusan.csv` | `src.kelulusan` | berhasil | 347 |  |

**Bukti proses impor:**hasil query verifikasi jumlah record seluruh tabel setelah impor.

<img width="606" height="451" alt="image" src="https://github.com/user-attachments/assets/df7a5174-b774-43d6-9b63-aee5d9792f1b" />


**Interpretasi:** Proses impor sepuluh file CSV ke tabel tujuan pada schema src berhasil dilakukan melalui fitur Import Data di DBeaver. Berdasarkan catatan hasil impor, jumlah baris yang masuk berkisar dari 6 baris pada program_studi hingga 200.356 baris pada aktivitas_lms. Jumlah tersebut selanjutnya diverifikasi kembali menggunakan query COUNT(*) agar dapat dipastikan bahwa data telah termuat sesuai jumlah yang dilaporkan.

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

<img width="497" height="457" alt="image" src="https://github.com/user-attachments/assets/111eb339-0c21-4805-9f17-04009eb1166c" />



**Interpretasi:** Schema src berisi 10 base table yang sesuai dengan sepuluh dataset praktikum, sehingga source layer lengkap.

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

<img width="595" height="360" alt="image" src="https://github.com/user-attachments/assets/343d4e35-9aee-4673-90cb-46a231159bac" />



**Interpretasi:**  Lima tabel master/reference berhasil diverifikasi memiliki jumlah baris yang berbeda sesuai fungsinya. Tabel mahasiswa berisi 1.965 baris, mata_kuliah 208 baris, dosen 96 baris, semester 8 baris, dan program_studi 6 baris. Hasil ini menunjukkan bahwa data pada kelima tabel telah tersedia dan dapat digunakan sebagai sumber referensi untuk proses profiling berikutnya.

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

<img width="624" height="451" alt="image" src="https://github.com/user-attachments/assets/b546b3dc-f4d5-4823-be6d-50a687603df5" />



**Interpretasi:** Seluruh tabel memiliki jumlah baris yang sama dengan nilai acuan, sehingga pemuatan dinilai lengkap. Tidak ada tabel yang kosong atau kekurangan baris.

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

<img width="515" height="465" alt="image" src="https://github.com/user-attachments/assets/0464e214-fd84-43e1-820e-75225d59d859" />



**Interpretasi:** Berdasarkan hasil query, jumlah kolom pada setiap tabel berada pada rentang 5 sampai 11 kolom. Tabel mahasiswa memiliki jumlah kolom terbanyak, yaitu 11 kolom, sedangkan program_studi memiliki jumlah kolom paling sedikit, yaitu 5 kolom. Jumlah kolom tersebut sesuai dengan struktur source yang digunakan dalam praktikum.

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

<img width="508" height="484" alt="image" src="https://github.com/user-attachments/assets/ccc6604c-58d0-470e-ab18-c9f0d2451d33" />


**Interpretasi:** **Interpretasi:**

Berdasarkan hasil verifikasi struktur tabel mahasiswa menggunakan query pada `information_schema.columns`, diperoleh bahwa tabel mahasiswa memiliki 11 kolom dengan urutan yang sesuai, yaitu `nim`, `nama`, `jk_raw`, `tanggal_lahir_raw`, `kota_asal_raw`, `kode_prodi_raw`, `prodi_raw`, `angkatan`, `tanggal_masuk_raw`, `status_raw`, dan `email_kampus`.

Hasil pemeriksaan menunjukkan bahwa sebagian besar kolom menggunakan tipe data `character varying`, sedangkan kolom `angkatan` menggunakan tipe data `integer`. Tipe data `character varying` digunakan untuk menyimpan data berbentuk teks, sementara tipe data `integer` digunakan untuk menyimpan bilangan bulat.

Dengan demikian, struktur tabel mahasiswa telah terbentuk dengan 11 kolom dan tipe data yang dapat digunakan untuk menampung informasi mahasiswa sesuai dengan fungsi masing-masing kolom. Perbedaan tampilan tipe data `character varying` dengan `text` tidak menunjukkan kesalahan, karena keduanya merupakan tipe data teks pada PostgreSQL. Oleh karena itu, hasil verifikasi menunjukkan bahwa struktur tabel telah terbentuk, sedangkan kesesuaian tipe data secara spesifik tetap mengacu pada definisi source pada bahan praktikum.


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

<img width="527" height="302" alt="image" src="https://github.com/user-attachments/assets/bb65619b-2be5-414d-bda1-ba25da34a202" />


**Analisis:**

- Apakah jumlah seluruh baris sama dengan jumlah NIM unik? Tidak (1.965 vs 1.950)
- Apakah terdapat indikasi NIM duplikat? Ya, terdapat 15 baris berlebih.
- Apakah hasil ini sudah cukup untuk memutuskan penghapusan record? Belum. Hasil hanya menunjukkan selisih jumlah; belum diketahui apakah baris-baris itu identik penuh atau memuat data historis.

**Interpretasi:** Belum. Hasil hanya menunjukkan selisih jumlah; belum diketahui apakah baris-baris itu identik penuh atau memuat data historis.

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

<img width="484" height="260" alt="image" src="https://github.com/user-attachments/assets/ab9270d5-9cac-4ee7-9509-5b57cf41df33" />


**Interpretasi:** Berdasarkan hasil query untuk mengetahui rentang angkatan mahasiswa, diperoleh nilai angkatan minimum sebesar 2021 dan angkatan maksimum sebesar 2024. Hal ini menunjukkan bahwa dataset mahasiswa mencakup mahasiswa dari angkatan 2021 hingga 2024, dengan rentang tahun angkatan selama 4 tahun. Dengan demikian, data yang terdapat dalam dataset mencakup mahasiswa dari angkatan paling awal tahun 2021 hingga angkatan paling baru tahun 2024.


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

<img width="465" height="233" alt="image" src="https://github.com/user-attachments/assets/665e4fad-7ce6-43de-8831-0a3a03d4af91" />


**Interpretasi:** Berdasarkan hasil query pemeriksaan data kota asal mahasiswa, ditemukan sebanyak 30 data yang memiliki nilai kota asal kosong atau tidak terisi. Data kosong tersebut dapat memengaruhi analisis persebaran daerah asal mahasiswa karena informasi mengenai asal daerah tidak tersedia untuk sejumlah mahasiswa. Akibatnya, hasil analisis persebaran daerah asal menjadi kurang lengkap dan jumlah mahasiswa dari setiap daerah yang teridentifikasi mungkin tidak mencerminkan keseluruhan dataset. Oleh karena itu, data kota asal yang kosong perlu diperhatikan agar analisis persebaran daerah asal mahasiswa dapat dilakukan secara lebih akurat.

---

## 12. Menghitung Variasi Label Program Studi pada Mahasiswa

Pemeriksaan awal dilakukan untuk mengetahui jumlah variasi nilai pada kolom `prodi_raw`.

**Query SQL:**

```sql
SELECT COUNT(DISTINCT prodi_raw) AS distinct_prodi_raw
FROM src.mahasiswa;
```

**Hasil eksekusi:**

<img width="606" height="211" alt="image" src="https://github.com/user-attachments/assets/bba59037-392b-4316-bd96-29e89c47fc4f" />


**Interpretasi:** Hasil menunjukkan terdapat 30 variasi label program studi pada data mahasiswa. Jumlah ini belum tentu sama dengan jumlah program studi resmi karena terdapat kemungkinan perbedaan penulisan atau variasi label untuk program studi yang sama.

---

## 13. Menghitung Jumlah Program Studi pada Tabel Referensi

Tabel `src.program_studi` digunakan sebagai referensi program studi. Jumlah record pada tabel referensi dihitung untuk dibandingkan dengan variasi label pada `prodi_raw`.

**Query SQL:**

```sql
SELECT COUNT(*) AS canonical_programs
FROM src.program_studi;
```

**Hasil eksekusi:**

<img width="604" height="210" alt="image" src="https://github.com/user-attachments/assets/4654560d-5f5d-4ca2-9034-53982ed4e2e1" />


**Perbandingan:**

| Keterangan | Jumlah |
|---|---:|
| Variasi label `prodi_raw` | 30 |
| Record pada `src.program_studi` | 6 |

**Interpretasi:** Tabel referensi src.program_studi berisi 6 record program studi yang digunakan sebagai acuan nama program studi resmi. Jika dibandingkan dengan 30 variasi label pada kolom prodi_raw, terdapat selisih 24 label. Selisih ini menunjukkan bahwa data mahasiswa memuat beberapa bentuk penulisan selain label resmi, sehingga diperlukan pemetaan label ke program studi yang sesuai pada tahap berikutnya.



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

<img width="648" height="558" alt="image" src="https://github.com/user-attachments/assets/2256f7c4-4a83-4cc5-a0cd-df5c1789f586" />

<img width="595" height="370" alt="image" src="https://github.com/user-attachments/assets/bb1e67d1-5249-4788-9ebb-59694d28dd19" />



**Interpretasi:** Distribusi menunjukkan bahwa label Teknologi Informasi memiliki jumlah terbanyak, yaitu 286 record. Selain enam label yang sama dengan nama program studi pada tabel referensi, terdapat 24 label lain dengan total 435 record atau sekitar 22,1% dari seluruh data mahasiswa. Variasi tersebut terlihat dalam bentuk singkatan, pemendekan nama, dan perbedaan kapitalisasi. Oleh karena itu, label-label tersebut perlu diperiksa dan dipetakan terlebih dahulu sebelum dilakukan standardisasi agar setiap mahasiswa terhubung dengan program studi yang tepat.

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

<img width="501" height="349" alt="image" src="https://github.com/user-attachments/assets/35afccb4-6cf2-4e56-880b-1af96ee2a137" />

**Interpretasi:** Hasil pengelompokan menunjukkan terdapat enam label pada kolom jk_raw, yaitu F, L, Laki-laki, M, P, dan Perempuan. Keenam label tersebut merepresentasikan dua kategori, yaitu laki-laki dan perempuan, tetapi ditulis dengan bentuk yang berbeda. Jika data langsung dihitung berdasarkan label mentah, jumlah setiap kategori dapat terpisah ke beberapa kelompok. Karena itu, standardisasi label diperlukan pada tahap transformasi berikutnya, bukan pada source raw.

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

<img width="554" height="298" alt="image" src="https://github.com/user-attachments/assets/b4a85f3a-4e88-453b-a7b5-e6da166f48c5" />

<img width="568" height="292" alt="image" src="https://github.com/user-attachments/assets/b6614cb1-65d1-45bc-bdc2-d517bc1f0bc1" />

<img width="594" height="302" alt="image" src="https://github.com/user-attachments/assets/07473911-3e18-4259-9d5b-b4fd3ebc321e" />

Lima baris pertama berdasarkan urutan baris pada file sumber (tanpa ORDER BY).

**Interpretasi:** Lima record yang ditampilkan memberikan gambaran awal mengenai isi dan format kolom pada tabel mahasiswa. Contohnya, NIM memiliki pola gabungan tahun, kode program studi, dan nomor urut; kolom jenis kelamin menggunakan beberapa variasi label; sedangkan tanggal lahir ditulis dengan format yang berbeda. Meskipun demikian, sampel lima baris belum mewakili keseluruhan 1.965 record. Oleh karena itu, kesimpulan mengenai kualitas data harus didasarkan pada pemeriksaan seluruh record, seperti perhitungan duplikasi, nilai kosong, dan variasi label yang telah dilakukan pada bagian sebelumnya.

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

<img width="568" height="440" alt="image" src="https://github.com/user-attachments/assets/241c2386-0854-4be7-b027-abd7b85b16e2" />


**Source dengan jumlah baris terbanyak:** aktivitas_lms

**Jumlah baris:** 200.356

**Interpretasi:** Berdasarkan hasil pengurutan jumlah baris, tabel aktivitas_lms merupakan source dengan ukuran terbesar, yaitu 200.356 baris. Jumlah tersebut jauh lebih besar dibandingkan tabel source lainnya karena tabel ini mencatat aktivitas mahasiswa pada Learning Management System (LMS). Ukuran data tersebut perlu diperhatikan dalam perencanaan proses pengolahan berikutnya, terutama untuk menentukan strategi pemrosesan dan kebutuhan optimasi.

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

<img width="565" height="346" alt="image" src="https://github.com/user-attachments/assets/5075874f-b323-4981-a6c7-2599ef78a338" />


### 18.1 Catatan relasi awal

Berdasarkan kesamaan kolom `nim` dan konteks bisnis, lengkapi kandidat relasi berikut.

| Rel ID | Source A | Key A | Source B | Key B | Dugaan hubungan bisnis | Catatan/verifikasi lanjutan |
|---|---|---|---|---|---|---|
| REL01 | `mahasiswa` | `nim` | `krs` | `nim` | 1 mahasiswa : banyak KRS | Uji orphan NIM KRS terhadap mahasiswa |
| REL02 | `mahasiswa` | `nim` | `nilai` | `nim` | 1 mahasiswa : banyak nilai | Uji orphan NIM nilai; cocokkan dengan KRS |
| REL03 | `mahasiswa` | `nim` | `aktivitas_lms` | `nim` | 1 mahasiswa : banyak aktivitas LMS | Uji orphan NIM LMS |
| REL04 | `mahasiswa` | `nim` | `pembayaran` | `nim` | 1 mahasiswa : banyak pembayaran | Uji orphan NIM pembayaran |
| REL05 | `mahasiswa` | `nim` | `kelulusan` | `nim` | 1 mahasiswa : 0/1 outcome kelulusan secara bisnis | Uji duplikasi kelulusan dan orphan NIM |

**Interpretasi:** Kolom nim terdapat pada tabel mahasiswa serta tabel krs, nilai, aktivitas_lms, pembayaran, dan kelulusan. Hal ini menunjukkan adanya dugaan hubungan antara data mahasiswa dan data transaksi atau aktivitas. Jumlah NIM unik pada krs, nilai, aktivitas_lms, dan pembayaran masing-masing 1.950, sama dengan jumlah NIM unik pada tabel mahasiswa, sedangkan tabel kelulusan memiliki 345 NIM unik. Perbedaan tersebut dapat terjadi karena tidak semua mahasiswa memiliki catatan kelulusan. Namun, kesamaan nama kolom dan jumlah NIM unik belum membuktikan bahwa seluruh NIM pada tabel terkait benar-benar cocok. Integritas relasi masih perlu diperiksa melalui pengujian orphan menggunakan LEFT JOIN pada Unit 1.2.

---

## 19. Ringkasan Hasil Initial Profiling

Lengkapi tabel berikut berdasarkan hasil seluruh aktivitas Unit 1.1.

| No. | Aspek yang diperiksa | Temuan berdasarkan hasil query | Tindak lanjut yang disarankan |
|---:|---|---|---|
| 1 | Kesiapan environment PostgreSQL | Server dan database dapat diakses; versi dan user tercatat | Pertahankan konfigurasi untuk unit berikutnya |
| 2 | Ketersediaan schema dan tabel | Schema src dan 10 tabel tersedia | Tidak ada |
| 3 | Keberhasilan impor dataset | 10 file CSV termuat; jumlah baris sesuai acuan | Pertahankan raw data tanpa perubahan |
| 4 | Jumlah baris setiap source | 6 s.d. 200.356 baris; sesuai acuan | Tidak ada |
| 5 | Jumlah kolom setiap source | 5 s.d. 11 kolom | Tidak ada |
| 6 | Keunikan NIM mahasiswa | 1.965 baris vs 1.950 NIM unik; 15 baris berlebih | Selidiki apakah duplikat persis atau historis |
| 7 | Rentang angkatan | 2021 s.d. 2024 | Tidak ada |
| 8 | Kelengkapan kota asal | 30 record kosong (1,53%) | Tentukan penanganan pada ETL |
| 9 | Variasi label program studi | 30 label vs 6 program studi resmi | Susun tabel mapping label ke kode prodi |
| 10 | Variasi label jenis kelamin | 6 label untuk 2 konsep | Standardisasi ke L/P pada tahap transformasi |
| 11 | Ukuran source terbesar | aktivitas_lms (200.356 baris) | Rencanakan pemrosesan bertahap |
| 12 | Indikasi relasi antartabel | nim muncul di 5 tabel transaksi | Uji integritas referensial pada Unit 1.2 |

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

Source layer pada schema src telah siap: schema dan sepuluh tabel berhasil dibuat serta seluruh file CSV UADW v1.0 berhasil dimuat tanpa mengubah nilai raw. Jumlah baris setiap tabel sesuai dengan nilai acuan (dari 6 baris pada program_studi hingga 200.356 baris pada aktivitas_lms) dan jumlah kolom sesuai definisi source.

Initial profiling pada tabel mahasiswa menunjukkan beberapa karakteristik awal: NIM belum terbukti unik (1.965 baris vs 1.950 NIM unik), angkatan mencakup 2021–2024, 30 record tidak memiliki kota asal, terdapat 30 variasi label program studi untuk 6 program studi resmi, dan 6 variasi label untuk 2 konsep jenis kelamin. Kolom nim juga muncul pada lima tabel transaksi sehingga terindikasi relasi dengan mahasiswa.

Temuan tersebut hanya dicatat dan tidak diperbaiki pada unit ini. Unit berikutnya perlu memeriksa lebih dalam duplikasi (apakah identik penuh atau historis), kelengkapan, validitas, konsistensi format, dan integritas referensial antartabel sebelum dilakukan cleaning dan standardisasi.

---
