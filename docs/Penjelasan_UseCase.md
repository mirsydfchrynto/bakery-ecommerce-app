# Penjelasan Use Case Diagram Bakery E-Commerce

Diagram Use Case ini menggambarkan interaksi fungsional utama antara aktor (pengguna) dengan sistem Bakery E-Commerce. Berikut adalah rincian komponennya:

## 1. Aktor (Actors)
Dalam sistem ini terdapat 2 (dua) aktor utama:
*   **Pelanggan**: Merupakan *end-user* atau pembeli yang menggunakan aplikasi mobile untuk berbelanja produk roti/kue. Aktor ini memicu berbagai aksi yang berhubungan dengan transaksi.
*   **Admin Toko**: Merupakan pihak internal (karyawan/pemilik) yang mengelola sistem dari sisi *back-office* (Backend). Aktor ini bertanggung jawab atas pemeliharaan data produk dan pemrosesan pesanan.

## 2. Use Case (Skenario Sistem)
Berikut adalah daftar fungsionalitas yang bisa dilakukan oleh aktor:

### A. Fungsionalitas Umum (Shared)
*   **Autentikasi (Login/Register)**: 
    *   Baik Pelanggan maupun Admin wajib melakukan login untuk mengakses fitur-fitur penting (seperti checkout atau mengelola produk). 
    *   Jika belum memiliki akun, Pelanggan dapat melakukan registrasi (mendaftar).

### B. Fungsionalitas Pelanggan
*   **Melihat Katalog Produk**: Pelanggan dapat membuka aplikasi dan melihat daftar roti, filter berdasarkan kategori, serta melihat detail gambar dan harga tanpa perlu login (bersifat publik).
*   **Mengelola Keranjang**: Pelanggan dapat menambahkan produk, mengubah jumlah (kuantitas), atau menghapus produk dari keranjang belanjanya.
*   **Melakukan Checkout**: Skenario di mana Pelanggan menyelesaikan pesanannya. Use Case ini memiliki relasi `<<include>>` ke **Autentikasi**, yang artinya Pelanggan **wajib** dalam keadaan login untuk bisa melakukan checkout.

### C. Fungsionalitas Admin Toko
*   **Kelola Data Produk**: Admin dapat melakukan operasi CRUD (Create, Read, Update, Delete) pada katalog roti. Use Case ini juga memiliki relasi `<<include>>` ke **Autentikasi**, sehingga wajib login sebagai admin.
*   **Kelola Pesanan Masuk**: Admin menerima notifikasi pesanan dari pelanggan, mengkonfirmasi pembayaran, dan memperbarui status pesanan menjadi "Diproses" atau "Selesai". Sistem akan secara otomatis mengurangi stok melalui fungsi ini.
*   **Melihat Laporan Penjualan**: Admin dapat merekapitulasi total pendapatan dan riwayat transaksi yang sudah selesai.

## 3. Relasi *Include*
*   `Melakukan Checkout` **<<include>>** `Autentikasi`
*   `Kelola Data Produk` **<<include>>** `Autentikasi`
    *   *Penjelasan*: Relasi ini menunjukkan ketergantungan mutlak. Fitur checkout dan manajemen sistem *back-office* tidak mungkin bisa dijalankan jika aktor belum melewati proses autentikasi (login) terlebih dahulu.
