import re

ctrl_path = '/home/irsyad/bakery_project/bakery_app/lib/features/admin/presentation/controllers/admin_orders_controller.dart'
with open(ctrl_path, 'r') as f:
    ctrl = f.read()

# Add dio to controller if not present
if 'import \'package:dio/dio.dart\';' not in ctrl:
    ctrl = "import 'package:dio/dio.dart';\n" + ctrl

# Add viewPaymentProof method
new_method = """
  Future<void> viewPaymentProof(String orderId) async {
    try {
      final dio = Get.find<Dio>();
      final response = await dio.get('/admin/orders/$orderId/payment');
      if (response.data['success'] == true) {
        final data = response.data['data'];
        final String urlsJson = data['paymentProofUrls'] ?? '[]';
        // Parse the JSON string array
        List<String> urls = [];
        try {
          import 'dart:convert';
          urls = List<String>.from(jsonDecode(urlsJson));
        } catch (e) {
          // just in case it's already a list or parsing fails
          if (urlsJson.startsWith('[')) {
            // manual split if jsonDecode fails, but we need dart:convert
            urls = urlsJson.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
          }
        }
        
        Get.dialog(
          import 'package:flutter/material.dart';
          AlertDialog(
            title: const Text('Payment Proof'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: ListView(
                children: [
                  Text('Bank: ${data['bankName']}'),
                  Text('Account: ${data['accountName']}'),
                  Text('Amount: Rp ${data['transferAmount']}'),
                  const SizedBox(height: 16),
                  ...urls.map((url) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.network('http://10.0.2.2:8080' + url.trim()), // assuming relative path from backend
                  )).toList(),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('Close')),
              TextButton(
                onPressed: () {
                  Get.back();
                  updateStatus(orderId, 'PROCESSING');
                }, 
                child: const Text('Verify & Accept')
              ),
            ],
          )
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load payment proof: $e');
    }
  }
"""

if 'Future<void> viewPaymentProof' not in ctrl:
    # Instead of hacky import inside the method, let's just add it correctly via string replace
    ctrl = ctrl.replace("import 'package:get/get.dart';", "import 'package:get/get.dart';\nimport 'dart:convert';\nimport 'package:flutter/material.dart';")
    new_method = new_method.replace("import 'dart:convert';", "").replace("import 'package:flutter/material.dart';", "")
    ctrl = ctrl[:-2] + new_method + "\n}\n"
    with open(ctrl_path, 'w') as f:
        f.write(ctrl)

screen_path = '/home/irsyad/bakery_project/bakery_app/lib/features/admin/presentation/screens/admin_orders_screen.dart'
with open(screen_path, 'r') as f:
    screen = f.read()

verify_btn = """
          if (order.status == 'VERIFYING_PAYMENT') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.viewPaymentProof(order.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                ),
                child: const Text('View Payment Proof', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
          const SizedBox(height: 24),
"""

if 'View Payment Proof' not in screen:
    screen = screen.replace('const SizedBox(height: 24),\n          const Divider(color: Color(0xFF334155)),', verify_btn + '          const Divider(color: Color(0xFF334155)),')
    with open(screen_path, 'w') as f:
        f.write(screen)
