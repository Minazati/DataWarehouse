# LAPORAN MODUL 1 UNIT 1.3

## Identitas Laporan
Nama       : Minazati Ifada
NIM        : 240306035
Kelas      : A  
Kelompok   : 4  
Program Studi : Teknologi Informasi
Modul      : 1  
Unit       : 1.3  
Tanggal Praktikum : 5 November 2026 

---

## Studi Kasus
Universitas Digital Nusantara menemukan bahwa evaluasi akademik masih banyak dilakukan secara terpisah oleh program studi. Kaprodi dapat melihat nilai mahasiswa, tetapi belum memiliki informasi terintegrasi untuk menjawab pertanyaan seperti: mata kuliah mana yang paling sering menjadi hambatan, kelompok mahasiswa mana yang perlu mendapat intervensi lebih awal, apakah aktivitas pembelajaran di LMS berkaitan dengan performa nilai, dan pola apa yang muncul pada mahasiswa yang lulus tidak tepat waktu.

Wakil Rektor Bidang Akademik meminta tim Data Warehouse menyiapkan dasar kebutuhan analitik untuk mendukung program peningkatan keberhasilan studi dan kelulusan tepat waktu. Tim belum diminta membangun Star Schema atau ETL. Tugas pada Unit 1.3 adalah menerjemahkan masalah tersebut menjadi kebutuhan informasi dan kebutuhan data yang dapat ditelusuri ke dataset UADW v1.0.

Keputusan yang akan didukung antara lain:
- menentukan mata kuliah yang perlu mendapat evaluasi atau program remedial;
- menentukan kelompok mahasiswa yang perlu mendapat pendampingan akademik lebih awal;
- menentukan periode/angkatan/prodi yang menunjukkan penurunan performa;
- menilai apakah aktivitas LMS dapat menjadi indikator pendukung risiko akademik;
- mengevaluasi pola yang berkaitan dengan kelulusan tepat waktu.

Batas kasus: fokus utama adalah keberhasilan akademik dan kelulusan tepat waktu. Data pembayaran boleh digunakan sebagai pengayaan, tetapi tidak wajib (pada laporan ini tidak digunakan).

---

## 1. Identifikasi Stakeholder
Langkah pertama adalah mengidentifikasi pemangku kepentingan dari studi kasus ini. Stakeholder yang berhasil diidentifikasi adalah sebagai berikut:

| Stakeholder | Information Need | Decision Supported | Priority |
|---|---|---|---|
| Wakil Rektor Bidang Akademik | Gambaran terintegrasi performa akademik dan kelulusan tepat waktu lintas program studi dan angkatan | Menetapkan program peningkatan keberhasilan studi dan kelulusan tepat waktu tingkat universitas | High |
| Kepala Program Studi (Kaprodi) | Mata kuliah dengan tingkat ketidaklulusan tinggi, tren performa prodi, dan pola kelulusan tepat waktu | Menentukan mata kuliah yang perlu dievaluasi atau remedial dan prodi/angkatan yang perlu perhatian | High |
| Dosen Pengampu / Koordinator Mata Kuliah | Sebaran nilai dan tingkat kegagalan pada mata kuliah yang diampu serta keterlibatan mahasiswa di LMS | Mengevaluasi metode pengajaran, penilaian, dan materi LMS | Medium |
| Dosen Pembimbing Akademik / Bagian Akademik | Daftar kelompok mahasiswa berisiko (nilai rendah, aktivitas LMS rendah) | Menentukan mahasiswa yang perlu pendampingan akademik lebih awal | Medium |
| Tim Data Warehouse | Kualitas dan kesiapan data sumber untuk memenuhi kebutuhan analitik | Menentukan prioritas pembersihan data dan kandidat model | Medium |

## 2. Problem Statement
Berdasarkan studi kasus di atas, pertanyaan pemantik dijawab sebagai berikut:

1. Bagaimana kondisi sekarang? [Kondisi]

    > Evaluasi akademik dilakukan terpisah oleh masing-masing program studi. Kaprodi hanya dapat melihat nilai mahasiswa pada prodinya, sedangkan data KRS, nilai, aktivitas LMS, dan kelulusan tersimpan pada sumber terpisah.

2. Apa yang belum dapat dilakukan? [Masalah]

    > Universitas belum memiliki informasi terintegrasi untuk mengidentifikasi mata kuliah yang menjadi hambatan, menentukan kelompok mahasiswa yang perlu intervensi dini, menilai hubungan aktivitas LMS dengan nilai, serta menemukan pola mahasiswa yang lulus tidak tepat waktu.

3. Apa akibatnya bagi organisasi? [dampak]

    > Intervensi akademik terlambat dan tidak tepat sasaran, mata kuliah bermasalah sulit diprioritaskan, risiko mahasiswa terlambat lulus meningkat, dan keputusan pimpinan tidak berbasis data yang konsisten antarprodi.

4. Informasi apa yang dibutuhkan untuk memperbaiki kondisi tersebut? [kebutuhan analitik]

    > Tingkat ketidaklulusan per mata kuliah dan semester, tren performa per prodi/angkatan, persentase kelulusan tepat waktu, serta hubungan aktivitas LMS dengan nilai.

Menggunakan rumus **Current Condition → Problem → Impact → Analytical Need**, maka **Problem Statement** adalah sebagai berikut:

