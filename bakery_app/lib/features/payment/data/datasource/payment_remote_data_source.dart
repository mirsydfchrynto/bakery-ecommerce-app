import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

abstract class PaymentRemoteDataSource {
  Future<Map<String, dynamic>> uploadPaymentProof({
    required String orderId,
    required String paymentMethod,
    required String bankName,
    required String accountName,
    required double transferAmount,
    required List<String> filePaths,
  });
  Future<void> cancelOrder(String orderId);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;

  PaymentRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> uploadPaymentProof({
    required String orderId,
    required String paymentMethod,
    required String bankName,
    required String accountName,
    required double transferAmount,
    required List<String> filePaths,
  }) async {
    FormData formData = FormData.fromMap({
      'paymentMethod': paymentMethod,
      'bankName': bankName,
      'accountName': accountName,
      'transferAmount': transferAmount,
    });
    
    for (String path in filePaths) {
      String fileName = path.split('/').last;
      
      // Basic mime type detection based on extension for the backend validation
      String extension = fileName.split('.').last.toLowerCase();
      String mimeType = (extension == 'png') ? 'image/png' : 'image/jpeg';
      
      formData.files.add(MapEntry(
        'files',
        await MultipartFile.fromFile(
          path, 
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      ));
    }

    final response = await dio.post(
      '/payments/$orderId/upload',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw Exception(response.data['message'] ?? 'Upload failed');
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    final response = await dio.put('/orders/$orderId/cancel');
    if (response.statusCode != 200) {
      throw Exception(response.data['message'] ?? 'Failed to cancel order');
    }
  }
}
