import 'package:deliveryapp/colors.dart';
import 'package:deliveryapp/models/orders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class checkOrder extends StatefulWidget {
  final OrderData orders;

  const checkOrder({
    required this.orders,
    Key? key,
  }) : super(key: key);

  @override
  order createState() => order();
}

class order extends State<checkOrder> {

  Widget main(BuildContext context){
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(    // <-  WillPopScope로 감싼다.
      onWillPop: () {
        return Future(() => false);
      },
      child : Scaffold(
        backgroundColor: background_color,
        //resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45.0),
          child: AppBar(
            centerTitle: true,
            title: Text(
              "주문내역",
              style: TextStyle(
                color: white_color,
                fontFamily: 'fontnoto',
                fontWeight: FontWeight.w700,
              ),
            ),
            backgroundColor: background_color,
            iconTheme: IconThemeData(
              color: white_color, //change your color here
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            elevation: 0,
          ),
        ),
        ///resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
      child:Column(
      children: [
        Container(
            alignment:Alignment.topLeft,
            padding: const EdgeInsets.only(left:16, top:20),
            child:Text(
              '가게이름',
              style: TextStyle(
                color: on_color,
                fontFamily: 'fontnoto',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            )
        ),
        Container(
            alignment:Alignment.topLeft,
            padding: const EdgeInsets.only(left:16, top:8),
            child:Text(
              '${widget.orders.store_name}',
              style: TextStyle(
                color: white_color,
                fontFamily: 'fontnoto',
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            )
        ),
        Container(
            alignment:Alignment.topLeft,
            padding: const EdgeInsets.only(left:16, top:20),
            child:Text(
              '주문내역',
              style: TextStyle(
                color: on_color,
                fontFamily: 'fontnoto',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            )
        ),
        for(var item in widget.orders.cart)
          Container(
            padding: EdgeInsets.only(top:8, left:16,right:16),
        child:
          Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child:Text(
                    '${item['name'].toString().replaceAll(RegExp('[\\[\\[\\]]'), '')}',
                    style: TextStyle(
                      color: white_color,
                      fontFamily: 'fontnoto',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  )
              ),
              Container(
                  child:
                  item['count']!=null?
                  Text(
                    '수량 : ${item['count']} 금액 : ${item['price']}원',
                    style: TextStyle(
                      color: white_color,
                      fontFamily: 'fontnoto',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ):
                  Text(
                    '랜덤주문 금액 : ${item['price']}원',
                    style: TextStyle(
                      color: white_color,
                      fontFamily: 'fontnoto',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  )
              ),
            ],
          ),
          ),
        Container(
            alignment:Alignment.topLeft,
            padding: const EdgeInsets.only(left:16, top:20),
            child:Text(
              '합계금액(결제금액)',
              style: TextStyle(
                color: on_color,
                fontFamily: 'fontnoto',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            )
        ),

        Container(
            alignment:Alignment.topLeft,
            padding: const EdgeInsets.only(left:16, top:8),
            child:Text(
              '${widget.orders.all_price}원',
              style: TextStyle(
                color: white_color,
                fontFamily: 'fontnoto',
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            )
        ),

        Container(
            alignment:Alignment.topLeft,
            padding: const EdgeInsets.only(left:16, top:20),
            child:Text(
              '주문상태',
              style: TextStyle(
                color: on_color,
                fontFamily: 'fontnoto',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            )
        ),
        Container(
            alignment:Alignment.topLeft,
            padding: const EdgeInsets.only(left:16, top:8),
            child:Text(
              '${widget.orders.order_status}',
              style: TextStyle(
                color: white_color,
                fontFamily: 'fontnoto',
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            )
        ),
        Container(
            alignment:Alignment.topLeft,
            padding: const EdgeInsets.only(left:16, top:20),
            child:Text(
              '주문시간',
              style: TextStyle(
                color: on_color,
                fontFamily: 'fontnoto',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            )
        ),
        Container(
            alignment:Alignment.topLeft,
            padding: const EdgeInsets.only(left:16, top:8),
            child:Text(
              DateFormat('yyyy년 MM월 dd일 kk시 mm분 ss초').format(
                  DateTime.fromMillisecondsSinceEpoch(
                      widget.orders.date.seconds * 1000)
                      .add(Duration(hours: 9))),
              style: TextStyle(
                color: white_color,
                fontFamily: 'fontnoto',
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            )
        ),


      ],
    ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return main(context);
  }
}