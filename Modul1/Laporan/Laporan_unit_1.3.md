# LAPORAN MODUL 1 UNIT 1.3

**Business Requirement to Data Requirement**

**Studi Kasus 2 -- Evaluasi Keterlibatan Mahasiswa di LMS terhadap Performa Akademik**

### Identitas Laporan

Nama : Minazati Ifada
NIM : 240306035
Kelas : A
Kelompok : 4
Program Studi : Teknologi Informasi
Modul : 1
Unit : 1.3
Tanggal Praktikum : 5 November 2026

# 1. Skenario Kasus

Wakil Rektor Bidang Akademik dan pengelola Learning Management System (LMS) ingin mengevaluasi apakah penggunaan LMS benar-benar mendukung proses pembelajaran. Universitas sudah memiliki data aktivitas LMS dalam jumlah besar, tetapi pemanfaatannya masih sebatas laporan jumlah login atau jumlah aktivitas. Pimpinan ingin mengubah data itu menjadi informasi untuk menilai kualitas proses pembelajaran, yaitu apakah ada pola hubungan antara keterlibatan mahasiswa di LMS dan hasil belajar.

Contoh pertanyaan pimpinan: apakah mahasiswa dengan aktivitas LMS rendah cenderung bernilai akhir lebih rendah; apakah mahasiswa yang aktif menjelang ujian berbeda performanya dari yang aktif konsisten sepanjang semester; dan apakah ada mata kuliah dengan aktivitas LMS tinggi tetapi hasil belajar masih rendah. Pengelola program studi juga ingin membandingkan keterlibatan antar-semester, antar-mata kuliah, dan antar-program studi untuk menemukan mata kuliah yang perlu perbaikan desain pembelajaran digital, mahasiswa yang perlu pendampingan, dan indikator awal keterlibatan belajar.

Tantangannya: volume data LMS jauh lebih besar dari data akademik, satu mahasiswa dapat menghasilkan banyak catatan dalam sehari, sebagian aktivitas mungkin duplikasi teknis, dan tidak semua aktivitas relevan sebagai indikator keterlibatan. Universitas perlu menentukan informasi apa yang benar-benar diperlukan dan bagaimana data LMS dikaitkan dengan mahasiswa, KRS, mata kuliah, semester, dan nilai agar analisis tidak menyesatkan. Unit 1.3 hanya menerjemahkan masalah bisnis menjadi kebutuhan informasi dan data; Star Schema dan ETL belum dibuat.

Keputusan yang didukung:

- menilai apakah LMS layak dipertahankan atau ditingkatkan sebagai sarana pembelajaran;

- menentukan jenis aktivitas LMS yang relevan sebagai indikator keterlibatan;

- menentukan mata kuliah yang perlu perbaikan desain pembelajaran digital;

- menentukan mahasiswa yang berpotensi perlu pendampingan;

- menentukan apakah pola aktivitas (menjelang ujian atau konsisten) layak menjadi indikator awal keterlibatan.

**Batas kasus:** hubungan yang ditemukan bersifat asosiasi, bukan sebab-akibat. Data pembayaran dan kelulusan tidak dipakai pada kasus ini.

# 2. Stakeholder Utama

| **ID** | **Stakeholder**                       | **Peran dalam Kasus**                                   | **Contoh Keputusan**                                                                   |
|:-------|:--------------------------------------|:--------------------------------------------------------|:---------------------------------------------------------------------------------------|
| S1     | Wakil Rektor Bidang Akademik          | Mengevaluasi manfaat LMS bagi pembelajaran lintas prodi | Menilai apakah LMS layak dipertahankan atau ditingkatkan                               |
| S2     | Pengelola LMS                         | Mengelola platform dan data aktivitas LMS               | Menentukan indikator keterlibatan yang dipakai dan fitur LMS yang diprioritaskan       |
| S3     | Ketua Program Studi / Pengelola Prodi | Memantau mata kuliah dan mahasiswa prodi                | Menentukan mata kuliah untuk perbaikan desain digital dan mahasiswa untuk pendampingan |

# 3. Dataset UADW yang Digunakan

Raw data dipakai read-only (hanya SELECT); tidak ada cleansing atau ETL pada Unit 1.3. Volume berasal dari profiling Unit 1.2.

| **Dataset**                   | **Kolom Kunci**                                                                           | **Peran**                                 | **Volume (baris / unik)** |
|:------------------------------|:------------------------------------------------------------------------------------------|:------------------------------------------|:--------------------------|
| aktivitas_lms.csv             | lms_event_id, nim, kode_mk, semester_id, waktu_event, tipe_event, durasi_menit, skor_kuis | Keterlibatan mahasiswa di LMS             | 200.356 / 200.326 event   |
| krs.csv                       | krs_id, nim, kode_mk, semester_id                                                         | Populasi mahasiswa--mata kuliah--semester | 57.025 / 57.000           |
| nilai.csv                     | nim, kode_mk, semester_id, nilai_angka, status_lulus                                      | Hasil belajar                             | 57.000 / 57.000           |
| mahasiswa.csv                 | nim, kode_prodi_raw, prodi_raw, angkatan                                                  | Profil dan program studi                  | 1.965 / 1.950 NIM         |
| mata_kuliah.csv               | kode_mk, nama_mk, kode_prodi, sks, kategori                                               | Konteks mata kuliah                       | 208 / 208                 |
| semester.csv                  | semester_id, tahun_akademik, term, tanggal_mulai                                          | Konteks waktu akademik                    | 8 / 8                     |
| program_studi.csv (pelengkap) | kode_prodi, nama_prodi                                                                    | Acuan canonical program studi             | 6 / 6                     |

