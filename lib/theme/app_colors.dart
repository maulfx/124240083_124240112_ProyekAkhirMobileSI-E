import 'package:flutter/material.dart';
import '../core/services/theme_service.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// PARKSMART SINGLE SOURCE OF TRUTH (SSOT) - COLOR COMMAND CENTER
/// ═══════════════════════════════════════════════════════════════════════════
/// File pusat komando pengendali seluruh warna aplikasi ParkSmart.
///
/// ATURAN UTAMA ARSITEKTUR:
/// 1. DILARANG KERAS menggunakan hardcoded Color(0x...) atau Colors.* acak di file UI!
///    Semua urusan warna diatur 1 komando terpusat di file ini.
/// 2. [BAGIAN 1 - GLOBAL]: Terletak paling atas. Berisi warna-warna dasar yang
///    mayoritas dipakai bersama di seluruh halaman aplikasi (Background Scaffold,
///    Surface Card, Surface Field/Input, Garis Tepi/Border, Teks, Tombol, Dock Bawah).
/// 3. [BAGIAN 2 - PER SEGMEN HALAMAN]: Terletak di bawah Bagian Global. Berisi token
///    warna unik yang spesifik untuk halaman, fitur, atau perangkat fisik tertentu
///    (Slot, Map, Detail Parkir, Auth, Kendaraan, Sistem/Maintenance, AR, Catatan,
///    Profil, Kamera Viewfinder, Beranda, Splash, Favorit, Modal, Notifikasi, Feedback).
/// 4. Semua token reaktif terhadap Dark Mode / Light Mode secara otomatis via ThemeService.
/// ═══════════════════════════════════════════════════════════════════════════
class AppColors {
  // ===========================================================================
  // ─── [BAGIAN 1: GLOBAL] WARNA DASAR UMUM (SHARED ACROSS SCREENS) ───────────
  // ===========================================================================

  // ─── 1.1 WARNA LATAR BELAKANG GLOBAL (SCAFFOLD / PAGE BACKGROUND) ───
  /// Latar belakang dasar Scaffold pada Light Mode (Cream lembut bernuansa hangat).
  /// Digunakan di: HomeScreen, ExploreMapScreen, LoginScreen, RegisterScreen, ProfileScreen, dll.
  static const Color backgroundLight = Color(0xFFF6F3EC);

  /// Latar belakang dasar Scaffold pada Dark Mode (Hitam pekat modern hemat baterai OLED).
  /// Digunakan di: HomeScreen, ExploreMapScreen, LoginScreen, RegisterScreen, ProfileScreen, dll.
  static const Color backgroundDark = Color(0xFF111418);

  // ─── 1.2 WARNA KARTU / CONTAINER UTAMA (CARD & CONTAINER BACKGROUND) ───
  /// Latar belakang kartu/wadah utama pada Light Mode (Putih bersih berbayang halus).
  /// Digunakan di: Kartu info parkir, kartu kendaraan, kartu tiket, kartu profil.
  static const Color surfaceCardLight = Color(0xFFFFFFFF);

  /// Latar belakang kartu/wadah utama pada Dark Mode (Abu gelap elegan dengan kontras tinggi).
  /// Digunakan di: Kartu info parkir, kartu kendaraan, kartu tiket, kartu profil.
  static const Color surfaceCardDark = Color(0xFF1E232B);

  // ─── 1.3 WARNA CONTAINER SEKUNDER / AKSEN (SECONDARY / DIM CONTAINER) ───
  /// Latar belakang kontainer sekunder yang lebih lembut pada Light Mode.
  /// Digunakan di: Background badge, kotak info sekunder, header section list.
  static const Color surfaceDimLight = Color(0xFFEFECE5);

  /// Latar belakang kontainer sekunder yang lebih lembut pada Dark Mode.
  /// Digunakan di: Background badge, kotak info sekunder, header section list.
  static const Color surfaceDimDark = Color(0xFF262C36);

  // ─── 1.4 WARNA LATAR INPUT FIELD / TEXT FIELD / SEARCH BAR ───
  /// Latar belakang kotak input formulir pada Light Mode (Abu-krem soft tidak silau).
  /// Digunakan di: Field teks Login, Register, Edit Profile, Kotak Cari Peta & Favorit.
  static const Color surfaceFieldLight = Color(0xFFF3EFE7);

  /// Latar belakang kotak input formulir pada Dark Mode (Slate gelap bertepi tegas).
  /// Digunakan di: Field teks Login, Register, Edit Profile, Kotak Cari Peta & Favorit.
  static const Color surfaceFieldDark = Color(0xFF262C36);

  // ─── 1.5 WARNA TEKS UTAMA, SEKUNDER, DAN MUTED ───
  /// Warna teks judul utama & headline di Light Mode (Hitam arang pekat).
  static const Color textPrimaryLight = Color(0xFF1C1D1F);

  /// Warna teks judul utama & headline di Dark Mode (Putih salju kontras tinggi).
  static const Color textPrimaryDark = Color(0xFFF8FAFC);

  /// Warna teks keterangan, subjudul, dan deskripsi di Light Mode (Abu hangat netral).
  static const Color textSecondaryLight = Color(0xFF7A7874);

  /// Warna teks keterangan, subjudul, dan deskripsi di Dark Mode (Slate perak lembut).
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  /// Warna teks placeholder, hint text, dan label nonaktif di Light Mode.
  static const Color textMutedLight = Color(0xFFA29F98);

  /// Warna teks placeholder, hint text, dan label nonaktif di Dark Mode.
  static const Color textMutedDark = Color(0xFF64748B);

  // ─── 1.6 WARNA GARIS TEPI / BORDER CONTAINER & DIVIDER ───
  /// Warna garis outline kartu dan divider pemisah di Light Mode (Krem hangat).
  static const Color warmBorderLight = Color(0xFFEAE5DB);

  /// Warna garis outline kartu dan divider pemisah di Dark Mode (Slate border tegas).
  static const Color warmBorderDark = Color(0xFF2D3542);

  // ─── 1.7 WARNA TOMBOL PRIMER, CHIP, DAN WADAH IKON ───
  /// Warna tombol aksi primer di Light Mode (Hitam arang elegan).
  static const Color buttonPrimaryLight = Color(0xFF1C1D1F);

  /// Warna tombol aksi primer di Dark Mode (Slate abu solid terang).
  static const Color buttonPrimaryDark = Color(0xFF333C4A);

  /// Latar chip kategori filter di Light Mode (Krem netral).
  static const Color chipBgLight = Color(0xFFF1EEE7);

  /// Latar chip kategori filter di Dark Mode (Slate gelap netral).
  static const Color chipBgDark = Color(0xFF2B3340);

  /// Latar lingkaran wadah ikon di menu pengaturan & quick actions di Light Mode.
  static const Color iconContainerLight = Color(0xFFF5F1E8);

  /// Latar lingkaran wadah ikon di menu pengaturan & quick actions di Dark Mode.
  static const Color iconContainerDark = Color(0xFF2B3340);

  // ─── 1.8 WARNA DOCK NAVIGASI MENGAMBANG (BOTTOM FLOATING DOCK) ───
  /// Latar belakang bilah navigasi bawah mengambang di Light Mode.
  static const Color dockBgLight = Color(0xFF1C1D1F);

  /// Latar belakang bilah navigasi bawah mengambang di Dark Mode.
  static const Color dockBgDark = Color(0xFF181C22);

  // ─── 1.9 WARNA BRAND & STATUS AKSEN GLOBAL ───
  /// Warna primer identitas brand ParkSmart (Hitam arang signature).
  static const Color primary = Color(0xFF1C1C18);

  /// Warna biru dongker (Navy) khas identitas tombol & badge ParkSmart.
  static const Color brandNavy = Color(0xFF114177);

  /// Latar belakang kanvas aplikasi secara global (alias untuk background).
  static Color get surfaceBackground => background;

  /// Warna sekunder hangat identitas brand (Warm Terracotta / Coral).
  static const Color secondary = Color(0xFFE07A5F);

  /// Warna aksen signature Teal ParkSmart untuk status dan elemen interaktif.
  static const Color accentTeal = Color(0xFF2A9D8F);

  /// Warna terracotta pekat untuk aksen teks dan peringatan ramah.
  static const Color warmTerracotta = Color(0xFF9A442D);

  /// Indikator hijau status slot tersedia, server online, atau transaksi sukses.
  static const Color statusAvailable = Color(0xFF2A9D8F);

  /// Indikator hijau status aksi sukses atau notifikasi berhasil.
  static const Color statusSuccess = Color(0xFF059669);

  /// Indikator merah status slot penuh, server offline, atau error kritis.
  static const Color statusOccupied = Color(0xFFD94B4B);

  /// Indikator merah status aksi gagal atau error.
  static const Color statusError = Color(0xFFDC2626);

