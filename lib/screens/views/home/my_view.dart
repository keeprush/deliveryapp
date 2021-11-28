import 'package:deliveryapp/databases/stores_provider.dart';
import 'package:deliveryapp/models/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../colors.dart';

class myView extends StatefulWidget {
  const myView({Key? key}) : super(key: key);

  @override
  my createState() => my();
}

class my extends State<myView> {
  late List<String> profilelist;
  StoreProvider sp = StoreProvider();

  @override
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      // <-  WillPopScope로 감싼다.
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: background_color,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              profileImage(context),
              userInfo(context),
              logoutbutton(context),
              //storePlus(context),
            ],
          ),
        ),
      ),
    );
  }
  Widget profileImage(BuildContext context) {
    return CircleAvatar(
      backgroundImage: AssetImage("images/profile.png"),
      backgroundColor: white_color,
      radius: 50,
    );
  }
  Widget userInfo(BuildContext context) {
    var user = Provider.of<UserData>(context, listen: true);
    return Column(
      children: [
        Text(
          '닉네임 : ${user.nickname}',
          //overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: white_color,
            fontSize: 16,
            fontFamily: 'fontnoto',
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          '주문수 : ${user.order_month_count}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: white_color,
            fontSize: 16,
            fontFamily: 'fontnoto',
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          '이번달 등급 : ${user.order_month_count>=5?'주문괴물':user.order_month_count>=4?'주문천재':user.order_month_count>=3?'주문더해':user.order_month_count>=1?'너무적어':'병아리'}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: white_color,
            fontSize: 16,
            fontFamily: 'fontnoto',
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );

  }
  Widget logoutbutton(BuildContext context) {
    double num = MediaQuery.of(context).size.width;
    double num2 = MediaQuery.of(context).size.height;
    return Container(
      width: num * 0.40,
      height: num2 * 0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
        color: white_color,
      ),
      child: OutlineButton(
        onPressed: () => {
          signOut(),
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        borderSide: BorderSide(
          color: on_color,
        ),
        child: Row(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.logout, size: 40.0, color: on_color),
            ),
            Container(
              width: num * 0.05,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "로그아웃",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'fontnoto',
                  fontWeight: FontWeight.w700,
                  color: on_color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();

    ///await GoogleSignIn().signOut();
  }

  // 상점 늘리기용

  Widget storePlus(BuildContext context) {
    double num = MediaQuery.of(context).size.width;
    double num2 = MediaQuery.of(context).size.height;
    return Container(
      width: num * 0.40,
      height: num2 * 0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
        color: white_color,
      ),
      child: OutlineButton(
        onPressed: () => {
          sp.addStores(),
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        borderSide: BorderSide(
          color: on_color,
        ),
        child: Row(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.logout, size: 40.0, color: on_color),
            ),
            Container(
              width: num * 0.05,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "상점추가",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'fontnoto',
                  fontWeight: FontWeight.w700,
                  color: on_color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