# 4. Problem Statement

- **Current condition:** Data aktivitas LMS (200.326 event unik), KRS, nilai, profil mahasiswa, dan mata kuliah tersimpan di tabel terpisah; LMS baru dilaporkan sebagai jumlah login atau jumlah aktivitas.

- **Problem:** Pimpinan belum tahu apakah keterlibatan di LMS berkaitan dengan hasil belajar, mata kuliah mana yang aktivitasnya tinggi tetapi hasilnya rendah, dan mahasiswa mana yang keterlibatannya rendah.

- **Impact:** Evaluasi LMS dan desain pembelajaran digital tidak berbasis bukti, pendampingan mahasiswa terlambat, dan angka mentah seperti jumlah event berisiko ditafsirkan menyesatkan.

- **Analytical need:** Analisis historis dan komparatif yang menghubungkan indikator keterlibatan LMS (volume, durasi, konsistensi, jenis aktivitas) dengan nilai pada tingkat mahasiswa--mata kuliah--semester, dibandingkan antar-semester, mata kuliah, dan prodi.

Pernyataan ini dapat ditelusuri ke S1 (kelayakan LMS), S2 (indikator keterlibatan), dan S3 (perbaikan mata kuliah dan pendampingan).

# 5. Business Process yang Relevan

| **ID** | **Proses Bisnis**             | **Deskripsi**                                                                            | **Dataset**                | **Keputusan terkait** |
|:-------|:------------------------------|:-----------------------------------------------------------------------------------------|:---------------------------|:----------------------|
| BP1    | Aktivitas pembelajaran di LMS | Mahasiswa mengakses materi, mengerjakan kuis dan tugas, dan berinteraksi di LMS.         | aktivitas_lms              | DR1--DR6              |
| BP2    | Pengambilan mata kuliah (KRS) | Menentukan populasi mahasiswa--mata kuliah--semester yang seharusnya memiliki aktivitas. | krs, mata_kuliah, semester | DR1, DR3, DR4         |
| BP3    | Penilaian mahasiswa           | Mahasiswa memperoleh nilai akhir untuk satu mata kuliah pada satu semester.              | nilai                      | DR1, DR3, DR4, DR5    |

# 6. Business Objectives dan Decision Requirements

**Business Objectives**

- **O1** -- Mengevaluasi apakah penggunaan LMS mendukung hasil belajar mahasiswa.

- **O2** -- Mengidentifikasi mata kuliah yang membutuhkan perbaikan desain pembelajaran digital.

- **O3** -- Mengidentifikasi mahasiswa yang berpotensi membutuhkan pendampingan berdasarkan indikator awal keterlibatan.

- **O4** -- Membandingkan pola keterlibatan antar-semester, antar-mata kuliah, dan antar-prodi.

**Decision Requirements**

| **ID** | **Decision Requirement**                                                                                            | **Stakeholder**                            | **Objective** |
|:-------|:--------------------------------------------------------------------------------------------------------------------|:-------------------------------------------|:--------------|
| DR1    | Menilai apakah LMS layak dipertahankan atau ditingkatkan berdasarkan hubungan keterlibatan dan nilai.               | Wakil Rektor Akademik                      | O1            |
| DR2    | Menentukan jenis aktivitas LMS yang relevan sebagai indikator keterlibatan, bukan sekadar login.                    | Pengelola LMS                              | O1, O3        |
| DR3    | Menentukan mata kuliah dengan aktivitas LMS tinggi tetapi nilai rendah untuk perbaikan desain pembelajaran digital. | Ketua Program Studi                        | O2            |
| DR4    | Menentukan mahasiswa dengan keterlibatan rendah yang perlu pendampingan.                                            | Ketua Program Studi                        | O3            |
| DR5    | Membandingkan pola keterlibatan dan nilai antar-semester, antar-mata kuliah, dan antar-prodi.                       | Wakil Rektor Akademik, Ketua Program Studi | O4            |
| DR6    | Menilai apakah pola waktu aktivitas (menjelang ujian atau konsisten) layak menjadi indikator awal keterlibatan.     | Pengelola LMS, Ketua Program Studi         | O3            |

# 7. Sheet 01_Stakeholder (Kebutuhan Informasi dan Keputusan)

| **Stakeholder**                       | **Kebutuhan Informasi**                                                                           | **Decision Supported**                                                                 | **Priority** |
|:--------------------------------------|:--------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------|:-------------|
| Wakil Rektor Bidang Akademik          | Hubungan keterlibatan LMS dengan nilai, serta perbandingan antar-prodi dan antar-semester         | Menilai apakah LMS layak dipertahankan atau ditingkatkan                               | High         |
| Pengelola LMS                         | Jenis aktivitas dan pola waktu (menjelang ujian atau konsisten) yang berkaitan dengan nilai       | Menentukan indikator keterlibatan yang dipakai dan fitur LMS yang diprioritaskan       | High         |
| Ketua Program Studi / Pengelola Prodi | Mata kuliah dengan aktivitas LMS tinggi tetapi nilai rendah; mahasiswa dengan keterlibatan rendah | Menentukan mata kuliah untuk perbaikan desain digital dan mahasiswa untuk pendampingan | High         |

