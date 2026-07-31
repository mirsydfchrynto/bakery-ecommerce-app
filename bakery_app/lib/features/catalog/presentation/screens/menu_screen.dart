import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/catalog_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final CatalogController controller = Get.find<CatalogController>();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive grid column calculation
    final screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth > 800 ? 5 : (screenWidth > 600 ? 4 : 2);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'Menu Kami',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Cari roti, kue...',
                        hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                        icon: const Icon(Icons.search_rounded, color: Color(0xFFBDBDBD)),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, color: Color(0xFFBDBDBD)),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Categories Filter
          SizedBox(
            height: 100,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
          
          // Product Grid
          Expanded(
            child: controller.obx(
              (products) {
                if (products == null || products.isEmpty) {
                  return const Center(child: Text('Tidak ada produk tersedia.'));
                }
                
                final filteredProducts = products.where((p) {
                  bool matchesSearch = _searchQuery.isEmpty || p.name.toLowerCase().contains(_searchQuery.toLowerCase());
                  bool matchesCategory = _selectedCategory == 'Semua' || p.categoryName.toLowerCase() == _selectedCategory.toLowerCase();
                  return matchesSearch && matchesCategory;
                }).toList();
                
                if (filteredProducts.isEmpty) {
                  return Center(child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        const Text('Tidak ada barang ditemukan.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  ));
                }

                return Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 100.0), // Padding bawah agar tidak tertutup FAB
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount, // Responsive Columns!
                          childAspectRatio: 0.75,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ProductCard(product: product);
                        },
                      ),
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
              onError: (error) => Center(child: Text('Gagal: $error')),
            ),
          ),
        ],
      ),
    ));
  }
}

