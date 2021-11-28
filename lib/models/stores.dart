import 'package:cloud_firestore/cloud_firestore.dart';

class StoreData {
  final String uid;
  final String nickname;
  final String location;
  final String location_detail;
  final List location_gps;
  final String store_notice;
  // store 정보
  final String store_img;
  final String store_name;
  final double star;
  final int review_count;
  // 아래꺼는 정보에 사용
  final int order_count;
  late int steamed_count;
  final String category_type;
  // 음식점 정보
  final String operation_time;
  final String no_operation_time;
  final String phone_number;
  final String possible_delivery;
  // 배달팁
  final int delivery_fee;
  // 최소주문금액
  final int at_least_money;
  // 배달 시간
  final List delivery_time;
  // 날짜(가게 찾기용)
  final Timestamp date;




  StoreData(
      {required this.uid,
        required this.nickname,
        required this.location,
        required this.location_detail,
        required this.location_gps,
        required this.store_notice,
        required this.store_img,
        required this.store_name,
        required this.star,
        required this.review_count,
        required this.order_count,
        required this.steamed_count,
        required this.category_type,
        required this.operation_time,
        required this.no_operation_time,
        required this.phone_number,
        required this.possible_delivery,
        required this.delivery_fee,
        required this.at_least_money,
        required this.delivery_time,
        required this.date,
      });

  factory StoreData.fromMap(Map map) {
    return StoreData(
      uid: map['uid'] ?? '',
      nickname: map['nickname'] ?? '',
      location: map['location'] ?? '',
      location_detail: map['location_detail'] ?? '',
      location_gps: map['location_gps'] ?? [],
      store_notice: map['store_notice'] ?? '',
      store_img: map['store_img'] ?? '',
      store_name: map['store_name'] ?? '',
      star: map['star'] ?? 0.0,
      review_count: map['review_count'] ?? 0,
      order_count: map['order_count'] ?? 0,
      steamed_count: map['steamed_count'] ?? 0,
      category_type: map['category_type'] ?? '',
      operation_time: map['operation_time'] ?? '',
      no_operation_time: map['no_operation_time'] ?? '',
      phone_number: map['phone_number'] ?? '',
      possible_delivery: map['possible_delivery'] ?? '',
      delivery_fee: map['delivery_fee'] ?? 0,
      at_least_money: map['at_least_money'] ?? 0,
      delivery_time: map['delivery_time'] ?? [],
      date: map['date'] ?? DateTime.now(),
    );
  }

  factory StoreData.fromFireStore(DocumentSnapshot doc) {
    Map map = doc.data as Map;

    return StoreData(
      uid: map['uid'] ?? '',
      nickname: map['nickname'] ?? '',
      location: map['location'] ?? '',
      location_detail: map['location_detail'] ?? '',
      location_gps: map['location_gps'] ?? [],
      store_notice: map['store_notice'] ?? '',
      store_img: map['store_img'] ?? '',
      store_name: map['store_name'] ?? '',
      star: map['star'] ?? 0.0,
      review_count: map['review_count'] ?? 0,
      order_count: map['order_count'] ?? 0,
      steamed_count: map['steamed_count'] ?? 0,
      category_type: map['category_type'] ?? '',
      operation_time: map['operation_time'] ?? '',
      no_operation_time: map['no_operation_time'] ?? '',
      phone_number: map['phone_number'] ?? '',
      possible_delivery: map['possible_delivery'] ?? '',
      delivery_fee: map['delivery_fee'] ?? 0,
      at_least_money: map['at_least_money'] ?? 0,
      delivery_time: map['delivery_time'] ?? [],
      date: map['date'] ?? DateTime.now(),
    );
  }
  factory StoreData.fromFireStoreQuery(QueryDocumentSnapshot qds) {
    Map<String, dynamic> map = qds.data() as Map<String, dynamic>;
    return StoreData(
      uid: map['uid'] ?? '',
      nickname: map['nickname'] ?? '',
      location: map['location'] ?? '',
      location_detail: map['location_detail'] ?? '',
      location_gps: map['location_gps'] ?? [],
      store_notice: map['store_notice'] ?? '',
      store_img: map['store_img'] ?? '',
      store_name: map['store_name'] ?? '',
      star: map['star'] ?? 0.0,
      review_count: map['review_count'] ?? 0,
      order_count: map['order_count'] ?? 0,
      steamed_count: map['steamed_count'] ?? 0,
      category_type: map['category_type'] ?? '',
      operation_time: map['operation_time'] ?? '',
      no_operation_time: map['no_operation_time'] ?? '',
      phone_number: map['phone_number'] ?? '',
      possible_delivery: map['possible_delivery'] ?? '',
      delivery_fee: map['delivery_fee'] ?? 0,
      at_least_money: map['at_least_money'] ?? 0,
      delivery_time: map['delivery_time'] ?? [],
      date: map['date'] ?? DateTime.now(),
    );
  }
}
