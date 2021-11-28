import 'package:cloud_firestore/cloud_firestore.dart';

class RandomMenuData {
  final List names;
  int price;

  RandomMenuData(
      {
        required this.names,
        required this.price,
      });

  factory RandomMenuData.fromMap(Map map) {
    return RandomMenuData(
      names: map['name'] ?? [],
      price: map['price'] ?? 0,
    );
  }

  factory RandomMenuData.fromFireStore(DocumentSnapshot doc) {
    Map map = doc.data as Map;

    return RandomMenuData(
      names: map['name'] ?? [],
      price: map['price'] ?? 0,
    );
  }
  factory RandomMenuData.fromFireStoreQuery(QueryDocumentSnapshot qds) {
    Map<String, dynamic> map = qds.data() as Map<String, dynamic>;
    return RandomMenuData(
      names: map['name'] ?? [],
      price: map['price'] ?? 0,
    );
  }
}