> **Saat ini evaluasi akademik dilakukan secara terpisah oleh masing-masing program studi, tetapi universitas belum memiliki informasi terintegrasi untuk mengidentifikasi mata kuliah penghambat, mahasiswa yang perlu intervensi dini, hubungan aktivitas LMS dengan nilai, dan pola kelulusan tidak tepat waktu. Akibatnya intervensi akademik terlambat dan tidak tepat sasaran sehingga keberhasilan studi serta kelulusan tepat waktu sulit ditingkatkan. Oleh karena itu diperlukan analisis terintegrasi atas data nilai, KRS, aktivitas LMS, dan kelulusan yang mencakup tingkat ketidaklulusan, tren performa, ketepatan waktu lulus, dan hubungan keterlibatan LMS dengan nilai.**

## 3. Business Process
Business Process disusun dengan rumus **Actor melakukan Event terhadap Object pada Time**.

1. **Kejadian bisnis apa yang menghasilkan data**

    > Pengambilan mata kuliah (KRS), penetapan nilai akhir, aktivitas pembelajaran di LMS, dan penetapan kelulusan mahasiswa.

2. **Siapa Aktor yang berperan**

    > Mahasiswa, dosen pengampu, bagian akademik, dan sistem LMS.

3. **Apa yang menjadi objek dari studi kasus**

    > Mata kuliah yang diambil dan dinilai, hasil studi mahasiswa (nilai), aktivitas belajar di LMS, serta status kelulusan.

4. **Kapan kejadian bisnis terjadi**

    > Per semester (2021 Ganjil s.d. 2024 Genap); aktivitas LMS tercatat 15 Agu 2021 – 10 Jun 2025; kelulusan tercatat pada Juni 2025.

Sehingga, proses bisnis yang berhasil dibuat pada domain:

1. **KRS**

    > Mahasiswa melakukan pengambilan mata kuliah terhadap mata kuliah yang ditawarkan pada awal setiap semester (`tanggal_ambil_raw`, `semester_id`).

2. **Penilaian**

    > Dosen pengampu menetapkan nilai akhir (angka, huruf, status lulus) terhadap mahasiswa pada suatu mata kuliah di akhir semester (`tanggal_input_raw`, `semester_id`).

3. **Aktivitas Pembelajaran LMS**

    > Mahasiswa melakukan aktivitas pembelajaran (login, view_material, assignment_submit, quiz_attempt, forum_post) terhadap mata kuliah pada LMS sepanjang periode perkuliahan.

4. **Kelulusan**

    > Bagian akademik menetapkan kelulusan terhadap mahasiswa yang menyelesaikan studi, beserta IPK akhir, masa studi, dan status tepat waktu pada tanggal kelulusan (`tanggal_lulus_raw`).

## 4. Business Objective
Business Objective menjawab **apa yang ingin dicapai dari studi kasus**, memakai rumus *Verb tindakan + objek yang ingin diperbaiki + tujuan bisnis*.

**Business Objective** dari studi kasus tersebut adalah:

> **BO01** — Meningkatkan kemampuan program studi mengidentifikasi mata kuliah yang secara konsisten memiliki performa rendah agar evaluasi dan program remedial dapat diprioritaskan.
>
> **BO02** — Memperkuat deteksi dini mahasiswa dan kelompok (prodi/angkatan) yang berisiko agar pendampingan akademik dapat diberikan lebih awal.
>
> **BO03** — Mengevaluasi pola kelulusan tepat waktu agar universitas dapat menyusun program peningkatan kelulusan tepat waktu.
>
> **BO04** — Mengevaluasi hubungan aktivitas LMS dengan performa nilai agar aktivitas LMS dapat dipertimbangkan sebagai indikator pendukung risiko akademik.

## 5. Decision Requirement
Decision Requirement menjawab **keputusan apa yang harus dibuat**, dengan template **[Stakeholder] perlu menentukan [keputusan] berdasarkan [informasi].**

> **DR01** — Kaprodi perlu menentukan mata kuliah yang mempunyai tingkat ketidaklulusan tinggi secara konsisten berdasarkan persentase ketidaklulusan per mata kuliah per semester.
>
> **DR02** — Wakil Rektor Bidang Akademik perlu menentukan prodi dan angkatan yang perlu program penguatan berdasarkan tren persentase ketidaklulusan dan persentase kelulusan tepat waktu.
>
> **DR03** — Dosen Pembimbing Akademik/Bagian Akademik perlu menentukan kelompok mahasiswa yang mendapat pendampingan lebih awal berdasarkan perbedaan nilai semester awal antar kelompok predikat kelulusan (Cukup, Memuaskan, Sangat Memuaskan) dan, bila data pembanding tersedia, antara lulusan tepat waktu dan terlambat.
>
> **DR04** — Dosen Pengampu dan Kaprodi perlu menentukan apakah aktivitas LMS layak menjadi indikator pendukung risiko akademik berdasarkan pola hubungan aktivitas LMS dengan nilai.

## 6. Analytical Questions
Analytical question disusun dengan rumus **Metric + Dimension + Time + Comparison** dan empat pola pertanyaan berikut:

1. Trend

    > Bagaimana perubahan **persentase ketidaklulusan** berdasarkan **program studi** dari **semester 2021G** ke **semester 2024E**?

2. Comparison

    > Bagaimana perbedaan **persentase kelulusan tepat waktu** antara **prodi A** dan **prodi B**?

3. Ranking

    > Mata kuliah (**dimension**) apa yang memiliki **persentase ketidaklulusan** (**metric**) tertinggi pada setiap **semester**?

4. Relationship

    > Bagaimana pola hubungan antara **jumlah/durasi aktivitas LMS** dan **nilai angka** pada suatu mata kuliah?

Sehingga analytical question dapat disimpulkan dalam tabel berikut:

| AQ | Analytical Question | Stakeholder | Decision | Priority |
|---|---|---|---|---|
| AQ01 | Mata kuliah apa yang memiliki tingkat ketidaklulusan tertinggi pada setiap semester? (Ranking) | Kaprodi | DR01 | High |
| AQ02 | Bagaimana perubahan persentase ketidaklulusan setiap program studi dari semester 2021G sampai 2024E? (Trend) | Wakil Rektor Bidang Akademik | DR02 | High |
| AQ03 | Bagaimana perbedaan persentase kelulusan tepat waktu dan rata-rata masa studi antar program studi pada kelompok lulusan yang tercatat? (Comparison) | Wakil Rektor Bidang Akademik; Kaprodi | DR02 | High |
| AQ04 | Bagaimana pola hubungan antara total durasi/jumlah aktivitas LMS dan nilai angka mahasiswa pada setiap mata kuliah? (Relationship) | Dosen Pengampu; Kaprodi | DR04 | Medium |
| AQ05 | Bagaimana perbedaan rata-rata nilai angka pada semester awal antar kelompok predikat kelulusan? (Comparison) | Dosen Pembimbing Akademik / Bagian Akademik | DR03 | High |

## 7. Key Performance Indicator (KPI)
KPI disusun dengan pendekatan top-down:

> Business Objective ⇒ Decision Requirement ⇒ Analytical Questions ⇒ Memilih Bentuk Metriks yang Adil ⇒ Formulasi KPI.

### KPI01 — Course Failure Rate

**Business Objective (BO01)** = Meningkatkan kemampuan program studi mengidentifikasi mata kuliah yang secara konsisten memiliki performa rendah.

**Decision Requirement (DR01)** = Kaprodi perlu menentukan mata kuliah yang mempunyai tingkat ketidaklulusan tinggi secara konsisten.

**Analytical Question (AQ01)** = Mata kuliah apa yang memiliki tingkat ketidaklulusan tertinggi pada setiap semester?

1. **Membedah tujuan bisnis (BO01).** Kata kunci adalah *performa rendah*. Performa mata kuliah diukur dari seberapa banyak mahasiswa memenuhi standar kelulusan; jika banyak mahasiswa gagal, performa mata kuliah tersebut rendah.
2. **Menangkap kebutuhan keputusan (DR01).** Kata kunci adalah *tingkat ketidaklulusan*. Kaprodi memerlukan informasi yang spesifik dan jika tingkatnya tinggi maka perlu intervensi.
3. **Menerjemahkan ke pertanyaan analitis (AQ01).** Measure: tingkat ketidaklulusan; dimension: mata kuliah dan semester; cara mencari: ranking dari yang tertinggi.
4. **Memilih bentuk metrik yang adil.** Dipilih **persentase** (rasio), bukan angka absolut, karena jumlah peserta tiap mata kuliah berbeda. Misalnya 15 dari 20 mahasiswa tidak lulus (75%) lebih parah daripada 20 dari 200 (10%).
5. **Merumuskan KPI final.**

- **KPI Name:** Persentase Ketidaklulusan per Mata Kuliah (Course Failure Rate)
- **Definisi:** Proporsi mahasiswa yang tidak memenuhi standar kelulusan pada suatu mata kuliah dibandingkan total mahasiswa yang memiliki nilai akhir pada mata kuliah tersebut di semester yang sama.
- **Formula:**
  - Numerator: jumlah record nilai pada grain unik mahasiswa–mata kuliah–semester dengan `status_lulus` = `Tidak Lulus` pada mata kuliah tertentu. `nilai_huruf` tidak dipakai sebagai penentu sementara karena ditemukan 20 ketidaksesuaian angka–huruf.
  - Denominator: jumlah mahasiswa unik pada grain mahasiswa–mata kuliah–semester yang memiliki `nilai_angka` valid (0–100) dan `status_lulus` terisi pada mata kuliah tersebut di semester yang sama.
  - Aggregation: `COUNT` pada entitas nilai (mahasiswa–mata kuliah–semester), rasio dikalikan 100%.

$$\left(\frac{\text{COUNT(Mahasiswa Tidak Lulus)}}{\text{COUNT(Total Mahasiswa Peserta Mata Kuliah)}}\right)\times 100\%$$

- **Konteks:** Waktu (tahun akademik, semester Ganjil/Genap), mata kuliah (kode, nama, jenis), program studi, dan dosen pengampu.
- **Caveat:**
  - Bias jumlah peserta kecil: pada mata kuliah dengan peserta sedikit (mis. < 10), 1–2 mahasiswa gagal dapat menyebabkan lonjakan persentase.
  - Nilai kosong (20 baris) dan di luar rentang 0–100 (12 baris) dikeluarkan dari denominator.
  - `status_lulus` konsisten dengan aturan sementara berbasis `nilai_angka` (ambang 60) pada 56.968 nilai valid, tetapi 20 ketidaksesuaian angka–huruf dan 17 ketidaksesuaian huruf–status menunjukkan `nilai_huruf` perlu diverifikasi. Aturan kelulusan tetap harus dikonfirmasi melalui data dictionary/pemilik data.
  - Perubahan kurikulum atau batas kelulusan di tengah periode mengurangi akurasi perbandingan antarsemester.

### KPI02 — On-Time Graduation Rate

**Business Objective (BO03)** = Mengevaluasi pola kelulusan tepat waktu agar universitas dapat menyusun program peningkatan kelulusan tepat waktu.

**Decision Requirement (DR02)** = Wakil Rektor Bidang Akademik perlu menentukan prodi dan angkatan yang perlu program penguatan berdasarkan persentase kelulusan tepat waktu.

**Analytical Question (AQ03)** = Bagaimana perbedaan persentase kelulusan tepat waktu dan rata-rata masa studi antar program studi?