# 8. Sheet 02_Analytical_Questions

| **ID** | **Analytical Question**                                                                                                                                     | **Tipe**     | **Stakeholder / DR** |
|:-------|:------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------|:---------------------|
| AQ01   | Apakah mahasiswa dengan aktivitas LMS rendah cenderung memiliki nilai akhir lebih rendah pada mata kuliah dan semester yang sama?                           | Relationship | S1, S3 / DR1, DR4    |
| AQ02   | Apakah mahasiswa yang aktif menjelang akhir semester (periode ujian) memiliki performa berbeda dibanding mahasiswa yang aktif konsisten sepanjang semester? | Comparison   | S2, S3 / DR6         |
| AQ03   | Mata kuliah mana yang memiliki aktivitas LMS tinggi tetapi rata-rata nilai rendah atau failure rate tinggi?                                                 | Ranking      | S3 / DR3             |
| AQ04   | Bagaimana tingkat keterlibatan LMS (event dan durasi per mahasiswa) berubah antar-semester?                                                                 | Trend        | S1 / DR5             |
| AQ05   | Mata kuliah mana yang keterlibatan LMS-nya tertinggi dan terendah, dan bagaimana sebarannya antar kategori mata kuliah?                                     | Ranking      | S3 / DR3, DR5        |
| AQ06   | Bagaimana keterlibatan LMS dan rata-rata nilai dibandingkan antar-prodi pada semester yang sama?                                                            | Comparison   | S1, S3 / DR5         |
| AQ07   | Jenis aktivitas LMS (tipe_event) mana yang paling berkaitan dengan nilai akhir?                                                                             | Comparison   | S2 / DR2             |
| AQ08   | Mahasiswa mana yang keterlibatan LMS-nya rendah pada suatu semester dan berpotensi membutuhkan pendampingan?                                                | Ranking      | S3 / DR4             |
| AQ09   | Apakah keterlibatan mahasiswa menurun dari awal ke akhir semester, dan apakah penurunan itu berkaitan dengan nilai rendah?                                  | Trend        | S2, S3 / DR6         |
| AQ10   | Apakah skor kuis di LMS berkaitan dengan nilai akhir mata kuliah?                                                                                           | Relationship | S2 / DR2             |
| AQ11   | Berapa proporsi mahasiswa--mata kuliah--semester di KRS yang tidak memiliki aktivitas LMS sama sekali, dan bagaimana nilainya dibanding yang memiliki?      | Comparison   | S1, S2 / DR1         |
| AQ12   | Apakah hubungan keterlibatan--nilai konsisten antar-prodi dan antar-semester?                                                                               | Relationship | S1 / DR1, DR5        |

Catatan: AQ01, AQ02, AQ09, AQ10, dan AQ12 hanya menunjukkan asosiasi, bukan sebab-akibat. Ambang 'rendah' dan 'tinggi' (asumsi awal: kuartil) dan batas periode ujian (asumsi awal: 14 hari terakhir semester) perlu disepakati stakeholder.

# 9. Sheet 03_KPI_Dictionary

| **ID** | **KPI**                      | **Definisi**                                                                         | **Formula Konseptual**                                                                                       | **Caveat utama**                                                                                               |
|:-------|:-----------------------------|:-------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------|
| K1     | LMS Engagement Level         | Tingkat keterlibatan mahasiswa pada satu mata kuliah di satu semester.               | Jumlah event unik dan total durasi_menit per (nim, kode_mk, semester_id), dikelompokkan rendah/sedang/tinggi | Dedup 30 event; hanya tipe_event yang relevan (ditetapkan Pengelola LMS); pengelompokan kuartil adalah asumsi. |
| K2     | Active Days Ratio            | Konsistensi aktivitas mahasiswa sepanjang semester.                                  | Hari berbeda dengan event / jumlah hari semester × 100%                                                      | 825 event berada sebelum semester mulai; atribusi lewat semester_id.                                           |
| K3     | Pre-Exam Activity Share      | Porsi aktivitas yang terjadi menjelang ujian.                                        | Event pada N hari terakhir semester / total event × 100%                                                     | Tidak ada jadwal ujian di dataset; akhir semester jadi proxy (N = 14, asumsi).                                 |
| K4     | Average Final Grade          | Rata-rata nilai akhir numerik pada kelompok dan periode tertentu.                    | SUM(nilai_angka valid) / COUNT(record nilai valid)                                                           | 12 nilai di luar domain dan 20 kosong dikecualikan.                                                            |
| K5     | Course Failure Rate          | Persentase record nilai valid berstatus tidak lulus pada suatu mata kuliah.          | Failed Grade Records / Valid Grade Records × 100%                                                            | 17 status_lulus kontradiktif dengan huruf mutu; failure flag harus divalidasi.                                 |
| K6     | Average Quiz Score           | Rata-rata skor kuis di LMS.                                                          | AVG(skor_kuis) untuk event kuis                                                                              | skor_kuis kosong 79,88% (struktural); hanya event kuis, kosong tidak diimputasi.                               |
| K7     | High-Activity Low-Grade Flag | Penanda mata kuliah dengan keterlibatan di atas median tetapi nilai di bawah median. | Flag = (K1 mata kuliah \> median semua MK) dan (K4 mata kuliah \< median semua MK)                           | Median dan arti 'tinggi/rendah' disepakati stakeholder; asosiasi, bukan sebab-akibat.                          |
| K8     | Low-Engagement Student Count | Jumlah mahasiswa unik dengan keterlibatan rendah pada satu semester.                 | COUNT(DISTINCT nim) dengan K1 = rendah                                                                       | Ambang kuartil bawah adalah asumsi; populasi mengacu KRS dan perlu dedup mahasiswa.                            |
| K9     | Zero-LMS Enrollment Rate     | Proporsi pengambilan mata kuliah (KRS) tanpa aktivitas LMS sama sekali.              | KRS tanpa event / total KRS unik × 100%                                                                      | KRS didedup (25 baris ganda); cakupan KRS terhadap LMS belum diprofiling (F07).                                |

