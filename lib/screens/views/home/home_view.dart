import 'package:deliveryapp/screens/views/home/order_list/order_random/order_random_view.dart';
import 'package:deliveryapp/screens/views/home/store_list/character_sliver_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../colors.dart';

class homeView extends StatefulWidget {
  const  homeView({Key? key}) : super(key: key);
  @override
  home createState() => home();
}

class home extends State<homeView> {
  @override
  void initState() {super.initState();}
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(    // <-  WillPopScope로 감싼다.
      onWillPop: () {

        return Future(() => false);
      },
      child :Scaffold(
        backgroundColor:  background_color,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child:Column(
            children: <Widget>[
              first_main(context),
              second_main(context),
              random_order(context),
            ],
          ),
        ),
      ),
    );
  }
}
final List <String> imgList2 =[
  'images/공지사항.png',
  'images/공지사항.png',
  'images/공지사항.png',
];

Widget random_order(BuildContext context) {
  return Container(
      //padding:const EdgeInsets.only(top: 16),
    margin: const EdgeInsets.only(top:16.0),
    decoration: BoxDecoration(
      border: Border.all(
        width: 1,
        color: down_color,
      ),
    ),
    height:MediaQuery.of(context).size.height*0.06,
    width:MediaQuery.of(context).size.width*0.92,
    child:
    RaisedButton(
      highlightColor:background_color,
      highlightElevation:0.0,
      color: background_color,
        elevation:0.0,
      onPressed: () async {
        Navigator.push<Widget>(
          context,
          MaterialPageRoute(
            builder: (context) =>  orderRandomView(),
          ),);
      },
      child: Text(
        '랜덤 주문하기',
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'fontnoto',
          fontWeight: FontWeight.w700,
          color: white_color,
        ),
      ),
    ),
  );
}
// 공지사항
Widget first_main(BuildContext context){
  return Container(
      height : 150,
      child: Padding(
          padding : const EdgeInsets.all(0),
          child : Swiper(
            autoplay: true,
            pagination: const SwiperPagination() ,
            itemCount : imgList2.length,
            itemBuilder: (BuildContext context, int itemCount){
              return Image.asset(imgList2[itemCount],fit:BoxFit.fill);
            },
            viewportFraction: 1,
            scale: 0.8,

          )
      )

  );
}

final List<String> title = ['전체보기','한식/중식/일식','분식/치킨/피자','아시안/양식','족발/보쌈','카페/디저트','야식','프랜차이즈'];
final List <String> imgList =[
  'images/전체보기.jpg',
  'images/한식.jpg',
  'images/분식.jpg',
  'images/아시안.jpg',
  'images/족발.jpg',
  'images/카페.jpg',
  'images/야식.jpg',
  'images/프랜차이즈.jpg',
];

Widget second_main(BuildContext context){
  return GridView.builder(
        shrinkWrap: true,
      padding:const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 0),
      physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 20),
        itemCount: title.length,
        itemBuilder: (BuildContext ctx, index) {
          return InkWell(
              onTap: () async {
                Navigator.push<Widget>(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  VideoList(index: index),
                  ),);
                print(index);
              },
            child:Container(
            width:200,
            height:70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: background_color,
                border: Border.all(
                  width: 1,
                  color: down_color,
                ),
                borderRadius: BorderRadius.circular(0)),
            child:
            Column(
                mainAxisAlignment:MainAxisAlignment.spaceAround,
                children: <Widget>[
            ClipOval(
            child:Image.asset(imgList[index],fit:BoxFit.fill,width:51, height:51),
            ),
                  Text(
                    title[index],
                    style:  TextStyle(
                      color: white_color,
                      fontSize:9,
                      fontFamily: 'fontnoto',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
            ],
            ),
          ));
        });
}
// 최근 영상 이미지