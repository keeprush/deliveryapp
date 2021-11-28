import 'package:cloud_firestore/cloud_firestore.dart';

class OrderData {
  final String user_uid;
  final String store_name;
  final String user_location;
  final String user_location_detail;
  final List user_location_gps;
  final String store_location;
  final String store_location_detail;
  final List store_location_gps;
  // 드론 gps
  final List drone_location_gps;
  // 배달 시간
  final List delivery_time;
  // 주문 시간
  final Timestamp date;
  final List cart;
  final int all_price;
  final String order_status;



  OrderData(
      {required this.user_uid,
      required this.store_name,
      required this.user_location,
      required this.user_location_detail,
      required this.user_location_gps,
      required this.store_location,
      required this.store_location_detail,
        required this.store_location_gps,
        required this.drone_location_gps,

      required this.delivery_time,
      required this.date,
      required this.cart,
      required this.all_price,
      required this.order_status,

      });

  factory OrderData.fromMap(Map map) {
    return OrderData(
      user_uid: map['user_uid'] ?? '',
      store_name: map['store_name'] ?? '',
      user_location: map['user_location'] ?? '',
      user_location_detail: map['user_location_detail'] ?? '',
      user_location_gps: map['user_location_gps'] ?? [],
      store_location: map['store_location'] ?? '',
      store_location_detail: map['store_location_detail'] ?? '',
      store_location_gps: map['store_location_gps'] ?? [],
      drone_location_gps: map['drone_location_gps'] ?? [],
      delivery_time: map['delivery_time'] ?? [],
      date: map['date'] ?? DateTime.now(),
      cart: map['cart'] ?? [],
      all_price: map['all_price'] ?? 0,
      order_status: map['order_status'] ?? '',
    );
  }

  factory OrderData.fromFireStore(DocumentSnapshot doc) {
    Map map = doc.data as Map;

    return OrderData(
      user_uid: map['user_uid'] ?? '',
      store_name: map['store_name'] ?? '',
      user_location: map['user_location'] ?? '',
      user_location_detail: map['user_location_detail'] ?? '',
      user_location_gps: map['user_location_gps'] ?? [],
      store_location: map['store_location'] ?? '',
      store_location_detail: map['store_location_detail'] ?? '',
      store_location_gps: map['store_location_gps'] ?? [],
      drone_location_gps: map['drone_location_gps'] ?? [],
      delivery_time: map['delivery_time'] ?? [],
      date: map['date'] ?? DateTime.now(),
      cart: map['cart'] ?? [],
      all_price: map['all_price'] ?? 0,
      order_status: map['order_status'] ?? '',
    );
  }
  factory OrderData.fromFireStoreQuery(QueryDocumentSnapshot qds) {
    Map<String, dynamic> map = qds.data() as Map<String, dynamic>;
    return OrderData(
      user_uid: map['user_uid'] ?? '',
      store_name: map['store_name'] ?? '',
      user_location: map['user_location'] ?? '',
      user_location_detail: map['user_location_detail'] ?? '',
      user_location_gps: map['user_location_gps'] ?? [],
      store_location: map['store_location'] ?? '',
      store_location_detail: map['store_location_detail'] ?? '',
      store_location_gps: map['store_location_gps'] ?? [],
      drone_location_gps: map['drone_location_gps'] ?? [],
      delivery_time: map['delivery_time'] ?? [],
      date: map['date'] ?? DateTime.now(),
      cart: map['cart'] ?? [],
      all_price: map['all_price'] ?? 0,
      order_status: map['order_status'] ?? '',
    );
  }
}
