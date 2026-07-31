import 'package:get/get.dart';
import '../../../../core/storage/secure_storage_helper.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../../../routes/app_pages.dart';

/// AuthController bertugas sebagai jembatan antara Tampilan (UI) dan Logika Bisnis (Domain).
/// Menggunakan StateMixin dari GetX untuk mengatur loading state (sedang memuat, sukses, atau gagal)
/// sehingga UI tidak perlu repot membuat variabel boolean isLoading secara manual.
class AuthController extends GetxController with StateMixin<void> {
  // Dependency Injection: Menyuntikkan UseCase agar Controller tidak perlu tahu
  // detail bagaimana cara memanggil API internet.
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthController(this.loginUseCase, this.registerUseCase);

  @override
  void onInit() {
    super.onInit();
    // Saat pertama kali dibuat, set status menjadi sukses (tidak loading).
    change(null, status: RxStatus.success());
  }

  /// Fungsi untuk menangani proses masuk akun (Login)
  Future<void> login(String username, String password) async {
    // 1. Ubah status menjadi loading, tombol di UI akan berputar otomatis.
    change(null, status: RxStatus.loading());
    try {
      // 2. Eksekusi UseCase. Jika gagal, akan melempar error (masuk ke catch).
      await loginUseCase.execute(username, password);
      
      // 3. Jika berhasil, token JWT sudah tersimpan. Sekarang kita cek role user.
      final storage = Get.find<SecureStorageHelper>();
      final role = await storage.getRole();
      
      // 4. Ubah status kembali sukses.
      change(null, status: RxStatus.success());
      
      // 5. Arahkan pengguna ke halaman yang tepat berdasarkan role (Hak Akses)
      // Ini alasan kita membedakan akun Admin dan akun Customer.
      if (role == 'ADMIN') {
        Get.offAllNamed(Routes.adminHome);
      } else {
        Get.offAllNamed(Routes.home);
      }
    } catch (e) {
      // 6. Jika terjadi kesalahan (misal: password salah), tampilkan peringatan.
      change(null, status: RxStatus.error(e.toString()));
      Get.snackbar('Gagal', e.toString());
    }
  }

  /// Fungsi untuk mendaftar akun baru (Register)
  Future<void> register(String username, String email, String phone, String password) async {
    change(null, status: RxStatus.loading());
    try {
      // 1. Memanggil logika bisnis register.
      await registerUseCase.execute(username, email, phone, password);
      
      change(null, status: RxStatus.success());
      
      // 2. Jika sukses, beri tahu pengguna dan arahkan kembali ke layar Login.
      Get.snackbar('Berhasil', 'Registrasi berhasil! Silakan masuk.');
      Get.offNamed(Routes.login);
    } catch (e) {
      // 3. Tangani jika username sudah terpakai atau terjadi masalah lain.
      change(null, status: RxStatus.error(e.toString()));
      Get.snackbar('Gagal', e.toString());
    }
  }
}