1. **Membedah tujuan bisnis (BO03).** Kata kunci adalah *kelulusan tepat waktu*, yaitu mahasiswa yang menyelesaikan studi sesuai masa studi normal.
2. **Menangkap kebutuhan keputusan (DR02).** Pimpinan perlu membandingkan prodi/angkatan untuk menentukan target program penguatan.
3. **Menerjemahkan ke pertanyaan analitis (AQ03).** Measure: persentase lulusan tepat waktu; dimension: program studi (dan angkatan); cara mencari: perbandingan antarkelompok.
4. **Memilih bentuk metrik yang adil.** Dipilih **persentase** karena jumlah lulusan tiap prodi berbeda; angka absolut lulusan tepat waktu akan menguntungkan prodi yang besar.
5. **Merumuskan KPI final.**

- **KPI Name:** Persentase Kelulusan Tepat Waktu (On-Time Graduation Rate)
- **Definisi:** Proporsi lulusan yang menyelesaikan studi tepat waktu dibandingkan total lulusan pada kelompok yang dianalisis.
- **Formula:**
  - Numerator: jumlah mahasiswa unik pada tabel kelulusan dengan `status_tepat_waktu` = `Ya`.
  - Denominator: jumlah mahasiswa unik (`DISTINCT nim`) pada tabel kelulusan pada kelompok yang sama.
  - Aggregation: `COUNT(DISTINCT nim)` lalu rasio dikalikan 100%.

$$\left(\frac{\text{COUNT(DISTINCT NIM Lulus Tepat Waktu)}}{\text{COUNT(DISTINCT NIM Lulus)}}\right)\times 100\%$$

- **Konteks:** Program studi, angkatan, dan periode kelulusan.
- **Caveat:**
  - Data kelulusan hanya mencakup satu periode (Juni 2025) sehingga persentase hanya menggambarkan kelompok yang sudah lulus, bukan seluruh angkatan; mahasiswa yang belum lulus tidak ikut dihitung.
  - Dua baris kelulusan duplikat (347 baris vs 345 NIM unik) harus dideduplikasi agar tidak membiaskan hasil.
  - Pada data saat ini seluruh 347 record kelulusan berstatus `Ya` (Soal 34 Unit 1.2), sehingga KPI bernilai 100% pada semua program studi dan belum membedakan kinerja. Seluruh lulusan berasal dari angkatan 2021 dengan masa studi 46–47 bulan. KPI perlu dilengkapi `AVG(masa_studi_bulan)` dan baru bermakna setelah data lulusan terlambat atau angkatan berikutnya tersedia.
  - Definisi masa studi normal dan konsistensi `status_tepat_waktu` dengan `masa_studi_bulan` perlu dikonfirmasi.

### KPI03 — LMS Engagement per Mata Kuliah

**Business Objective (BO04)** = Mengevaluasi hubungan aktivitas LMS dengan performa nilai agar aktivitas LMS dapat dipertimbangkan sebagai indikator risiko akademik.

**Decision Requirement (DR04)** = Dosen Pengampu dan Kaprodi perlu menentukan apakah aktivitas LMS layak menjadi indikator pendukung risiko akademik berdasarkan pola hubungannya dengan nilai.

**Analytical Question (AQ04)** = Bagaimana pola hubungan antara total durasi/jumlah aktivitas LMS dan nilai angka pada setiap mata kuliah?

1. **Membedah tujuan bisnis (BO04).** Kata kunci adalah *aktivitas LMS* dan *performa nilai*; keduanya perlu diukur pada level mahasiswa–mata kuliah agar dapat dibandingkan.
2. **Menangkap kebutuhan keputusan (DR04).** Dosen perlu bukti pola hubungan sebelum menjadikan aktivitas LMS sebagai penanda risiko.
3. **Menerjemahkan ke pertanyaan analitis (AQ04).** Measure: jumlah aktivitas dan total durasi LMS per mahasiswa; dimension: mata kuliah; cara mencari: hubungan (relationship) dengan nilai angka.
4. **Memilih bentuk metrik yang adil.** Dipilih **rata-rata per mahasiswa** (bukan total aktivitas), karena jumlah peserta tiap mata kuliah berbeda.
5. **Merumuskan KPI final.**

- **KPI Name:** Rata-rata Aktivitas LMS per Mahasiswa per Mata Kuliah (LMS Engagement)
- **Definisi:** Rata-rata jumlah aktivitas (event) LMS yang dilakukan setiap mahasiswa pada suatu mata kuliah, digunakan sebagai indikator keterlibatan belajar.
- **Formula:**
  - Numerator: `COUNT(DISTINCT lms_event_id)` pada mata kuliah tertentu.
  - Denominator: jumlah mahasiswa yang terdaftar/mengambil mata kuliah pada semester tersebut berdasarkan KRS yang telah diperiksa duplikasinya. Mahasiswa yang tidak memiliki event LMS tetap masuk denominator.
  - Aggregation: rata-rata (rasio numerator terhadap denominator); dapat dilengkapi `AVG(durasi_menit)`.

$$\frac{\text{COUNT(DISTINCT lms\_event\_id)}}{\text{COUNT(DISTINCT NIM pada KRS)}}$$

- **Konteks:** Mata kuliah, tipe aktivitas (`tipe_event`), dan periode (`semester_id` atau `waktu_event`); dibandingkan dengan nilai angka mahasiswa pada mata kuliah yang sama.
- **Caveat:**
  - 30 event LMS duplikat persis harus ditangani pada staging agar jumlah event dan durasi tidak terhitung ganda. Denominator harus berasal dari KRS yang telah diperiksa duplikasinya, bukan hanya mahasiswa yang aktif di LMS.
  - `skor_kuis` hanya terisi pada `quiz_attempt` sehingga rata-rata skor harus dihitung khusus tipe tersebut.
  - Hubungan statistik tidak membuktikan sebab-akibat.

