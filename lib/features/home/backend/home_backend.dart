import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/session_service.dart';
import '../../profile/backend/profile_backend.dart';

/// Backend khusus untuk HomeScreen (lib/features/home/home_screen.dart)
/// Menggunakan Targeted Column Query untuk efisiensi maksimal
class HomeBackend extends ChangeNotifier {
  HomeBackend._();
  static final HomeBackend instance = HomeBackend._();

  SupabaseClient get _client => Supabase.instance.client;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _userId = '';
  String get userId => _userId;

  String _userName = 'Pengguna';
  String get userName {
    if (_userName.isNotEmpty && _userName != 'Pengguna') {
      return _userName;
    }
    final sessionName = SessionService.instance.userName;
    if (sessionName != null && sessionName.trim().isNotEmpty) {
      return sessionName.trim();
    }
    return _userName;
  }

  double _walletBalance = 0.0;
  double get walletBalance => _walletBalance;

  int _points = 0;
  int get points => _points;

  String _memberTier = 'BRONZE';
  String get memberTier => _memberTier;

  int _unreadNotificationCount = 0;
  int get unreadNotificationCount => _unreadNotificationCount;

  List<Map<String, dynamic>> _recommendedLocations = [];
  List<Map<String, dynamic>> get recommendedLocations => _recommendedLocations;

  List<Map<String, dynamic>> _allLocations = [];
  List<Map<String, dynamic>> get allLocations => _allLocations;

  String _selectedCategory = 'Terdekat';
  String get selectedCategory => _selectedCategory;

  List<Map<String, dynamic>> _activeSessions = [];
  List<Map<String, dynamic>> get activeSessions => _activeSessions;

  Map<String, dynamic>? _activeSession;
  Map<String, dynamic>? get activeSession => _activeSession;
  bool get hasActiveSession => _activeSessions.isNotEmpty;

  Position? _currentGpsPosition;
  Position? get currentGpsPosition => _currentGpsPosition;

  void setLoggedInUser({
    required String id,
    required String userName,
    double walletBalance = 0.0,
    int points = 0,
    String memberTier = 'BRONZE',
  }) {
    _userId = id;
    _userName = userName;
    _walletBalance = walletBalance;
    _points = points;
    _memberTier = memberTier;
    notifyListeners();
  }

  /// Reset seluruh state HomeScreen ketika user logout atau switch akun
  void clear() {
    _userId = '';
    _userName = 'Pengguna';
    _walletBalance = 0.0;
    _points = 0;
    _memberTier = 'BRONZE';
    _unreadNotificationCount = 0;
    _recommendedLocations = [];
    _allLocations = [];
    _activeSessions = [];
    _activeSession = null;
    notifyListeners();
  }

