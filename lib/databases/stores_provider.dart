import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryapp/models/menus.dart';
import 'package:deliveryapp/models/rand_menus.dart';
import 'package:deliveryapp/models/stores.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoreProvider {
  var last;

  // 상점 늘리기용
  Future<void> addStores() async {
    var date = Timestamp.now();
    Map<String, dynamic> data = {
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'nickname': '사장',
      'location': '서울특별시 성북구 동선동 3가 98',
      'location_detail': '101호',
      'location_gps': [37.5054, 126.983894653],
      'store_notice': '안녕하세요 가게.',
      'store_img':
          'https://firebasestorage.googleapis.com/v0/b/delivery-e3379.appspot.com/o/%ED%94%BC%EC%9E%90.jpg?alt=media&token=e93ea488-2264-416d-8b19-dbe7d514e12f',
      'store_name': '가게3',
      'star': 0.0,
      'review_count': 0,
      'order_count': 0,
      'steamed_count': 0,
      'category_type': '양식',
      'operation_time': '10시 ~ 21시',
      'no_operation_time': '매주 화 쉽니다.',
      'phone_number': '010-5031-7353',
      'possible_delivery': '성북구 일대',
      'delivery_fee': 1000,
      'date': date,
      'at_least_money': 2000,
      'delivery_time': [30, 40],
    };
    final CollectionReference user =
        FirebaseFirestore.instance.collection('Stores');
    var ref = user.doc(data['uid'] + date.seconds.toString());

    await ref
        .set(data, SetOptions(merge: true))
        .then((value) => print("상점 추가 완료"))
        .catchError((error) => print("상점 추가 실패 : $error"));
  }

  // 메뉴 가져오기용
  Future<List<MenuData>> getRecommendMenus(Map<String, dynamic> data) async {
    var recommend = await FirebaseFirestore.instance
        .collection('Stores')
        .doc(data['store_uid'] + data['date'].seconds.toString())
        .collection('recommendMenus')
        .get();
    List<MenuData> _recommend = [];
    recommend.docs.forEach((doc) {
      _recommend.add(MenuData.fromFireStoreQuery(doc));
    });
    return _recommend;
  }

  Future<List<MenuData>> getMainMenus(Map<String, dynamic> data) async {
    var recommend = await FirebaseFirestore.instance
        .collection('Stores')
        .doc(data['store_uid'] + data['date'].seconds.toString())
        .collection('mainMenus')
        .get();
    List<MenuData> _recommend = [];
    recommend.docs.forEach((doc) {
      _recommend.add(MenuData.fromFireStoreQuery(doc));
    });
    return _recommend;
  }

  Future<List<MenuData>> getSideMenus(Map<String, dynamic> data) async {
    var recommend = await FirebaseFirestore.instance
        .collection('Stores')
        .doc(data['store_uid'] + data['date'].seconds.toString())
        .collection('sideMenus')
        .get();
    List<MenuData> _recommend = [];
    recommend.docs.forEach((doc) {
      _recommend.add(MenuData.fromFireStoreQuery(doc));
    });
    return _recommend;
  }

  // 상점 리스트 가져오기
  static Future<List?> getStore(
      int order_price, double review_star, int delivery_fee) async {
    List<StoreData> list = [];
    var stores;
    // 별점, 배달팁
    // 파이어베이스는 where 절 다른 속성으로 비교 불가
    stores = await FirebaseFirestore.instance
        .collection('Stores')
        .where('star', isGreaterThanOrEqualTo: review_star)
        .get();
    stores.docs.forEach((doc) {
      list.add(StoreData.fromFireStoreQuery(doc));
    });
    var result = [];
    for (var i = 0; i < list.length; i++) {
      if(list[i].delivery_fee<=delivery_fee) {
        var temp = await getRandomMenus(list[i], order_price);
        if(temp == null){
          print('null');
        }
        else{
          result.add([list[i],temp]);
        }
      }
    }
    if(result.isEmpty) {
      return null;
    }
    result.shuffle();
    return result[0];
  }

  static Future<RandomMenuData?> getRandomMenus(StoreData data, int order_price) async {
    var recommend = await FirebaseFirestore.instance
        .collection('Stores')
        .doc(data.uid + data.date.seconds.toString())
        .collection('randomMenus')
        .get();
    RandomMenuData? rmd;
    List<RandomMenuData> _recommend = [];
    recommend.docs.forEach((doc) {
      _recommend.add(RandomMenuData.fromFireStoreQuery(doc));
    });
    if(_recommend.isEmpty) {
      return null;
    }
    else{
      for(var i =0;i<_recommend.length;i++) {
        if(_recommend[i].price==order_price){
          rmd = _recommend[i];
        }
        }
    }
    return rmd;
    //return _recommend;
  }

  // 메뉴 늘리기용
  Future<void> addMenus1(Map<String, dynamic> data) async {
    var date = Timestamp.now();
    Map<String, dynamic> menu = {
      'name': '된장찌개',
      'price': 4000,
    };
    final CollectionReference user = FirebaseFirestore.instance
        .collection('Stores')
        .doc(data['store_uid'] + data['date'].seconds.toString())
        .collection('recommendMenus');
    var ref = user.doc(date.seconds.toString());

    await ref
        .set(menu, SetOptions(merge: true))
        .then((value) => print("추천 추가 완료"))
        .catchError((error) => print("메인메뉴 추가 실패 : $error"));
  }

  Future<void> addMenus2(Map<String, dynamic> data) async {
    var date = Timestamp.now();
    Map<String, dynamic> menu = {
      'name': '치즈돈까스',
      'price': 8000,
    };
    final CollectionReference user = FirebaseFirestore.instance
        .collection('Stores')
        .doc(data['store_uid'] + data['date'].seconds.toString())
        .collection('mainMenus');
    var ref = user.doc(date.seconds.toString());

    await ref
        .set(menu, SetOptions(merge: true))
        .then((value) => print("메인메뉴 추가 완료"))
        .catchError((error) => print("메인메뉴 추가 실패 : $error"));
  }

  Future<void> addMenus3(Map<String, dynamic> data) async {
    var date = Timestamp.now();
    Map<String, dynamic> menu = {
      'name': '김치우동',
      'price': 5000,
    };
    final CollectionReference user = FirebaseFirestore.instance
        .collection('Stores')
        .doc(data['store_uid'] + data['date'].seconds.toString())
        .collection('sideMenus');
    var ref = user.doc(date.seconds.toString());

    await ref
        .set(menu, SetOptions(merge: true))
        .then((value) => print("사이드메뉴 추가 완료"))
        .catchError((error) => print("사이드메뉴 추가 실패 : $error"));
  }

  Future<void> addMenusRandom(Map<String, dynamic> data) async {
    var date = Timestamp.now();
    Map<String, dynamic> menu = {
      'name': ['김밥', '떡볶이', '콜라', '순대'],
      'price': 10000,
    };
    final CollectionReference user = FirebaseFirestore.instance
        .collection('Stores')
        .doc(data['store_uid'] + data['date'].seconds.toString())
        .collection('randomMenus');
    var ref = user.doc(date.seconds.toString());

    await ref
        .set(menu, SetOptions(merge: true))
        .then((value) => print("랜덤메뉴 추가 완료"))
        .catchError((error) => print("사이드메뉴 추가 실패 : $error"));
  }

  // 무한 스크롤
  Future<List<StoreData>> getStoreInfiniteScroll(
      int offset, int limit, int index) async {
    List<StoreData> list = [];
    print('hi');
    var stores;
    if (offset == 0) {
      stores = await FirebaseFirestore.instance
          .collection('Stores')
          .orderBy('date', descending: true)
          .limit(limit)
          .get();
    } else if (offset != 0) {
      print('else');
      stores = await FirebaseFirestore.instance
          .collection('Stores')
          .orderBy('date', descending: true)
          .startAfter([last.data()['date']])
          .limit(limit)
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
}
