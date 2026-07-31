import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../data/models/user_model.dart';

class AdminCustomersController extends GetxController with StateMixin<List<UserModel>> {
  final AdminRepository repository;
  
  // State for search
  final RxString searchQuery = ''.obs;
  final RxList<UserModel> allCustomers = <UserModel>[].obs;
  final RxList<UserModel> filteredCustomers = <UserModel>[].obs;
  
  final TextEditingController searchController = TextEditingController();

  AdminCustomersController(this.repository);

  @override
  void onInit() {
    super.onInit();
    
    // Listen to search query changes
    debounce(searchQuery, (_) => _filterCustomers(), time: const Duration(milliseconds: 300));
    
    fetchCustomers();
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }
  
  void _filterCustomers() {
    if (searchQuery.value.isEmpty) {
      filteredCustomers.assignAll(allCustomers);
    } else {
      final query = searchQuery.value.toLowerCase();
      final filtered = allCustomers.where((user) {
        return user.username.toLowerCase().contains(query) || 
               user.email.toLowerCase().contains(query) ||
               user.role.toLowerCase().contains(query);
      }).toList();
      filteredCustomers.assignAll(filtered);
    }
    
    if (filteredCustomers.isEmpty) {
      change([], status: RxStatus.empty());
    } else {
      change(filteredCustomers, status: RxStatus.success());
    }
  }

  Future<void> fetchCustomers() async {
    change(null, status: RxStatus.loading());
    try {
      final list = await repository.getUsers();
      allCustomers.assignAll(list);
      _filterCustomers(); // Will set the status accordingly
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      await repository.deleteUser(id);
      Get.snackbar('Berhasil', 'Pelanggan berhasil dihapus', 
        backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      fetchCustomers();
    } catch (e) {
      Get.snackbar('Gagal', 'Tidak dapat menghapus pelanggan: $e',
        backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    }
  }
}
