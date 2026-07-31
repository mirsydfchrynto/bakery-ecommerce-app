# Diagram Aplikasi Bakery

## 1. Use Case Diagram

```mermaid
usecaseDiagram
    actor Pelanggan as "Pelanggan"
    actor Admin as "Admin (Sistem)"

    Pelanggan --> (Login / Register)
    Pelanggan --> (Melihat Katalog)
    Pelanggan --> (Filter Kategori)
    Pelanggan --> (Tambah ke Keranjang)
    Pelanggan --> (Checkout Pesanan)
    
    (Checkout Pesanan) --> Admin : "Kirim Data Pesanan"
    Admin --> (Kurangi Stok Inventaris)
    Admin --> (Update Status Pesanan)
```

## 2. Flowchart Proses Pemesanan

```mermaid
graph TD
    A[Mulai Aplikasi] --> B{Sudah Login?}
    B -- Belum --> C[Halaman Login/Register]
    C --> D[Halaman Utama / Katalog]
    B -- Sudah --> D
    D --> E[Pilih Produk]
    E --> F[Tambah ke Keranjang]
    F --> G[Buka Keranjang]
    G --> H{Cek Total}
    H -- Setuju --> I[Klik Checkout]
    I --> J[Pesanan Terbuat di Backend]
    J --> K[Selesai]
```