  /// Indikator oranye status peringatan, kuota hampir penuh, atau verifikasi pending.
  static const Color statusWarning = Color(0xFFE07A5F);

  /// Putih murni standar (Universal).
  static const Color white = Color(0xFFFFFFFF);

  // ===========================================================================
  // ─── [DYNAMIC GETTERS GLOBAL] BEREAKSI OTOMATIS TERHADAP DARK/LIGHT MODE ───
  // ===========================================================================
  static bool get _isDark => ThemeService.instance.isDarkMode;

  /// Background Scaffold yang otomatis menyesuaikan tema aktif (Light/Dark).
  static Color get background => _isDark ? backgroundDark : backgroundLight;
  static Color get bg => background; // Alias praktis

  /// Card / Container Box Utama yang otomatis menyesuaikan tema aktif.
  static Color get surfaceCard => _isDark ? surfaceCardDark : surfaceCardLight;
  static Color get card => surfaceCard; // Alias praktis
  static Color get container => surfaceCard; // Alias praktis

  /// Secondary Container / Dim Surface yang otomatis menyesuaikan tema aktif.
  static Color get surface => _isDark ? surfaceDimDark : surfaceDimLight;
  static Color get surfaceDim => _isDark ? surfaceDimDark : surfaceDimLight;
  static Color get cardAlt => surfaceDim; // Alias praktis

  /// Input Field / Text Field Background yang otomatis menyesuaikan tema aktif.
  static Color get surfaceField => _isDark ? surfaceFieldDark : surfaceFieldLight;

  /// Warna teks judul & teks penting yang otomatis kontras terhadap tema aktif.
  static Color get textPrimary => _isDark ? textPrimaryDark : textPrimaryLight;

  /// Warna teks sekunder & keterangan yang otomatis ramah di mata untuk tema aktif.
  static Color get textSecondary => _isDark ? textSecondaryDark : textSecondaryLight;

  /// Warna teks placeholder & teks redup yang otomatis menyesuaikan tema aktif.
  static Color get textMuted => _isDark ? textMutedDark : textMutedLight;

  /// Warna garis tepi (border) kartu & pembatas (divider) reaktif tema aktif.
  static Color get warmBorder => _isDark ? warmBorderDark : warmBorderLight;
  static Color get border => warmBorder; // Alias praktis
  static Color get divider => warmBorder;

  /// Warna tombol utama reaktif tema aktif.
  static Color get buttonPrimary => _isDark ? buttonPrimaryDark : buttonPrimaryLight;

  /// Warna latar chip filter reaktif tema aktif.
  static Color get chipBg => _isDark ? chipBgDark : chipBgLight;

  /// Warna wadah lingkaran ikon reaktif tema aktif.
  static Color get iconContainer => _isDark ? iconContainerDark : iconContainerLight;

  /// Warna ikon default yang mengikuti teks utama.
  static Color get iconColor => textPrimary;

  /// Warna latar dock navigasi melayang reaktif tema aktif.
  static Color get dockBg => _isDark ? dockBgDark : dockBgLight;

  /// Latar oranye lembut reaktif tema aktif (misal badge diskon/tag).
  static Color get secondarySoft => _isDark ? const Color(0xFF3B2720) : const Color(0xFFFDECE7);

  /// Latar teal lembut reaktif tema aktif (misal badge aktif/verifikasi).
  static Color get accentTealSoft => _isDark ? const Color(0xFF193834) : const Color(0xFFE3F4F1);

  // ===========================================================================
  // ─── [BAGIAN 2: PER SEGMEN HALAMAN] WARNA UNIK KHUSUS PER FITUR ─────────────
  // ===========================================================================
  // Akses dengan pola: AppColors.<segmen>.<token>

  /// Segmen 1: Slot Selection Screen (Pilihan Denah Slot, Grid, Indikator Lantai)
  static const slot = _AppSlotColors();

  /// Segmen 2: Map & Navigation Screen (Peta, GPS, Kompas, Rute, Traffic)
  static const map = _AppMapColors();

  /// Segmen 3: Parking Detail Screen (Tarif Kendaraan, Ulasan, Jam Operasional)
  static const parkingDetail = _AppParkingDetailColors();

  /// Segmen 4: Auth & Biometrics Screen (Login, Register, Forgot Password, Face ID)
  static const auth = _AppAuthColors();

  /// Segmen 5: Vehicle & Garage (Data Kendaraan, Plat Nomor, Cat Fisik Mobil)
  static const vehicle = _AppVehicleColors();

  /// Segmen 6: System & Maintenance (Banner Perawatan, Offline, Cache Gambar)
  static const system = _AppSystemColors();

  /// Segmen 7: AR Navigation Screen (Visualisasi Jalur Augmented Reality 3D)
  static const ar = _AppArColors();

  /// Segmen 8: Parking Notes (Catatan Pengingat Lokasi & Foto Parkir)
  static const notes = _AppNotesColors();

  /// Segmen 9: Profile & KYC Status (Status Verifikasi, Badge Tier, KTP Scanner)
  static const profile = _AppProfileColors();

  /// Segmen 10: Camera & Viewfinder (Lensa Kamera, Scanner Plat Kendaraan)
  static const camera = _AppCameraColors();

  /// Segmen 11: Home & Dashboard (Dompet ParkSmart Pay, Rekomendasi, Promo)
  static const home = _AppHomeColors();

  /// Segmen 12: Splash Animation (Simulasi Fisika Cairan GPU Shader)
  static const splash = _AppSplashColors();

  /// Segmen 13: Favorite Screen (Tempat Parkir Favorit, Badge Eco, Fast Exit)
  static const favorite = _AppFavoriteColors();

  /// Segmen 14: Modals & Dialogs (Pilihan Mata Uang, Preferensi Parkir)
  static const modal = _AppModalColors();

  /// Segmen 15: Notification Screen (Kartu Notifikasi, Titik Belum Dibaca)
  static const notification = _AppNotificationColors();

  /// Segmen 16: Feedback & Rating Screen (Ulasan Bintang & Form Saran)
  static const feedback = _AppFeedbackColors();
}

// ─────────────────────────────────────────────────────────────────────────────
// [SEGMEN 1] WARNA UNIK HALAMAN PEMILIHAN SLOT (SLOT SELECTION SCREEN)
// ─────────────────────────────────────────────────────────────────────────────
class _AppSlotColors {
  const _AppSlotColors();

  /// Hijau terang: Indikator slot kosong yang siap dipesan di SlotSelectionScreen.
  Color get available => const Color(0xFF10B981);

  /// Teal elektrik: Indikator slot parkir khusus mobil listrik (EV) di SlotSelectionScreen.
  Color get ev => const Color(0xFF17A18A);

  /// Ungu: Indikator slot parkir prioritas difabel di SlotSelectionScreen.
  Color get disabled => const Color(0xFF8B5CF6);

  /// Oranye hangat: Indikator slot prioritas khusus wanita (Ladies Parking) di SlotSelectionScreen.
  Color get ladies => const Color(0xFFF59E0B);

  /// Kuning emas: Indikator slot khusus tamu VIP di SlotSelectionScreen.
  Color get vip => const Color(0xFFEAB308);

  /// Warna slot yang sedang dipilih oleh pengguna di SlotSelectionScreen.
  Color get selected => AppColors._isDark ? const Color(0xFF2DD4BF) : const Color(0xFF114177);

  /// Garis tepi slot yang sedang dipilih pengguna di SlotSelectionScreen.
  Color get selectedBorder => AppColors._isDark ? const Color(0xFF2DD4BF) : const Color(0xFF114177);