## 8. Data Requirement
Kebutuhan data diturunkan dari measure, context, time, dan filter/comparison pada Analytical Question dan KPI.

1. **AQ01 dan KPI01**

   **Analytical Question (AQ01)** = Mata kuliah apa yang memiliki tingkat ketidaklulusan tertinggi pada setiap semester?

   **Persentase Ketidaklulusan per Mata Kuliah (Course Failure Rate)**, dengan komponen: (1) total mahasiswa tidak lulus dan (2) total mahasiswa per mata kuliah.

   - Measure: jumlah mahasiswa, nilai_angka, hitung failure rate
   - Context: mata kuliah, program studi
   - Time: semester
   - Comparison/filter: nilai valid 0–100; gunakan `status_lulus` sebagai indikator sementara setelah aturan resminya dikonfirmasi

   Data yang dibutuhkan:
   - `nim` dari tabel `nilai`, untuk jumlah mahasiswa (measure)
   - `kode_mk` dari tabel `nilai`, untuk mata kuliah yang dipantau (context)
   - `semester_id` dari tabel `nilai`, untuk periode evaluasi (time)
   - `nilai_angka` dan `status_lulus` dari tabel `nilai` untuk menghitung KPI sementara; `nilai_huruf` dipakai untuk pemeriksaan konsistensi, bukan penentu KPI sampai skala resminya dikonfirmasi

2. **AQ02 dan KPI01 (tren per prodi)**

   Failure rate yang sama dihitung per program studi per semester. Tambahan data: `kode_prodi` mahasiswa (dari `mahasiswa.kode_prodi_raw` setelah `TRIM` + `UPPER`) dan referensi `program_studi`.

3. **AQ03 dan KPI02 (kelulusan tepat waktu)**

   - Measure: jumlah lulusan unik, jumlah lulusan tepat waktu, rata-rata masa studi
   - Context: program studi, angkatan
   - Time: periode kelulusan
   - Filter: satu baris per NIM (setelah deduplikasi)
   - Data: `nim`, `status_tepat_waktu`, `masa_studi_bulan`, `ipk_final`, `predikat`, `tanggal_lulus_raw` dari `kelulusan`; `angkatan` dan `kode_prodi_raw` dari `mahasiswa`; `kode_prodi`, `nama_prodi` dari `program_studi`.

4. **AQ04 dan KPI03 (LMS dan nilai)**

   - Measure: jumlah event, `durasi_menit`, `skor_kuis`, `nilai_angka`
   - Context: mata kuliah, tipe event
   - Time: semester
   - Filter: `lms_event_id` unik; skor kuis hanya dari `quiz_attempt`
   - Data: `lms_event_id`, `nim`, `kode_mk`, `semester_id`, `waktu_event`, `tipe_event`, `durasi_menit`, `skor_kuis` dari `aktivitas_lms`; `nim`, `kode_mk`, `semester_id`, `nilai_angka` dari `nilai`; serta `nim`, `kode_mk`, `semester_id` dari `krs` untuk denominator mahasiswa terdaftar (join pada `nim` + `kode_mk` + `semester_id`).

5. **AQ05 (nilai semester awal vs predikat kelulusan)**

   - Measure: rata-rata `nilai_angka`
   - Context: predikat kelulusan (Cukup, Memuaskan, Sangat Memuaskan)
   - Time: semester awal (mis. 2 semester pertama setiap mahasiswa)
   - Filter: nilai valid 0–100; lulusan unik
   - Data: `nim`, `semester_id`, `nilai_angka` dari `nilai`; `nim`, `predikat`, `ipk_final` dari `kelulusan`; `semester_id`, `urutan_tahun` dari `semester`.
   - Catatan: pembanding tepat waktu vs terlambat belum tersedia karena seluruh lulusan berstatus tepat waktu.

Seluruh kebutuhan data disimpulkan dalam tabel berikut:

| AQ | Measure | Context | Time | Filter/Comparison | Required Data |
|---|---|---|---|---|---|
| AQ01 | jumlah mahasiswa, jumlah tidak lulus, failure rate | mata kuliah, prodi | semester | nilai valid 0–100; `status_lulus` sementara menjadi indikator lulus/tidak lulus | `nim`, `kode_mk`, `semester_id`, `nilai_angka`, `status_lulus` |
| AQ02 | failure rate per prodi | program studi | semester (2021G–2024E) | nilai valid; urutan waktu semester | `nim`, `kode_mk`, `semester_id`, `status_lulus`, `kode_prodi_raw`, `kode_prodi`, `nama_prodi` |
| AQ03 | jumlah lulusan, lulusan tepat waktu, rata-rata masa studi | program studi, angkatan | periode kelulusan | satu baris per NIM | `nim`, `status_tepat_waktu`, `masa_studi_bulan`, `tanggal_lulus_raw`, `angkatan`, `kode_prodi_raw` |
| AQ04 | jumlah event, durasi, skor kuis, nilai angka, jumlah mahasiswa terdaftar | mata kuliah, tipe event | semester | `lms_event_id` unik; skor hanya `quiz_attempt`; denominator dari KRS unik | `lms_event_id`, `nim`, `kode_mk`, `semester_id`, `tipe_event`, `durasi_menit`, `skor_kuis`, `nilai_angka`, data KRS |
| AQ05 | rata-rata nilai angka | predikat kelulusan | semester awal | nilai valid; lulusan unik | `nim`, `semester_id`, `nilai_angka`, `predikat` |

