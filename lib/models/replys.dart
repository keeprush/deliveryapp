import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyData {
  final String uid;
  final String nickname;
  final Timestamp bundle_id;
  final Timestamp bundle_order;
  final bool is_deleted;
  final String reply;
  final Timestamp created_date;
  final Timestamp updated_date;
  final Timestamp deleted_date;
  final int star_count;

  ReplyData({
    required this.uid,
    required this.nickname,
    required this.bundle_id,
    required this.bundle_order,
    required this.is_deleted,
    required this.reply,
    required this.created_date,
    required this.updated_date,
    required this.deleted_date,
    required this.star_count,

  });

  factory ReplyData.fromMap(Map map) {
    return ReplyData(
      uid: map['uid'] ?? '',
      nickname: map['nickname'] ?? '',
      bundle_id: map['bundle_id'] ?? DateTime.now(),
      bundle_order: map['bundle_order'] ?? '',
      is_deleted: map['is_deleted'] ?? true,
      reply: map['reply'] ?? '',
      created_date: map['created_date'] ?? DateTime.now(),
      updated_date: map['updated_date'] ?? DateTime.now(),
      deleted_date: map['deleted_date'] ?? DateTime.now(),
      star_count:map['star_count'] ?? 0,
    );
  }

  factory ReplyData.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;

    return ReplyData(
      uid: map['uid'] ?? '',
      nickname: map['nickname'] ?? '',
      bundle_id: map['bundle_id'] ?? DateTime.now(),
      bundle_order: map['bundle_order'] ?? '',
      is_deleted: map['is_deleted'] ?? true,
      reply: map['reply'] ?? '',
      created_date: map['created_date'] ?? DateTime.now(),
      updated_date: map['updated_date'] ?? DateTime.now(),
      deleted_date: map['deleted_date'] ?? DateTime.now(),
      star_count:map['star_count'] ?? 0,
    );
  }

  factory ReplyData.fromFireStoreQuery(QueryDocumentSnapshot qds) {
    Map<String, dynamic> map = qds.data() as Map<String, dynamic>;
    return ReplyData(
      uid: map['uid'] ?? '',
      nickname: map['nickname'] ?? '',
      bundle_id: map['bundle_id'] ?? DateTime.now(),
      bundle_order: map['bundle_order'] ?? '',
      is_deleted: map['is_deleted'] ?? true,
      reply: map['reply'] ?? '',
      created_date: map['created_date'] ?? DateTime.now(),
      updated_date: map['updated_date'] ?? DateTime.now(),
      deleted_date: map['deleted_date'] ?? DateTime.now(),
      star_count:map['star_count'] ?? 0,
    );
  }
}