  /// Latar slot yang sudah terisi / sudah dibooking orang lain di SlotSelectionScreen.
  Color get booked => AppColors._isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);

  /// Garis tepi slot yang sudah terisi di SlotSelectionScreen.
  Color get bookedBorder => AppColors._isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

  /// Latar belakang floating bar pemesanan di bagian bawah SlotSelectionScreen.
  Color get bookingBarBg => const Color(0xFF16A34A);

  /// Tombol biru aksi final 'Pesan Slot Sekarang' di SlotSelectionScreen.
  Color get bookingButton => const Color(0xFF2563EB);

  /// Garis tepi kartu legenda keterangan warna slot di SlotSelectionScreen.
  Color get legendBorder => AppColors._isDark ? Colors.white : const Color(0xFFC6C6CA);

  /// Latar tab pemilih lantai yang aktif di SlotSelectionScreen.
  Color get floorActive => AppColors._isDark ? const Color(0xFF334155) : const Color(0xFF1C1D1F);

  /// Latar tab pemilih lantai yang tidak aktif di SlotSelectionScreen.
  Color get floorInactive => AppColors._isDark ? const Color(0xFF1E232B) : const Color(0xFFF1EEE7);

  // Legacy Container Constants
  Color get secondary => const Color(0xFF9A442D);
  Color get primaryContainer => const Color(0xFF1C1D1F);
  Color get tertiaryFixed => const Color(0xFFBBEED4);
  Color get surfaceContainerLow => const Color(0xFFF6F3EC);
  Color get surfaceContainerHigh => const Color(0xFFEBE8E1);

  /// Ikon pemilih lantai di SlotSelectionScreen.
  Color get floorIcon => AppColors._isDark ? const Color(0xFF94A3B8) : const Color(0xFF76777A);

  /// Latar lingkaran kompas mini di SlotSelectionScreen.
  Color get compassBg => AppColors._isDark ? Colors.white : const Color(0xFF020304);

  /// Ikon pin lokasi oranye di SlotSelectionScreen.
  Color get pinOrange => AppColors._isDark ? const Color(0xFFFB923C) : const Color(0xFF9A442D);

  /// Teks keterangan sekunder abu-abu gelap di SlotSelectionScreen.
  Color get textSubtle => AppColors._isDark ? const Color(0xFF94A3B8) : const Color(0xFF45474A);

  /// Garis pemisah antar seksi lantai di SlotSelectionScreen.
  Color get divider => AppColors._isDark ? const Color(0xFF334155) : const Color(0xFFEBE8E1);

  /// Ikon tips rekomendasi zona teal di SlotSelectionScreen.
  Color get tipTeal => const Color(0xFF2DD4BF);

  /// Teks tips rekomendasi zona di SlotSelectionScreen.
  Color get tipText => AppColors._isDark ? Colors.white : const Color(0xFF45474A);

  /// Teks tombol filter kendaraan di SlotSelectionScreen.
  Color get btnVehicleText => AppColors._isDark ? Colors.white : const Color(0xFF45474A);

  /// Badge tipe kendaraan terpilih di SlotSelectionScreen.
  Color get btnVehicleBadge => AppColors._isDark ? const Color(0xFF9A442D) : const Color(0xFFFC9174);

  /// Teks badge tipe kendaraan di SlotSelectionScreen.
  Color get btnVehicleBadgeText => AppColors._isDark ? Colors.black87 : const Color(0xFFFCF9F2).withValues(alpha: 0.8);

  /// Ikon viewfinder scanner tiket di SlotSelectionScreen.
  Color get scanIcon => AppColors._isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8);

  /// Teks petunjuk scanner tiket di SlotSelectionScreen.
  Color get scanText => AppColors._isDark ? Colors.white : const Color(0xFF64748B);

  /// Latar kartu legenda tipe slot parkir di SlotSelectionScreen.
  Color get legendBg => AppColors._isDark ? const Color(0xFF1E293B) : const Color(0xFFEBE8E1).withValues(alpha: 0.6);

  /// Latar slot mobil listrik (EV) di SlotSelectionScreen.
  Color get evBg => AppColors._isDark ? const Color(0xFF1E232B) : const Color(0xFFE8F7F4);

  /// Teks nomor slot parkir di SlotSelectionScreen.
  Color get slotNumber => AppColors._isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

  /// Ikon hijau tua fasilitas slot di SlotSelectionScreen.
  Color get iconDarkGreen => const Color(0xFF002115);

  /// Latar badge penanda khusus di SlotSelectionScreen.
  Color get badgeSalmon => const Color(0xFFFC9174);

  /// Teks badge penanda khusus di SlotSelectionScreen.
  Color get badgeSalmonText => const Color(0xFF742814);
}

// ─────────────────────────────────────────────────────────────────────────────
// [SEGMEN 2] WARNA UNIK PETA & KOMPAS (EXPLORE MAP & COMPASS SCREEN)
// ─────────────────────────────────────────────────────────────────────────────
class _AppMapColors {
  const _AppMapColors();

  /// Titik biru lokasi langsung pengguna (GPS User Dot) di ExploreMapScreen.
  Color get userGpsDot => const Color(0xFF2563EB);

  /// Lingkaran transparan radius akurasi GPS pengguna di ExploreMapScreen.
  Color get userGpsRing => const Color(0x332563EB);

  /// Titik denyut hijau radar pencarian lokasi di ExploreMapScreen.
  Color get blipGpsRadar => const Color(0xFF22C55E);

  /// Garis biru rute navigasi dari lokasi pengguna ke lokasi parkir di ExploreMapScreen.
  Color get routePolyline => const Color(0xFF0284C7);

  /// Garis tepi luar kontras untuk polyline rute navigasi di ExploreMapScreen.
  Color get routePolylineOutline => const Color(0xFF0C4A6E);

  /// Indikator hijau: Kondisi lalu lintas lancar di ExploreMapScreen.
  Color get trafficSmooth => const Color(0xFF10B981);

  /// Indikator kuning/oranye: Kondisi lalu lintas padat merayap di ExploreMapScreen.
  Color get trafficSlow => const Color(0xFFF59E0B);

  /// Indikator merah: Kondisi lalu lintas macet total di ExploreMapScreen.
  Color get trafficCongested => const Color(0xFFEF4444);

  /// Jarum merah penunjuk arah mata angin Utara di CompassDetailDialog & ExploreMapScreen.
  Color get compassNeedleNorth => const Color(0xFFEF4444);

  /// Jarum abu-abu penunjuk arah mata angin Selatan di CompassDetailDialog & ExploreMapScreen.
  Color get compassNeedleSouth => const Color(0xFF94A3B8);

  /// Latar belakang gelap piringan dial kompas digital di CompassDetailDialog.
  Color get compassDialBg => const Color(0xFF0F172A);

  /// Garis derajat & aksen teal piringan dial kompas di CompassDetailDialog.
  Color get compassDialAccent => const Color(0xFF2DD4BF);

  /// Lingkaran luar kompas azimuth di CompassDetailDialog.
  Color get compassRing => const Color(0xFF1E293B);

  /// Latar kartu status heading kompas di CompassDetailDialog.
  Color get compassCardBg => AppColors._isDark ? const Color(0xFF1E232B) : const Color(0xFFFFFFFF);

  /// Latar pil estimasi waktu tiba (ETA) di ExploreMapScreen.
  Color get etaPillBg => AppColors._isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);

  /// Latar lingkaran pengelompokan pin parkir (marker cluster) di ExploreMapScreen.
  Color get markerClusterBg => const Color(0xFF114177);

  /// Ujung jarum utara kompas merah di CompassDetailDialog.
  Color get needleNorth => const Color(0xFFEF4444);

  /// Bayangan jarum utara merah gelap di CompassDetailDialog.
  Color get needleNorthShadow => const Color(0xFFDC2626);

  /// Ujung jarum selatan kompas putih/abu di CompassDetailDialog.
  Color get needleSouth => AppColors._isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B);

  /// Bayangan jarum selatan di CompassDetailDialog.
  Color get needleSouthShadow => AppColors._isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

  /// Titik poros tengah jarum kompas di CompassDetailDialog.
  Color get needlePivot => AppColors._isDark ? Colors.white : const Color(0xFF1E293B);

  /// Garis penanda derajat utama (0, 90, 180, 270) di CompassDetailDialog.
  Color get dialMarksMajor => AppColors._isDark ? Colors.white70 : const Color(0xFF1E293B);

  /// Garis penanda derajat minor di CompassDetailDialog.
  Color get dialMarksMinor => AppColors._isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

  /// Lingkaran pinggir piringan kompas di CompassDetailDialog.
  Color get dialRingBorder => AppColors._isDark ? const Color(0xFF475569).withValues(alpha: 0.8) : const Color(0xFF94A3B8);

  /// Garis tepi kartu derajat heading di CompassDetailDialog.
  Color get headingCardBorder => AppColors._isDark ? const Color(0xFF334155).withValues(alpha: 0.5) : const Color(0xFFE2E8F0);

  /// Jarum utara merah terang alternatif di CompassDetailDialog.
  Color get needleNorthAlt => const Color(0xFFFF5252);

  /// Bayangan jarum utara merah tua alternatif di CompassDetailDialog.
  Color get needleNorthAltDark => const Color(0xFFD32F2F);

  /// Jarum selatan kompas alternatif di CompassDetailDialog.
  Color get needleSouthAlt => AppColors._isDark ? const Color(0xFFE2E8F0) : const Color(0xFF64748B);

  /// Bayangan jarum selatan alternatif di CompassDetailDialog.
  Color get needleSouthAltDark => AppColors._isDark ? const Color(0xFF94A3B8) : const Color(0xFF334155);

  /// Poros jarum alternatif di CompassDetailDialog.
  Color get needleCenterDot => AppColors._isDark ? const Color(0xFF1E293B) : Colors.white;

  /// Latar lingkaran arah tujuan parkir di CompassDetailDialog.
  Color get targetBearingBlue => const Color(0xFF1A73E8).withValues(alpha: 0.15);

  /// Ikon panah arah tujuan parkir di CompassDetailDialog.
  Color get targetBearingIcon => const Color(0xFF38BDF8);

  /// Biru khas Google Maps pada tombol rute dan ikon di ExploreMapScreen.
  Color get brandBlue => const Color(0xFF1A73E8);

  /// Merah pin penanda tujuan akhir lokasi di ExploreMapScreen.
  Color get destPinRed => const Color(0xFFEA4335);

  /// Hijau teal adaptif tema gelap/terang di ExploreMapScreen.
  Color get darkTeal => AppColors._isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0F766E);

  /// Gradien 4 cincin pulsasi radar GPS di ExploreMapScreen.
  List<Color> get gpsPuckRings => const [
    Color(0x994285F4),
    Color(0x664285F4),
    Color(0x334285F4),
    Color(0x084285F4),
  ];

  /// Latar biru muda ikon GPS di ExploreMapScreen.
  Color get gpsIconLightBg => const Color(0xFFE8F0FE);

  /// Garis tepi kotak unggah foto admin di ExploreMapScreen.
  Color get adminPhotoBorder => const Color(0xFFDADCE0);

  /// Ikon & teks hijau teal unggah foto admin di ExploreMapScreen.
  Color get adminPhotoTeal => const Color(0xFF0F766E);

  /// Latar kartu ANPR sensor kamera di ExploreMapScreen.
  Color get anprCardBg => AppColors._isDark ? const Color(0xFF1E293B) : const Color(0xFFF0FDF4);

  /// Teks & ikon hijau ANPR sensor di ExploreMapScreen.
  Color get anprGreen => AppColors._isDark ? const Color(0xFF2DD4BF) : const Color(0xFF16A34A);

  /// Latar pil fitur fasilitas tempat parkir di ExploreMapScreen.
  Color get featurePillBg => AppColors._isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F3F4);

  /// Ikon pil fitur fasilitas tempat parkir di ExploreMapScreen.
  Color get featurePillIcon => AppColors._isDark ? const Color(0xFF90CAF9) : const Color(0xFF1A73E8);

  /// Teks pil fitur fasilitas tempat parkir di ExploreMapScreen.
  Color get featurePillText => AppColors._isDark ? const Color(0xFFE2E8F0) : const Color(0xFF3C4043);

  /// Latar selector moda transportasi aktif di ExploreMapScreen.
  Color get modeSelectorActiveBg => AppColors._isDark ? const Color(0xFF1D4ED8) : const Color(0xFFE8F0FE);

  /// Garis tepi selector moda transportasi aktif di ExploreMapScreen.
  Color get modeSelectorActiveBorder => AppColors._isDark ? const Color(0xFF60A5FA) : const Color(0xFF1A73E8);
}