# 10. Sheet 04_Data_Requirements

| **AQ** | **Measure**                                            | **Context dan Time**                          | **Required Data Elements**                                                     |
|:-------|:-------------------------------------------------------|:----------------------------------------------|:-------------------------------------------------------------------------------|
| AQ01   | Total event, total durasi, rata-rata nilai             | Mahasiswa, mata kuliah; Semester              | lms_event_id, nim, kode_mk, semester_id, durasi_menit, nilai_angka             |
| AQ02   | Share aktivitas akhir semester, hari aktif, nilai      | Mahasiswa, mata kuliah; Hari dalam semester   | waktu_event, semester_id, tanggal semester, nim, kode_mk, nilai_angka          |
| AQ03   | Event dan durasi per MK, rata-rata nilai, failure rate | Mata kuliah; Semester                         | kode_mk, nama_mk, lms_event_id, semester_id, nilai_angka, status_lulus         |
| AQ04   | Event dan durasi per mahasiswa                         | Semester, prodi; Semester                     | lms_event_id, nim, semester_id, durasi_menit, kode_prodi_raw                   |
| AQ05   | Event dan durasi per MK                                | Mata kuliah, kategori; Semester               | kode_mk, nama_mk, kategori, lms_event_id, durasi_menit, semester_id            |
| AQ06   | Event, durasi, rata-rata nilai                         | Program studi; Semester                       | nim, kode_prodi_raw, kode_prodi, lms_event_id, nilai_angka, semester_id        |
| AQ07   | Rata-rata nilai per tipe aktivitas                     | Tipe event; Semester                          | tipe_event, lms_event_id, nim, kode_mk, semester_id, nilai_angka               |
| AQ08   | Tingkat keterlibatan per mahasiswa                     | Mahasiswa, prodi, angkatan; Semester          | nim, semester_id, lms_event_id, durasi_menit, kode_prodi_raw, angkatan, krs_id |
| AQ09   | Event per minggu dalam semester, nilai akhir           | Mahasiswa, mata kuliah; Minggu dalam semester | waktu_event, semester_id, tanggal semester, nim, kode_mk, nilai_angka          |
| AQ10   | Rata-rata skor kuis, nilai akhir                       | Mahasiswa, mata kuliah; Semester              | tipe_event, skor_kuis, nim, kode_mk, semester_id, nilai_angka                  |
| AQ11   | Jumlah KRS tanpa event, rata-rata nilai dua kelompok   | KRS (mahasiswa--MK--semester); Semester       | krs_id, nim, kode_mk, semester_id, lms_event_id, nilai_angka                   |
| AQ12   | Selisih nilai antar tingkat keterlibatan               | Program studi; Semester                       | nim, kode_prodi_raw, semester_id, lms_event_id, durasi_menit, nilai_angka      |

# 11. Sheet 05_Source_Mapping

Nama kolom tanggal semester disesuaikan dengan file semester.csv.

