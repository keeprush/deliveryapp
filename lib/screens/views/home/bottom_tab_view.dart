import 'package:deliveryapp/colors.dart';
import 'package:deliveryapp/databases/users_provider.dart';
import 'package:deliveryapp/screens/views/first/set_up_nickname.dart';
import 'package:flutter/material.dart';
import 'package:deliveryapp/screens/views/home/home_view.dart';
import 'package:deliveryapp/screens/views/home/my_view.dart';
import 'package:deliveryapp/screens/views/home/order_list/order_list_view.dart';
import 'package:deliveryapp/screens/views/home/steamed_view.dart';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
bottomTab home_state = bottomTab();

class bottomTabView extends StatefulWidget {
  const bottomTabView({Key? key}) : super(key: key);

  @override
  bottomTab createState() => bottomTab();
}

class bottomTab extends State<bottomTabView> {

  int currentIndex = 0;
  late final List<Widget> _children = [
    homeView(), // 홈
    steamedView(), // 찜
    ordersListView(), // 주문내역
    myView(), // 홈
  ];
  final List<String> _title = [
    "홈",
    "찜",
    "주문목록",
    "my_view",
  ];
  is_first() async {
    UserProvider db = UserProvider();
    var res = await db.isFirst();
    if (!res) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const setUpNicknameView()));
      });
    }
  }
  //GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  void onTap_page(int index) {
    setState(() {
      currentIndex = index;
    });
  }
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
        () async {
      // 처음이라면 유저 정보 입력
          await is_first();
      EasyLoading.dismiss();
    }();
  }

  Widget build(BuildContext context) {
    return WillPopScope(    // <-  WillPopScope로 감싼다.
      onWillPop: () {

        return Future(() => false);
      },
      child : Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(42.0),
          child: AppBar(
          // 주소 띄우는 화면
            centerTitle: true,
            title: Text(
              _title[currentIndex],
              style:  TextStyle(
                color: white_color,
                fontFamily: 'fontnoto',
                fontWeight: FontWeight.w900,
              ),
            ),
            backgroundColor: background_color,
            automaticallyImplyLeading: false,
            elevation: 0,
          ),
        ),
        body: _children[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          //key:,
          type: BottomNavigationBarType.fixed,
          onTap: onTap_page,
          currentIndex: currentIndex,
          //fixedColor: Colors.black,
          selectedItemColor: on_color,
          unselectedItemColor: down_color,
          backgroundColor: common_color,

          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.home),
              title: Text(
                '홈',
                style: TextStyle(
                  fontFamily: 'fontnoto', fontWeight: FontWeight.w700,
                  color: down_color,

                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text(
                '찜',
                style: TextStyle(
                  color: down_color,
                  fontFamily: 'fontnoto', fontWeight: FontWeight.w700,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              title: Text(
                '주문내역',
                style: TextStyle(
                  color: down_color,
                  fontFamily: 'fontnoto', fontWeight: FontWeight.w700,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_turned_in),
              title: Text(
                'My',
                style: TextStyle(
                  color: down_color,
                  fontFamily: 'fontnoto', fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