// ─────────────────────────────────────────────────────────────────────────────
// [SEGMEN 3] WARNA UNIK DETAIL PARKIR (PARKING DETAIL SCREEN)
// ─────────────────────────────────────────────────────────────────────────────
class _AppParkingDetailColors {
  const _AppParkingDetailColors();

  /// Aksen biru laut tab pilihan tarif motor di ParkingDetailScreen.
  Color get rateMotor => const Color(0xFF114177);

  /// Aksen hitam arang tab pilihan tarif mobil di ParkingDetailScreen.
  Color get rateMobil => const Color(0xFF1C1D1F);

  /// Aksen hijau teal tab pilihan tarif mobil listrik di ParkingDetailScreen.
  Color get rateEv => const Color(0xFF17A18A);

  /// Badge hijau fasilitas kamera sensor ANPR di ParkingDetailScreen.
  Color get anprSensorBadge => const Color(0xFF10B981);

  /// Ikon hati merah saat lokasi parkir difavoritkan di ParkingDetailScreen & FavoriteScreen.
  Color get favoriteActive => const Color(0xFFEF4444);

  /// Warna abu-abu placeholder saat foto galeri lokasi parkir loading di ParkingDetailScreen.
  Color get photoPlaceholder => const Color(0xFF9CA3AF);

  /// Badge hijau penanda lokasi parkir sedang buka di ParkingDetailScreen.
  Color get statusOpen => const Color(0xFF10B981);

  /// Badge merah penanda lokasi parkir sedang tutup di ParkingDetailScreen.
  Color get statusClosed => const Color(0xFFDC2626);

  /// Ikon penunjuk arah alamat lokasi parkir di ParkingDetailScreen.
  Color get navAddressIcon => AppColors._isDark ? const Color(0xFF2DD4BF) : const Color(0xFF1F4F3C);

  /// Latar kartu tips rekomendasi zona parkir terbaik di ParkingDetailScreen.
  Color get zoneTipCardBg => AppColors._isDark ? const Color(0xFF1E232B) : const Color(0xFF1C1C18);

  /// Aksen oranye tarif kendaraan reguler/motor di ParkingDetailScreen.
  Color get rateAccentDefault => const Color(0xFFD96B43);

  /// Latar snackbar saat lokasi parkir dihapus dari favorit di ParkingDetailScreen.
  Color get favoriteRemovedBg => const Color(0xFF475569);

  /// Ikon fasilitas penunjang parkir (CCTV, Valet, Ev Charge) di ParkingDetailScreen.
  Color get amenityIcon => AppColors._isDark ? const Color(0xFF2DD4BF) : const Color(0xFF45474A);
}

// ─────────────────────────────────────────────────────────────────────────────
// [SEGMEN 4] WARNA UNIK AUTENTIKASI & BIOMETRIK (AUTH & BIOMETRICS)
// ─────────────────────────────────────────────────────────────────────────────
class _AppAuthColors {
  const _AppAuthColors();

  /// Garis laser hijau pemindai wajah di FaceIdScannerDialog.
  Color get faceLaser => const Color(0xFF10B981);

  /// Garis bidik bingkai pemindai wajah di FaceIdScannerDialog.
  Color get faceBorder => const Color(0xFF2DD4BF);

  /// Latar gelap transparan pemindai kamera biometrik di FaceIdScannerDialog.
  Color get faceOverlayBg => Colors.black.withValues(alpha: 0.65);

  /// Latar lingkaran radar scanner biometrik di FaceIdScannerDialog.
  Color get faceRadarRing => const Color(0xFF0D9488);

  /// Lingkaran progress scanner wajah saat membaca fitur di FaceIdScannerDialog.
  Color get faceProgress => const Color(0xFF2DD4BF);

  /// Warna indikator scanner saat sukses memverifikasi wajah di FaceIdScannerDialog.
  Color get faceSuccess => const Color(0xFF34D399);

  /// Gradien awal header halaman LoginScreen & RegisterScreen.
  Color get brandGradientStart => const Color(0xFF114177);

  /// Gradien akhir header halaman LoginScreen & RegisterScreen.
  Color get brandGradientEnd => const Color(0xFF0284C7);

  /// Latar tombol putih 'Sign in with Google' di LoginScreen & RegisterScreen.
  Color get googleButtonBg => const Color(0xFFFFFFFF);

  /// Garis tepi tombol Google di LoginScreen & RegisterScreen.
  Color get googleButtonBorder => const Color(0xFFE2E8F0);

  /// Garis pegangan (drag handle) penarik modal sheet di LoginScreen.
  Color get dragHandle => AppColors._isDark
      ? const Color(0xFF475569)
      : const Color(0xFF1E293B).withValues(alpha: 0.20);

  /// Latar avatar lingkaran default pengguna di header RegisterScreen.
  Color get avatarHeaderBg => AppColors._isDark ? const Color(0xFF0D2824) : const Color(0xFF1C1C18);

  /// Warna fokus input form di LoginScreen & RegisterScreen.
  Color get inputFocus => AppColors._isDark ? const Color(0xFF2DD4BF) : const Color(0xFF114177);

  /// Warna tautan / link teks 'Lupa Password' dan 'Daftar' di LoginScreen & RegisterScreen.
  Color get linkBlue => AppColors._isDark ? const Color(0xFF38BDF8) : const Color(0xFF114177);

  /// Warna aksen oranye pada tab header di LoginScreen.
  Color get accentOrange => AppColors._isDark ? const Color(0xFFFB923C) : const Color(0xFFC05621);

  /// Garis border input modal admin di LoginScreen.
  Color get adminModalBorder => const Color(0xFFE2E8F0);

  /// Ikon pada input dialog admin di LoginScreen.
  Color get adminModalIcon => const Color(0xFF64748B);

  /// Teks pada input dialog admin di LoginScreen.
  Color get adminModalText => const Color(0xFF0F172A);

  /// Teks hint placeholder dialog admin di LoginScreen.
  Color get adminModalHint => const Color(0xFF94A3B8);

  /// Tombol submit dialog admin portal di LoginScreen.
  Color get adminModalButton => const Color(0xFF0F172A);

  /// Latar kartu box input OTP di ForgotPasswordScreen.
  Color get otpCardBg => AppColors._isDark ? const Color(0xFF161E28) : const Color(0xFFF0F5FA);