| **Data Element**        | **Dataset**                                            | **Column**                                              | **Role**                                      |
|:------------------------|:-------------------------------------------------------|:--------------------------------------------------------|:----------------------------------------------|
| Mahasiswa               | aktivitas_lms.csv; krs.csv; nilai.csv; mahasiswa.csv   | nim                                                     | Key penghubung                                |
| Mata kuliah             | aktivitas_lms.csv; krs.csv; nilai.csv; mata_kuliah.csv | kode_mk                                                 | Key; analytical context                       |
| Atribut mata kuliah     | mata_kuliah.csv                                        | nama_mk, kategori, sks, kode_prodi                      | Atribut dimensi                               |
| Semester                | aktivitas_lms.csv; krs.csv; nilai.csv; semester.csv    | semester_id                                             | Time context                                  |
| Waktu akademik          | semester.csv                                           | tahun_akademik, term, tanggal_mulai (dan tanggal akhir) | Dasar hari semester dan periode ujian (proxy) |
| Event LMS               | aktivitas_lms.csv                                      | lms_event_id                                            | Grain; jumlah event                           |
| Waktu event             | aktivitas_lms.csv                                      | waktu_event                                             | Konsistensi dan pola menjelang ujian          |
| Tipe aktivitas          | aktivitas_lms.csv                                      | tipe_event                                              | Memilih aktivitas relevan                     |
| Durasi                  | aktivitas_lms.csv                                      | durasi_menit                                            | Measure keterlibatan                          |
| Skor kuis               | aktivitas_lms.csv                                      | skor_kuis                                               | Measure (khusus kuis)                         |
| Populasi KRS            | krs.csv                                                | krs_id, nim, kode_mk, semester_id                       | Populasi mahasiswa--MK--semester              |
| Nilai akhir             | nilai.csv                                              | nilai_angka                                             | Measure hasil belajar                         |
| Status lulus            | nilai.csv                                              | status_lulus                                            | Klasifikasi lulus/gagal                       |
| Program studi mahasiswa | mahasiswa.csv; program_studi.csv                       | kode_prodi_raw; kode_prodi, nama_prodi                  | Atribut prodi                                 |
| Angkatan                | mahasiswa.csv                                          | angkatan                                                | Konteks cohort                                |

# 12. Sheet 06_Data_Fitness

Penilaian memakai temuan profiling Unit 1.2. Ringkasan: 4 READY, 12 CONDITIONALLY READY, 2 NOT READY. Tidak ada data yang diperbaiki pada Unit 1.3.

| **ID** | **Data Element**                                | **Temuan Unit 1.2**                                                                                                                       | **Status**              | **Required Action**                                                                     |
|:-------|:------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------|:------------------------|:----------------------------------------------------------------------------------------|
| F01    | aktivitas_lms.lms_event_id                      | DUP04 / A04: 200.356 baris vs 200.326 unik; 30 duplikat persis (duplikasi teknis).                                                        | **CONDITIONALLY READY** | Dedup berdasarkan lms_event_id.                                                         |
| F02    | aktivitas_lms.waktu_event                       | VAL14 / A20: 825 event 1--5 hari sebelum tanggal mulai semester.                                                                          | **CONDITIONALLY READY** | Atribusi semester memakai semester_id; tentukan aturan event pra-semester.              |
| F03    | aktivitas_lms.skor_kuis                         | MIS05 / A24 / PAT07: 160.035 kosong (79,88%), struktural untuk event non-kuis.                                                            | **CONDITIONALLY READY** | Hitung hanya event kuis; kosong tidak diimputasi.                                       |
| F04    | aktivitas_lms.durasi_menit                      | Column profiling (2.2): Rentang 1--111 menit, tanpa nilai kosong.                                                                         | **READY**               | Tidak ada.                                                                              |
| F05    | aktivitas_lms.tipe_event                        | DST18 / PAT: 5 tipe event; tidak semuanya setara sebagai indikator keterlibatan (sesuai skenario kasus).                                  | **CONDITIONALLY READY** | Pengelola LMS menetapkan tipe event yang dihitung sebelum agregasi.                     |
| F06    | aktivitas_lms (nim, kode_mk, semester_id) → krs | VAL16 / PAT09: 0 orphan: setiap event LMS memiliki pasangan KRS.                                                                          | **READY**               | Tidak ada.                                                                              |
| F07    | krs (nim, kode_mk, semester_id) → aktivitas_lms | Belum diprofiling: Jumlah KRS tanpa aktivitas LMS tidak diketahui.                                                                        | **CONDITIONALLY READY** | Verifikasi: anti-join KRS terhadap LMS pada (nim, kode_mk, semester_id).                |
| F08    | (tidak ada kolom)                               | Column profiling sheet 01--02: Tidak ditemukan kolom jadwal ujian pada tabel yang diprofiling.                                            | **NOT READY**           | Gunakan N hari terakhir semester sebagai proxy atau minta jadwal ujian per mata kuliah. |
| F09    | krs.krs_id                                      | DUP02 / A02: 57.025 baris vs 57.000 unik; 25 duplikat persis.                                                                             | **CONDITIONALLY READY** | Dedup berdasarkan krs_id.                                                               |
| F10    | nilai.nilai_angka                               | VAL01 / MIS02 / A05 / A09: 12 nilai di luar 0--100 (6 \>100, 6 negatif); 20 nilai kosong.                                                 | **CONDITIONALLY READY** | Validasi domain; kecualikan dari record valid; tanpa imputasi; konfirmasi ke SIAKAD.    |
| F11    | nilai.status_lulus                              | VAL04 / A08: 17 baris kontradiktif dengan huruf mutu; 20 baris berstatus tanpa nilai.                                                     | **CONDITIONALLY READY** | Turunkan failure flag dari aturan nilai yang sudah dikonfirmasi.                        |
| F12    | nilai.nilai_huruf                               | VAL02 / VAL03 / A06 / A07: 41.224 dari 56.968 baris (72,4%) tidak cocok skala modul; 20 baris tidak cocok skala yang tampak dipakai data. | **NOT READY**           | Konfirmasi skala resmi; tidak dipakai sebagai measure.                                  |
| F13    | nilai ↔ krs (nim, kode_mk, semester_id)         | VAL16 / DUP05 / PAT09: 57.000 kombinasi cocok dua arah; business key nilai tanpa duplikat.                                                | **READY**               | Tidak ada.                                                                              |
| F14    | mahasiswa.nim                                   | DUP01 / A01: 15 NIM muncul 2× (duplikat persis); 1.965 vs 1.950 unik.                                                                     | **CONDITIONALLY READY** | Dedup berdasarkan nim di staging.                                                       |
| F15    | mahasiswa.kode_prodi_raw                        | VAL06 / A11: 208 baris berspasi/huruf kecil; cocok 100% setelah UPPER(TRIM()).                                                            | **CONDITIONALLY READY** | Standardisasi UPPER(TRIM()) sebelum join.                                               |
| F16    | mahasiswa.prodi_raw                             | VAL05 / A10: 30 label untuk 6 prodi; 435 baris (22,14%) tidak canonical.                                                                  | **CONDITIONALLY READY** | Mapping lewat kode_prodi, bukan nama.                                                   |
| F17    | mata_kuliah.nama_mk, kode_prodi                 | DUP08 / A23: 145 nama untuk 208 kode_mk (63 nama berulang antar-prodi); 16 MKU berkode ALL.                                               | **CONDITIONALLY READY** | Analisis memakai kode_mk; atribusi prodi MKU lewat prodi mahasiswa.                     |
| F18    | semester.semester_id                            | Table/Column profiling: 8 semester unik 2021G--2024E, tanpa kosong atau duplikat.                                                         | **READY**               | Tidak ada.                                                                              |

