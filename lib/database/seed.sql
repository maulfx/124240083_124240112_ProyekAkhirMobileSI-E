-- ============================================================================
-- MASTER SEED DATA SQL (CLEAN VIEWER MODE) - PARKSMART ID
-- Path: lib/database/seed.sql
-- Data Awal Tempat Parkir, Denah Slot Kosong/Terisi, dan Akun Uji Coba
-- ============================================================================

-- 1. DATA PENGGUNA UJI COBA
INSERT INTO public.users (id, auth_user_id, email, phone, full_name, avatar_url, gender, birth_date, address, wallet_balance, points, member_tier, status, password)
VALUES
('df714843-c4cf-4d45-b385-0390404d4429', NULL, 'user@gmail.com', '0813277156100', 'Andi Prawono', NULL, 'Laki-laki', '1998-05-12', 'Jl. Kaliurang KM 5, Sleman, Yogyakarta', 0, 50, 'GOLD', 'active', '123456'),
('225428bf-e24d-4869-98c6-fed811518497', NULL, 'aji@gmail.com', '085242636121', 'Aji Pratama', NULL, 'Laki-laki', '2000-08-20', 'Condongcatur, Depok, Sleman, Yogyakarta', 0, 10, 'BRONZE', 'active', '123456')
ON CONFLICT (id) DO NOTHING;

-- 2. DATA ADMIN / STAF OPERASIONAL
INSERT INTO public.admins (id, auth_user_id, email, full_name, phone, role, division, status, password)
VALUES
('a78f3e2b-4c59-4d81-9b16-83f1245890ab', NULL, 'admin@parksmart.id', 'Admin Parkir', '+62 812-0000-0001', 'super_admin', 'Operasional Lapangan', 'active', 'admin123')
ON CONFLICT (id) DO NOTHING;

-- 3. DATA KENDARAAN TERDAFTAR
INSERT INTO public.vehicles (id, user_id, plate_number, vehicle_type, vehicle_category, brand, model, color, plate_expiry, is_default)
VALUES
('c370b869-b78a-4abe-bc73-0c1b3866b9d7', '225428bf-e24d-4869-98c6-fed811518497', 'AB 1234 XY', 'mobil', 'suv', 'Honda', 'HR-V', 'Hitam Metalik', '10 • 28', true),
('cd02e022-f451-4082-8812-c44690acdfa1', 'df714843-c4cf-4d45-b385-0390404d4429', 'AB 5894 LI', 'mobil', 'sedan', 'Toyota', 'Corolla Cross', 'Putih Mutiara', '11 • 26', true),
('2b82696f-274c-4102-ae42-ffa26ed895e9', 'df714843-c4cf-4d45-b385-0390404d4429', 'B 2975 KP', 'motor', 'scooter', 'Honda', 'Vario 160', 'Merah Matte', '11 • 30', false)
ON CONFLICT (id) DO NOTHING;