  /// Garis border box input OTP di ForgotPasswordScreen.
  Color get otpCardBorder => AppColors._isDark ? const Color(0xFF223447) : const Color(0xFFD6E4F0);
}

// ─────────────────────────────────────────────────────────────────────────────
// [SEGMEN 5] WARNA UNIK KENDARAAN (VEHICLE & GARAGE SCREEN)
// ─────────────────────────────────────────────────────────────────────────────
class _AppVehicleColors {
  const _AppVehicleColors();

  /// Latar hitam plat nomor kendaraan di VehicleScreen & AddVehicleScreen.
  Color get plateBg => const Color(0xFF18181B);

  /// Teks putih plat nomor kendaraan di VehicleScreen & AddVehicleScreen.
  Color get plateText => const Color(0xFFF8FAFC);

  /// Garis biru plat mobil listrik ramah lingkungan di VehicleScreen & AddVehicleScreen.
  Color get plateEvStripe => const Color(0xFF38BDF8);

  /// Badge hijau penanda kendaraan utama (Default Vehicle) di VehicleScreen.
  Color get defaultBadge => const Color(0xFF0D9488);

  /// Tombol merah hapus data kendaraan di VehicleScreen.
  Color get deleteDanger => const Color(0xFFEF4444);

  // Pilihan Warna Cat Fisik Mobil (Kategori A: Fisik Dunia Nyata di AddVehicleScreen)
  /// Cat fisik kendaraan: Hitam metalik di AddVehicleScreen.
  Color get paintBlack => const Color(0xFF171717);

  /// Cat fisik kendaraan: Abu-abu abu rokok di AddVehicleScreen.
  Color get paintGrey => const Color(0xFF64748B);

  /// Cat fisik kendaraan: Merah marun di AddVehicleScreen.
  Color get paintRed => const Color(0xFFBE123C);

  /// Cat fisik kendaraan: Perak elegan di AddVehicleScreen.
  Color get paintSilver => const Color(0xFFD6D3D1);

  /// Cat fisik kendaraan: Putih mutiara di AddVehicleScreen.
  Color get paintWhite => const Color(0xFFFFFFFF);

  /// Notifikasi snackbar sukses scan OCR & simpan kendaraan di AddVehicleScreen.
  Color get ocrSuccess => const Color(0xFF10B981);

  /// Notifikasi snackbar error validasi plat nomor di AddVehicleScreen.
  Color get ocrError => const Color(0xFFDC2626);

  /// Latar header modal scanner di AddVehicleScreen.
  Color get modalHeaderBg => AppColors._isDark ? const Color(0xFF1E232B) : const Color(0xFF141518);

  /// Latar dialog konfirmasi / opsi di AddVehicleScreen.
  Color get dialogBg => AppColors._isDark ? const Color(0xFF1E232B) : Colors.white;

  /// Teks petunjuk OCR di AddVehicleScreen.
  Color get ocrHelpText => AppColors._isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

  /// Latar input teks manual OCR di AddVehicleScreen.
  Color get ocrInputFill => AppColors._isDark ? const Color(0xFF2E3848) : const Color(0xFFF1F5F9);

  /// Latar fisik plat nomor simulasi di AddVehicleScreen.
  Color get physicalPlatePreviewBg => const Color(0xFF111215);

  /// Garis tepi plat nomor aktif terisi di AddVehicleScreen.
  Color get plateBorderActive => const Color(0xFF34D399);

  /// Garis tepi plat nomor saat kosong di AddVehicleScreen.
  Color get plateBorderInactive => const Color(0xFF2E3848);

  /// Teks kecil masa berlaku plat nomor di AddVehicleScreen.
  Color get plateMutedText => const Color(0xFFA3A3A3);

  /// Ikon dan teks plat nomor terverifikasi di AddVehicleScreen.
  Color get plateVerifiedGreen => const Color(0xFF34D399);

  /// Latar banner peringatan di AddVehicleScreen.
  Color get warningBannerBg => AppColors._isDark ? const Color(0xFF3B2720) : const Color(0xFFFFFBEB);

  /// Garis tepi banner peringatan di AddVehicleScreen.
  Color get warningBannerBorder => AppColors._isDark ? const Color(0xFF7C2D12) : const Color(0xFFFDE68A);

  /// Teks banner peringatan di AddVehicleScreen.
  Color get warningBannerText => AppColors._isDark ? const Color(0xFFFB923C) : const Color(0xFF92400E);

  /// Latar kartu status OCR realtime di AddVehicleScreen.
  Color get ocrLiveStatusCardBg => AppColors._isDark ? const Color(0xFF064E3B) : const Color(0xFFD1FAE5);

  /// Teks kartu status OCR realtime di AddVehicleScreen.
  Color get ocrLiveStatusCardText => AppColors._isDark ? const Color(0xFF6EE7B7) : const Color(0xFF065F46);

  /// Tombol utama aksi (Simpan / Lanjut) di AddVehicleScreen.
  Color get primaryActionButton => AppColors._isDark ? Colors.white : const Color(0xFF141518);

  /// Latar akurasi OCR tinggi (>80%) di AddVehicleScreen.
  Color get confScoreBgSuccess => AppColors._isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5);

  /// Latar akurasi OCR sedang (<80%) di AddVehicleScreen.
  Color get confScoreBgWarning => AppColors._isDark ? const Color(0xFF451A03) : const Color(0xFFFFFBEB);

  /// Border akurasi OCR tinggi di AddVehicleScreen.
  Color get confScoreBorderSuccess => AppColors._isDark ? const Color(0xFF047857) : const Color(0xFFA7F3D0);

  /// Border akurasi OCR sedang di AddVehicleScreen.
  Color get confScoreBorderWarning => AppColors._isDark ? const Color(0xFFB45309) : const Color(0xFFFDE68A);

  /// Ikon akurasi tinggi di AddVehicleScreen.
  Color get confScoreIconSuccess => const Color(0xFF10B981);

  /// Ikon akurasi sedang di AddVehicleScreen.
  Color get confScoreIconWarning => const Color(0xFFF59E0B);

  /// Teks akurasi tinggi di AddVehicleScreen.
  Color get confScoreTextSuccess => AppColors._isDark ? const Color(0xFF6EE7B7) : const Color(0xFF047857);

  /// Teks akurasi sedang di AddVehicleScreen.
  Color get confScoreTextWarning => AppColors._isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309);

  /// Garis tepi preview plat OCR di AddVehicleScreen.
  Color get ocrPlatePreviewBorder => AppColors._isDark ? const Color(0xFF334155) : const Color(0xFF2B2D33);

  /// Teks putih terang plat nomor di AddVehicleScreen.
  Color get plateHighlightText => const Color(0xFFE5E5E5);

  /// Latar chip scanner cepat di AddVehicleScreen.
  Color get quickScanChipBg => AppColors._isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);

  /// Warna teks batas peringatan hapus foto plat di AddVehicleScreen.
  Color get plateDeleteWarning => const Color(0xFFDC2626).withValues(alpha: 0.85);

  /// Latar isian form data kendaraan di AddVehicleScreen.
  Color get fieldFill => AppColors._isDark ? const Color(0xFF1E232B) : const Color(0xFFF7F5ED);

  /// Ikon centang hijau validasi plat di AddVehicleScreen.
  Color get plateCheckIcon => const Color(0xFF34D399);

  /// Teks gelap item opsi kendaraan di AddVehicleScreen.
  Color get itemDarkText => const Color(0xFF1C1917);
}

// ─────────────────────────────────────────────────────────────────────────────
// [SEGMEN 6] WARNA UNIK SISTEM & PEMELIHARAAN (SYSTEM & MAINTENANCE)
// ─────────────────────────────────────────────────────────────────────────────
class _AppSystemColors {
  const _AppSystemColors();

  /// Ikon dan teks merah status pemeliharaan darurat di MaintenanceService.
  Color get maintenanceRed => const Color(0xFFDC2626);

  /// Latar belakang banner darurat perbaikan server di MaintenanceService.
  Color get maintenanceBg => const Color(0xFFFDE8E4);

  /// Garis tepi banner darurat perbaikan server di MaintenanceService.
  Color get maintenanceBorder => const Color(0xFFFCA5A5);

  /// Ikon peringatan kuning pemeliharaan terjadwal di MaintenanceService.
  Color get warningYellow => const Color(0xFFD97706);

  /// Latar kotak pengumuman pemeliharaan di MaintenanceService.
  Color get warningBg => const Color(0xFFFEF3C7);

  /// Garis tepi kotak pengumuman pemeliharaan di MaintenanceService.
  Color get warningBorder => const Color(0xFFFDE68A);

  /// Indikator jaringan internet aktif dan normal di NoInternetOverlay.
  Color get onlineGreen => const Color(0xFF10B981);

  /// Indikator jaringan internet terputus di NoInternetOverlay.
  Color get offlineRed => const Color(0xFFEF4444);

