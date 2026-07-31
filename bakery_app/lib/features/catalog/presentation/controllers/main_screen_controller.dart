import 'package:get/get.dart';

/// Controller untuk mengelola tab navigasi utama (Home, Menu, Cart, Profile).
/// Diekstrak ke GetxController agar bisa diakses dari halaman mana pun
/// (misalnya: tombol "See All" di HomeScreen bisa langsung berpindah ke tab Menu).
class MainScreenController extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