  /// Memuat seluruh data pendukung HomeScreen dari Supabase
  Future<void> loadHomeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _fetchUserProfile();
      await Future.wait([
        _fetchRecommendedLocations(),
        _fetchUnreadNotifications(),
        _fetchActiveSession(),
      ]);
    } catch (e) {
      debugPrint('[HomeBackend] loadHomeData error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 1. Ambil nama & profil user
  Future<void> _fetchUserProfile() async {
    try {
      String uid = _userId;
      if (uid.isEmpty) {
        uid = ProfileBackend.instance.userId.isNotEmpty
            ? ProfileBackend.instance.userId
            : (SessionService.instance.userId ?? '');
      }

      String email = SessionService.instance.identifier ?? ProfileBackend.instance.email;

      final user = _client.auth.currentUser;
      dynamic query = _client
          .from('users')
          .select('id, full_name, wallet_balance, points, member_tier');

      if (user != null) {
        query = query.eq('auth_user_id', user.id);
      } else if (uid.isNotEmpty) {
        query = query.eq('id', uid);
      } else if (email.isNotEmpty) {
        query = query.eq('email', email);
      } else {
        // Tidak ada user yang login! Jangan asal load user pertama
        return;
      }

      final data = await query.limit(1).maybeSingle();

      if (data != null) {
        _userId = data['id']?.toString() ?? _userId;
        _userName = data['full_name'] as String? ?? _userName;
        _walletBalance = (data['wallet_balance'] as num?)?.toDouble() ?? 0.0;
        _points = (data['points'] as int?) ?? 0;
        _memberTier = data['member_tier'] as String? ?? 'BRONZE';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[HomeBackend] _fetchUserProfile error: $e');
    }
  }

  /// Mengubah kategori filter ('Terdekat', 'Mall', 'Parkir EV')
  Future<void> setFilterCategory(String category) async {
    _selectedCategory = category;
    notifyListeners();
    await _fetchRecommendedLocations();
    notifyListeners();
  }

  /// Muat ulang rekomendasi parkir berdasarkan filter aktif
  Future<void> refreshFilter() async {
    await _fetchRecommendedLocations();
    notifyListeners();
  }

  /// 2. Ambil lokasi parkir rekomendasi dari Supabase dengan filter GPS & Kategori
  Future<void> _fetchRecommendedLocations() async {
    try {
      // 1. Ambil semua lokasi aktif dari database Supabase
      final response = await _client
          .from('parking_locations')
          .select('id, code, name, type, city, address, latitude, longitude, total_capacity, hourly_rate_mobil, hourly_rate_motor, hourly_rate_ev, rating, review_count, status, image_url, images, facilities, operating_hours, is_ev_ready, ev_slots_capacity')
          .order('rating', ascending: false);

      List<Map<String, dynamic>> rawList = List<Map<String, dynamic>>.from(response);

      // Hitung koordinat dan jarak untuk seluruh lokasi terlebih dahulu
      Position? userPos = _currentGpsPosition;
      if (userPos == null) {
        try {
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (serviceEnabled) {
            LocationPermission permission = await Geolocator.checkPermission();
            if (permission == LocationPermission.denied) {
              permission = await Geolocator.requestPermission();
            }
            if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
              userPos = await Geolocator.getCurrentPosition(
                locationSettings: const LocationSettings(
                  accuracy: LocationAccuracy.medium,
                  timeLimit: Duration(seconds: 4),
                ),
              );
              _currentGpsPosition = userPos;
            }
          }
        } catch (gpsError) {
          debugPrint('[HomeBackend] GPS check error: $gpsError');
        }
      }

      // Koordinat acuan (GPS aktif atau default koordinat SCBD Jakarta)
      final refLat = userPos?.latitude ?? -6.1754;
      final refLng = userPos?.longitude ?? 106.8272;

      for (var loc in rawList) {
        final lat = (loc['latitude'] as num?)?.toDouble() ?? refLat;
        final lng = (loc['longitude'] as num?)?.toDouble() ?? refLng;
        final distMeters = Geolocator.distanceBetween(refLat, refLng, lat, lng);
        loc['calculated_distance'] = distMeters;
        loc['distance_label'] = distMeters < 1000
            ? '${distMeters.round()} m'
            : '${(distMeters / 1000).toStringAsFixed(1)} km';
      }

      // Simpan seluruh lokasi lengkap sebelum difilter kategori
      _allLocations = List<Map<String, dynamic>>.from(rawList);

      // 2. Filter Kategori berdasarkan kolom 'type' (%mall% dan %ev%) atau urutan 'Terdekat'
      if (_selectedCategory == 'Terdekat') {
        // Urutkan lokasi dari jarak terdekat ke terjauh berdasarkan posisi user
        rawList.sort((a, b) {
          final distA = (a['calculated_distance'] as num?)?.toDouble() ?? 99999999.0;
          final distB = (b['calculated_distance'] as num?)?.toDouble() ?? 99999999.0;
          return distA.compareTo(distB);
        });
      } else if (_selectedCategory == 'Mall') {
        // Filter kolom 'type' yang mengandung kata kunci "%mall%" (case-insensitive substring)
        rawList = rawList.where((loc) {
          final type = (loc['type'] ?? '').toString().toLowerCase();
          return type.contains('mall');
        }).toList();
      } else if (_selectedCategory == 'Parkir EV') {
        // Filter lokasi yang memiliki fasilitas EV (is_ev_ready, ev_slots_capacity, hourly_rate_ev, fasilitas EV)
        rawList = rawList.where((loc) {
          final type = (loc['type'] ?? '').toString().toLowerCase();
          final isEvReady = loc['is_ev_ready'] == true ||
              loc['is_ev_ready'] == 1 ||
              loc['is_ev_ready']?.toString().toLowerCase() == 'true';
          final evSlots = (loc['ev_slots_capacity'] as num?)?.toInt() ?? 0;
          final hourlyRateEv = (loc['hourly_rate_ev'] as num?)?.toDouble() ?? 0.0;

          bool hasEvFacility = false;
          final facilities = loc['facilities'];
          if (facilities is List) {
            hasEvFacility = facilities.any((f) {
              final str = f.toString().toLowerCase();
              return str.contains('ev') ||
                  str.contains('charging') ||
                  str.contains('spklu') ||
                  str.contains('listrik');
            });
          } else if (facilities != null) {
            final str = facilities.toString().toLowerCase();
            hasEvFacility = str.contains('ev') ||
                str.contains('charging') ||
                str.contains('spklu') ||
                str.contains('listrik');
          }

          return isEvReady ||
              evSlots > 0 ||
              hourlyRateEv > 0 ||
              hasEvFacility ||
              type.contains('ev');
        }).toList();
      }

      _recommendedLocations = rawList;
    } catch (e) {
      debugPrint('[HomeBackend] _fetchRecommendedLocations error: $e');
    }
  }

  /// 3. Hitung notifikasi belum dibaca (hanya untuk akun aktif & bukan broadcast role lain)
  Future<void> _fetchUnreadNotifications() async {
    try {
      final uid = _userId.isNotEmpty
          ? _userId
          : (ProfileBackend.instance.userId.isNotEmpty
              ? ProfileBackend.instance.userId
              : (SessionService.instance.userId ?? ''));

      if (uid.isEmpty) {
        _unreadNotificationCount = 0;
        notifyListeners();
        return;
      }

      var query = _client
          .from('system_notifications')
          .select('id, recipient_user_id, target_role')
          .eq('is_read', false)
          .inFilter('target_role', ['user', 'all']);

      query = query.or('recipient_user_id.eq.$uid,recipient_user_id.is.null');

      final data = await query;
      final rawList = List<Map<String, dynamic>>.from(data);
      final filtered = rawList.where((n) {
        final role = (n['target_role'] ?? 'all').toString().toLowerCase().trim();
        if (role != 'all' && role != 'user') return false;
        final rId = n['recipient_user_id']?.toString().trim();
        if (rId != null && rId.isNotEmpty && rId.toLowerCase() != uid.toLowerCase()) return false;
        return true;
      }).toList();

      _unreadNotificationCount = filtered.length;
      notifyListeners();
    } catch (e) {
      debugPrint('[HomeBackend] _fetchUnreadNotifications error: $e');
    }
  }

  /// Sinkronisasi badge unread notifikasi dari luar
  Future<void> refreshUnreadNotifications() => _fetchUnreadNotifications();

  /// Sinkronisasi sesi parkir aktif secara manual / otomatis dari luar
  Future<void> refreshActiveSessions() => _fetchActiveSession();

  /// 4. Viewer-only mode: sesi parkir transaksi dinonaktifkan
  Future<void> _fetchActiveSession() async {
    _activeSessions = [];
    _activeSession = null;
    notifyListeners();
  }
}