  /// Tombol biru 'Coba Lagi' di NoInternetOverlay.
  Color get retryButton => AppColors._isDark ? const Color(0xFF38BDF8) : const Color(0xFF114177);

  /// Ikon Wi-Fi putus merah di NoInternetOverlay.
  Color get offlineIconRed => const Color(0xFFD94B4B);

  /// Latar kotak notifikasi koneksi offline di NoInternetOverlay.
  Color get offlineBadgeBg => const Color(0xFFFDE8E4);

  /// Garis tepi notifikasi koneksi offline di NoInternetOverlay.
  Color get offlineBadgeBorder => const Color(0xFFFCA5A5);

  /// Latar kotak placeholder saat gambar sedang memuat di AppImageCacheService.
  Color get cachePlaceholderBg => const Color(0xFFF1EEE7);

  /// Ikon gambar rusak / loading di AppImageCacheService.
  Color get cachePlaceholderIcon => const Color(0xFF9CA3AF);

  /// Latar kotak detail log teknis sistem di MaintenanceService.
  Color get adminLogBg => const Color(0xFFF8FAFC);

  /// Border kotak detail log teknis sistem di MaintenanceService.
  Color get adminLogBorder => const Color(0xFFE2E8F0);

  /// Teks detail log teknis di MaintenanceService.
  Color get adminLogText => const Color(0xFF334155);

  /// Latar tombol logout darurat di MaintenanceService.
  Color get maintenanceBtnBg => const Color(0xFF1C1D1F);
}

// ─────────────────────────────────────────────────────────────────────────────
// [SEGMEN 7] WARNA UNIK NAVIGASI AUGMENTED REALITY (AR NAVIGATION)
// ─────────────────────────────────────────────────────────────────────────────
class _AppArColors {
  const _AppArColors();

  /// Bidik hijau kamera AR saat waypoint terdeteksi tepat di ArNavigationScreen.
  Color get reticleActive => const Color(0xFF10B981);

  /// Bidik kuning kamera AR saat mencari titik orientasi di ArNavigationScreen.
  Color get reticleSearch => const Color(0xFFF59E0B);

  /// Garis laser pemandu virtual 3D menuju slot parkir di ArNavigationScreen.
  Color get laserGuide => const Color(0xFF06B6D4);

  /// Pin penanda tujuan akhir lokasi parkir di ArNavigationScreen.
  Color get destinationMarker => const Color(0xFFEF4444);

  /// Bayangan luar garis rute navigasi di ArNavigationScreen.
  Color get routeShadow => const Color(0xFF1558B0);

  /// Garis inti rute navigasi GPS aktif di ArNavigationScreen.
  Color get routeActive => const Color(0xFF1A73E8);

  /// Latar pin merah penanda tujuan di ArNavigationScreen.
  Color get destPinBg => const Color(0xFFEA4335);

  /// Aura biru akurasi GPS pengguna di ArNavigationScreen.
  Color get gpsAura => const Color(0xFF1A73E8).withValues(alpha: 0.22);

  /// Latar tombol suara bisu di ArNavigationScreen.
  Color get soundMutedBg => AppColors._isDark ? const Color(0xFF7F1D1D).withValues(alpha: 0.35) : const Color(0xFFFCE8E6);

  /// Ikon suara bisu di ArNavigationScreen.
  Color get soundMutedIcon => const Color(0xFFF87171);

  /// Indikator hijau status GPS terkunci di ArNavigationScreen.
  Color get gpsPillLocked => const Color(0xFF10B981);

  /// Indikator oranye/merah mencari sinyal GPS di ArNavigationScreen.
  Color get gpsPillSearching => AppColors._isDark ? const Color(0xFFF87171) : const Color(0xFF9A442D);

  /// Latar kartu pill estimasi durasi & jarak di ArNavigationScreen.
  Color get hudTimePillBg => AppColors._isDark ? const Color(0xFF262C36) : const Color(0xFF1C1D1F);

  /// Ikon tombol pusatkan lokasi GPS di ArNavigationScreen.
  Color get myLocationIcon => AppColors._isDark ? const Color(0xFF38BDF8) : const Color(0xFF1C1D1F);

  /// Warna snackbar hijau saat berhasil tiba di lokasi tujuan di ArNavigationScreen.
  Color get successArrived => const Color(0xFF1E8E3E);

  /// Ikon sensor kompas di dialog menu ArNavigationScreen.
  Color get bearingNorthTeal => AppColors._isDark ? const Color(0xFF34D399) : const Color(0xFF1C1D1F);

  /// Warna teks dan ikon batalkan/hentikan navigasi di ArNavigationScreen.
  Color get stopNavRed => const Color(0xFFEA4335);
}

// ─────────────────────────────────────────────────────────────────────────────
// [SEGMEN 8] WARNA UNIK CATATAN PARKIR (PARKING NOTES SCREEN)
// ─────────────────────────────────────────────────────────────────────────────
class _AppNotesColors {
  const _AppNotesColors();

  /// Tag warna ungu penanda nomor lantai parkir di ParkingNotesScreen & AddParkingNoteScreen.
  Color get pillFloor => const Color(0xFF8B5CF6);

  /// Tag warna merah muda penanda zona parkir di ParkingNotesScreen & AddParkingNoteScreen.
  Color get pillZone => const Color(0xFFEC4899);

  /// Tag warna biru penanda nomor slot parkir di ParkingNotesScreen & AddParkingNoteScreen.
  Color get pillSlot => const Color(0xFF0EA5E9);

  /// Tombol biru aksi utama (FAB, Buat Catatan, Simpan) di ParkingNotesScreen & AddParkingNoteScreen.
  Color get primaryBlue => const Color(0xFF2563EB);

  /// Latar badge hijau status catatan parkir aktif di ParkingNotesScreen.
  Color get activeStatusBg => const Color(0xFF10B981).withAlpha(25);

  /// Teks badge hijau status catatan parkir aktif di ParkingNotesScreen.
  Color get activeStatusText => const Color(0xFF10B981);

  /// Ikon dan teks oranye pengingat alarm waktu parkir di ParkingNotesScreen.
  Color get alarmWarning => const Color(0xFFF59E0B);

  /// Ikon biru penanda tanggal & waktu pengingat dipilih di AddParkingNoteScreen.
  Color get reminderSelected => const Color(0xFF3B82F6);

  /// Latar snackbar hijau sukses menyimpan catatan di AddParkingNoteScreen.
  Color get saveSuccess => const Color(0xFF10B981);
}

// ─────────────────────────────────────────────────────────────────────────────
// [SEGMEN 9] WARNA STATUS PROFIL & KYC (PROFILE & KYC SCREEN)
// ─────────────────────────────────────────────────────────────────────────────
class _AppProfileColors {
  const _AppProfileColors();

  /// Badge hijau tanda verifikasi identitas (KYC) disetujui di SettingsScreen & ProfileScreen.
  Color get kycVerified => const Color(0xFF10B981);

  /// Badge oranye tanda verifikasi KYC sedang ditinjau di SettingsScreen.
  Color get kycPending => const Color(0xFFF59E0B);

  /// Badge merah tanda verifikasi KYC ditolak di SettingsScreen.
  Color get kycRejected => const Color(0xFFEF4444);

  /// Latar oranye kotak ringkasan penghematan uang parkir di ProfileScreen.
  Color get savingsOrange => const Color(0xFFC05621);

  /// Tombol merah keluar dari akun pengguna di ProfileScreen & SettingsScreen.
  Color get logoutRed => const Color(0xFF8B0000);

  // Gradien Tingkat Keanggotaan (Membership Tiers di ProfileScreen)
  /// Gradien perunggu untuk anggota akun Bronze di ProfileScreen.
  List<Color> get badgeBronze => const [Color(0xFF8C532B), Color(0xFFBF7B46), Color(0xFF6E3E1C)];

  /// Gradien perak untuk anggota akun Silver di ProfileScreen.
  List<Color> get badgeSilver => const [Color(0xFF7E8B9B), Color(0xFFBDC7D0), Color(0xFF6C7887)];

  /// Gradien emas murni untuk anggota akun Gold di ProfileScreen.
  List<Color> get badgeGold => const [Color(0xFFC5942B), Color(0xFFFFD56B), Color(0xFF9E6E17)];

  /// Gradien platinum mewah untuk anggota akun Platinum di ProfileScreen.
  List<Color> get badgePlatinum => const [Color(0xFFA2AAB3), Color(0xFFD4D8DD), Color(0xFF8B95A1)];

  /// Latar redup gelap kamera pemindai KTP di KtpCameraScreen.
  Color get ktpOverlayBg => const Color(0xFF070B12).withValues(alpha: 0.85);

  /// Garis bidik pemandu batas kartu identitas KTP di KtpCameraScreen.
  Color get ktpGuideBorder => const Color(0xFF2DD4BF);

