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
import 'package:deliveryapp/databases/stores_provider.dart';
// 프로바이더
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class orderRandomView extends StatefulWidget {
  @override
  orderRandomState createState() => orderRandomState();
}

class orderRandomState extends State<orderRandomView> {
  final order_price_list = ['10000', '20000', '30000','40000', '50000', '60000', '70000', '80000', '90000', '100000'];
  var selected_order_price = '10000';
  final review_star_list = ['4.0', '4.1', '4.2', '4.3', '4.4', '4.5', '4.6', '4.7', '4.8', '4.9', '5.0'];
  var selected_review_star = '4.0';
  final delivery_fee_list = ['0', '1000', '2000','3000','4000','5000'];
  var selected_delivery_fee = '0';

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
    List<MenuData> cart = Provider.of<List<MenuData>>(context, listen: false);
    UserData user = Provider.of<UserData>(context, listen: false);
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
                '랜덤주문',
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
          body: Container(
              padding:EdgeInsets.all(16),
              child:Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:<Widget>[
                      Text(
                        '주문 금액 (만원 단위로 선택)',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'fontnoto',
                          fontWeight: FontWeight.w500,
                          color: on_color,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      //TODO
                      dropDownList('selected_order_price',selected_order_price,order_price_list),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:<Widget>[
                      Text(
                        '리뷰 별점 (선택한 별점 이상)',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'fontnoto',
                          fontWeight: FontWeight.w500,
                          color: on_color,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      dropDownList('selected_review_star',selected_review_star,review_star_list),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:<Widget>[
                      Text(
                        '배달팁 (선택한 배달팁 이하)',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'fontnoto',
                          fontWeight: FontWeight.w500,
                          color: on_color,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      dropDownList('selected_delivery_fee',selected_delivery_fee,delivery_fee_list),
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
              '랜덤 주문하기',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'fontnoto',
                fontWeight: FontWeight.w900,
                color: white_color,
              ),
            ),
            onPressed: () async {
              /*
             가게들의 리스트 중 사용자가 설정한 가격대에 랜덤한 주문을 할 수 있도록 올려놨고 배달팁도 설정한 대로
             사용자가 설정한 리뷰 별점 이상의 가게를 가져온다. 만약 없다면 불가능하다고 !
             그 중에 랜덤하게 주문하기. 만약 없다면 설정된 가게는 없다고 출력하기
             */
              /*
              실 기능에서는 가장 가까운 드론의 위치로 배달 예정시간 알아볼 수 있도록 설정하기
               */
              var temp = await StoreProvider.getStore(int.parse(selected_order_price),double.parse(selected_review_star),int.parse(selected_delivery_fee));
              //TODO
              if(temp==null){
                EasyLoading.showToast('주문이 불가합니다.',dismissOnTap: true, maskType: EasyLoadingMaskType.custom,toastPosition:EasyLoadingToastPosition.center);
              }
              else {
                //Map<String, dynamic>
                Map<String, dynamic> data = {
                  'user_uid': FirebaseAuth.instance.currentUser!.uid,
                  'store_name': temp[0].store_name,
                  'user_location': '서울특별시 성북구 동선동3가 98',
                  'user_location_detail': '101호',
                  'user_location_gps': user.location_gps,
                  'store_location' : temp[0].location,
                  'store_location_detail' : temp[0].location_detail,
                  'store_location_gps' : temp[0].location_gps,
                  'delivery_time': temp[0].delivery_time,
                  'date': Timestamp.now(),
                  'cart': [{'name':temp[1].names,'price':temp[1].price}],
                  'all_price':int.parse(selected_order_price) + temp[0].delivery_fee,
                  'order_status':'주문완료',
                };
                print(data);
                cart = [];
                UserProvider.setOrders(
                    data, temp[0].uid, temp[0].date);
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
  Widget dropDownList(String selected,String selected_value, List<String> list) {
    return DropdownButton(
      autofocus:true,
        alignment:Alignment.centerRight,
      style: TextStyle(color: on_color),
      dropdownColor:background_color,
      value: selected_value,
      items: list.map(
            (value) {
          return DropdownMenuItem (
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
      onChanged: (value) {
        setState(() {
          if(selected.compareTo('selected_order_price')==0)
            selected_order_price = value.toString();
          else if(selected.compareTo('selected_review_star')==0)
            selected_review_star = value.toString();
          else if(selected.compareTo('selected_delivery_fee')==0)
            selected_delivery_fee = value.toString();

        });
      },
    );
  }

}