## 9. Source Mapping
Pendekatan: **Data yang dibutuhkan → Tabel/file mana? → kolom apa → untuk fungsi/role apa?**

| Data Requirement | Source | Column | Role |
|---|---|---|---|
| Mahasiswa | `nilai`; `mahasiswa` | `nim` | integration key |
| Mata kuliah | `nilai`; `mata_kuliah` | `kode_mk` | course identifier |
| Nama MK | `mata_kuliah` | `nama_mk` | analytical context |
| Semester | `nilai`; `semester` | `semester_id` | time key |
| Nilai | `nilai` | `nilai_angka` | measure |
| Lulus/gagal | `nilai` | `status_lulus`, `nilai_huruf` | KPI component |
| Program studi mahasiswa | `mahasiswa`; `program_studi` | `kode_prodi_raw` → `kode_prodi`; `nama_prodi` | analytical context |
| Angkatan | `mahasiswa` | `angkatan` | analytical context |
| Status tepat waktu | `kelulusan` | `status_tepat_waktu` | KPI component |
| Predikat dan IPK lulusan | `kelulusan` | `predikat`, `ipk_final` | analytical context / measure |
| Masa studi lulusan | `kelulusan` | `masa_studi_bulan` | measure |
| Aktivitas LMS | `aktivitas_lms` | `lms_event_id` | measure (jumlah event) |
| Peserta terdaftar per mata kuliah-semester | `krs` | `nim`, `kode_mk`, `semester_id` | denominator KPI LMS Engagement |
| Durasi aktivitas LMS | `aktivitas_lms` | `durasi_menit` | measure |
| Semester aktivitas LMS | `aktivitas_lms` | `semester_id` | time key |
| Tipe aktivitas | `aktivitas_lms` | `tipe_event` | analytical context |

## 10. Data Fitness
Kondisi data dinilai dari hasil Unit 1.2 (Data Profiling).

| Source | Evidence Unit 1.2 | Fitness | Required Action |
|---|---|---|---|
| mahasiswa | 15 NIM duplikat persis (1.965 vs 1.950 unik); 30 label prodi untuk 6 prodi (435 baris); 6 kode jenis kelamin; 208 `kode_prodi_raw` bermasalah spasi/huruf kecil; 30 kota asal kosong; 3 format tanggal | Conditional Ready | Deduplikasi per `nim`; mapping prodi lewat `kode_prodi_raw` (TRIM + UPPER); standardisasi label dan parsing tanggal |
| program_studi | 6 baris, kode dan nama unik, bersih | Ready | Gunakan sebagai acuan canonical dimensi program studi |
| mata_kuliah | `kode_mk` unik; 0 orphan dari KRS/nilai/LMS; 63 nama MK berulang antar-prodi (wajar) | Ready | Gunakan `kode_mk` (bukan `nama_mk`) sebagai key |
| semester | 8 baris bersih (2021G–2024E); 0 orphan dari KRS/nilai | Ready | Gunakan sebagai dimensi waktu |
| krs | 25 duplikat persis (57.025 vs 57.000 unik); 0 orphan; 3 format tanggal | Conditional Ready | Deduplikasi sebelum menghitung peserta; parsing tanggal |
| nilai | Key unik (57.000); 20 nilai kosong; 12 di luar 0–100; 20 huruf tidak sesuai angka; 17 status tidak konsisten dengan huruf; 0 orphan | Conditional Ready | Keluarkan nilai kosong/invalid dari KPI; tetapkan kolom otoritatif dan skala resmi; turunkan status lulus dari nilai |
| aktivitas_lms | 30 event duplikat persis; skor kuis hanya pada `quiz_attempt`; durasi dan skor dalam rentang; 0 orphan | Conditional Ready | Deduplikasi per `lms_event_id` |
| kelulusan – profile on-time | 347 baris vs 345 NIM unik (2 duplikat persis); 0 orphan; 1 format tanggal; `status_tepat_waktu` = `Ya` pada 347 baris; masa studi 46–47 bulan; hanya angkatan 2021 | Conditional Ready | Deduplikasi per `nim`; profil masa studi, IPK, dan predikat dapat dipakai setelah deduplikasi |
| kelulusan – on-time vs late | Seluruh 347 record bernilai `Ya` (tidak ada kategori terlambat); lulusan hanya angkatan 2021 pada Juni 2025 | Not Ready | Konfirmasi ke bagian akademik apakah mahasiswa terlambat belum tercatat atau belum lulus; perbandingan tepat vs terlambat ditunda sampai data tersedia |

Ket: Fitness diisi dengan Ready, Not Ready, atau Conditional Ready. Satu kebutuhan berstatus *Not Ready* (perbandingan lulusan tepat waktu vs terlambat) karena data tidak memuat kategori terlambat; masalah lain dapat diatasi di tahap cleaning/ETL.

## 11. Candidate Model
Pada tahap ini belum dibuat Star Schema final, hanya kandidat model berdasarkan rumus **Analytical Question → Business Event → Grain → Dimension → Fact → Measure**.

**AQ01** :
>Mata kuliah apa yang memiliki failure rate tertinggi per semester?

**Business Event**:
>Mahasiswa memperoleh nilai akhir

**Candidate Grain**:
>Satu nilai akhir mahasiswa untuk satu mata kuliah pada satu semester

**Candidate Fact**:
>Penilaian / Nilai

**Candidate Dimensions**:
- Mahasiswa
- Mata Kuliah
- Semester
- Program Studi

**Candidate Measures**:
- nilai_angka
- is_lulus
- record count

**AQ02** :
>Bagaimana perubahan persentase ketidaklulusan setiap program studi dari semester 2021G sampai 2024E?

