import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryapp/models/replys.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReplyProvider {

  Future<List<int>> getStarCounts(Map<String, dynamic> data) async {
    List<int> scores = [0,0,0,0,0];

      var stars = await FirebaseFirestore.instance.collection('Stores').doc(data['store_uid'] + data['date'].seconds.toString()).collection('Replys').get();
    stars.docs.forEach((doc) {
      doc['star_count']==1?scores[0]+=1:
      doc['star_count']==2?scores[1]+=1:
      doc['star_count']==3?scores[2]+=1:
      doc['star_count']==4?scores[3]+=1:
      doc['star_count']==5?scores[4]+=1:
          print('No star(사장님 댓글)');
    });

    return scores;
  }
// 댓글
  static Future<void> setReplyFix(Map<String, dynamic> data) async {
    final CollectionReference user = await FirebaseFirestore.instance.collection(
        'Stores').doc(data['store_uid'] + data['date'].seconds.toString()).collection('Replys');

    var ref = user.doc(data['uid'] + data['created_date'].seconds.toString());


    await ref.set(
        {'reply': data['reply'], 'updated_date': data['updated_date']},
        SetOptions(merge: true))
        .then((value) => print("fix 댓글 성공"))
        .catchError((error) => print("Failed : $error"));
  }

  static Future<void> deleteReply(Map<String, dynamic> data) async {
    var replylist;

    replylist = await FirebaseFirestore.instance.collection(
        'Stores').doc(data['store_uid'] + data['date'].seconds.toString()).collection('Replys').where(
        'bundle_id', isEqualTo: data['bundle_id'])
        .get();
    replylist.docs.forEach((document) async {
      print(document.id);
      await FirebaseFirestore.instance.collection(
          'Stores').doc(data['store_uid'] + data['date'].seconds.toString()).collection('Replys')
          .doc(document.id).set({'is_deleted': true}, SetOptions(merge: true))
          .then((value) => print("delete 댓글 성공")).catchError((error) =>
          print("Failed : $error"));
    });
  }

  static Future<void> deleteReplyReply(Map<String, dynamic> data) async {
    final CollectionReference user = FirebaseFirestore.instance.collection(
        'Stores').doc(data['store_uid']+ data['date'].seconds.toString()).collection('Replys');

    var ref = user.doc(data['uid'] + data['created_date'].seconds.toString());

    await ref.set({'is_deleted': true}, SetOptions(merge: true)).then((value) =>
        print("delete 답글 성공")).catchError((error) =>
        print("Failed : $error"));
  }

  static Future<void> setReply(Map<String, dynamic> data) async {
    final CollectionReference user = FirebaseFirestore.instance.collection(
        'Stores').doc(data['store_uid'] + data['date'].seconds.toString()).collection('Replys');

    var ref = user.doc(data['uid'] + data['created_date'].seconds.toString());

    await ref.set(data, SetOptions(merge: true)).then((value) =>
        print("set 댓글 성공")).catchError((error) =>
        print("Failed : $error"));

    final CollectionReference store = FirebaseFirestore.instance.collection('Stores');

    var ref2 = store.doc(data['store_uid'] + data['date'].seconds.toString());

    double star = await ref2.get().then((DocumentSnapshot documentSnapshot) {
      return documentSnapshot['star'];
    });
    int review_count = await ref2.get().then((DocumentSnapshot documentSnapshot) {
      return documentSnapshot['review_count'];
    });
    double star_value = (star*review_count+data['star_count'])/(review_count+1);
    print(star_value);

    await ref2.set({'review_count': FieldValue.increment(1),'star':star_value }, SetOptions(merge: true)).then((value) =>
        print("review count, star 변경")).catchError((error) =>
        print("Failed : $error"));

    // store 리뷰 수 증가
    // store 리뷰 별점 변경

  }
}