# 13. Sheet 07_Candidate_Model

Ini candidate model, bukan Star Schema final. Dimensi kandidat: Mahasiswa, Mata Kuliah, Semester/Waktu, Program Studi, dan Tipe Event.

| **ID** | **Candidate Grain**                                                                           | **Fact**                     | **Dimensions**                                      | **Measures**                                                                     | **Source**                         |
|:-------|:----------------------------------------------------------------------------------------------|:-----------------------------|:----------------------------------------------------|:---------------------------------------------------------------------------------|:-----------------------------------|
| CG1    | Satu event aktivitas LMS seorang mahasiswa pada satu mata kuliah.                             | Aktivitas LMS                | Mahasiswa; Mata Kuliah; Semester; Tipe Event; Waktu | durasi_menit; skor_kuis; jumlah event                                            | aktivitas_lms.csv (200.326 unik)   |
| CG2    | Satu nilai akhir seorang mahasiswa untuk satu mata kuliah pada satu semester.                 | Nilai                        | Mahasiswa; Mata Kuliah; Semester; Program Studi     | nilai_angka; indikator lulus/gagal                                               | nilai.csv (57.000)                 |
| CG3    | Satu pengambilan mata kuliah oleh seorang mahasiswa pada satu semester.                       | KRS                          | Mahasiswa; Mata Kuliah; Semester                    | jumlah pengambilan (penyebut populasi)                                           | krs.csv (57.000 unik)              |
| CG4    | Ringkasan keterlibatan satu mahasiswa pada satu mata kuliah pada satu semester (turunan CG1). | Engagement Summary (agregat) | Mahasiswa; Mata Kuliah; Semester                    | total event; total durasi; hari aktif; share akhir semester; rata-rata skor kuis | Diturunkan dari CG1 (maks. 57.000) |

**Reasoning:** CG1 punya volume terbesar dan grain jauh lebih halus daripada CG2 dan CG3. Bila CG1 digabung langsung dengan nilai, setiap nilai terhitung sebanyak jumlah event sehingga rata-rata nilai menjadi berbobot jumlah event dan menyesatkan. Karena itu CG1 diagregasi dulu ke grain mahasiswa--mata kuliah--semester (CG4), lalu dibandingkan dengan CG2; CG3 menjadi penyebut populasi untuk mahasiswa tanpa aktivitas LMS.

# 14. Sheet 08_Traceability

Rantai pembacaan: Business Problem → Objective → Decision Requirement → Analytical Question → KPI → Required Data → Source Dataset + Column → Data Fitness → Candidate Model.

