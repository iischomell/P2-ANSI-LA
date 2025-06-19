-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 18, 2025 at 10:28 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `akademik_layanan`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_user` (IN `p_nim` VARCHAR(20), IN `p_tanggal_lahir` DATE)   BEGIN
    DECLARE user_count INT;
    DECLARE user_role ENUM('mahasiswa', 'admin');
    
    SELECT COUNT(*), peran INTO user_count, user_role 
    FROM users 
    WHERE nim = p_nim AND tanggal_lahir = p_tanggal_lahir 
    AND password = SHA2(p_tanggal_lahir, 256);
    
    IF user_count > 0 THEN
        UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE nim = p_nim;
        SELECT user_count AS login_success, user_role AS user_role;
    ELSE
        SELECT 0 AS login_success, NULL AS user_role;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `register_mahasiswa` (IN `p_nim` VARCHAR(20), IN `p_nama` VARCHAR(100), IN `p_email` VARCHAR(100), IN `p_tanggal_lahir` DATE, IN `p_password` VARCHAR(255))   BEGIN
    INSERT INTO users (nim, nama, email, peran, tanggal_lahir, password) 
    VALUES (p_nim, p_nama, p_email, 'mahasiswa', p_tanggal_lahir, 
            SHA2(p_password, 256));
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `mahasiswa_detail`
--

CREATE TABLE `mahasiswa_detail` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `prodi` varchar(100) DEFAULT NULL,
  `fakultas` varchar(100) DEFAULT NULL,
  `semester` varchar(10) DEFAULT NULL,
  `tempat_lahir` varchar(100) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `tahun_masuk` year(4) DEFAULT NULL,
  `status_mahasiswa` enum('aktif','cuti','lulus','keluar') DEFAULT 'aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mahasiswa_detail`
--

INSERT INTO `mahasiswa_detail` (`id`, `user_id`, `prodi`, `fakultas`, `semester`, `tempat_lahir`, `alamat`, `no_hp`, `foto`, `tahun_masuk`, `status_mahasiswa`, `created_at`, `updated_at`) VALUES
(1, 2, 'Teknik Informatika', 'Fakultas Teknik dan Ilmu Komputer', '7', 'Bima', 'Bima, Nusa Tenggara Barat', NULL, NULL, '2021', 'aktif', '2025-05-26 07:02:40', '2025-05-26 07:02:40'),
(2, 3, 'Teknik Informatika', 'Fakultas Teknik dan Ilmu Komputer', '6', 'Bima', 'Bima, Nusa Tenggara Barat', '', NULL, '2021', 'aktif', '2025-05-26 07:02:40', '2025-05-26 09:57:59'),
(5, 5, 'Ilmu Komputer', 'Fakultas Teknik dan Ilmu Komputer', '6', 'Kota Bima', 'Melayu', '085339370766', NULL, '2025', 'aktif', '2025-05-26 09:57:40', '2025-05-26 09:57:40'),
(6, 6, 'Ilmu Komputer', 'Fakultas Teknik dan Ilmu Komputer', '6', 'Kota Bima', 'mangge maci, Rt02, Rw01', '081337629907', NULL, '2025', 'aktif', '2025-05-26 10:04:08', '2025-05-26 10:04:08'),
(7, 7, 'Ilmu Komputer', 'Fakultas Teknik dan Ilmu Komputer', '6', 'Kota Bima', 'nae, kota Kota Bima', '08525383028', NULL, '2025', 'aktif', '2025-05-27 10:51:08', '2025-05-27 10:51:08'),
(8, 8, 'Ilmu Komputer', 'Fakultas Teknik dan Ilmu Komputer', '6', 'Kota Bima', 'lelamase', '085338764251', NULL, '2025', 'aktif', '2025-06-02 03:09:30', '2025-06-02 03:09:30'),
(9, 9, 'Ilmu Komputer', 'Fakultas Teknik dan Ilmu Komputer', '6', 'Kota Bima', 'mangge maci, Rt02, Rw01', '081337629907', NULL, '2025', 'aktif', '2025-06-12 02:58:57', '2025-06-12 02:58:57'),
(10, 10, 'Teknik Informatika', 'Fakultas Teknik dan Ilmu Komputer', '7', 'Bima', 'ranggo', '081337629900', NULL, '2025', 'aktif', '2025-06-12 03:01:17', '2025-06-12 03:01:17');