  /// Latar kotak isian saran & pesan perkuliahan di ProfileScreen.
  Color get feedbackFieldBg => AppColors._isDark ? const Color(0xFF1E232B) : const Color(0xFFF8FAFC);

  /// Ikon lampu ide saran perkuliahan di ProfileScreen.
  Color get feedbackIdeaYellow => AppColors._isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);

  /// Ikon pesan percakapan perkuliahan di ProfileScreen.
  Color get feedbackMessageGreen => AppColors._isDark ? const Color(0xFF34D399) : const Color(0xFF059669);

  /// Garis tepi fokus input teks saran & pesan perkuliahan di ProfileScreen.
  Color get feedbackFocusBorder => AppColors._isDark ? const Color(0xFF38BDF8) : const Color(0xFF2563EB);

  /// Tombol simpan data saran & pesan perkuliahan di ProfileScreen.
  Color get feedbackSaveBtn => AppColors._isDark ? const Color(0xFF2563EB) : const Color(0xFF1E3A8A);
}

// ─────────────────────────────────────────────────────────────────────────────
// [SEGMEN 10] WARNA KAMERA & LENSA VIEWFINDER (KATEGORI A: PERANGKAT FISIK)
// ─────────────────────────────────────────────────────────────────────────────
class _AppCameraColors {
  const _AppCameraColors();

  /// Latar redup gelap di luar bingkai kamera di CustomCameraScreen.
  Color get viewfinderOverlay => const Color(0xFF141518);

  /// Bingkai bidik kamera lensa di CustomCameraScreen.
  Color get viewfinderBorder => const Color(0xFF2E323B);

  /// Garis laser hijau pembaca plat otomatis di CustomCameraScreen.
  Color get scannerGreen => const Color(0xFF34D399);

  /// Ikon perisai hijau tanda plat terverifikasi aman di CustomCameraScreen.
  Color get shieldGreen => const Color(0xFF047857);

  /// Warna teks tombol kamera sekunder di CustomCameraScreen.
  Color get cameraBtnMuted => const Color(0xFF94A3B8);

  /// Latar bar bawah tombol jepret kamera di CustomCameraScreen.
  Color get cameraControlBar => const Color(0xFF0D0E11);

  /// Latar dialog pemrosesan OCR gambar plat di CustomCameraScreen.
  Color get loadingDialogBg => const Color(0xFF1E2128);
}

// ─────────────────────────────────────────────────────────────────────────────
// [SEGMEN 11] WARNA BERANDA & DASHBOARD (HOME & DASHBOARD)
// ─────────────────────────────────────────────────────────────────────────────
class _AppHomeColors {
  const _AppHomeColors();

  /// Gradien awal kartu dompet saldo ParkSmart Pay di HomeScreen.
  Color get walletGradientStart => const Color(0xFF114177);

  /// Gradien akhir kartu dompet saldo ParkSmart Pay di HomeScreen.
  Color get walletGradientEnd => const Color(0xFF0284C7);

  /// Latar hijau badge voucher / promosi parkir di HomeScreen.
  Color get promoTagBg => const Color(0xFFDCFCE7);

  /// Teks hijau badge voucher / promosi parkir di HomeScreen.
  Color get promoTagText => const Color(0xFF15803D);

  /// Bintang kuning rating ulasan tempat parkir di HomeScreen & ParkingDetailScreen.
  Color get starYellow => const Color(0xFFF4B400);

  /// Indikator hijau: Tempat parkir masih lowong di HomeScreen.
  Color get capacityLow => const Color(0xFF10B981);

  /// Indikator oranye: Tempat parkir mulai padat di HomeScreen.
  Color get capacityMedium => const Color(0xFFF59E0B);

  /// Indikator merah: Tempat parkir hampir penuh di HomeScreen.
  Color get capacityHigh => const Color(0xFFEF4444);

  /// Latar banner peringatan booking aktif di HomeScreen.
  Color get activeBookingBannerBg => const Color(0xFFFEF3C7);

  /// Garis tepi banner peringatan booking aktif di HomeScreen.
  Color get activeBookingBannerBorder => const Color(0xFFFDE68A);

  /// Ikon peringatan booking aktif di HomeScreen.
  Color get activeBookingBannerIcon => const Color(0xFFD97706);

  /// Teks judul booking aktif di HomeScreen.
  Color get activeBookingBannerTitle => const Color(0xFF92400E);

  /// Teks subjudul booking aktif di HomeScreen.
  Color get activeBookingBannerSub => const Color(0xFFB45309);

  /// Gradien merah peringatan waktu parkir overstay di HomeScreen.
  List<Color> get overstayGradient => const [Color(0xFF8B0000), Color(0xFFC0392B)];

  /// Warna merah peringatan overstay di HomeScreen.
  Color get overstayRed => const Color(0xFFC0392B);

  /// Aura biru pencarian lokasi GPS di HomeScreen.
  Color get searchGpsAura => const Color(0xFF1A73E8).withValues(alpha: 0.18);

  /// Lingkaran radar hijau lokasi di HomeScreen.
  Color get radarGreen => const Color(0xFF10B981);

  /// Latar banner status satelit live di HomeScreen.
  Color get satelliteBannerBg => const Color(0xFFECFDF5);

  /// Garis tepi banner satelit live di HomeScreen.
  Color get satelliteBannerBorder => const Color(0xFFA7F3D0);

  /// Teks dan ikon hijau status satelit live di HomeScreen.
  Color get satelliteBannerGreen => const Color(0xFF059669);

  /// Latar tombol tutup modal di HomeScreen.
  Color get modalCloseBtnBg => const Color(0xFFF3F4F6);

  /// Ikon tombol tutup modal di HomeScreen.
  Color get modalCloseBtnIcon => const Color(0xFF6B7280);

  /// Garis pembatas (divider) dalam modal di HomeScreen.
  Color get modalDivider => const Color(0xFFF3F4F6);

  // Kategori Filter Cepat Lokasi di HomeScreen
  Color get catMallBg => const Color(0xFFEEF2FF);
  Color get catMallIcon => const Color(0xFF4F46E5);
  Color get catAirportBg => const Color(0xFFECFDF5);
  Color get catAirportIcon => const Color(0xFF059669);
  Color get catStationBg => const Color(0xFFEFF6FF);
  Color get catStationIcon => const Color(0xFF2563EB);
  Color get catTourismBg => const Color(0xFFFFF7ED);
  Color get catTourismIcon => const Color(0xFFD97706);
  Color get catCampusBg => const Color(0xFFFAF5FF);
  Color get catCampusIcon => const Color(0xFF9333EA);
  Color get catHospitalBg => const Color(0xFFFFF1F2);
  Color get catHospitalIcon => const Color(0xFFE11D48);

  /// Latar kartu GPS lokasi saat ini di HomeScreen.
  Color get gpsLocationCardBg => const Color(0xFFF9FAFB);

  /// Garis tepi kartu GPS lokasi saat ini di HomeScreen.
  Color get gpsLocationCardBorder => const Color(0xFFE5E7EB);

  /// Ikon kartu GPS lokasi saat ini di HomeScreen.
  Color get gpsLocationCardIcon => const Color(0xFF6B7280);

  /// Teks kartu GPS lokasi saat ini di HomeScreen.
  Color get gpsLocationCardText => const Color(0xFF4B5563);

  /// Teks abu-abu redup petunjuk pencarian di HomeScreen.
  Color get searchMutedText => const Color(0xFF9CA3AF);

  /// Teks gelap hasil pencarian di HomeScreen.
  Color get searchResultDarkText => const Color(0xFF1F2937);

  /// Denyut radar hijau gelap di HomeScreen.
  Color get radarPulseDark => const Color(0xFF059669);

  /// Denyut radar hijau terang di HomeScreen.
  Color get radarPulseLight => const Color(0xFF34D399);

  /// Chip filter hijau menyala di HomeScreen.
  Color get filterChipGreen => const Color(0xFF00E676);

  /// Teks abu-abu chip filter di HomeScreen.
  Color get filterChipText => const Color(0xFF62615B);

  /// Garis bayangan kartu di HomeScreen.
  Color get cardShadowBorder => AppColors._isDark ? const Color(0xFF2D3542) : Colors.black.withValues(alpha: 0.06);

  /// Latar placeholder foto kartu parkir di HomeScreen.
  Color get cardPhotoPlaceholderBg => const Color(0xFFE5E7EB);

  /// Ikon placeholder foto kartu parkir di HomeScreen.
  Color get cardPhotoPlaceholderIcon => const Color(0xFF9CA3AF);

  /// Latar badge mobil listrik EV di kartu parkir HomeScreen.
  Color get cardEvBadgeBg => const Color(0xFF0F766E).withValues(alpha: 0.94);

  /// Teks sekunder kartu tempat parkir di HomeScreen.
  Color get cardSecondaryText => AppColors._isDark ? Colors.white : const Color(0xFF5F6368);

