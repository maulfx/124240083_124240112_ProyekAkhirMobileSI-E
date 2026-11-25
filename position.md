# DOKUMEN POSISI & PEMETAAN KODE MODUL PRAKTIKUM
## Aplikasi ParkSmart (Teknologi & Pemrograman Mobile)

Dokumen ini memetakan seluruh implementasi materi praktikum (Modul 2 sampai Modul 7 serta PPT Pemrograman Berorientasi Objek / OOP) ke dalam baris kode (*file path* & *line number*) pada proyek aplikasi **ParkSmart**.

---

## DAFTAR ISI
1. [Modul 2 — WIDGET](#modul-2--widget)
2. [Modul 3 — STATE & DATA](#modul-3--state--data)
3. [Modul 4 — NAVIGATION](#modul-4--navigation)
4. [Modul 5 — HTTP REQUEST & DAFTAR LENGKAP API PROJEK](#modul-5--http-request--daftar-lengkap-api-projek)
5. [Modul 6 — LOCAL STORAGE (Shared Preferences & Hive)](#modul-6--local-storage)
6. [Modul 7 — NOTIFICATION & LBS (Location-Based Services)](#modul-7--notification--lbs)
7. [PPT MATERI — OBJECT-ORIENTED PROGRAMMING (OOP)](#ppt-materi--object-oriented-programming-oop)

---

## MODUL 2 — WIDGET

### A. Foundation Widgets
1. **MaterialApp (Top Level App Configuration & Theme)**
   - **File**: `lib/main.dart`
   - **Line**: 138 – 155
   - **Kode**:
     ```dart
     return MaterialApp(
       title: 'ParkSmart',
       debugShowCheckedModeBanner: false,
       theme: AppTheme.lightTheme,
       darkTheme: AppTheme.darkTheme,
       themeMode: theme.themeMode,
       home: _determineInitialScreen(),
     );
     ```
2. **Home dan Scaffold (Fondasi / Kerangka Layar)**
   - **File**: `lib/features/favorite/favorite_screen.dart` (Line 81 – 100) & `lib/features/home/home_screen.dart` (Line 378 – 400)
   - **Deskripsi**: `Scaffold` menjadi penopang utama halaman yang mengikat `appBar` dan `body`.
3. **AppBar (Menu Bar Atas)**
   - **File**: `lib/features/favorite/favorite_screen.dart`
   - **Line**: 82 – 99
   - **Kode**:
     ```dart
     appBar: AppBar(
       backgroundColor: headerBg,
       elevation: 0,
       leading: IconButton(
         icon: Icon(Icons.arrow_back, color: textMain),
         onPressed: () => Navigator.pop(context),
       ),
       title: Text('Favorite Parking'.tr, style: GoogleFonts.inter(...)),
       centerTitle: true,
     ),
     ```
4. **Body**
   - **File**: `lib/features/favorite/favorite_screen.dart` (Line 100 – 102) & `lib/features/home/home_screen.dart` (Line 380 – 385)
   - **Deskripsi**: Properti `body` pada Scaffold yang menampung komponen layout utama (seperti `Column`, `Stack`, atau `CustomScrollView`).

---

### B. Layout Widgets
1. **Single Child Layout**:
   - **Container**: `lib/widgets/bottom_dock_navigation.dart` (Line 17 – 32) & `lib/features/profile/edit_profile_screen.dart` (Line 781 – 790) — Mengatur dekorasi border radius kapsul, background color, dan padding.
   - **SizedBox**: `lib/widgets/bottom_dock_navigation.dart` (Line 38, 45, 52) — Memberikan spasi horizontal presisi 8 px antar tombol ikon dock.
   - **Center & Align**: `lib/features/home/home_screen.dart` (Line 893 – 896) — Menempatkan floating dock navigasi tepat di tengah bawah layar (`Center(child: BottomDockNavigation(...))`).

2. **Multi Child Layout**:
   - **Column**: `lib/features/profile/edit_profile_screen.dart` (Line 769 – 780) & `lib/features/favorite/favorite_screen.dart` (Line 100 – 135) — Menata label teks dan kotak input formulir secara vertikal (y-axis).
   - **Row**: `lib/widgets/bottom_dock_navigation.dart` (Line 32 – 57) — Menyusun keempat tombol navigasi utama (Home, Map, Notes, Profile) secara horizontal (x-axis).
   - **Stack**: `lib/features/home/home_screen.dart` (Line 380 – 905) & `lib/features/profile/edit_profile_screen.dart` (Line 444 – 507) — Menumpuk lapisan layer: peta/daftar konten di lapisan dasar, dan badge kamera/floating bottom dock di lapisan atas.

---

### C. Basic Widgets
1. **Text**:
   - `lib/features/favorite/favorite_screen.dart` (Line 91 – 96) — Menampilkan judul `'Favorite Parking'.tr`.
2. **Button (3 Jenis Tombol Sesuai Modul)**:
   - **TextButton**: `lib/features/profile/profile_screen.dart` (Line 248 – 258) & `lib/features/parking_notes/add_parking_note_screen.dart` (Line 421 – 430).
   - **OutlinedButton**: `lib/features/vehicle/add_vehicle_screen.dart` (Line 151 – 165, 796 – 815) & `lib/features/auth/face_id_scanner_dialog.dart` (Line 383 – 395).
   - **ElevatedButton (Contained Button)**: `lib/features/profile/edit_profile_screen.dart` (Line 711 – 745) — Tombol aksi utama "Simpan Perubahan" dengan elevasi dan efek penekanan.
3. **Icon**:
   - `lib/widgets/bottom_dock_navigation.dart` (Line 35, 40, 46, 51) — Ikon Material vektor (`Icons.home_rounded`, `Icons.map_rounded`, `Icons.note_alt_rounded`, `Icons.person_rounded`).
4. **Image (Asset & Network)**:
   - **Image.asset**: `lib/features/auth/login_screen.dart` (Line 643 – 660) & `lib/features/splash/splash_screen.dart` (Line 190) — Memuat logo aplikasi lokal dari path aset yang terdaftar di `pubspec.yaml` (Line 49-52).
   - **Image.network / AppCachedNetworkImage**: `lib/features/favorite/favorite_screen.dart` (Line 215 – 225) & `lib/core/services/app_image_cache_service.dart` (Line 110 – 130) — Menampilkan foto spot parkir langsung dari URL internet / CDN Supabase.
5. **TextField & TextFormField**:
   - **TextField**: `lib/features/favorite/favorite_screen.dart` (Line 112 – 130) & `lib/features/home/home_screen.dart` (Line 790 – 815) — Input pencarian dengan listener interaktif.
   - **TextField Form Data Diri**: `lib/features/profile/edit_profile_screen.dart` (Line 790 – 822) — Mengambil input teks nama, email, nomor HP, dan alamat dengan InputDecoration.

---

### D. Scrollable Widgets
1. **ListView & ListView.builder & ListTile**:
   - **ListView.builder**: `lib/features/favorite/favorite_screen.dart` (Line 187 – 215) — Render dinamis daftar spot parkir favorit berdasarkan panjang data list array (`itemCount: displayedFavorites.length`).
   - **ListTile**: `lib/features/profile/edit_profile_screen.dart` (Line 250 – 300) — Format kompak pilihan opsi foto profil (Kamera & Galeri) dengan leading icon, title, dan tap event.
2. **SingleChildScrollView**:
   - `lib/features/profile/edit_profile_screen.dart` (Line 437 – 442) & `lib/features/auth/login_screen.dart` (Line 625 – 635) — Mencegah error layout menabrak batas layar (*RenderFlex Overflow*) saat keyboard virtual Android/iOS terbuka.
3. **Grid Layouting**:
   - `lib/features/parking/slot_selection_screen.dart` (Line 300 – 600) — Membangun matriks visual slot parkir kendaraan (Zona A & Zona B) berdasarkan baris dan kolom.

---

## MODUL 3 — STATE & DATA

### A. Konsep State & setState()
- **Pengertian State**: Kondisi data dinamis sebuah widget yang dapat berubah saat pengguna berinteraksi.
- **Implementasi `setState()`**:
  - `lib/features/favorite/favorite_screen.dart` (Line 36 – 38):
    ```dart
    void _onSearchChanged(String query) {
      setState(() {
        _searchQuery = query.trim().toLowerCase();
      });
    }
    ```
  - `lib/features/profile/edit_profile_screen.dart` (Line 132, 831): `setState(() => _isLoading = true)` untuk memicu *rebuild* animasi loading saat tombol simpan ditekan.

---

### B. StatelessWidget vs StatefulWidget
1. **StatelessWidget (Statis, Tanpa Internal State)**:
   - `lib/widgets/bottom_dock_navigation.dart` (Line 10):
     ```dart
     class BottomDockNavigation extends StatelessWidget {
       final DockTab activeTab;
       const BottomDockNavigation({super.key, required this.activeTab});
       ...
     }
     ```
   - `lib/core/widgets/no_internet_overlay.dart` (Line 8).
2. **StatefulWidget (Dinamis, Memiliki Siklus Hidup & State)**:
   - `lib/features/favorite/favorite_screen.dart` (Line 12 – 19):
     ```dart
     class FavoriteScreen extends StatefulWidget {
       const FavoriteScreen({super.key});
       @override
       State<FavoriteScreen> createState() => _FavoriteScreenState();
     }
     ```
   - `lib/features/profile/edit_profile_screen.dart` (Line 13 – 29).

---

### C. Model dan Object Data
- **Model Cetak Biru (Class Data Structure)**:
  - **File**: `lib/features/parking_notes/models/parking_note.dart`
  - **Line**: 1 – 90
  - **Fitur Model**:
    - Deklarasi properti bertipe data kuat: `id`, `locationName`, `slotNumber`, `note`, `createdAt`, `reminderTime`, `isSynced`.
    - Generative Constructor dengan parameter `required` (Line 11-20).
    - Metode serialisasi data: `toMap()`, `fromMap()`, `toSupabaseMap()`, dan `copyWith()`.
- **Pembuatan Object dari Model**:
  - **File**: `lib/features/parking_notes/add_parking_note_screen.dart` (Line 80 – 100) & `lib/core/services/client_info_service.dart` (Line 25 – 45 untuk model `AdminLoginLog`).

---

## MODUL 4 — NAVIGATION

### A. Macam-Macam Method Navigator
1. **Navigator.push() (Menambah Halaman ke Stack LIFO)**:
   - **File**: `lib/features/favorite/favorite_screen.dart` (Line 43 – 48)
   - **Kode**:
     ```dart
     Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) => ParkingDetailScreen(locationId: locId),
       ),
     );
     ```
   - Penggunaan lain: `lib/features/parking_notes/parking_notes_screen.dart` (Line 266 – 270) menuju `AddParkingNoteScreen`.
2. **Navigator.pop() (Menghapus Halaman Teratas Stack)**:
   - **File**: `lib/features/favorite/favorite_screen.dart` (Line 88): `Navigator.pop(context)`.
   - **File**: `lib/features/profile/edit_profile_screen.dart` (Line 180 – 184) dengan mengembalikan data hasil editan:
     ```dart
     Navigator.pop(context, {
       'name': name,
       'email': email,
       'phone': phone,
     });
     ```
3. **Navigator.pushReplacement() (Mengganti Halaman Tanpa Menambah Stack)**:
   - **File**: `lib/widgets/bottom_dock_navigation.dart` (Line 42, 47, 52)
   - **Kode**:
     ```dart
     Navigator.pushReplacement(
       context,
       MaterialPageRoute(builder: (_) => const ExploreMapScreen()),
     );
     ```
   - Mencegah penumpukan halaman menu utama di memory saat berpindah antara Peta, Catatan, dan Profil.
4. **Navigator.pushAndRemoveUntil() (Mereset Seluruh Stack)**:
   - **File**: `lib/widgets/bottom_dock_navigation.dart` (Line 37):
     ```dart
     Navigator.pushAndRemoveUntil(
       context,
       MaterialPageRoute(builder: (_) => const HomeScreen()),
       (route) => false,
     );
     ```
   - **File**: `lib/features/profile/profile_screen.dart` (Line 260 – 270): Digunakan pada tombol Logout untuk menghapus seluruh stack halaman autentikasi.

---

### B. Passing Data Antar Halaman
1. **Mengirim Data melalui Constructor Halaman Tujuan**:
   - **Halaman Penerima**: `lib/features/profile/edit_profile_screen.dart` (Line 18 – 24):
     ```dart
     const EditProfileScreen({
       super.key,
       this.initialName,
       this.initialEmail,
       this.initialPhone,
     });
     ```
   - **Halaman Penerima Detail**: `lib/features/parking/parking_detail_screen.dart` (Line 20 – 30) menerima `locationId`.
2. **Mengembalikan Data Kembali ke Caller**:
   - `lib/features/profile/edit_profile_screen.dart` (Line 180) mengembalikan `Map<String, dynamic>` saat di-pop.

---

### C. Bottom Navigation Bar / Indexed Navigation
- **File**: `lib/widgets/bottom_dock_navigation.dart` (Line 10 – 78) & `lib/features/map/explore_map_screen.dart` (Line 4000 – 4060)
- **Implementasi**: Menampilkan bar navigasi bawah mengambang (*floating dock navigation*) yang menyorot tab aktif (`DockTab.home`, `DockTab.map`, `DockTab.notes`, `DockTab.profile`) dan mengontrol pergantian halaman secara terstruktur.

---

## MODUL 5 — HTTP REQUEST & DAFTAR LENGKAP API PROJEK

### A. Rangkuman Tabel Seluruh API di Aplikasi ParkSmart

| No | Nama Layanan API | Endpoint URL | HTTP Method | File Pemanggilan API & Baris | File Pengolahan Data & Baris |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | **Open-Meteo Weather API** | `https://api.open-meteo.com/v1/forecast` | `GET` | `lib/features/map/explore_map_screen.dart`<br>**Line 514 – 518** | `lib/features/map/explore_map_screen.dart`<br>**Line 519 – 560** |
| **2** | **Open Exchange Rates API** | `https://open.er-api.com/v6/latest/IDR` | `GET` | `lib/core/services/currency_service.dart`<br>**Line 140 – 145** | `lib/core/services/currency_service.dart`<br>**Line 146 – 165** |
| **3** | **OSRM Driving Routing API** | `https://router.project-osrm.org/route/v1/driving/...` | `GET` | `lib/features/navigation/backend/ar_navigation_backend.dart`<br>**Line 72 – 86** | `lib/features/navigation/backend/ar_navigation_backend.dart`<br>**Line 87 – 120** |
| **4** | **Ipify Public IP API** | `https://api.ipify.org?format=json` | `GET` | `lib/core/services/client_info_service.dart`<br>**Line 120 – 124** | `lib/core/services/client_info_service.dart`<br>**Line 125 – 132** |
| **5** | **IP-API Geolocation & ISP** | `http://ip-api.com/json/` | `GET` | `lib/core/services/client_info_service.dart`<br>**Line 143 – 147** | `lib/core/services/client_info_service.dart`<br>**Line 148 – 165** |
| **6** | **Supabase PostgREST REST API** | `${SUPABASE_URL}/rest/v1/...` | `GET`, `POST`, `PATCH`, `DELETE` | `lib/core/services/parking_notification_service.dart`<br>**Line 550 – 560** | `lib/core/services/parking_notification_service.dart`<br>**Line 561 – 585** |
| **7** | **App Image Cache HTTP Service** | CDN Image URL (Supabase Storage / Web) | `GET` | `lib/core/services/app_image_cache_service.dart`<br>**Line 115 – 120** | `lib/core/services/app_image_cache_service.dart`<br>**Line 121 – 135** |

---

### B. Rincian Pengolahan Masing-Masing API

#### 1. Open-Meteo Weather Forecast API (Data Cuaca Real-Time)
- **Tujuan**: Mengambil informasi suhu dan kondisi cuaca di atas koordinat GPS tempat parkir.
- **Lokasi Pemanggilan**: `lib/features/map/explore_map_screen.dart` (Line 514 – 518):
  ```dart
  final url = Uri.parse(
    'https://api.open-meteo.com/v1/forecast?latitude=${pos.latitude}&longitude=${pos.longitude}&current_weather=true'
  );
  final response = await http.get(url).timeout(const Duration(seconds: 8));
  ```
- **Pengolahan API**: `lib/features/map/explore_map_screen.dart` (Line 519 – 560):
  Data diuraikan menggunakan `jsonDecode(response.body)`. Nilai `current_weather['temperature']` dan kode `weathercode` dipetakan ke dalam teks kondisi Indonesia (`Cerah`, `Sebagian Cerah`, `Cerah Berawan`, `Hujan`, `Badai Petir`) beserta emoji representatif untuk badge cuaca peta.

#### 2. Open Exchange Rates / ER-API (Kurs Mata Uang Global)
- **Tujuan**: Mengambil kurs valuta asing terkini terhadap Rupiah (IDR) secara otomatis.
- **Lokasi Pemanggilan**: `lib/core/services/currency_service.dart` (Line 140 – 145):
  ```dart
  final response = await http.get(Uri.parse('https://open.er-api.com/v6/latest/IDR')).timeout(const Duration(seconds: 10));
  ```
- **Pengolahan API**: `lib/core/services/currency_service.dart` (Line 146 – 165):
  Menggunakan `jsonDecode(response.body) as Map<String, dynamic>`. Map `data['rates']` diekstrak ke variabel in-memory `_rates` dan dicadangkan ke `SharedPreferences`. Digunakan oleh method `convert()` dan `format()` untuk mengonversi tarif parkir ke USD, EUR, JPY, SGD, MYR, atau GBP secara instan.

#### 3. OpenStreetMap OSRM Driving Routing API (Rute Jalan & Navigasi AR)
- **Tujuan**: Menghitung rute navigasi mengemudi dari posisi kendaraan menuju pintu masuk tempat parkir.
- **Lokasi Pemanggilan**: `lib/features/navigation/backend/ar_navigation_backend.dart` (Line 72 – 86) & `lib/features/navigation/ar_navigation_screen.dart` (Line 210 – 220):
  ```dart
  final url = 'https://router.project-osrm.org/route/v1/driving/${origin.longitude},${origin.latitude};${dest.longitude},${dest.latitude}?overview=full&geometries=geojson';
  final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 8));
  ```
- **Pengolahan API**: `lib/features/navigation/backend/ar_navigation_backend.dart` (Line 87 – 120):
  `jsonDecode(res.body)` mengambil koordinat polyline rute `routes[0]['geometry']['coordinates']`, jarak tempuh total (`routes[0]['distance']`), dan estimasi waktu perjalanan (`routes[0]['duration']`) untuk ditampilkan pada viewfinder kamera Augmented Reality.

#### 4. Ipify API & IP-API (Identifikasi Jaringan & Keamanan Admin)
- **Tujuan**: Mencatat IP publik, kota, negara, dan ISP pengguna untuk audit trail keamanan sesi login.
- **Lokasi Pemanggilan**: `lib/core/services/client_info_service.dart` (Line 120 – 124 & Line 143 – 147).
- **Pengolahan API**: `lib/core/services/client_info_service.dart` (Line 125 – 132 & Line 148 – 165):
  `jsonDecode` mengambil properti string `ip`, `city`, `regionName`, dan `isp` kemudian disimpan ke instance `AdminLoginLog` dan disinkronkan ke Supabase REST.

#### 5. Supabase PostgREST REST API (Direct REST Endpoint)
- **Tujuan**: Mengecek status notifikasi latar belakang (*background service isolate*) secara langsung tanpa inisialisasi heavy SDK.
- **Lokasi Pemanggilan**: `lib/core/services/parking_notification_service.dart` (Line 550 – 560):
  ```dart
  final uri = Uri.parse('$supabaseUrl/rest/v1/system_notifications?user_id=eq.$uid&is_read=eq.false&select=*');
  final res = await http.get(uri, headers: {
    'apikey': anonKey,
    'Authorization': 'Bearer $anonKey',
  });
  ```
- **Pengolahan API**: `lib/core/services/parking_notification_service.dart` (Line 561 – 585):
  Mengurai list data JSON `jsonDecode(res.body) as List<dynamic>` dan memicu sistem alarm darurat native Android jika terdapat notifikasi waktu parkir hampir habis.

---

### C. Asynchronous Programming (Future, async, await)
- **Future**: Menandakan operasi yang hasilnya tersedia di masa depan (misal: `Future<void> fetchFavorites()` di `lib/features/favorite/backend/favorite_backend.dart` Line 65).
- **async & await**: Mencegah UI membeku (*anti-freeze*) saat aplikasi menunggu respons HTTP dari server internet atau operasi disk lokal (contoh di `lib/features/map/explore_map_screen.dart` Line 513).

---

## MODUL 6 — LOCAL STORAGE

### A. Shared Preferences (Key-Value Storage)
- **Paket**: `shared_preferences: ^2.5.5`
- **Inisialisasi Paralel Cepat**: `lib/main.dart` (Line 82 – 89).
- **Implementasi Kunci di Projek**:
  1. **Mode Tema (Dark/Light)**: `lib/core/services/theme_service.dart` (Line 23 – 30) -> Menyimpan boolean `is_dark_mode`.
  2. **Preferensi Bahasa**: `lib/core/services/language_service.dart` (Line 20 – 35) -> Menyimpan kode string `language_code` ('id' / 'en').
  3. **Pilihan Mata Uang**: `lib/core/services/currency_service.dart` (Line 40 – 55) -> Menyimpan string `selected_currency` ('IDR', 'USD', dll).
  4. **Fitur "Ingat Saya" (Auth)**: `lib/features/auth/login_screen.dart` (Line 280 – 305) -> Menyimpan email dan password login terenkripsi.
  5. **Keamanan Biometrik**: `lib/features/profile/settings_screen.dart` (Line 150 – 210) -> Menyimpan flag `fingerprint_enabled` & `face_id_enabled`.
  6. **Data Diri Pengguna**: `lib/features/profile/edit_profile_screen.dart` (Line 135 – 145) -> Menyimpan cache nama, no telp, dan gender.
  7. **Manajemen Timeout Sesi**: `lib/core/services/session_service.dart` (Line 50 – 70).

---

### B. Hive NoSQL Database (Object / Document Storage)
- **Paket**: `hive: ^2.2.3` & `hive_flutter: ^1.1.0`
- **Inisialisasi Engine & Box**:
  - **File**: `lib/main.dart` (Line 92 – 98)
  - **Kode**:
    ```dart
    await Hive.initFlutter();
    await Hive.openBox('parking_notes');
    ```
- **Operasi CRUD Lengkap pada Hive Box `'parking_notes'`**:
  - **File**: `lib/features/parking_notes/backend/parking_notes_backend.dart`
  - **Getter Box**: Line 16: `Box get _box => Hive.box('parking_notes');`
  - **Create (Tambah Data)**: Line 60: `await _box.put(note.id, note.toMap());`
  - **Read (Baca Data Offline)**: Line 38: `final localData = _box.values.map((e) => ParkingNote.fromMap(Map<dynamic, dynamic>.from(e))).toList();`
  - **Update (Perbarui Data)**: Line 62: `await _box.put(note.id, note.toMap());`
  - **Delete (Hapus Data)**: Line 85: `await _box.delete(id);`
- **Layar Tampilan Hive**:
  - `lib/features/parking_notes/parking_notes_screen.dart` (Line 40 – 80): Menampilkan daftar catatan langsung dari box Hive saat perangkat offline.
  - `lib/features/parking_notes/add_parking_note_screen.dart` (Line 30 – 50): Form input simpan catatan langsung ke Hive.

---

## MODUL 7 — NOTIFICATION & LBS

### A. Notification (Immediate & Scheduled)
- **Paket**: `flutter_local_notifications: ^22.3.1`
- **Inisialisasi**: `lib/core/services/notification_service.dart` (Line 14 – 22).
1. **Immediate Notification (Muncul Seketika Saat Dipicu)**:
   - **File**: `lib/core/services/notification_service.dart`
   - **Line**: 45 – 59
   - **Kode**:
     ```dart
     Future<void> showInstantNotification({required int id, required String title, required String body}) async {
       await _flutterLocalNotificationsPlugin.show(
         id: id,
         title: title,
         body: body,
         notificationDetails: platformChannelSpecifics,
       );
     }
     ```
2. **Scheduled Notification (Dijadwalkan di Masa Depan & Tetap Aktif saat Aplikasi Ditutup)**:
   - **File**: `lib/core/services/notification_service.dart`
   - **Line**: 61 – 87
   - **Kode**:
     ```dart
     Future<void> scheduleNotification({
       required int id,
       required String title,
       required String body,
       required DateTime scheduledDate,
     }) async {
       await _flutterLocalNotificationsPlugin.zonedSchedule(
         id: id,
         title: title,
         body: body,
         scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
         notificationDetails: details,
         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
       );
     }
     ```
   - **Penerapan**: Mengingatkan pengguna 10 menit sebelum masa durasi parkir habis.

---

### B. Location-Based Services (LBS)
- **Paket**: `geolocator: ^14.1.1` & `latlong2: ^0.10.1`
1. **Pemeriksaan & Permintaan Izin Lokasi (Location Permission)**:
   - **File**: `lib/features/map/explore_map_screen.dart` (Line 379 – 383) & `lib/features/home/home_screen.dart` (Line 299 – 305):
     ```dart
     LocationPermission permission = await Geolocator.checkPermission();
     if (permission == LocationPermission.denied) {
       permission = await Geolocator.requestPermission();
     }
     ```
2. **Mendapatkan Koordinat GPS (Latitude & Longitude)**:
   - **File**: `lib/features/map/explore_map_screen.dart` (Line 384 – 390):
     ```dart
     final pos = await Geolocator.getCurrentPosition(
       desiredAccuracy: LocationAccuracy.high,
     );
     // Mengakses koordinat: pos.latitude & pos.longitude
     ```
3. **Penghitungan Jarak Real-Time (Distance Calculation)**:
   - **File**: `lib/features/map/explore_map_screen.dart` (Line 903 – 910) & `lib/features/home/backend/home_backend.dart` (Line 214):
     ```dart
     final distMeters = Geolocator.distanceBetween(refLat, refLng, targetLat, targetLng);
     ```
4. **Integrasi Hasil LBS ke Tampilan UI**:
   - Menampilkan titik posisi user pada peta OpenStreetMap (`flutter_map`) di `lib/features/map/explore_map_screen.dart`.
   - Mengurutkan daftar tempat parkir dari yang paling dekat dengan pengguna (*Distance-based recommendation*) di `lib/features/home/home_screen.dart`.

---

## PPT MATERI — OBJECT-ORIENTED PROGRAMMING (OOP)

### 1. Class & Object
- **Pengertian**: Class adalah cetak biru (*blueprint*), Object adalah entitas nyata yang dibentuk dari class.
- **Implementasi Class**: `lib/features/parking_notes/models/parking_note.dart` (Line 1 – 10):
  ```dart
  class ParkingNote {
    final String? id;
    final String locationName;
    final String slotNumber;
    ...
  }
  ```
- **Implementasi Object**: `lib/features/parking_notes/add_parking_note_screen.dart` (Line 90):
  ```dart
  final note = ParkingNote(
    locationName: _locationController.text.trim(),
    slotNumber: _slotController.text.trim(),
    note: _noteController.text.trim(),
    createdAt: DateTime.now(),
  );
  ```

---

### 2. Constructor
- **Generative Constructor (dengan required properties)**:
  - `lib/features/parking_notes/models/parking_note.dart` (Line 11 – 20):
    ```dart
    ParkingNote({
      this.id,
      this.userId,
      required this.locationName,
      required this.slotNumber,
      required this.note,
      required this.createdAt,
      this.reminderTime,
      this.isSynced = true,
    });
    ```
- **Named / Factory Constructor**:
  - `lib/features/parking_notes/models/parking_note.dart` (Line 74 – 89): `factory ParkingNote.fromMap(...)`.
  - `lib/core/services/client_info_service.dart` (Line 59 – 80): `factory AdminLoginLog.fromJson(...)`.
- **Private Constructor (Singleton Pattern)**:
  - `lib/core/services/theme_service.dart` (Line 13):
    ```dart
    class ThemeService extends ChangeNotifier {
      static final ThemeService instance = ThemeService._();
      ThemeService._(); // Private Named Constructor
    }
    ```

---

### 3. Encapsulation (Enkapsulasi)
- **Pengertian**: Membungkus data menggunakan identifier private (`_`), serta menyediakan akses terkontrol lewat **Getter** dan **Setter/Method**.
- **Implementasi**:
  - `lib/core/services/theme_service.dart` (Line 15 – 45):
    ```dart
    // Private variable (hanya dapat diakses di dalam file ini)
    bool _isDarkMode = false;

    // Getter untuk membaca nilai private secara aman
    bool get isDarkMode => _isDarkMode;

    // Method terkontrol (Setter behavior) untuk memvalidasi & mengubah state
    Future<void> setTheme(bool isDark) async {
      _isDarkMode = isDark;
      notifyListeners();
    }
    ```
  - `lib/features/parking_notes/backend/parking_notes_backend.dart` (Line 16): `Box get _box => Hive.box('parking_notes');` menyembunyikan akses instance Hive dari luar class.

---

### 4. Inheritance (Pewarisan)
- **Pengertian**: Subclass mewarisi atribut dan perilaku dari Superclass menggunakan keyword `extends`, serta menggunakan keyword `super` untuk memanggil method induk.
- **Implementasi**:
  - `lib/features/favorite/backend/favorite_backend.dart` (Line 11):
    ```dart
    class FavoriteBackend extends ChangeNotifier { ... }
    ```
    `FavoriteBackend` mewarisi seluruh kemampuan `ChangeNotifier` (`notifyListeners()`, `addListener()`).
  - `lib/features/favorite/favorite_screen.dart` (Line 19, 25):
    ```dart
    class _FavoriteScreenState extends State<FavoriteScreen> {
      @override
      void initState() {
        super.initState(); // Memanggil lifecycle initState milik class parent State
        FavoriteBackend.instance.fetchFavorites();
      }
    }
    ```

---

### 5. Polymorphism (Satu Interface, Banyak Bentuk)
- **Pengertian**: Kemampuan satu interface atau superclass untuk menangani objek dari berbagai subclass yang memiliki implementasi berbeda.
- **Implementasi**:
  - **ListenableBuilder Polymorphism**: `lib/features/favorite/favorite_screen.dart` (Line 57 – 60):
    ```dart
    ListenableBuilder(
      listenable: Listenable.merge([
        ThemeService.instance,
        FavoriteBackend.instance,
        CurrencyService.instance,
        LanguageService.instance
      ]),
      builder: (context, _) { ... },
    );
    ```
    Semua service (`ThemeService`, `FavoriteBackend`, `CurrencyService`, `LanguageService`) memiliki tipe dasar polimorfis yang sama yaitu `Listenable`, namun masing-masing mengelola state internal yang sangat berbeda.
  - **Widget Polymorphism**: Semua elemen antarmuka (`Container`, `Column`, `ListView`, `Scaffold`) merupakan turunan dari superclass `Widget` sehingga dapat disusun secara fleksibel di dalam widget tree.

---

### 6. Abstraction (Abstraksi)
- **Pengertian**: Menyembunyikan detail kerumitan implementasi teknis dan hanya mengekspos fungsi-fungsi esensial kepada pengguna.
- **Implementasi**:
  - **Abstract Contract `ChangeNotifier` & `Listenable`**: Menentukan kontrak bahwa objek dapat didengar perubahannya tanpa mengekspos cara kerja internal event bus.
  - **Arsitektur Service Terisolasi**: File UI seperti `favorite_screen.dart` hanya memanggil `backend.fetchFavorites()` atau `backend.removeFavorite(locId)` tanpa perlu tahu detail query SQL Supabase, penanganan timeout HTTP, atau serialisasi Map/JSON di baliknya.

---
*Dokumen ini disusun secara otomatis dan menyeluruh sesuai dengan seluruh materi Modul 2, 3, 4, 5, 6, 7 serta PPT OOP Laboratorium Jurusan Informatika.*

