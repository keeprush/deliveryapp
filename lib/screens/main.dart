/*
2. 랜덤 주문,
1. 드론 제일 가까운거 배달
3. 주문한걸로 등급 매기기
*/

// 네비게이션바(홈)
import 'package:deliveryapp/databases/users_provider.dart';
import 'package:deliveryapp/models/menus.dart';
import 'package:deliveryapp/models/stores.dart';
import 'package:deliveryapp/models/users.dart';
import 'package:deliveryapp/screens/views/home/bottom_tab_view.dart';
import 'package:deliveryapp/screens/views/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:deliveryapp/join_or_login.dart';
// 이지로딩
import 'package:flutter_easyloading/flutter_easyloading.dart';

// 파이어베이스
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 프로바이더
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..progressColor = Colors.white
    ..indicatorSize = 50.0
    ..indicatorColor = Colors.white
    ..textColor = Colors.black45
    ..textStyle = const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'fontnoto')
    ..backgroundColor = Colors.amberAccent
    ..maskColor = Colors.black.withOpacity(0.3)
    ..fontSize = 15
    ..radius = 20
    ..lineWidth = 5.0

    ..userInteractions = false //
    ..dismissOnTap = false; //
}

class MyApp extends StatelessWidget {
  UserProvider up =UserProvider();
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
        providers: [
          StreamProvider<UserData>(
            create:(context) =>  up.getUser(),
            initialData: UserData(nickname: '', location_gps: [],order_count: 0, order_month_count: 0,created_date: Timestamp.now()),
          ),
          Provider<List<MenuData>>.value(value:[]),
          Provider<List<StoreData>>.value(value:[StoreData(location_detail: '',
              order_count: 0, star: 0, phone_number: '', no_operation_time: '', date: Timestamp.now(), store_img: '', store_name: '', location_gps: [], delivery_time: [], nickname: '', store_notice: ''
                  '', steamed_count: 0, at_least_money: 0, location: '', uid: '', category_type: '', possible_delivery: '', delivery_fee: 0, operation_time: '', review_count: 0)]),
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // 리본 제거
        home: MyHomePage(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: EasyLoading.init(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> user) {
          if (user.hasData && user.data!.emailVerified) {
            return const bottomTabView();
          }
          else {
            return ChangeNotifierProvider<JoinOrLogin>.value(
              // 사용한다고만 알리는 역할
                value: JoinOrLogin(), // 오브젝트를 생성하여 전달
                child: loginView());
          }
        });
  }
}
