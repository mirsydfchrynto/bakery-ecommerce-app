# 🥐 Bakery E-Commerce Application

Selamat datang di repositori aplikasi Bakery E-Commerce. Proyek ini dibangun sebagai demonstrasi implementasi **Clean Architecture**, API Security, dan antarmuka pengguna (UI/UX) yang modern menggunakan **Spring Boot (Backend)** dan **Flutter (Frontend)**.

Aplikasi ini ditujukan sebagai proyek referensi dan sertifikasi kompetensi.

---

## 🛠️ Teknologi yang Digunakan

### Backend
- **Kotlin** & **Spring Boot 3**
- **Spring Data JPA** & **PostgreSQL**
- **Spring Security** & **JWT** (JSON Web Token)
- **Swagger/OpenAPI** (Dokumentasi API Otomatis)
- **Struktur Kode**: Layered Architecture (Domain, Repository, Service, Controller)

### Frontend (Mobile App)
- **Flutter** & **Dart**
- **GetX** (State Management & Dependency Injection)
- **Dio** (HTTP Client dengan Interceptor)
- **Flutter Secure Storage** (Keamanan Token)
- **Struktur Kode**: Feature-First Clean Architecture

---

## 🌟 Fitur Utama

### 🧑‍💼 Customer (Pelanggan)
1. **Otentikasi**: Register & Login.
2. **Katalog**: Melihat daftar roti, kue, dan minuman beserta harga dan deksripsi (Data dummy realistik dengan foto asli).
3. **Keranjang & Checkout**: Menambahkan produk ke keranjang dan memproses pesanan (Otomatis memotong stok gudang).
4. **Riwayat Pesanan**: Melihat rincian pesanan dan status terkini (Pending, Processing, Completed, dll).

### 🛡️ Admin (Pemilik Toko)
1. **Dasbor Terpusat**: Login khusus menggunakan akun Admin.
2. **Manajemen Katalog**: Fitur CRUD (Create, Read, Update, Delete) untuk produk.
   - *Otomasi*: Saat produk baru dibuat, sistem otomatis menyuntikkan data stok ke gudang (Inventory) sebesar 100 unit.
3. **Manajemen Pesanan**: Menerima pesanan masuk, memantau rincian item pesanan, dan memperbarui status pengiriman.

---

## 🚀 Cara Menjalankan Aplikasi

### 1. Persiapan Database
Pastikan Anda memiliki **PostgreSQL** (atau server XAMPP jika menggunakan MySQL, sesuaikan konfigurasi di `application.yml`).
Buat database bernama `bakery_db`.

### 2. Menjalankan Backend (Spring Boot)
Buka terminal dan arahkan ke folder `backend`:
```bash
cd backend
./gradlew bootRun
```
> **Info:** Aplikasi telah dilengkapi dengan **Database Seeder**. Jika database kosong, sistem akan otomatis membuat akun Admin (`admin` / `admin123`), akun Pelanggan (`customer` / `customer123`), dan 6 produk roti dengan foto dan deskripsi yang realistik.

Akses dokumentasi API (Swagger) di: `http://localhost:8080/swagger-ui.html`

### 3. Menjalankan Frontend (Flutter)
Buka terminal baru dan arahkan ke folder `bakery_app`:
```bash
cd bakery_app
# Salin konfigurasi environment
cp .env.example .env
# Ganti BASE_URL di dalam file .env dengan IP lokal komputer Anda (contoh: http://192.168.1.5:8080/api/v1)

# Unduh dependensi
flutter pub get

# Jalankan aplikasi (pastikan emulator atau perangkat sudah terhubung)
flutter run
```

---

## 🏗️ Standar Kode & Clean Architecture

Kode ini disusun dengan sangat hati-hati agar **ramah bagi pemula** namun tetap memenuhi **standar industri (Production-Grade)**.
- **Tidak ada kode spaghetti**: Setiap fungsi memiliki tugas yang spesifik (Single Responsibility Principle).
- **Penamaan Variabel Bahasa Inggris yang Jelas**: Menghindari singkatan yang membingungkan.
- **Penanganan Error Terpusat**: Penggunaan Dio Interceptor untuk *auto-logout* jika token kadaluarsa, dan Spring Exception Handler di sisi backend.

---
*Dibuat dengan ❤️ untuk Ujian Sertifikasi Kompetensi.*