| **AQ** | **Stkh.** | **Obj.** | **DR**   | **KPI**        | **Source Dataset + Column**                                                                         | **Data Fitness**                             | **Candidate** |
|:-------|:----------|:---------|:---------|:---------------|:----------------------------------------------------------------------------------------------------|:---------------------------------------------|:--------------|
| AQ01   | S1, S3    | O1, O3   | DR1, DR4 | K1, K4         | aktivitas_lms.csv (lms_event_id, nim, kode_mk, semester_id, durasi_menit) + nilai.csv (nilai_angka) | **CONDITIONALLY READY (F01, F05, F10, F13)** | CG4, CG2      |
| AQ02   | S2, S3    | O3       | DR6      | K2, K3, K4     | aktivitas_lms.csv (waktu_event) + semester.csv (tanggal semester) + nilai.csv                       | **CONDITIONALLY READY (F02, F08, F10)**      | CG1, CG4, CG2 |
| AQ03   | S3        | O2       | DR3      | K1, K4, K5, K7 | aktivitas_lms.csv + nilai.csv (nilai_angka, status_lulus) + mata_kuliah.csv (nama_mk)               | **CONDITIONALLY READY (F01, F10, F11, F17)** | CG4, CG2      |
| AQ04   | S1        | O4       | DR5      | K1             | aktivitas_lms.csv + semester.csv + mahasiswa.csv (kode_prodi_raw)                                   | **CONDITIONALLY READY (F01, F02, F18)**      | CG1, CG4      |
| AQ05   | S3        | O2, O4   | DR3, DR5 | K1             | aktivitas_lms.csv + mata_kuliah.csv (kode_mk, nama_mk, kategori)                                    | **CONDITIONALLY READY (F01, F17)**           | CG4           |
| AQ06   | S1, S3    | O4       | DR5      | K1, K4         | aktivitas_lms.csv + nilai.csv + mahasiswa.csv + program_studi.csv                                   | **CONDITIONALLY READY (F14, F15, F16)**      | CG4, CG2      |
| AQ07   | S2        | O1       | DR2      | K1, K4         | aktivitas_lms.csv (tipe_event) + nilai.csv (nilai_angka)                                            | **CONDITIONALLY READY (F05, F10)**           | CG1, CG2      |
| AQ08   | S3        | O3       | DR4      | K1, K8         | aktivitas_lms.csv + krs.csv + mahasiswa.csv (angkatan, kode_prodi_raw)                              | **CONDITIONALLY READY (F07, F09, F14)**      | CG4, CG3      |
| AQ09   | S2, S3    | O3       | DR6      | K2, K4         | aktivitas_lms.csv (waktu_event) + semester.csv + nilai.csv                                          | **CONDITIONALLY READY (F01, F02)**           | CG1, CG2      |
| AQ10   | S2        | O1       | DR2      | K6, K4         | aktivitas_lms.csv (tipe_event, skor_kuis) + nilai.csv                                               | **CONDITIONALLY READY (F03, F10)**           | CG1, CG2      |
| AQ11   | S1, S2    | O1       | DR1      | K9, K4         | krs.csv (krs_id) + aktivitas_lms.csv + nilai.csv                                                    | **CONDITIONALLY READY (F06, F07, F09)**      | CG3, CG4, CG2 |
| AQ12   | S1        | O1, O4   | DR1, DR5 | K1, K4         | aktivitas_lms.csv + nilai.csv + mahasiswa.csv (kode_prodi_raw)                                      | **CONDITIONALLY READY (F01, F10, F15)**      | CG4, CG2      |

# 15. Mini-Workflow Penyelesaian Kasus

1.  Narasi kasus dibaca (bagian 1).

2.  Stakeholder dan keputusan ditentukan (bagian 2, 7).

3.  Business objectives dirumuskan (bagian 6).

4.  Dua belas analytical questions disusun (bagian 8).

5.  Sembilan KPI didefinisikan (bagian 9).

6.  AQ didekomposisi menjadi kebutuhan data (bagian 10).

7.  Data element dipetakan ke dataset dan kolom (bagian 11).

8.  Temuan profiling Unit 1.2 diambil kembali (bagian 12).

9.  Data fitness dinilai dengan alasan dan required action (bagian 12).

10. Candidate grain, fact, dimension, dan measure ditentukan (bagian 13).

11. Traceability end-to-end dibangun (bagian 14).

# 16. Pembagian Kerja Kelompok

| **Peran**            | **Tanggung Jawab**                           | **Bagian laporan** | **Nama**            |
|:---------------------|:---------------------------------------------|:-------------------|:--------------------|
| Business Analyst     | Stakeholder, objective, decision requirement | 2, 4--7            | (Alda Syafitri)     |
| Analytical Designer  | Analytical questions dan KPI                 | 8, 9               | (Minazati Ifada)    |
| Data Analyst         | Data requirements dan source mapping         | 3, 10, 11          | (Eka Yuliana Rizky) |
| Data Quality Analyst | Profiling findings dan data fitness          | 12                 | (Baiq Nadya Fairuz) |
| Integration Reviewer | Candidate model dan traceability             | 13, 14             | (Kerjain Bersama)   |

# 17. Target Minimum dan Capaian

| **Luaran**                | **Minimum** | **Capaian**   |
|:--------------------------|:------------|:--------------|
| Problem Statement         | 1           | 1             |
| Business Process          | 3           | 3             |
| Stakeholder               | 3           | 3             |
| Business Objective        | 3           | 4             |
| Decision Requirement      | 5           | 6             |
| Analytical Questions      | 10          | 12            |
| Metric / KPI              | 5           | 9             |
| Profiling findings reused | 5           | 18            |
| Candidate Grain           | 2           | 4             |
| Requirement Traceability  | seluruh AQ  | 12 dari 12 AQ |

# 18. Bukti yang Ditunjukkan

1.  Profiling Unit 1.2 yang dirujuk: DUP01, DUP02, DUP04, DUP05, DUP08, VAL01, VAL02, VAL04, VAL05, VAL06, VAL14, VAL16, MIS02, MIS05, DST18 (bagian 12).

2.  Dataset dan kolom pendukung tiap data requirement: bagian 10 dan 11.

3.  Alasan status READY / CONDITIONALLY READY / NOT READY: kolom Temuan dan Required Action pada bagian 12.

4.  Hubungan AQ dengan stakeholder dan decision supported: bagian 8 dan 14.