-- --------------------------------------------------------

--
-- Table structure for table `notifikasi`
--

CREATE TABLE `notifikasi` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `judul` varchar(100) NOT NULL,
  `isi` text NOT NULL,
  `terbaca` tinyint(1) DEFAULT 0,
  `tanggal_kirim` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifikasi`
--

INSERT INTO `notifikasi` (`id`, `user_id`, `judul`, `isi`, `terbaca`, `tanggal_kirim`) VALUES
(1, 3, 'Pengajuan Surat Diterima', 'Pengajuan surat cuti anda telah diterima dan sedang menunggu persetujuan.', 0, '2025-05-14 16:04:19'),
(2, 3, 'Pengajuan Surat Diterima', 'Pengajuan surat pindah anda telah diterima dan sedang menunggu persetujuan.', 0, '2025-05-14 16:07:53'),
(3, 3, 'Pengajuan Surat Diterima', 'Pengajuan surat aktif anda telah diterima dan sedang menunggu persetujuan.', 0, '2025-05-14 16:13:10'),
(4, 3, 'Pengajuan Surat Diterima', 'Pengajuan surat cuti anda telah diterima dan sedang menunggu persetujuan.', 0, '2025-05-14 16:28:47'),
(5, 3, 'Pengajuan Surat Diterima', 'Pengajuan surat cuti anda telah diterima dan sedang menunggu persetujuan.', 0, '2025-05-15 01:55:42'),
(6, 3, 'Pengajuan Surat Diterima', 'Pengajuan surat cuti anda telah diterima dan sedang menunggu persetujuan.', 0, '2025-05-15 02:14:21'),
(7, 3, 'Pengajuan Surat Diterima', 'Pengajuan surat cuti anda telah diterima dan sedang menunggu persetujuan.', 0, '2025-05-21 13:19:38'),
(8, 6, 'Pengajuan Surat Berhasil', 'Pengajuan surat pindah Anda berhasil dikirim dengan nomor: SPD/003/FTIK/UMBIMA/05/2025', 0, '2025-05-27 01:32:32'),
(9, 6, 'Pengajuan Surat Ditolak', 'Pengajuan surat Anda dengan nomor SPD/003/FTIK/UMBIMA/05/2025 ditolak. Catatan: kamu masi kecil bocil', 0, '2025-05-27 01:43:42'),
(10, 6, 'Pengajuan Surat Berhasil', 'Pengajuan surat lainnya Anda berhasil dikirim dengan nomor: SLL/001/FTIK/UMBIMA/05/2025', 0, '2025-05-27 04:20:37'),
(11, 6, 'Pengajuan Surat Disetujui', 'Pengajuan surat Anda dengan nomor SLL/001/FTIK/UMBIMA/05/2025 telah disetujui', 0, '2025-05-27 04:25:58'),
(12, 6, 'Pengajuan Surat Berhasil', 'Pengajuan surat cuti Anda berhasil dikirim dengan nomor: SCT/003/FTIK/UMBIMA/05/2025', 0, '2025-05-27 05:04:05'),
(13, 6, 'Pengajuan Surat Dibatalkan', 'Pengajuan surat Anda telah dibatalkan', 0, '2025-05-27 05:04:33'),
(14, 6, 'Pengajuan Surat Berhasil', 'Pengajuan surat pindah Anda berhasil dikirim dengan nomor: SPD/003/FTIK/UMBIMA/05/2025', 0, '2025-05-27 05:05:46'),
(15, 6, 'Pengajuan Surat Dibatalkan', 'Pengajuan surat Anda telah dibatalkan', 0, '2025-05-27 05:06:17'),
(16, 6, 'Pengajuan Surat Dibatalkan', 'Pengajuan surat Anda telah dibatalkan', 0, '2025-05-27 05:06:23'),
(17, 8, 'Pengajuan Surat Berhasil', 'Pengajuan surat aktif Anda berhasil dikirim dengan nomor: SKA/001/FTIK/UMBIMA/06/2025', 0, '2025-06-01 20:13:18'),
(18, 8, 'Pengajuan Surat Disetujui', 'Pengajuan surat Anda dengan nomor SKA/001/FTIK/UMBIMA/06/2025 telah disetujui', 0, '2025-06-01 20:22:07'),
(19, 6, 'Pengajuan Surat Berhasil', 'Pengajuan surat cuti Anda berhasil dikirim dengan nomor: SCT/003/FTIK/UMBIMA/06/2025', 0, '2025-06-11 20:12:53'),
(20, 6, 'Pengajuan Surat Disetujui', 'Pengajuan surat Anda dengan nomor SCT/003/FTIK/UMBIMA/06/2025 telah disetujui', 0, '2025-06-11 20:15:27');

-- --------------------------------------------------------

--
-- Table structure for table `pengaduan`
--

CREATE TABLE `pengaduan` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `topik` varchar(100) NOT NULL,
  `pesan` text NOT NULL,
  `status` enum('baru','diproses','selesai') DEFAULT 'baru',
  `balasan` text DEFAULT NULL,
  `tanggal` timestamp NOT NULL DEFAULT current_timestamp(),
  `admin_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengaduan`
--

INSERT INTO `pengaduan` (`id`, `user_id`, `topik`, `pesan`, `status`, `balasan`, `tanggal`, `admin_id`) VALUES
(1, 3, 'Masalah Akademik', 'Ingin konsultasi tentang jadwal kuliah', 'selesai', 'nanti ke prodi aja', '2025-05-12 12:50:56', 1),
(2, 2, 'Konsultasi: bimbingan lapporan magang', 'dospem saya tidak aktif pak', 'selesai', 'ehh ajg dosen juga ada keperluan pribadi babi', '2025-05-22 04:07:55', 1),
(3, 6, 'Pengaduan: dosen pemrograman mobile jarang masuk min', 'kami protes karna pemrograman mobile ini ini tidak pernah masuk sama sekali min', 'diproses', 'kami akan melaporkan kepada rektor', '2025-05-27 00:07:42', 1),
(4, 6, 'Pengaduan: bimbingan lapporan magang', 'ya ya ya ya ya ya ya ya ya', 'selesai', 'okey', '2025-05-27 01:33:59', 1),
(5, 6, 'Pengaduan: ac rusak', 'ac nya gada dingin sama sekali, saya kepansan di kelas. tolong acnya di perbaiki', 'diproses', 'baik anak cantik, imut dan sangat soft spoken kami akan mangurus acnya', '2025-05-27 04:24:11', 1),
(6, 8, 'Konsultasi: bimbingan lapporan magang', 'ingin melakukan bimbingan laporan magang pada hari senin depan', 'selesai', 'lakukan bimbingan nanti sore di aula ', '2025-06-01 20:15:15', 1),
(7, 6, 'Pengaduan: dosen pemrograman mobile jarang masuk ', 'dosen pemograman mobile jarang masuk dan ga pernah mengarkan kita tantang materi nya. kita jadi tidak pintar', 'diproses', 'baik akan kami segera proses', '2025-06-11 20:05:46', 1);

-- --------------------------------------------------------

--
-- Table structure for table `surat_pengajuan`
--

CREATE TABLE `surat_pengajuan` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `nama_pengaju` varchar(100) DEFAULT NULL,
  `nim_pengaju` varchar(20) DEFAULT NULL,
  `jenis_surat` enum('aktif','cuti','pindah','lainnya','surat_keterangan_aktif','surat_keterangan_mahasiswa','surat_pengantar_pkl','surat_pengantar_skripsi','surat_keterangan_lulus','surat_rekomendasi','surat_keterangan_berkelakuan_baik') NOT NULL,
  `status` enum('menunggu','diproses','disetujui','ditolak') DEFAULT 'menunggu',
  `catatan_admin` text DEFAULT NULL,
  `nomor_surat` varchar(50) DEFAULT NULL,
  `alasan` text DEFAULT NULL,
  `lampiran` varchar(255) DEFAULT NULL,
  `tanggal` timestamp NOT NULL DEFAULT current_timestamp(),
  `admin_id` int(11) DEFAULT NULL,
  `tanggal_diproses` datetime DEFAULT NULL,
  `file_surat_resmi` varchar(255) DEFAULT NULL,
  `tanggal_surat_resmi` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `surat_pengajuan`
--

INSERT INTO `surat_pengajuan` (`id`, `user_id`, `nama_pengaju`, `nim_pengaju`, `jenis_surat`, `status`, `catatan_admin`, `nomor_surat`, `alasan`, `lampiran`, `tanggal`, `admin_id`, `tanggal_diproses`, `file_surat_resmi`, `tanggal_surat_resmi`) VALUES
(5, 3, NULL, NULL, 'cuti', 'menunggu', NULL, NULL, 'Karna ada urusan diluar kota', NULL, '2025-05-14 09:20:54', NULL, NULL, NULL, NULL),
(8, 3, NULL, NULL, 'cuti', 'menunggu', NULL, NULL, 'mau istirahat', NULL, '2025-05-15 02:14:21', NULL, NULL, NULL, NULL),
(10, 2, NULL, NULL, 'pindah', 'disetujui', 'nanti ke prodi', 'SPD/002/10/05/2025', 'pengajuan dilakukan karena kampus anda burik dan fasilitas nya zumhur eee bona poda', 'uploads/1747909533_341d8395107cb074d894.docx', '2025-05-22 03:25:33', 1, '2025-05-26 07:18:23', 'uploads/surat_resmi/surat_resmi_SPD_002_10_05_2025.html', '2025-05-26 00:18:23'),
(11, 2, NULL, NULL, 'pindah', 'ditolak', NULL, 'SPD/003/11/05/2025', 'pengajuan dilakukan karena kampus anda burik dan fasilitas nya zumhur eee bona poda', 'uploads/1747909675_e1d27c48a1b04d52a260.docx', '2025-05-22 03:27:55', NULL, NULL, NULL, NULL),
(12, 2, NULL, NULL, 'aktif', 'menunggu', NULL, 'SKA/003/12/05/2025', 'vrfhqwifhqfipfc b2dbo23 f i3h  bi2hhih bfbbf1fipf bf2ihi ffb ', '', '2025-05-22 03:44:41', NULL, NULL, NULL, NULL),
(13, 3, NULL, NULL, 'pindah', 'diproses', NULL, 'SPD/004/13/05/2025', 'pe pe pe pe pe pe pe pe pe pe', 'uploads/1748096977_2ed7475d4c4b422a2294.pdf', '2025-05-24 07:29:37', NULL, NULL, NULL, NULL),
(14, 2, NULL, NULL, 'cuti', 'disetujui', 'nanti ke prodi serahin surat nya', 'SCT/001/FTIK/UMBIMA/05/2025', 'saya pengen mengajukan cuti untuk 2 bulan karna mau ikut seleksi cpns', '', '2025-05-25 23:49:11', 1, '2025-05-26 07:17:27', 'uploads/surat_resmi/surat_resmi_SCT_001_FTIK_UMBIMA_05_2025.html', '2025-05-26 00:17:27'),
(15, 6, NULL, NULL, 'pindah', 'disetujui', 'wahh kamu pintar sekali nak ', 'SPD/002/FTIK/UMBIMA/05/2025', 'saya mau pindah ke UGM, sudah lulus beasiswa senggol donggg', '', '2025-05-26 03:07:00', 1, '2025-05-26 10:08:10', 'uploads/surat_resmi/surat_resmi_SPD_002_FTIK_UMBIMA_05_2025.html', '2025-05-26 03:08:10'),
(16, 6, NULL, NULL, 'cuti', 'disetujui', 'nanti serahin di prodi', 'SCT/002/FTIK/UMBIMA/05/2025', 'karna ingin mengikuti seleksi cpns tahun ini saya akan mengajukan 2 bulan cuti', '', '2025-05-26 23:48:10', 1, '2025-05-27 06:49:10', 'uploads/surat_resmi/surat_resmi_SCT_002_FTIK_UMBIMA_05_2025.pdf', '2025-05-26 23:49:10'),
(17, 6, NULL, NULL, 'pindah', 'ditolak', 'kamu masi kecil bocil', 'SPD/003/FTIK/UMBIMA/05/2025', 'nee pindah ee mada ma lao nikah wau aka palibelo arie', '', '2025-05-27 01:32:32', 1, '2025-05-27 08:43:42', NULL, NULL),
(18, 6, NULL, NULL, 'lainnya', 'disetujui', 'saya akan scors si iwan nakal itu', 'SLL/001/FTIK/UMBIMA/05/2025', 'saya di bully sama M. iwan setiawan Kls p1, dia suka membuli saya dari semester 1 sampe sekarang. Saya di kencoki sama dia ', 'uploads/1748344837_35e3428800c1600da859.pdf', '2025-05-27 04:20:37', 1, '2025-05-27 11:25:58', 'uploads/surat_resmi/surat_resmi_SLL_001_FTIK_UMBIMA_05_2025.pdf', '2025-05-27 04:26:02'),
(22, 8, NULL, NULL, 'aktif', 'disetujui', NULL, 'SKA/001/FTIK/UMBIMA/06/2025', 'ya ya ya ya ya ya ya ya ya ya ya ya', '', '2025-06-01 20:13:18', 1, '2025-06-02 03:22:07', 'uploads/surat_resmi/surat_resmi_SKA_001_FTIK_UMBIMA_06_2025.pdf', '2025-06-01 20:22:12'),
(23, 6, NULL, NULL, 'cuti', 'disetujui', 'silahkan ambil surat di prodi', 'SCT/003/FTIK/UMBIMA/06/2025', 'saya ingin mengajukan cuti hari jumaat tgl 13-20', '', '2025-06-11 20:12:53', 1, '2025-06-12 03:15:27', 'uploads/surat_resmi/surat_resmi_SCT_003_FTIK_UMBIMA_06_2025.pdf', '2025-06-11 20:15:31');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nim` varchar(20) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `peran` enum('mahasiswa','admin') NOT NULL,
  `tanggal_lahir` date NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `nim`, `nama`, `email`, `peran`, `tanggal_lahir`, `password`, `created_at`, `last_login`) VALUES