**Business Event**:
>Mahasiswa memperoleh nilai akhir

**Candidate Grain**:
>Satu nilai akhir mahasiswa untuk satu mata kuliah pada satu semester (sama dengan AQ01)

**Candidate Fact**:
>Penilaian / Nilai

**Candidate Dimensions**:
- Program Studi (melalui Mahasiswa)
- Semester
- Mahasiswa

**Candidate Measures**:
- is_tidak_lulus
- jumlah_peserta
- failure_rate

**AQ03** :
> Bagaimana perbedaan persentase kelulusan tepat waktu dan rata-rata masa studi antar program studi?

**Business Event**:
>Mahasiswa dinyatakan lulus

**Candidate Grain**:
>Satu kelulusan untuk satu mahasiswa

**Candidate Fact**:
>Kelulusan

**Candidate Dimensions**:
- Mahasiswa
- Program Studi
- Angkatan
- Tanggal Lulus

**Candidate Measures**:
- is_tepat_waktu
- masa_studi_bulan
- ipk_final
- jumlah_lulusan

Catatan: seluruh lulusan saat ini bernilai tepat waktu sehingga `masa_studi_bulan` menjadi measure pembeda yang lebih informatif.

**AQ04** :
>Bagaimana pola hubungan antara aktivitas LMS dan nilai angka pada setiap mata kuliah?

**Business Event**:
>Mahasiswa melakukan aktivitas pembelajaran di LMS

**Candidate Grain**:
>Satu event aktivitas LMS (satu `lms_event_id`)

**Candidate Fact**:
>Aktivitas LMS

**Candidate Dimensions**:
- Mahasiswa
- Mata Kuliah
- Tipe Aktivitas
- Tanggal/Waktu

**Candidate Measures**:
- durasi_menit
- skor_kuis (khusus `quiz_attempt`)
- jumlah_event

Catatan: hubungan dengan nilai dilakukan dengan menggabungkan hasil agregasi LMS per mahasiswa–mata kuliah dengan Fact Penilaian melalui dimensi bersama (Mahasiswa dan Mata Kuliah).

**AQ05** :
>Bagaimana perbedaan rata-rata nilai angka semester awal antar kelompok predikat kelulusan?

**Business Event**:
>Mahasiswa memperoleh nilai akhir dan dinyatakan lulus (dua event dihubungkan melalui mahasiswa)

**Candidate Grain**:
> Agregasi nilai semester awal menjadi satu ringkasan per mahasiswa terlebih dahulu, kemudian dihubungkan ke satu record kelulusan per mahasiswa. Jangan menggabungkan dua fact table pada grain detail secara langsung karena dapat menggandakan baris (fan-out).

**Candidate Fact**:
> Fact_Penilaian (diagregasi per mahasiswa untuk dua semester awal) dan Fact_Kelulusan (satu baris per mahasiswa), dianalisis melalui Dim_Mahasiswa.

**Candidate Dimensions**:
- Mahasiswa
- Semester
- Predikat Kelulusan

**Candidate Measures**:
- nilai_angka
- ipk_final

## 12. Traceability
Rumus: Problem → Business Objective → Stakeholder → Decision Requirement → Analytical Question → KPI / Metric → Data Requirement → Source Mapping → Data Fitness → Candidate Model.

1. **TR01 – Course Failure**

    - Problem → mata kuliah berisiko belum mudah diidentifikasi
    - Stakeholder → Kaprodi
    - Decision → menentukan mata kuliah prioritas
    - AQ → failure rate tertinggi per semester
    - KPI → Course Failure Rate
    - Data → NIM, MK, semester, status/score
    - Source → nilai + mata_kuliah + semester
    - Fitness → nilai Conditional; MK/Semester Ready
    - Candidate Process → Penilaian
    - Candidate Grain → nilai mahasiswa per MK per semester

    Karena ada mata kuliah berisiko yang belum mudah diidentifikasi, maka Kaprodi ingin mencapai peningkatan kualitas pembelajaran dan deteksi dini masalah akademik dan harus membuat keputusan dalam menentukan mata kuliah prioritas. Untuk itu diperlukan jawaban atas mata kuliah mana yang memiliki failure rate tertinggi per semester menggunakan KPI Course Failure Rate. KPI membutuhkan data NIM, mata kuliah (MK), semester, dan status kelulusan/skor, yang berasal dari tabel nilai, mata_kuliah, dan semester. Berdasarkan profiling, data berstatus Conditional untuk tabel nilai, sedangkan tabel mata_kuliah dan semester berstatus Ready. Oleh karena itu, kandidat model untuk proses bisnis Penilaian adalah:
      - **Grain**: Satu baris data mewakili nilai akhir satu mahasiswa per mata kuliah per semester.
      - **Fact**: Fact_Penilaian (atau Fact_Nilai_Mahasiswa).
      - **Dimension**: Dim_Mahasiswa (dari NIM), Dim_Mata_Kuliah (dari MK), dan Dim_Semester (dari semester).
      - **Measure**: Score (Nilai Angka), Status_Lulus (Flag 1/0 atau Tidak Lulus), Jumlah_Peserta, Jumlah_Tidak_Lulus, dan Course_Failure_Rate (%).