5.  Hubungan KPI dengan data source: bagian 9 sampai 11.

6.  Reasoning candidate grain, fact, dimension, measure: bagian 13.

# 19. Checklist Sebelum Submit

- Problem statement mengikuti Current Condition → Problem → Impact → Analytical Need. (selesai)

- Tiga stakeholder atau lebih, masing-masing dengan keputusan yang jelas (3). (selesai)

- Tiga business objectives atau lebih (4). (selesai)

- Lima decision requirements atau lebih (6). (selesai)

- Sepuluh analytical questions atau lebih (12), tiap AQ punya stakeholder dan decision. (selesai)

- Lima KPI atau lebih dengan definisi dan formula konseptual (9). (selesai)

- Tiap AQ dipecah menjadi data requirements dan dipetakan ke dataset + column. (selesai)

- Lima temuan profiling atau lebih dipakai ulang (18). (selesai)

- Data fitness memiliki alasan dan required action. (selesai)

- Dua candidate grain atau lebih (4); belum menjadi Star Schema final. (selesai)

- Traceability dapat dibaca end-to-end. (selesai)

- RAW DATA tidak dimodifikasi. (selesai)

# 20. Rantai Reasoning (contoh AQ03)

Kaprodi perlu menentukan mata kuliah yang aktivitas LMS-nya tinggi tetapi hasil belajarnya rendah untuk perbaikan desain pembelajaran digital (DR3, objective O2). Karena itu AQ03 membandingkan keterlibatan LMS dan nilai per mata kuliah, dengan KPI LMS Engagement Level (K1), Average Final Grade (K4), Course Failure Rate (K5), dan High-Activity Low-Grade Flag (K7). Data yang diperlukan adalah kode_mk, nama_mk, lms_event_id, durasi_menit, semester_id, nilai_angka, dan status_lulus, bersumber dari aktivitas_lms.csv, nilai.csv, dan mata_kuliah.csv. Profiling menunjukkan 30 event LMS ganda, 12 nilai di luar domain, 20 nilai kosong, 17 status_lulus kontradiktif, dan 63 nama mata kuliah berulang antar-prodi, sehingga statusnya CONDITIONALLY READY dengan required action dedup event, validasi domain nilai, dan analisis memakai kode_mk. Candidate grain: ringkasan keterlibatan per mahasiswa--mata kuliah--semester (CG4) dibandingkan dengan nilai (CG2).

Pola yang sama berlaku untuk AQ lain: keputusan → AQ → KPI → data → source → fitness → candidate model.

# 21. Tantangan Tambahan

Dipilih opsi 3: AQ yang tidak dapat dijawab dengan baik oleh UADW v1.0.

| **Kebutuhan**                                          | **Mengapa belum bisa dijawab**                                                         | **Data tambahan yang dibutuhkan**                                           |
|:-------------------------------------------------------|:---------------------------------------------------------------------------------------|:----------------------------------------------------------------------------|
| Aktif 'menjelang ujian' secara tepat (AQ02, K3)        | Tidak ada jadwal ujian; hanya akhir semester sebagai proxy                             | Jadwal ujian per mata kuliah dan semester                                   |
| Penyebab rendahnya keterlibatan atau nilai             | Data observasional; hanya asosiasi yang dapat ditunjukkan                              | Faktor lain (beban kerja, perangkat, kualitas materi) dan desain pembanding |
| Kualitas desain pembelajaran digital per mata kuliah   | Dataset hanya mencatat aktivitas, bukan isi atau struktur materi                       | Katalog konten dan struktur kelas di LMS                                    |
| Keterlibatan di luar LMS (tatap muka, belajar mandiri) | Tidak tercatat di dataset                                                              | Data kehadiran dan aktivitas pembelajaran lain                              |
| Pendampingan mahasiswa oleh dosen tertentu             | Tidak ada relasi dosen pendamping--mahasiswa; dosen tidak terhubung ke transaksi (A25) | Tabel penugasan dosen wali atau pendamping                                  |
| Huruf mutu sebagai indikator hasil belajar             | Skala modul dan skala data berbeda                                                     | Skala konversi nilai resmi                                                  |

# 22. Prinsip Penutup

- **Mulai dari keputusan, bukan tabel.** Seluruh AQ diturunkan dari enam decision requirement (bagian 6 dan 8).

- **Setiap AQ mempunyai alasan bisnis.** Tiap AQ terhubung ke stakeholder, DR, dan objective (bagian 14).

- **Setiap KPI dapat diturunkan menjadi kebutuhan data.** Sembilan KPI dipetakan ke elemen data dan source (bagian 9 sampai 11).

- **Setiap kebutuhan data ditelusuri ke source.** Pemetaan sampai tingkat dataset dan kolom (bagian 11).

- **Data fitness didukung bukti profiling.** Delapan belas temuan Unit 1.2 dirujuk dengan angka (bagian 12).

**Asumsi yang perlu dikonfirmasi:** ambang keterlibatan rendah dan tinggi (kuartil), periode menjelang ujian (14 hari terakhir semester), dan daftar tipe_event yang dihitung sebagai keterlibatan (ditetapkan Pengelola LMS). Ketiganya diajukan sebagai asumsi awal sampai dikonfirmasi.