-- 4. DATA TEMPAT PARKIR (YOGYAKARTA & SEKITARNYA)
INSERT INTO public.parking_locations (id, code, name, type, city, address, latitude, longitude, total_capacity, hourly_rate_mobil, hourly_rate_motor, hourly_rate_ev, rating, review_count, status, facilities, image_url)
VALUES
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'PKW-01', 'Pakuwon Mall Jogja', 'Mall', 'Sleman', 'Jl. Ring Road Utara, Kaliwaru, Condongcatur, Depok, Sleman', -7.7588, 110.3995, 60, 5000, 2000, 7500, 4.9, 320, 'active', ARRAY['CCTV 24 Jam', 'Charging EV', 'Toilet Bersih', 'Valet', 'Musholla'], 'https://images.unsplash.com/photo-1590674899484-d5640e854abe?w=800&auto=format&fit=crop&q=80'),
('e1a2b3c4-d5e6-4f7a-8b9c-0d1e2f3a4b5c', 'AMB-02', 'Plaza Ambarrukmo', 'Mall', 'Sleman', 'Jl. Laksda Adisucipto No.80, Caturtunggal, Depok, Sleman', -7.7828, 110.4011, 45, 5000, 2000, 8000, 4.8, 280, 'active', ARRAY['CCTV 24 Jam', 'Charging EV', 'Toilet', 'Musholla'], 'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?w=800&auto=format&fit=crop&q=80'),
('a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d', 'MLB-03', 'Malioboro Mall', 'Mall', 'Kota Yogyakarta', 'Jl. Malioboro No.52-58, Suryatmajan, Danurejan, Kota Yogyakarta', -7.7925, 110.3658, 40, 6000, 3000, 9000, 4.7, 410, 'active', ARRAY['CCTV 24 Jam', 'Keamanan Ketat', 'Toilet'], 'https://images.unsplash.com/photo-1573348722427-f1d6819fdf98?w=800&auto=format&fit=crop&q=80'),
('b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e', 'JCM-04', 'Jogja City Mall', 'Mall', 'Sleman', 'Jl. Magelang No.KM.6 No.18, Kutu Tegal, Sinduadi, Mlati, Sleman', -7.7547, 110.3602, 50, 4000, 2000, 7000, 4.8, 195, 'active', ARRAY['CCTV 24 Jam', 'Charging EV', 'Musholla Luas'], 'https://images.unsplash.com/photo-1545179605-1296651e4d43?w=800&auto=format&fit=crop&q=80'),
('c3d4e5f6-a7b8-4c9d-0e1f-2a3b4c5d6e7f', 'TGU-05', 'Parkir Khusus Stasiun Tugu', 'Stasiun', 'Kota Yogyakarta', 'Jl. Margo Utomo, Gowongan, Jetis, Kota Yogyakarta', -7.7892, 110.3639, 35, 5000, 2000, 7500, 4.6, 520, 'active', ARRAY['CCTV 24 Jam', 'Buka 24 Jam', 'Pintu Keluar Khusus'], 'https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=800&auto=format&fit=crop&q=80'),
('d4e5f6a7-b8c9-4d0e-1f2a-3b4c5d6e7f8a', 'LPJ-06', 'Lippo Plaza Jogja', 'Mall', 'Kota Yogyakarta', 'Jl. Laksda Adisucipto No.32-34, Demangan, Gondokusuman, Kota Yogyakarta', -7.7844, 110.3912, 35, 4000, 2000, 6000, 4.5, 140, 'active', ARRAY['CCTV 24 Jam', 'Toilet', 'Akses Langsung Rumah Sakit'], 'https://images.unsplash.com/photo-1517524008697-84bbe3c3fd98?w=800&auto=format&fit=crop&q=80'),
('f5a6b7c8-d9e0-4f1a-2b3c-4d5e6f7a8b9c', 'UPN-07', 'Gedung Parkir Terpadu UPN Veteran', 'Kampus', 'Sleman', 'Jl. SWK 104 (Lingkar Utara), Condongcatur, Depok, Sleman', -7.7735, 110.4087, 80, 2000, 1000, 4000, 4.9, 650, 'active', ARRAY['Gratis Khusus Mahasiswa', 'CCTV 24 Jam', 'Parkir Helm Aman', 'Shelter Sepeda'], 'https://images.unsplash.com/photo-1508962914676-134849a727f0?w=800&auto=format&fit=crop&q=80')
ON CONFLICT (id) DO UPDATE SET image_url = EXCLUDED.image_url;

-- 5. DATA DENAH SLOT PARKIR (LANTAI 1 & LANTAI 2 DI PAKUWON MALL JOGJA)
-- Kombinasi slot Kosong ('available') dan Terisi ('occupied')
INSERT INTO public.parking_slots (location_id, floor_name, zone, slot_code, slot_type, status, current_plate_number)
VALUES
-- Lantai 1 (Pakuwon Mall)
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 1', 'Zona A', 'A-01', 'mobil', 'available', NULL),
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 1', 'Zona A', 'A-02', 'mobil', 'occupied', 'AB 1234 CD'),
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 1', 'Zona A', 'A-03', 'mobil', 'available', NULL),
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 1', 'Zona A', 'A-04', 'mobil', 'available', NULL),
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 1', 'Zona A', 'A-05', 'ev', 'available', NULL),
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 1', 'Zona A', 'A-06', 'ev', 'occupied', 'B 8888 EV'),
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 1', 'Zona B', 'B-01', 'mobil', 'available', NULL),
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 1', 'Zona B', 'B-02', 'mobil', 'occupied', 'AD 5678 EF'),
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 1', 'Zona B', 'B-03', 'difabel', 'available', NULL),
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 1', 'Zona B', 'B-04', 'vip', 'occupied', 'B 1 RFS'),

