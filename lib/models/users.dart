import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String nickname;
  final List location_gps;
  final int order_count;
  final int order_month_count;
  final Timestamp created_date;

  UserData({
    required this.nickname,
    required this.location_gps,
    required this.order_count,
    required this.order_month_count,
    required this.created_date,
  });

  factory UserData.fromMap(Map map) {
    return UserData(
      nickname: map['nickname'] ?? '',
      location_gps: map['location_gps'] ?? [],
      order_count: map['order_count'] ?? 0,
        order_month_count: map['order_month_count'] ?? 0,
      created_date: map['created_date'] ?? Timestamp.now(),
    );
  }

  factory UserData.fromFireStore(DocumentSnapshot doc) {
    Map map = doc.data as Map;

    return UserData(
      nickname: map['nickname'] ?? '',
      location_gps: map['location_gps'] ?? [],
      order_count: map['order_count'] ?? [],
      order_month_count: map['order_month_count'] ?? 0,
      created_date: map['created_date'] ?? Timestamp.now(),
    );
  }
}
