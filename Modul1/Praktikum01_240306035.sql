-- UADW v1.0 - Modul Praktikum 01
CREATE SCHEMA IF NOT EXISTS src;
DROP TABLE IF EXISTS src.program_studi;
CREATE TABLE src.program_studi (kode_prodi TEXT,nama_prodi TEXT,fakultas TEXT,departemen TEXT,status TEXT);
DROP TABLE IF EXISTS src.semester;
CREATE TABLE src.semester (semester_id TEXT,tahun_akademik TEXT,term TEXT,urutan_tahun TEXT,tanggal_mulai TEXT,tanggal_selesai TEXT);
DROP TABLE IF EXISTS src.mahasiswa;
CREATE TABLE src.mahasiswa (nim TEXT,nama TEXT,jk_raw TEXT,tanggal_lahir_raw TEXT,kota_asal_raw TEXT,kode_prodi_raw TEXT,prodi_raw TEXT,angkatan TEXT,tanggal_masuk_raw TEXT,status_raw TEXT,email_kampus TEXT);
DROP TABLE IF EXISTS src.dosen;
CREATE TABLE src.dosen (nidn TEXT,nama_dosen TEXT,jk_raw TEXT,unit_prodi_raw TEXT,jabatan_akademik TEXT,tanggal_masuk_raw TEXT,status TEXT);
DROP TABLE IF EXISTS src.mata_kuliah;
CREATE TABLE src.mata_kuliah (kode_mk TEXT,nama_mk TEXT,kode_prodi TEXT,sks TEXT,semester_rekomendasi TEXT,kategori TEXT,aktif TEXT);

--9. Menjalankan excercise C - Membuat data Inventory
SELECT 'program_studi' AS tabel,
COUNT(*) AS jumlah_baris,
(select COUNT(*)
from information_schema.columns
where table_schema = 'src'
and table_name = 'program_studi') as jumlah_kolom,
'kode_prodi' AS natural_key_candidate,
'Master/Reference Program Studi' AS peran_bisnis
FROM src.program_studi
UNION all
SELECT 'semester', 
COUNT(*),
(select COUNT(*)
from information_schema."columns"
where table_schema = 'src'
and table_name = 'semester'),
'semester_id',
'Reference Semester'
FROM src.semester
UNION all
SELECT 'mahasiswa',
COUNT(*),
(select COUNT(*)
from information_schema.columns
where table_schema = 'src'
and table_name = 'mahasiswa'),
 'nim',
 'Master Mahasiswa'
from src.mahasiswa
UNION all
SELECT 'dosen',
COUNT(*),
(SELECT COUNT(*)
from information_schema.columns
where table_schema = 'src'
and table_name = 'dosen'),
'nidn',
'Master Dosen'
FROM src.dosen
UNION all
SELECT 'mata_kuliah',
COUNT(*),
(select COUNT(*)
from information_schema.columns
where table_schema = 'src'
and table_name = 'mata_kuliah'),
 'kode_mk',
 'Master Mata Kuliah'
FROM src.mata_kuliah;

--10. Excercise D - Eksplorasi Awal
--- Mencari jumlah mahasiswa dan duplikat
select COUNT(*) as RAW_ROWS,
COUNT(distinct NIM) as DISTINCT_NIM,
COUNT(*) - COUNT(distinct NIM) as SELISIH
from src.mahasiswa;

--- Cari missing data kolom kota_raw
select count(*) as missing_kota
from src.mahasiswa
where trim(coalesce(kota_asal_raw, '')) = '';

---Variasi label prodi
select prodi_raw, count(*) as jumlah
from src.mahasiswa
group by prodi_raw 
order by prodi_raw ;


--Tugas nomer 11. Problem Challenge
---1. Jumlah baris pada masing-masing tabel sumber
select 'program_studi' as tabel, COUNT(*) as jumlah_baris
from src.program_studi
union all
select 'semester', COUNT(*)
from src.semester
union all
select 'mahasiswa', COUNT(*)
from src.mahasiswa
union all
select 'dosen', COUNT(*)
from src.dosen
union all
select 'mata_kuliah', COUNT(*)
from src.mata_kuliah;