2. **TR02 – On-Time Graduation**

    - Problem → pola mahasiswa yang lulus tidak tepat waktu belum terlihat antarprodi
    - Stakeholder → Wakil Rektor Bidang Akademik
    - Decision → menentukan prodi/angkatan yang perlu program penguatan
    - AQ → perbedaan persentase kelulusan tepat waktu antar prodi
    - KPI → On-Time Graduation Rate
    - Data → NIM, status_tepat_waktu, angkatan, kode prodi
    - Source → kelulusan + mahasiswa + program_studi
    - Fitness → kelulusan dan mahasiswa Conditional (kelulusan semua tepat waktu); program_studi Ready
    - Candidate Process → Kelulusan
    - Candidate Grain → satu kelulusan per mahasiswa

    Karena pola kelulusan tidak tepat waktu belum terlihat antarprodi, maka Wakil Rektor Bidang Akademik ingin mencapai evaluasi pola kelulusan tepat waktu dan harus membuat keputusan menentukan prodi/angkatan yang perlu program penguatan. Untuk itu diperlukan jawaban atas perbedaan persentase kelulusan tepat waktu antar program studi menggunakan KPI On-Time Graduation Rate. KPI membutuhkan data NIM, status tepat waktu, angkatan, dan kode program studi, yang berasal dari tabel kelulusan, mahasiswa, dan program_studi. Berdasarkan profiling, data berstatus Conditional untuk kelulusan (2 baris duplikat; seluruh 347 record berstatus tepat waktu sehingga KPI belum membedakan prodi) dan mahasiswa (15 NIM duplikat serta label prodi tidak seragam), sedangkan program_studi berstatus Ready. Oleh karena itu kandidat modelnya adalah:
      - **Grain**: satu kelulusan untuk satu mahasiswa.
      - **Fact**: Fact_Kelulusan.
      - **Dimension**: Dim_Mahasiswa, Dim_Program_Studi, Dim_Angkatan, Dim_Tanggal_Lulus.
      - **Measure**: is_tepat_waktu, masa_studi_bulan, ipk_final, jumlah_lulusan, On_Time_Graduation_Rate (%).

3. **TR03 – LMS Engagement dan Nilai**

    - Problem → belum diketahui apakah aktivitas LMS berkaitan dengan performa nilai
    - Stakeholder → Dosen Pengampu dan Kaprodi
    - Decision → menentukan apakah aktivitas LMS layak menjadi indikator risiko akademik
    - AQ → pola hubungan aktivitas LMS dan nilai angka per mata kuliah
    - KPI → LMS Engagement per Mata Kuliah
    - Data → lms_event_id, NIM, MK, durasi, skor kuis, nilai angka
    - Source → aktivitas_lms + nilai
    - Fitness → aktivitas_lms Conditional (30 duplikat); nilai Conditional
    - Candidate Process → Aktivitas Pembelajaran LMS
    - Candidate Grain → satu event aktivitas LMS

    Karena belum diketahui apakah aktivitas LMS berkaitan dengan performa nilai, maka Dosen Pengampu dan Kaprodi ingin mengevaluasi hubungan tersebut dan harus menentukan apakah aktivitas LMS layak menjadi indikator risiko akademik. Untuk itu diperlukan jawaban atas pola hubungan aktivitas LMS dan nilai angka per mata kuliah menggunakan KPI LMS Engagement. KPI membutuhkan data `lms_event_id`, NIM, kode MK, durasi, skor kuis, dan nilai angka, yang berasal dari tabel aktivitas_lms dan nilai. Berdasarkan profiling, aktivitas_lms berstatus Conditional (30 event duplikat) dan nilai berstatus Conditional (nilai kosong, di luar rentang, dan tidak konsisten). Oleh karena itu kandidat modelnya adalah:
      - **Grain**: satu event aktivitas LMS.
      - **Fact**: Fact_Aktivitas_LMS.
      - **Dimension**: Dim_Mahasiswa, Dim_Mata_Kuliah, Dim_Tipe_Aktivitas, Dim_Tanggal.
      - **Measure**: jumlah_event, durasi_menit, skor_kuis.

4. **TR04 – Deteksi Dini Mahasiswa Berisiko**

    - Problem → kelompok mahasiswa yang perlu pendampingan lebih awal belum teridentifikasi
    - Stakeholder → Dosen Pembimbing Akademik / Bagian Akademik
    - Decision → menentukan kelompok mahasiswa yang didampingi lebih awal
    - AQ → perbedaan rata-rata nilai semester awal antar kelompok predikat kelulusan
    - KPI → Rata-rata nilai angka semester awal per predikat kelulusan (turunan dari KPI01)
    - Data → NIM, semester, nilai angka, predikat
    - Source → nilai + kelulusan + semester
    - Fitness → nilai dan kelulusan Conditional; semester Ready
    - Candidate Process → Penilaian dan Kelulusan
    - Candidate Grain → ringkasan nilai dua semester awal per mahasiswa, dihubungkan ke satu kelulusan per mahasiswa

    Karena kelompok mahasiswa yang perlu pendampingan awal belum teridentifikasi, maka Dosen Pembimbing Akademik ingin memperkuat deteksi dini dan harus menentukan kelompok mahasiswa yang didampingi lebih awal. Untuk itu diperlukan jawaban atas perbedaan rata-rata nilai semester awal antar kelompok predikat kelulusan (perbandingan tepat waktu vs terlambat belum dapat dilakukan karena seluruh lulusan berstatus tepat waktu). Data berasal dari nilai, kelulusan, dan semester dengan status Conditional untuk nilai dan kelulusan serta Ready untuk semester. Oleh karena itu kandidat modelnya adalah Fact_Penilaian yang terlebih dahulu diagregasi menjadi ringkasan nilai semester awal per mahasiswa dan Fact_Kelulusan dengan grain satu kelulusan per mahasiswa. Kedua hasil dihubungkan melalui Dim_Mahasiswa; hindari join langsung pada grain detail agar tidak terjadi penggandaan baris. Dimensi pendukung adalah Dim_Semester dan Dim_Predikat, dengan measure rata-rata nilai semester awal dan ipk_final.
