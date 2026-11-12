# ParkSmart ID — Real-Time Parking Availability & Note System

<p align="center">
  <img src="assets/images/app_icon.png" width="100" height="100" alt="ParkSmart Logo" style="border-radius: 20px;" />
</p>

<p align="center">
  <b>Aplikasi Pemantauan Ketersediaan Slot Parkir Real-Time & Manajemen Catatan Parkir Pintar</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Supabase-Database%20%26%20Realtime-3ECF8E?logo=supabase&logoColor=white" alt="Supabase" />
  <img src="https://img.shields.io/badge/Hive-Local%20Storage-FFA000?logo=hive&logoColor=white" alt="Hive" />
</p>

---

## 📌 1. Deskripsi Proyek

**ParkSmart ID** adalah aplikasi mobile berbasis Flutter yang dirancang untuk mempermudah pengguna memantau ketersediaan slot parkir secara langsung (*real-time*) di area Yogyakarta dan sekitarnya. Pengguna dapat melihat denah slot parkir aktual, status keterisian (kosong/terisi), fasilitas khusus (mobil, motor, stasiun pengisian daya EV), serta menyimpan catatan posisi kendaraan dan mengatur pengingat durasi parkir melalui notifikasi lokal terjadwal.

Aplikasi ini memenuhi capaian pembelajaran mata kuliah Pemrograman Mobile:
- **Modul 2**: Desain Antarmuka Responsif (Material 3, Dark & Light Mode, Multi-Language ID/EN).
- **Modul 3**: Navigasi, State Management & Integrasi Layanan (Provider & SharedPreferences).
- **Modul 4**: Integrasi API Eksternal & Peta Geospasial (OpenStreetMap via `flutter_map`, Open-Meteo Weather API, ExchangeRate-API).
- **Modul 5**: Integrasi Database Backend Cloud & Realtime (Supabase PostgreSQL & Realtime Socket).
- **Modul 6**: Penyimpanan Data Lokal Offline dengan Hive NoSQL (`parking_notes`).
- **Modul 7**: Notifikasi Lokal & Terjadwal (`flutter_local_notifications` & `timezone`).

---

## 🛠️ 2. Teknologi & Pustaka Utama

| Komponen | Pustaka / Layanan | Fungsi & Keterangan |
| :--- | :--- | :--- |
| **Framework** | Flutter (Dart 3) | Kerangka kerja pengembangan antarmuka multiplatform responsif. |
| **Backend & Cloud DB** | Supabase (PostgreSQL) | Manajemen data lokasi parkir, ketersediaan slot, profil, dan pembaruan realtime via WebSocket. |
| **Local NoSQL Storage** | Hive & Hive Flutter | Penyimpanan catatan lokasi parkir offline berkecepatan tinggi tanpa dependensi jaringan (Modul 6). |
| **Local Notifications** | `flutter_local_notifications` & `timezone` | Pengingat durasi parkir terjadwal dan notifikasi instan saat menyimpan posisi kendaraan (Modul 7). |
| **Peta & Visualisasi** | `flutter_map` & `latlong2` | Peta interaktif berbasis OpenStreetMap untuk menampilkan titik-titik lokasi parkir. |
| **Prakiraan Cuaca** | Open-Meteo Weather API | Informasi suhu (°C) dan kondisi iklim aktual di sekitar lokasi parkir secara live. |
| **Konversi Mata Uang** | ExchangeRate-API | Konverter multi-mata uang internasional (IDR, USD, EUR, SGD, MYR, JPY) dengan sistem caching cerdas. |
| **State Management** | Provider | Manajemen status reaktif pada antarmuka aplikasi. |

---

## 📱 3. Fitur Utama Aplikasi

1. **Pemantau Ketersediaan Slot Parkir Real-Time**:
   - Menampilkan daftar lokasi parkir terkemuka di Yogyakarta (Pakuwon Mall, Plaza Ambarrukmo, Malioboro Mall, Jogja City Mall, Stasiun Tugu, Lippo Plaza, UPN Veteran).
   - Visualisasi denah slot lantai per lantai (Mobil, Motor, EV Charging).
   - Indikator status slot hijau (*Available*) dan merah (*Occupied*) yang sinkron secara realtime.

2. **Catatan Parkir Lokal (Modul 6 - Hive NoSQL)**:
   - Pencatatan posisi parkir (nama lokasi, nomor lantai, kode slot, nomor plat, serta catatan tambahan).
   - Penyimpanan data offline menggunakan kotak Hive `'parking_notes'` yang aman dan cepat.
   - Operasi CRUD lengkap dengan sinkronisasi UI reaktif (`ValueListenableBuilder`).

3. **Notifikasi Lokal & Terjadwal (Modul 7)**:
   - Notifikasi instan konfirmasi penyimpanan catatan parkir.
   - Pengingat durasi parkir terjadwal dengan integrasi *Time Picker* dan `timezone` (`zonedSchedule`).

4. **Peta Interaktif & Informasi Cuaca**:
   - Peta interaktif OpenStreetMap dengan penanda lokasi parkir.
   - Widget prakiraan cuaca lokal real-time dari Open-Meteo API.

5. **Preferensi Pengguna**:
   - Pengaturan mode gelap (*Dark Mode*) dan terang (*Light Mode*).
   - Pengalih bahasa (Bahasa Indonesia & English).
   - Multi-currency switcher untuk kemudahan wisatawan asing.

---

## 🚀 4. Panduan Menjalankan Aplikasi

### Langkah 1: Klon Repositori
```bash
git clone https://github.com/maulfx/parkiran.git
cd parkiran
```

### Langkah 2: Unduh Dependensi Dart & Flutter
```bash
flutter pub get
```

### Langkah 3: Konfigurasi Variabel Lingkungan (`.env`)
Pastikan file `.env` di root proyek berisi kredensial Supabase Anda:
```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key
```

### Langkah 4: Setup Database Supabase
1. Masuk ke [Supabase Dashboard](https://supabase.com/dashboard) proyek Anda.
2. Buka menu **SQL Editor**.
3. Eksekusi skrip DDL [`lib/database/schema.sql`](lib/database/schema.sql) untuk membentuk tabel `parking_locations`, `parking_slots`, `users`, `vehicles`, dll.
4. Eksekusi skrip data awal [`lib/database/seed.sql`](lib/database/seed.sql) untuk mengisi data lokasi parkir dan slot di Yogyakarta.

### Langkah 5: Jalankan Aplikasi
```bash
flutter run
```

---

<p align="center">
  Dibuat untuk memenuhi tugas mata kuliah <b>Pemrograman Mobile</b>.<br/>
  © 2026 <b>ParkSmart ID Team</b>.
</p>
