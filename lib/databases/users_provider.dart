import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryapp/models/orders.dart';
import 'package:deliveryapp/models/stores.dart';
import 'package:deliveryapp/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider {
  final CollectionReference user =
      FirebaseFirestore.instance.collection('Users');
  var last;

  Stream<UserData> getUser() {
    var snap = user.doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
    print('유저 정보 가져오기');

    return snap
        .map((list) => UserData.fromMap(list.data() as Map<String, dynamic>));
  }

  Stream<List<UserData>> getUsers() {
    print('유저 정보 가져오기');
    return user.snapshots().map(
        (list) => list.docs.map((doc) => UserData.fromFireStore(doc)).toList());
  }

  Future<bool> isFirst() async {
    var ref = user.doc(FirebaseAuth.instance.currentUser!.uid);
    var exist = await ref.get().then((DocumentSnapshot documentSnapshot) {
      print('회원가입 후 첫 로그인인지 아닌지 체크. 첫 로그인 여부 : ${documentSnapshot.exists}');
      return documentSnapshot.exists;
    });
    return exist;
  }

  // 찜
  static Future<bool> isLiked(String data) async {
    var liked = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('LikedList')
        .where('store_name', isEqualTo: data)
        .get();
    bool is_liked = false;
    liked.docs.forEach((doc) {
      is_liked = true;
    });
    return is_liked;
  }

  static Future<void> addLikedList(Map<String, dynamic> data) async {
    final CollectionReference user = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('LikedList');
    var ref = user.doc(Timestamp.now().seconds.toString());
    await LikedCntPlus(data);
    await ref
        .set({'store_name': data['store_name']}, SetOptions(merge: true))
        .then((value) => print("steamed"))
        .catchError((error) => print("Failed : $error"));
  }

  static Future<void> removeLikedList(Map<String, dynamic> data) async {
    var likedlist;
    likedlist = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('LikedList')
        .get();
    likedlist.docs.forEach((doc) async {
      Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
      if (data['store_name'] == map['store_name']) {
        await doc.reference.delete();
      }
    });
    await LikedCntMinus(data);
  }

  static Future<void> LikedCntPlus(Map<String, dynamic> data) async {
    final CollectionReference user =
        FirebaseFirestore.instance.collection('Stores');
    var ref = user.doc(data['store_uid'] + data['date'].seconds.toString());
    await ref.update({'steamed_count': FieldValue.increment(1)}).then(
        (value) => print('찜 O'));
  }

  static Future<void> LikedCntMinus(Map<String, dynamic> data) async {
    final CollectionReference user =
        FirebaseFirestore.instance.collection('Stores');
    var ref = user.doc(data['store_uid'] + data['date'].seconds.toString());
    await ref.update({'steamed_count': FieldValue.increment(-1)}).then(
        (value) => print('찜 X'));
  }

  // 무한 스크롤 찜
  Future<List<StoreData>> getSteamedInfiniteScroll(
      int offset, int limit) async {
    List<StoreData> list = [];
    var stores;
    List<String> liked_list = [];
    var liked = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('LikedList')
        .get();
    liked.docs.forEach((doc) {
      liked_list.add(doc['store_name']);
    });
    // 찜 리스트에 있는 것만 출력하기
    if (offset == 0) {
      stores = await FirebaseFirestore.instance
          .collection('Stores')
          .orderBy('date', descending: true)
          .limit(limit)
          .where('store_name', whereIn: liked_list)
          .get();
    } else if (offset != 0) {
      print('else');
      stores = await FirebaseFirestore.instance
          .collection('Stores')
          .orderBy('date', descending: true)
          .startAfter([last.data()['date']])
          .limit(limit)
          .where('store_name', whereIn: liked_list)
          .get();
    } else {
      print("무언가 잘못되었습니다.");
    }
    stores.docs.forEach((doc) {
      list.add(StoreData.fromFireStoreQuery(doc));
    });
    if (list.isEmpty) {
      last = null;
    } else {
      last = stores.docs[stores.docs.length - 1];
    }
    return list;
  }

  // 1. 주문 목록을 받아온다. (store_uid, date 필요 or store_name 저장 필요, 주문 목록 저장)
  // 2. 받아온 주문목록으로 가게 정보를 불러온다.
  // 3. 받아온 가게정보와 주문 목록을 리턴한다.

  static Future<void> setOrders(Map<String, dynamic> data, String store_uid, Timestamp date) async {
    // 주문
    final CollectionReference order =
        FirebaseFirestore.instance.collection('Orders');
    var ref = order.doc(data['user_uid'] + data['date'].seconds.toString());
    // 가게
    final CollectionReference store =
    FirebaseFirestore.instance.collection('Stores');
    var ref2 = store.doc(store_uid + date.seconds.toString());
    // 유저
    final CollectionReference user =
    FirebaseFirestore.instance.collection('Users');
    var ref3 = user.doc(FirebaseAuth.instance.currentUser!.uid);

    await ref
        .set(data, SetOptions(merge: true))
        .then((value) => print("주문 삽입 완료"))
        .catchError((error) => print("Failed : $error"));
    await ref2.update({'order_count': FieldValue.increment(1)}).then(
            (value) => print('가게 주문 수 1 증가'));
    await ref3.update({'order_count': FieldValue.increment(1),'order_month_count': FieldValue.increment(1)}).then(
            (value) => print('유저 주문 수 1 증가'));


  }
  static Future<void> setOrderStatus(Map<String, dynamic> data) async {
    final CollectionReference user =
    FirebaseFirestore.instance.collection('Orders');

    var ref = user.doc(data['user_uid'] + data['date'].seconds.toString());

    await ref
        .set(data, SetOptions(merge: true))
        .then((value) => print("배달 상태 변경 완료"))
        .catchError((error) => print("Failed : $error"));
  }

  // 무한 스크롤 주문목록
  Future<List<dynamic>> getOrdersInfiniteScroll(int offset, int limit) async {
    var list = [];
    var stores;
    var orders;
    List<OrderData> orders_list = [];
    List<StoreData> stores_list = [];
    List<String> stores_name_list = [];

    if (offset == 0) {
      orders = await FirebaseFirestore.instance
          .collection('Orders')
          .orderBy('date', descending: true)
          .where('user_uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .limit(limit)
          .get();
    } else if (offset != 0) {
      orders = await FirebaseFirestore.instance
          .collection('Orders')
          .orderBy('date', descending: true)
          .startAfter([last.data()['date']])
          .limit(limit)
          .where('user_uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
    } else {
      print("무언가 잘못되었습니다.");
    }
    orders.docs.forEach((doc) {
      stores_name_list.add(doc['store_name']);
      orders_list.add(OrderData.fromFireStoreQuery(doc));
    });
    stores = await FirebaseFirestore.instance
        .collection('Stores')
        .orderBy('date', descending: true)
        .where('store_name', whereIn: stores_name_list)
        .get();

    orders.docs.forEach((order) {
      stores.docs.forEach((store) {
        if (order['store_name'] == store['store_name']) {
          stores_list.add(StoreData.fromFireStoreQuery(store));
        }
      });
    });
    // 다 받아왔으면
    list.add(orders_list);
    list.add(stores_list);
    if (list.isEmpty) {
      last = null;
    } else {
      last = orders.docs[orders.docs.length - 1];
    }
    return list;
  }

  void createUserInfo(Map<String, dynamic> data) async {
    var ref = user.doc(FirebaseAuth.instance.currentUser!.uid);

    ref
        .set(data, SetOptions(merge: true))
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  void setAdress(Map<String, dynamic> data) async {
    var ref = user.doc(FirebaseAuth.instance.currentUser!.uid);
    ref
        .set(data, SetOptions(merge: true))
        .then((value) => print("set address 완료"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