(1, 'admin001', 'Admin Utama', 'admin@kampus.ac.id', 'admin', '1980-01-01', 'ace3fca547f2115d71ef02a4a0835642e6f38e97f843f1c5f001ce9059c5c442', '2025-05-12 12:50:56', '2025-06-11 20:13:23'),
(2, '2021001', 'Budi Santoso', 'budi@mahasiswa.ac.id', 'mahasiswa', '2000-05-15', '2cb42bea848f054552ad19f6e76d9b2f2645002af33767b5f6524d541564026c', '2025-05-12 12:50:56', '2025-06-11 20:24:11'),
(3, '2021002', 'Ani Wijaya', 'ani@mahasiswa.ac.id', 'mahasiswa', '2001-12-20', '3a439e31ea77ebc5a4a54f7179bc964a120dfaff12dc4cda3cab8b1179fbd327', '2025-05-12 12:50:56', '2025-05-25 07:55:58'),
(4, 'admin002', 'Iis Muzdalifah', 'nusabima34@gmail.com', 'admin', '2004-03-08', '20040308', '2025-05-22 11:43:06', NULL),
(5, 'B02220040', 'M. Iwan Setiawan', 'iwan@gmail.com', 'mahasiswa', '2004-05-08', '7e0f8d26f5711beb61eef4fdc4ba738b65659ccdc6a71a6cce07d7ebfa3104a7', '2025-05-26 09:57:40', NULL),
(6, 'B02220087', 'Iis muzdalifah', 'Iischomell@gmail.com', 'mahasiswa', '2004-03-08', 'cd728e23aaaca25765295bba9041914f558582013daf345960c37bd95e0a2725', '2025-05-26 10:04:08', '2025-06-11 20:26:14'),
(7, 'B02220194', 'Hesti faradilla', 'hestifaradilla@gmail.com', 'mahasiswa', '2004-05-25', '0fefd9f474875ae848d9f268c31c7d23d7c80bf76e8adeeec2581be6ac8b8b1e', '2025-05-27 10:51:08', NULL),
(8, 'B02220002', 'lulu julia', 'lulujulia@gmail.com', 'mahasiswa', '2003-07-19', 'c35f00546e3f43e136fae6990c28b0479ce41720570341840996db2f46808224', '2025-06-02 03:09:30', '2025-06-01 20:10:19'),
(9, 'B02220081', 'iis muzdalifah', 'iis@gmail.com', 'mahasiswa', '2004-03-08', 'cd728e23aaaca25765295bba9041914f558582013daf345960c37bd95e0a2725', '2025-06-12 02:58:57', NULL),
(10, 'B02220082', 'Nnurfadilah', 'iisss@gamil.com', 'mahasiswa', '2004-01-12', '2cc896ab8880540079e8907ef31df0569dd1bf14ffdca7708de2904b2e53fa91', '2025-06-12 03:01:17', NULL);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_mahasiswa_aktivitas`
-- (See below for the actual view)
--
CREATE TABLE `v_mahasiswa_aktivitas` (
`nim` varchar(20)
,`nama` varchar(100)
,`total_surat_pengajuan` bigint(21)
,`total_pengaduan` bigint(21)
,`total_notifikasi` bigint(21)
);

-- --------------------------------------------------------

--
-- Structure for view `v_mahasiswa_aktivitas`
--
DROP TABLE IF EXISTS `v_mahasiswa_aktivitas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_mahasiswa_aktivitas`  AS SELECT `u`.`nim` AS `nim`, `u`.`nama` AS `nama`, count(distinct `sp`.`id`) AS `total_surat_pengajuan`, count(distinct `p`.`id`) AS `total_pengaduan`, count(distinct `n`.`id`) AS `total_notifikasi` FROM (((`users` `u` left join `surat_pengajuan` `sp` on(`u`.`id` = `sp`.`user_id`)) left join `pengaduan` `p` on(`u`.`id` = `p`.`user_id`)) left join `notifikasi` `n` on(`u`.`id` = `n`.`user_id`)) WHERE `u`.`peran` = 'mahasiswa' GROUP BY `u`.`nim`, `u`.`nama` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `mahasiswa_detail`
--
ALTER TABLE `mahasiswa_detail`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_notifikasi_terbaca` (`terbaca`);

--
-- Indexes for table `pengaduan`
--
ALTER TABLE `pengaduan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `idx_pengaduan_status` (`status`);

--
-- Indexes for table `surat_pengajuan`
--
ALTER TABLE `surat_pengajuan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_surat_status` (`status`),
  ADD KEY `idx_surat_nomor` (`nomor_surat`),
  ADD KEY `idx_surat_admin` (`admin_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nim` (`nim`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_users_nim` (`nim`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `mahasiswa_detail`
--
ALTER TABLE `mahasiswa_detail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `notifikasi`
--
ALTER TABLE `notifikasi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `pengaduan`
--
ALTER TABLE `pengaduan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `surat_pengajuan`
--
ALTER TABLE `surat_pengajuan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `mahasiswa_detail`
--
ALTER TABLE `mahasiswa_detail`
  ADD CONSTRAINT `mahasiswa_detail_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD CONSTRAINT `notifikasi_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `pengaduan`
--
ALTER TABLE `pengaduan`
  ADD CONSTRAINT `pengaduan_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `pengaduan_ibfk_2` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `surat_pengajuan`
--
ALTER TABLE `surat_pengajuan`
  ADD CONSTRAINT `surat_pengajuan_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `surat_pengajuan_ibfk_2` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
