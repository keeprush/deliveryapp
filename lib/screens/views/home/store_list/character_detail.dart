import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryapp/colors.dart';
import 'package:deliveryapp/databases/users_provider.dart';
import 'package:deliveryapp/models/stores.dart';
import 'package:deliveryapp/screens/views/home/store_list/store_detail_navi/info.dart';
import 'package:deliveryapp/screens/views/home/store_list/store_detail_navi/info.dart';
import 'package:deliveryapp/screens/views/home/store_list/store_detail_navi/menu.dart';
import 'package:deliveryapp/screens/views/home/store_list/store_detail_navi/menu_detail.dart';
import 'package:deliveryapp/screens/views/home/store_list/store_detail_navi/review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:tiled_tab_indicator/tiled_tab_indicator.dart';

class storeDetail extends StatefulWidget {
  final StoreData stores;

  const storeDetail({
    required this.stores,
    Key? key,
  }) : super(key: key);

  @override
  _Character_detail createState() => _Character_detail();
}

class _Character_detail extends State<storeDetail> {
  bool is_in_liked_list = false;
  int index = 0;

  @override
  void initState() {
    super.initState();
    get_is_in_liked_list();
  }

  get_is_in_liked_list() async {
    bool _is_in_liked_list =
        await UserProvider.isLiked(widget.stores.store_name);
    if (mounted) {
      setState(() {
        is_in_liked_list = _is_in_liked_list;
      });
    }
  }

  @override
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: background_color,
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(45.0),
              child: AppBar(
                centerTitle: true,
                title: Text(
                  '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: white_color,
                    fontSize: 17,
                    fontFamily: 'fontnoto',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                backgroundColor: background_color,
                automaticallyImplyLeading: false,
                iconTheme: IconThemeData(
                  color: white_color, //change your color here
                ),
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: white_color,
                    ),
                    //TODO
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                actions: [
                  IconButton(
                      icon: is_in_liked_list
                          ? Icon(Icons.favorite, color: on_color)
                          : Icon(Icons.favorite, color: down_color),
                      onPressed: () {
                        var data = {
                          'store_name': widget.stores.store_name,
                          'date': widget.stores.date,
                          'store_uid': widget.stores.uid,
                        };
                        if (is_in_liked_list) {
                          EasyLoading.showToast('로딩중',
                              dismissOnTap: false,
                              maskType: EasyLoadingMaskType.custom,
                              toastPosition: EasyLoadingToastPosition.center);
                          UserProvider.removeLikedList(data);
                          setState(() {
                            is_in_liked_list = false;
                            widget.stores.steamed_count -= 1;
                          });
                          EasyLoading.dismiss();
                        } else {
                          EasyLoading.showToast('로딩중',
                              dismissOnTap: false,
                              maskType: EasyLoadingMaskType.custom,
                              toastPosition: EasyLoadingToastPosition.center);
                          UserProvider.addLikedList(data);
                          setState(() {
                            is_in_liked_list = true;
                            widget.stores.steamed_count += 1;
                          });
                          EasyLoading.dismiss();
                        }
                      }),
                ],
                elevation: 0,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.stores.store_name,
                      maxLines: 1,
                      style: TextStyle(
                        color: on_color,
                        fontFamily: 'fontnoto',
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.only(left: 0),
                          child: Text(
                            '총 주문 수 : ${widget.stores.order_count.toString()}',
                            style: TextStyle(
                              color: white_color,
                              fontFamily: 'fontnoto',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                      Container(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            '찜 수 : ${widget.stores.steamed_count.toString()}',
                            style: TextStyle(
                              color: white_color,
                              fontFamily: 'fontnoto',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                      Container(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            '리뷰 수 : ${widget.stores.review_count.toString()}',
                            style: TextStyle(
                              color: white_color,
                              fontFamily: 'fontnoto',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                    ],
                  ),
                  Container(
                    color: on_color,
                    height: 2,
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(top: 8, left: 16),
                      child: Text(
                        '최소주문금액 : ${widget.stores.at_least_money.toString()}원',
                        style: TextStyle(
                          color: white_color,
                          fontFamily: 'fontnoto',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        '배달팁 : ${widget.stores.delivery_fee.toString()}원',
                        style: TextStyle(
                          color: white_color,
                          fontFamily: 'fontnoto',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 16, bottom: 30),
                      child: Text(
                        '배달 시간 : ${widget.stores.delivery_time[0].toString()}~${widget.stores.delivery_time[1].toString()}분',
                        style: TextStyle(
                          color: white_color,
                          fontFamily: 'fontnoto',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  SizedBox(
                    height: 40,
                    child: TabBar(
                      tabs: [
                        Text('메뉴', style: TextStyle(color: white_color)),
                        Text('정보', style: TextStyle(color: white_color)),
                        Text('리뷰', style: TextStyle(color: white_color)),
                      ],
                      onTap: (int i) async {
                        setState(() {
                          index = i;
                        });
                      },
                      //indicator: ContainerTabIndicator(),
                      indicatorWeight: 3.0,
                      indicatorColor: on_color,
                    ),
                  ),
                  index == 0
                      ? menu(stores: widget.stores)
                      : index == 1
                          ? info(context, widget.stores)
                          : review(stores: widget.stores),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 70,
            right: 16,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
                color: white_color,
              ),
              child: IconButton(
                icon: const Icon(Icons.add_shopping_cart,
                    color: Color(0xffBB86FC), size: 40),
                onPressed: () => Navigator.push<Widget>(
                  context,
                  MaterialPageRoute(builder: (context) => menuDetail()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
