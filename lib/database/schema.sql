-- ============================================================================
-- SCRIPT DDL POSTGRESQL / SUPABASE - PARKSMART ID (CLEAN VIEWER MODE)
-- Path: lib/database/schema.sql
-- Skema Tabel Khusus Ketersediaan Slot Parkir & Profil Pengguna (Non-Transaksi)
-- ============================================================================

-- 1. EKSTENSI KRIPTOGRAFI & UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 2. TABEL PENGGUNA (USERS)
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_user_id UUID UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(30),
    full_name VARCHAR(150) NOT NULL,
    avatar_url TEXT,
    gender VARCHAR(20) DEFAULT 'Laki-laki',
    birth_date DATE,
    address TEXT,
    wallet_balance NUMERIC(14, 2) NOT NULL DEFAULT 0.00,
    points INT NOT NULL DEFAULT 0,
    member_tier VARCHAR(20) NOT NULL DEFAULT 'BRONZE',
    total_parking_count INT NOT NULL DEFAULT 0,
    total_savings NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    total_spent NUMERIC(14, 2) NOT NULL DEFAULT 0.00,
    monthly_spent NUMERIC(14, 2) NOT NULL DEFAULT 0.00,
    member_hash_code VARCHAR(66),
    favorite_location_ids UUID[] NOT NULL DEFAULT '{}',
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    password TEXT DEFAULT '123456',
    saran_kuliah TEXT,
    pesan_kuliah TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 3. TABEL ADMIN / STAF
CREATE TABLE IF NOT EXISTS public.admins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_user_id UUID,
    email VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(30),
    role VARCHAR(50) DEFAULT 'super_admin',
    division VARCHAR(100) DEFAULT 'Operasional Lapangan',
    avatar_url TEXT,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    password TEXT DEFAULT 'admin123'
);

-- 4. TABEL GARASI KENDARAAN PENGGUNA (VEHICLES)
CREATE TABLE IF NOT EXISTS public.vehicles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    plate_number VARCHAR(20) NOT NULL,
    vehicle_type VARCHAR(20) NOT NULL DEFAULT 'mobil',
    vehicle_category VARCHAR(30) DEFAULT 'suv',
    brand VARCHAR(60) NOT NULL,
    model VARCHAR(80) NOT NULL,
    color VARCHAR(40) NOT NULL,
    plate_expiry VARCHAR(10),
    photo_url TEXT,
    is_default BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    CONSTRAINT uq_user_plate UNIQUE (user_id, plate_number)
);

-- 5. TABEL LOKASI TEMPAT PARKIR (PARKING_LOCATIONS)
CREATE TABLE IF NOT EXISTS public.parking_locations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    type VARCHAR(50) NOT NULL DEFAULT 'Mall',
    city VARCHAR(100) NOT NULL DEFAULT 'Sleman',
    address TEXT NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    total_capacity INT NOT NULL DEFAULT 40,
    hourly_rate_mobil NUMERIC(10, 2) NOT NULL DEFAULT 5000,
    hourly_rate_motor NUMERIC(10, 2) NOT NULL DEFAULT 2000,
    hourly_rate_ev NUMERIC(10, 2) NOT NULL DEFAULT 7500,
    rating NUMERIC(3, 2) NOT NULL DEFAULT 4.8,
    review_count INT NOT NULL DEFAULT 120,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    image_url TEXT,
    facilities TEXT[] DEFAULT ARRAY['CCTV 24 Jam', 'Petugas Keamanan', 'Toilet Bersih', 'Musholla'],
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 6. TABEL DENAH & STATUS KETERSEDIAAN SLOT PARKIR (PARKING_SLOTS)
CREATE TABLE IF NOT EXISTS public.parking_slots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    location_id UUID NOT NULL REFERENCES public.parking_locations(id) ON DELETE CASCADE,
    floor_name VARCHAR(50) NOT NULL DEFAULT 'Lantai 1',
    zone VARCHAR(20) NOT NULL DEFAULT 'Zona A',
    slot_code VARCHAR(20) NOT NULL,
    slot_type VARCHAR(20) NOT NULL DEFAULT 'mobil',
    status VARCHAR(20) NOT NULL DEFAULT 'available', -- 'available' (kosong) atau 'occupied' (terisi)
    current_plate_number VARCHAR(20),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    CONSTRAINT uq_loc_slot UNIQUE (location_id, floor_name, slot_code)
);

-- 7. TABEL LOKASI PARKIR FAVORIT USER (USER_FAVORITES)
CREATE TABLE IF NOT EXISTS public.user_favorites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    location_id UUID NOT NULL REFERENCES public.parking_locations(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    CONSTRAINT uq_user_favorite UNIQUE (user_id, location_id)
);

-- 8. TABEL REVIEW & ULASAN PENGGUNA (CUSTOMER_FEEDBACKS)
CREATE TABLE IF NOT EXISTS public.customer_feedbacks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    location_id UUID REFERENCES public.parking_locations(id) ON DELETE CASCADE,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    feedback_text TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 9. TABEL NOTIFIKASI SISTEM & BROADCAST (SYSTEM_NOTIFICATIONS)
CREATE TABLE IF NOT EXISTS public.system_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'info',
    is_read BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 10. TABEL PENGATURAN SISTEM (SYSTEM_SETTINGS)
CREATE TABLE IF NOT EXISTS public.system_settings (
    key VARCHAR(100) PRIMARY KEY,
    value JSONB NOT NULL,
    description TEXT,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 11. TABEL VERIFIKASI IDENTITAS PROFIL (USER_KYC)
CREATE TABLE IF NOT EXISTS public.user_kyc (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    nik VARCHAR(20),
    full_name VARCHAR(150),
    birth_date VARCHAR(30),
    address TEXT,
    ktp_photo_url TEXT,
    status VARCHAR(20) DEFAULT 'approved',
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    CONSTRAINT uq_user_kyc UNIQUE (user_id)
);

-- ============================================================================
-- KONFIGURASI ROW LEVEL SECURITY (RLS) TERBUKA UNTUK PENGUJIAN MAHASISWA
-- ============================================================================
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vehicles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parking_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parking_slots ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customer_feedbacks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.system_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.system_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_kyc ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public users access" ON public.users;
CREATE POLICY "Public users access" ON public.users FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public admins access" ON public.admins;
CREATE POLICY "Public admins access" ON public.admins FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public vehicles access" ON public.vehicles;
CREATE POLICY "Public vehicles access" ON public.vehicles FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public parking_locations access" ON public.parking_locations;
CREATE POLICY "Public parking_locations access" ON public.parking_locations FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public parking_slots access" ON public.parking_slots;
CREATE POLICY "Public parking_slots access" ON public.parking_slots FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public user_favorites access" ON public.user_favorites;
CREATE POLICY "Public user_favorites access" ON public.user_favorites FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public customer_feedbacks access" ON public.customer_feedbacks;
CREATE POLICY "Public customer_feedbacks access" ON public.customer_feedbacks FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public system_notifications access" ON public.system_notifications;
CREATE POLICY "Public system_notifications access" ON public.system_notifications FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public system_settings access" ON public.system_settings;
CREATE POLICY "Public system_settings access" ON public.system_settings FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public user_kyc access" ON public.user_kyc;
CREATE POLICY "Public user_kyc access" ON public.user_kyc FOR ALL USING (true) WITH CHECK (true);

-- Aktifkan Realtime Replication untuk tabel parking_slots agar ketersediaan slot kosong live
ALTER PUBLICATION supabase_realtime ADD TABLE public.parking_slots;