---2. Jumlah NIM unik pada mahasiswa
select
	COUNT(*) as jumlah_baris,
	COUNT(distinct nim) as jumlah_nim_unik,
	case 
		when COUNT(*) = COUNT(distinct nim)
			then 'SAMA - tidak ada duplictae NIM'
		else 'BERBEDA - terdapat duplicate NIM'
	end as kesimpulan
from src.mahasiswa;

---3. Berapa baris mahasiswa yang merupakan excess duplicate
select 
	nim,
	COUNT(*) as jumlah_kemunculan,
	COUNT(*) - 1 as excess_duplicate
from src.mahasiswa
group by nim 
having COUNT(*) > 1
order by jumlah_kemunculan desc, nim;

---4. Rentang angkatan
select 
	TO_CHAR(MIN(nullif(TRIM(angkatan), '')::INTEGER), 'FM9999') as angkatan_terlama,
	TO_CHAR(MAX(nullif(TRIM(angkatan), '')::INTEGER), 'FM9999') as angkatan_terbaru
from src.mahasiswa;

---5. Mahasiswa yang kota_asal_raw koosng
select COUNT(*) as missing_kota
from src.mahasiswa
where TRIM(coalesce(kota_asal_raw, '')) = '';

---6. Banyak label prodi-raw dan perbandingan dengan jumlah prodi canonical
select 
	(select COUNT(distinct prodi_raw)
	from src.mahasiswa) as jumlah_prodi_raw_unik,
	(select COUNT(distinct nama_prodi)
	from src.program_studi) as jumlah_prodi_canonical;

---7. Data quality check
----1. Duplicate NIM
select 
	nim,
	COUNT(*) as jumlah
from src.mahasiswa
group by nim 
having COUNT(*) > 1
order by jumlah desc;

----2. Missing kota asal
select COUNT(*) as missing_kota
from src.mahasiswa
where TRIM(COALESCE(kota_asal_raw, '')) = '';

----3.Variasi prodi_raw
select 
	prodi_raw,
	COUNT(*) as jumlah
from src.mahasiswa
group by prodi_raw 
order by prodi_raw;

----4. Kode prodi yang tidak ada dalam master prodi
select
    m.kode_prodi_raw,
    COUNT(*) as jumlah_mahasiswa
from src.mahasiswa m
left join src.program_studi p
    on TRIM(m.kode_prodi_raw) = TRIM(p.kode_prodi)
where p.kode_prodi is null
group by m.kode_prodi_raw
order by jumlah_mahasiswa desc;

---8. Mengeleompokkan lima fike menjadi master atatau transactional
select * from src.program_studi limit 5;
select * from src.semester limit 5;
select * from src.mahasiswa limit 5;
select * from src.dosen limit 5;

---9. Pertanyaan analitik dan Dataset tambahan
----1. Berapa mahasiswa yang mengambil setiap mata kuliah? Dataset tambahan yang dibutuhkan adalah "KRS"
select 
	kode-mk,
	COUNT(distinct nim) as jumlah_mahasiswa
from src.krs
group by kode_mk
order by jumlah_mahasiswa desc;

----2. Berapa nilai rata-rata setiap mata kuliah? Dataset yang dibutuhkan untuk ini adalah "nilai"
select 
	kode_mk 
	AVG(nilai) as rata_rata_nilai
from src.nilai
group by kode_mk
order by rata_rata_nilai desc;

----3. Bagaimana distribusi nilai mahasiswa pada setiap mata kuiah? Dataset yang diperlukan juga "nilai"
select 
	kode_mk,
	nilai,
	COUNT(*) as jumlah_mahasiswa
from src.nilai
group by kode_mk, nilai 
order by kode_mk, nilai;

----4. Berapa mahasiswa yang aktif pada setiap semester? Dataset tambahan yang dibutuhkan disini adalah "registrasi mahasiswa"
select
	semester_id,
	COUNT(distinct nim) as jumlah_mahasiswa
from src.registrasi_mahasiswa
group by semester_id 
order by semester_id;

----5. Berapa tingkat kelulusan mahasiswa pada setiap semester? Dataset yang dibutuhkan disini adalah nilai dan status kelulusan, misalnya tabel nilai memiliki kolom status lulus di dalamnya
select 
	semester_id,
	COUNT(*) as total_mahasiswa,
	COUNT(*) filter (where status_lulus = 'LULUS') as jumlah_lulus
	from src.nilai
	group by semester_id
	order by semester_id;
select * from src.mata_kuliah limit 5;