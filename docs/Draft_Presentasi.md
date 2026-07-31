# Bakery Ecommerce Application - Certification Presentation

## Slide 1: Judul
- **Judul Proyek**: Bakery E-Commerce App
- **Nama Peserta**: Irsyad Fachryanto
- **Skema Sertifikasi**: Junior Mobile Programmer

## Slide 2: Latar Belakang
- Membantu toko roti lokal dalam melakukan digitalisasi penjualan.
- Mengubah sistem manual menjadi pemesanan online berbasis aplikasi.

## Slide 3: Arsitektur Sistem
- **Frontend**: Flutter (Dart) dengan GetX State Management.
- **Backend**: Spring Boot (Java/Kotlin) REST API.
- **Database**: MySQL.

## Slide 4: Fitur Utama (Frontend)
- **Katalog Produk**: Daftar roti dan kue dengan filter kategori.
- **Keranjang Belanja**: Menambah dan mengubah jumlah pesanan.
- **Checkout**: Proses pemesanan.
- **Autentikasi**: Login dan Register pengguna.

## Slide 5: API & Backend
- **Endpoint Aman**: Menggunakan JWT Authentication.
- **Manajemen Order**: Sistem otomatis memproses pesanan masuk.
- **Seeder**: Basis data diinisiasi otomatis dengan 80 data produk.

## Slide 6: Use Case Utama
- **Aktor**: Pelanggan.
- **Aksi**: Melihat menu -> Memasukkan ke keranjang -> Memilih metode pembayaran -> Checkout.

## Slide 7: Desain & UX
- Menggunakan palet warna hangat (coklat, oranye) yang identik dengan produk roti.
- UI responsif dan menggunakan micro-animations.

## Slide 8: Struktur Database
- Tabel: `users`, `products`, `categories`, `orders`, `order_items`, `inventory`.
- Relasi: One-to-Many dan Many-to-Many.

## Slide 9: Demo Aplikasi
- (Demo langsung di hadapan asesor atau lampirkan video).

## Slide 10: Penutup
- Kesimpulan: Aplikasi siap dikembangkan lebih lanjut dengan integrasi Payment Gateway nyata (Midtrans/Xendit).
- Q&A.
