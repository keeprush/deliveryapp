import 'package:deliveryapp/colors.dart';
import 'package:deliveryapp/databases/users_provider.dart';
import 'package:deliveryapp/models/menus.dart';
import 'package:deliveryapp/models/stores.dart';
import 'package:deliveryapp/models/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// 프로바이더
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class menuDetail extends StatefulWidget {
  @override
  menuDetailState createState() => menuDetailState();
}

class menuDetailState extends State<menuDetail> {
  @override
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    List<MenuData> cart = Provider.of<List<MenuData>>(context, listen: true);
    UserData user = Provider.of<UserData>(context, listen: false);
    var order_price = 0;
    cart.forEach((element) {
      order_price += element.price;
    });
    List<StoreData> store_info = Provider.of<List<StoreData>>(context, listen: false);
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: background_color,
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(45.0),
            child: AppBar(
              centerTitle: true,
              title: Text(
                '장바구니',
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
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              elevation: 0,
            ),
          ),
          body: SingleChildScrollView(
            child: Cart(context),
          ),
        ),
        Positioned(
          bottom: 70,
          left:0,
          width:MediaQuery.of(context).size.width * 1.0,
          //height:MediaQuery.of(context).size.height * 1.0,
          child:
          Container(
    padding:EdgeInsets.all(16),
          child:Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:<Widget>[
                  Text(
                    '주문금액',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'fontnoto',
                      fontWeight: FontWeight.w500,
                      color: on_color,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    '${order_price}원',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'fontnoto',
                        fontWeight: FontWeight.w500,
                        color: on_color,
                        decoration: TextDecoration.none
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:<Widget>[
                  Text(
                    '배달팁',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'fontnoto',
                      fontWeight: FontWeight.w500,
                      color: on_color,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    '${store_info[0].delivery_fee}원',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'fontnoto',
                        fontWeight: FontWeight.w500,
                        color: on_color,
                        decoration: TextDecoration.none
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:<Widget>[
                  Text(
                    '결제금액(배달팁 + 주문금액)',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'fontnoto',
                      fontWeight: FontWeight.w900,
                      color: on_color,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    '${order_price + store_info[0].delivery_fee}원',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'fontnoto',
                        fontWeight: FontWeight.w900,
                        color: on_color,
                        decoration: TextDecoration.none
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
        ),
        Positioned(
          bottom: 0,
          left:0,
          width:MediaQuery.of(context).size.width * 1.0,
          child: FlatButton(
            height:60,
          color:on_color,
              child: Text(
                '배달 주문하기',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'fontnoto',
                  fontWeight: FontWeight.w900,
                  color: white_color,
                ),
              ),
              onPressed: () async {
              //TODO
                // 장바구니에 아무 것도 없다는 뜻
                if(store_info[0].store_name==''){
                  EasyLoading.showToast('주문이 불가합니다.',dismissOnTap: true, maskType: EasyLoadingMaskType.custom,toastPosition:EasyLoadingToastPosition.center);
                }
                else {
                  List temp = [];
                  //Map<String, dynamic>
                  cart.forEach((c) {
                    temp.add({'name': c.name, 'price':c.price, 'count':c.count});
                  });
                  Map<String, dynamic> data = {
                    'user_uid': FirebaseAuth.instance.currentUser!.uid,
                    'store_name': store_info[0].store_name,
                    'user_location': '서울특별시 성북구 동선동3가 98',
                    'user_location_detail': '101호',
                    'user_location_gps': user.location_gps,
                    'store_location' : store_info[0].location,
                    'store_location_detail' : store_info[0].location_detail,
                    'store_location_gps' : store_info[0].location_gps,
                    'delivery_time': store_info[0].delivery_time,
                    'date': Timestamp.now(),
                    'cart': temp,
                    'all_price':order_price + store_info[0].delivery_fee,
                    'order_status':'주문완료',
                  };
                  cart = [];
                  UserProvider.setOrders(
                      data, store_info[0].uid, store_info[0].date);
                  EasyLoading.showToast('주문이 완료되었습니다.',dismissOnTap: true, maskType: EasyLoadingMaskType.custom,toastPosition:EasyLoadingToastPosition.center);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  //Navigator.pop(context);
                }
              },
            ),
          ),
      ],
    );
  }

  Widget Cart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        menu_item_side(context),
      ],
    );
  }

  Widget menu_item_side(BuildContext context) {
    List<MenuData> cart = Provider.of<List<MenuData>>(context, listen: true);
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // Nonscroll
      padding: const EdgeInsets.all(16),
      itemCount: cart.length,
      itemBuilder: (BuildContext context, int i) {
        return InkWell(
          onTap: () async {},
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
            children:<Widget>[
                Text(
                  '${cart[i].name}',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'fontnoto',
                    fontWeight: FontWeight.w400,
                    color: white_color,
                  ),
                ),
                Text(
                  '${cart[i].price}원',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'fontnoto',
                    fontWeight: FontWeight.w400,
                    color: white_color,
                  ),
                ),
                ]
                ),
                Text(
                  '수량 : ${cart[i].count}',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'fontnoto',
                    fontWeight: FontWeight.w400,
                    color: white_color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
