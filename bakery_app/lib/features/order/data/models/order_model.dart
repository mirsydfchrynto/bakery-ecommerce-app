class OrderItemModel {
  final String productId;
  final String productName;
  final int quantity;
  final double priceAtPurchase;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.priceAtPurchase,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      priceAtPurchase: json['priceAtPurchase'].toDouble(),
    );
  }
}

class OrderModel {
  final String id;
  final double totalAmount;
  final String status;
  final String orderedAt;
  final String? customerName;
  final String? customerPhone;
  final String? rejectionReason;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.orderedAt,
    this.customerName,
    this.customerPhone,
    this.rejectionReason,
    this.items = const [],
  });

  String get readableStatus {
    switch (status) {
      case 'DRAFT': return 'Draf';
      case 'PENDING': return 'Menunggu Checkout';
      case 'WAITING_PAYMENT': return 'Menunggu Pembayaran';
      case 'VERIFYING_PAYMENT': return 'Sedang Divalidasi';
      case 'PROCESSING': return 'Diproses Dapur';
      case 'COMPLETED': return 'Selesai';
      case 'PAYMENT_REJECTED': return 'Pembayaran Ditolak';
      case 'CANCELLED': return 'Dibatalkan';
      case 'EXPIRED': return 'Kadaluarsa';
      default: return status.replaceAll('_', ' ');
    }
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'UNKNOWN',
      orderedAt: json['orderedAt'] ?? '',
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      rejectionReason: json['rejectionReason'],
      items: (json['items'] as List?)?.map((item) => OrderItemModel.fromJson(item)).toList() ?? [],
    );
  }
}
