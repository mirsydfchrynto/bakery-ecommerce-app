import 'package:get/get.dart';
import '../../domain/repositories/admin_repository.dart';

class AdminDashboardController extends GetxController with StateMixin<Map<String, dynamic>> {
  final AdminRepository repository;

  AdminDashboardController(this.repository);

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    change(null, status: RxStatus.loading());
    try {
      final data = await repository.getDashboardAnalytics();
      change(data, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