-- Lantai 2 (Pakuwon Mall)
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 2', 'Zona C', 'C-01', 'mobil', 'available', NULL),
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 2', 'Zona C', 'C-02', 'mobil', 'available', NULL),
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 2', 'Zona C', 'C-03', 'mobil', 'occupied', 'H 9012 GH'),
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 2', 'Zona C', 'C-04', 'mobil', 'available', NULL),
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 2', 'Zona D', 'D-01', 'motor', 'available', NULL),
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 2', 'Zona D', 'D-02', 'motor', 'occupied', 'AB 3456 IJ'),
('923f7d1b-9c9f-408a-84f2-41e4c506807b', 'Lantai 2', 'Zona D', 'D-03', 'motor', 'available', NULL),

-- Lantai 1 (Plaza Ambarrukmo)
('e1a2b3c4-d5e6-4f7a-8b9c-0d1e2f3a4b5c', 'Lantai 1', 'Zona A', 'A-01', 'mobil', 'occupied', 'AB 2222 KL'),
('e1a2b3c4-d5e6-4f7a-8b9c-0d1e2f3a4b5c', 'Lantai 1', 'Zona A', 'A-02', 'mobil', 'available', NULL),
('e1a2b3c4-d5e6-4f7a-8b9c-0d1e2f3a4b5c', 'Lantai 1', 'Zona A', 'A-03', 'ev', 'available', NULL),
('e1a2b3c4-d5e6-4f7a-8b9c-0d1e2f3a4b5c', 'Lantai 1', 'Zona B', 'B-01', 'mobil', 'available', NULL),
('e1a2b3c4-d5e6-4f7a-8b9c-0d1e2f3a4b5c', 'Lantai 1', 'Zona B', 'B-02', 'mobil', 'occupied', 'D 4321 MN'),

-- Gedung Parkir UPN Veteran
('f5a6b7c8-d9e0-4f1a-2b3c-4d5e6f7a8b9c', 'Lantai 1', 'Zona Mahasiswa', 'M-01', 'motor', 'available', NULL),
('f5a6b7c8-d9e0-4f1a-2b3c-4d5e6f7a8b9c', 'Lantai 1', 'Zona Mahasiswa', 'M-02', 'motor', 'occupied', 'AB 6789 OP'),
('f5a6b7c8-d9e0-4f1a-2b3c-4d5e6f7a8b9c', 'Lantai 1', 'Zona Mahasiswa', 'M-03', 'motor', 'available', NULL),
('f5a6b7c8-d9e0-4f1a-2b3c-4d5e6f7a8b9c', 'Lantai 1', 'Zona Dosen', 'D-01', 'mobil', 'available', NULL),
('f5a6b7c8-d9e0-4f1a-2b3c-4d5e6f7a8b9c', 'Lantai 1', 'Zona Dosen', 'D-02', 'mobil', 'occupied', 'AB 1111 UPN')
ON CONFLICT (location_id, floor_name, slot_code) DO UPDATE
SET status = EXCLUDED.status, current_plate_number = EXCLUDED.current_plate_number;

-- 6. PENGATURAN SISTEM
INSERT INTO public.system_settings (key, value, description)
VALUES
('modular_maintenance', '{"ai":false,"kyc":false,"push":false,"booking":false}'::jsonb, 'Status pemeliharaan per modul sistem'),
('feature_toggles', '{"is_biometric_login_enforced":false}'::jsonb, 'Pengaturan fitur aktif')
ON CONFLICT (key) DO NOTHING;

-- 7. NOTIFIKASI INFORMASI AWAL
INSERT INTO public.system_notifications (title, message, type, notification_type, target_role, is_read)
VALUES
('Selamat Datang di ParkSmart!', 'Pantau ketersediaan slot kosong dan simpan catatan lokasi parkir Anda secara langsung.', 'info', 'info', 'all', false),
('Update Ketersediaan Slot', 'Sistem sensor slot real-time telah aktif di Pakuwon Mall Jogja & UPN Veteran.', 'info', 'info', 'all', false);
