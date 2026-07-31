import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/catalog_controller.dart';
import '../controllers/main_screen_controller.dart';
import '../../../../core/storage/secure_storage_helper.dart';

// Komponen (Widgets) hasil pemecahan file agar tidak melebihi 300 baris
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';

/// HomeScreen adalah halaman utama setelah pengguna login.
/// Halaman ini menampilkan nama pengguna, kotak pencarian, filter kategori, dan daftar produk.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mengambil controller yang sudah di-inject di memori oleh GetX
  final CatalogController controller = Get.find<CatalogController>();
  
  // State lokal (UI State) yang khusus dipakai di halaman ini saja
  String _username = 'Memuat...';
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      controller.fetchNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Mengambil nama pengguna dari ruang penyimpanan aman (Secure Storage)
  Future<void> _loadUsername() async {
    final storage = Get.find<SecureStorageHelper>();
    final savedName = await storage.getUsername() ?? 'Pengguna Tamu';
    if (mounted) {
      setState(() {
        _username = savedName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      
      // SafeArea agar tampilan tidak menabrak status bar HP (jam/baterai)
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildSearchBar(),
              const SizedBox(height: 32),
              _buildCategories(),
              const SizedBox(height: 32),
              _buildProductListHeader(),
              const SizedBox(height: 16),
              _buildProductGrid(),
              const SizedBox(height: 80), // Jarak ekstra agar list tidak tertutup Floating Button
            ],
          ),
        ),
      ),
    );
  }

  /// Widget Header (Salam & Profil)
  Widget _buildHeader() {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Selamat Pagi,' : (hour < 15 ? 'Selamat Siang,' : (hour < 18 ? 'Selamat Sore,' : 'Selamat Malam,'));
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: const TextStyle(fontSize: 16, color: Color(0xFF757575)),
            ),
            const SizedBox(height: 4),
            Text(
              '$_username 🥐',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFFF9800).withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFF9800), width: 2),
            image: DecorationImage(
              image: NetworkImage('https://ui-avatars.com/api/?name=$_username&background=FF9800&color=fff&size=200'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  /// Widget Kotak Pencarian (Search Bar)
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          // Ketika diketik, otomatis simpan kata kunci dan UI direfresh
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Cari roti, kue...',
          hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
          icon: Icon(Icons.search_rounded, color: Color(0xFFBDBDBD)),
        ),
      ),
    );
  }

  /// Widget Daftar Kategori yang bisa digeser menyamping
  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              CategoryChip(icon: Icons.grid_view_rounded, label: 'Semua', isSelected: _selectedCategory == 'Semua', onTap: () => setState(() => _selectedCategory = 'Semua')),
              CategoryChip(icon: Icons.bakery_dining_rounded, label: 'Roti', isSelected: _selectedCategory == 'Breads', onTap: () => setState(() => _selectedCategory = 'Breads')),
              CategoryChip(icon: Icons.cake_rounded, label: 'Kue', isSelected: _selectedCategory == 'Cakes', onTap: () => setState(() => _selectedCategory = 'Cakes')),
              CategoryChip(icon: Icons.cookie_rounded, label: 'Kue Kering', isSelected: _selectedCategory == 'Cookies', onTap: () => setState(() => _selectedCategory = 'Cookies')),
              CategoryChip(icon: Icons.local_cafe_rounded, label: 'Minuman', isSelected: _selectedCategory == 'Drinks', onTap: () => setState(() => _selectedCategory = 'Drinks')),
            ],
          ),
        ),
      ],
    );
  }

  /// Judul dinamis: Jika ada pencarian, berubah jadi 'Hasil Pencarian'
  Widget _buildProductListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _selectedCategory == 'Semua' && _searchQuery.isEmpty ? 'Populer Sekarang' : 'Hasil Pencarian',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
        ),
        if (_selectedCategory == 'Semua' && _searchQuery.isEmpty)
          TextButton(
            onPressed: () {
              Get.find<MainScreenController>().changeTab(1);
            },
            child: const Text(
              'Lihat Semua',
              style: TextStyle(color: Color(0xFFFF9800), fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }

  /// Grid Produk yang menggunakan controller.obx agar reaktif
  Widget _buildProductGrid() {
    return controller.obx(
      (products) {
        if (products == null || products.isEmpty) {
          return const Center(child: Text('Tidak ada produk tersedia.'));
        }

        // LOGIKA FILTER: Saring produk berdasarkan nama (search) DAN nama kategori.
        var filteredProducts = products.where((p) {
          bool matchesSearch = _searchQuery.isEmpty || p.name.toLowerCase().contains(_searchQuery.toLowerCase());
          bool matchesCategory = _selectedCategory == 'Semua' || p.categoryName.toLowerCase() == _selectedCategory.toLowerCase();
          return matchesSearch && matchesCategory;
        }).toList();

        // Batasi 4 produk jika sedang mode 'Populer Sekarang'
        if (_selectedCategory == 'Semua' && _searchQuery.isEmpty) {
          filteredProducts = filteredProducts.take(4).toList();
        }

        if (filteredProducts.isEmpty) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text('Tidak ada produk yang sesuai dengan pencarian Anda.', style: TextStyle(color: Colors.grey)),
          ));
        }

        return Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Agar scroll mengikuti layar induk
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(product: filteredProducts[index]);
              },
            ),
            GetBuilder<CatalogController>(
              builder: (c) {
                if (c.isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(color: Color(0xFFFF9800)),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        );
      },
      onLoading: const Center(child: CircularProgressIndicator(color: Color(0xFFFF9800))),
      onEmpty: const Center(child: Text('Tidak ada produk tersedia.')),
      onError: (error) => Center(child: Text('Error: $error')),
    );
  }
}