  /// Teks jarak tempat parkir di HomeScreen.
  Color get cardDistanceText => AppColors._isDark ? const Color(0xFF94A3B8) : const Color(0xFF76777B);

  /// Teks tarif parkir di HomeScreen.
  Color get cardPriceText => AppColors._isDark ? Colors.white : const Color(0xFF0F766E);
}

// ─────────────────────────────────────────────────────────────────────────────
// [SEGMEN 12] WARNA SIMULASI ANIMASI SPLASH (KATEGORI A: GPU FLUID DYNAMICS)
// ─────────────────────────────────────────────────────────────────────────────
class _AppSplashColors {
  const _AppSplashColors();

  /// Gelombang teal atas animasi fluida GPU di SplashScreen.
  Color get waveTop => const Color(0xFF0D9488);

  /// Gelombang hijau bawah animasi fluida GPU di SplashScreen.
  Color get waveBottom => const Color(0xFF064E3B);

  /// Latar belakang kanvas hitam obsidian di SplashScreen.
  Color get splashCanvasBg => const Color(0xFF070B12);

  /// Pendar cahaya ambient oranye logo di SplashScreen.
  Color get ambientOrange => const Color(0xFFF97316);

  /// Pendar cahaya ambient teal logo di SplashScreen.
  Color get ambientTeal => const Color(0xFF0D9488);

  /// Latar lingkaran ikon logo utama di SplashScreen.
  Color get logoCenterBg => const Color(0xFF0F172A);

  /// Gradien tengah ombak oranye fluida di SplashScreen.
  Color get ambientDarkOrange => const Color(0xFFC05621);

  /// Gradien dasar ombak fluida di SplashScreen.
  Color get ambientDeepRust => const Color(0xFF7C2D12);

  /// Puncak gelombang keemasan (golden crest) di SplashScreen.
  Color get ambientGold => const Color(0xFFFBBF24);

  /// Gradien kabur keemasan di SplashScreen.
  Color get ambientAmber => const Color(0xFFF59E0B);
}

// ─────────────────────────────────────────────────────────────────────────────
// [SEGMEN 13] WARNA UNIK LAYAR FAVORIT (FAVORITE SCREEN)
// ─────────────────────────────────────────────────────────────────────────────
class _AppFavoriteColors {
  const _AppFavoriteColors();

  /// Ikon hati merah lokasi parkir yang tersimpan di FavoriteScreen.
  Color get activeHeart => const Color(0xFFEF4444);

  /// Latar badge hijau ramah lingkungan di kartu parkir FavoriteScreen.
  Color get badgeEcoBg => AppColors._isDark
      ? const Color(0xFF064E3B).withValues(alpha: 0.5)
      : const Color(0xFFDEF7EC);

  /// Teks hijau badge ramah lingkungan di kartu parkir FavoriteScreen.
  Color get badgeEcoText => AppColors._isDark ? const Color(0xFF6EE7B7) : const Color(0xFF03543F);

  /// Latar badge biru akses keluar cepat di kartu parkir FavoriteScreen.
  Color get badgeFastBg => AppColors._isDark
      ? const Color(0xFF1E3A8A).withValues(alpha: 0.5)
      : const Color(0xFFE1EFFE);

  /// Teks biru badge akses keluar cepat di kartu parkir FavoriteScreen.
  Color get badgeFastText => AppColors._isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E429F);

  /// Ikon centang biru verifikasi resmi lokasi di FavoriteScreen.
  Color get verifiedBadge => const Color(0xFF1A73E8);

  /// Latar filter chip kategori aktif di FavoriteScreen.
  Color get filterChipActiveBg => AppColors._isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF);

  /// Teks filter chip kategori aktif di FavoriteScreen.
  Color get filterChipActiveText => AppColors._isDark ? const Color(0xFF38BDF8) : const Color(0xFF114177);
}

// ─────────────────────────────────────────────────────────────────────────────
// [SEGMEN 14] WARNA UNIK MODAL & PREFERENSI (CURRENCY & PREFERENCE MODALS)
// ─────────────────────────────────────────────────────────────────────────────
class _AppModalColors {
  const _AppModalColors();

  /// Latar baris mata uang yang sedang dipilih di CurrencySelectionModal.
  Color get currencySelectedBg => AppColors._isDark ? const Color(0xFF262C36) : const Color(0xFF1C1C18);

  /// Ikon centang hijau mata uang aktif di CurrencySelectionModal.
  Color get currencyCheckmark => AppColors._isDark ? const Color(0xFF4ADE80) : const Color(0xFF15803D);

  /// Garis pemisah daftar item mata uang di CurrencySelectionModal.
  Color get currencyBorder => AppColors._isDark ? const Color(0xFF262C36) : const Color(0xFFECE7DC);

  /// Latar baris opsi preferensi parkir terpilih di ParkingPreferenceModal.
  Color get preferenceSelectedBg => AppColors._isDark ? const Color(0xFF262C36) : const Color(0xFFF1EEE7);

  /// Garis pegangan penarik (drag handle) atas modal di CurrencySelectionModal & ParkingPreferenceModal.
  Color get dragHandle => AppColors._isDark ? const Color(0xFF475569) : const Color(0xFFD1D5DB);
}

// ─────────────────────────────────────────────────────────────────────────────
// [SEGMEN 15] WARNA UNIK NOTIFIKASI (NOTIFICATION SCREEN)
// ─────────────────────────────────────────────────────────────────────────────
class _AppNotificationColors {
  const _AppNotificationColors();

  /// Titik biru penanda notifikasi baru yang belum dibaca di NotificationScreen.
  Color get unreadDot => const Color(0xFF2563EB);

  /// Latar merah aksi geser untuk menghapus notifikasi di NotificationScreen.
  Color get dismissRed => const Color(0xFFEF4444);

  /// Ikon notifikasi promosi / voucher diskon di NotificationScreen.
  Color get promoIcon => const Color(0xFF10B981);

  /// Ikon notifikasi pengingat durasi parkir di NotificationScreen.
  Color get reminderIcon => const Color(0xFFF59E0B);

  /// Lingkaran latar peringatan mendesak (urgent overstay) pada menu pengujian di ProfileScreen & NotificationScreen.
  Color get urgentBg => AppColors._isDark ? const Color(0xFF7F1D1D).withValues(alpha: 0.35) : const Color(0xFFFDE8E8);

  /// Ikon jam peringatan overstay mendesak di ProfileScreen & NotificationScreen.
  Color get urgentIcon => AppColors._isDark ? const Color(0xFFF87171) : const Color(0xFF9B1C1C);

  /// Lingkaran latar pesan info sukses pada menu pengujian di ProfileScreen & NotificationScreen.
  Color get infoBg => AppColors._isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.35) : const Color(0xFFE1EFFE);

  /// Ikon tanda seru info notifikasi sukses di ProfileScreen & NotificationScreen.
  Color get infoIcon => AppColors._isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E429F);

  /// Ikon tipe notifikasi promo di NotificationScreen.
  Color get typePromo => const Color(0xFF2A9D8F);

  /// Ikon tipe notifikasi peringatan batas durasi / overstay di NotificationScreen.
  Color get typeWarning => const Color(0xFFD94B4B);

  /// Ikon tipe notifikasi sukses transaksi / KYC di NotificationScreen.
  Color get typeSuccess => const Color(0xFF10B981);

  /// Ikon tipe notifikasi umum / sistem di NotificationScreen.
  Color get typeDefault => const Color(0xFF006A9A);

  /// Teks tombol tandai semua dibaca di NotificationScreen.
  Color get markReadBtn => const Color(0xFF10B981);

  /// Indikator tarik-turun segarkan notifikasi di NotificationScreen.
  Color get refreshIndicator => const Color(0xFF10B981);

  /// Lingkaran latar ikon saat daftar notifikasi kosong di NotificationScreen.
  Color get emptyStateIconBg => AppColors._isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF);

  /// Ikon lonceng saat daftar notifikasi kosong di NotificationScreen.
  Color get emptyStateIcon => AppColors._isDark ? const Color(0xFF38BDF8) : const Color(0xFF114177);
}

// ─────────────────────────────────────────────────────────────────────────────
// [SEGMEN 16] WARNA UNIK ULASAN & SARAN (FEEDBACK SCREEN)
// ─────────────────────────────────────────────────────────────────────────────
class _AppFeedbackColors {
  const _AppFeedbackColors();

  /// Bintang aktif kuning rating ulasan di FeedbackScreen.
  Color get starActive => const Color(0xFFF59E0B);

  /// Bintang abu-abu belum dipilih di FeedbackScreen.
  Color get starInactive => const Color(0xFFD1D5DB);

  /// Tombol kirim ulasan di FeedbackScreen.
  Color get submitButton => const Color(0xFF114177);
}
