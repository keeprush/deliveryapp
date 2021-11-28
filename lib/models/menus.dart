import 'package:cloud_firestore/cloud_firestore.dart';

class MenuData {
  final String name;
  int price;
  int count;

  MenuData(
      {
        required this.name,
        required this.price,
        required this.count,
      });

  factory MenuData.fromMap(Map map) {
    return MenuData(
      name: map['name'] ?? '',
      price: map['price'] ?? 0,
      count: map['count'] ?? 0,
    );
  }

  factory MenuData.fromFireStore(DocumentSnapshot doc) {
    Map map = doc.data as Map;

    return MenuData(
      name: map['name'] ?? '',
      price: map['price'] ?? 0,
      count: map['count'] ?? 0,
    );
  }
  factory MenuData.fromFireStoreQuery(QueryDocumentSnapshot qds) {
    Map<String, dynamic> map = qds.data() as Map<String, dynamic>;
    return MenuData(
      name: map['name'] ?? '',
      price: map['price'] ?? 0,
      count: map['count'] ?? 0,
    );
  }
}
