import 'package:deliveryapp/colors.dart';
import 'package:deliveryapp/models/orders.dart';
import 'package:deliveryapp/models/stores.dart';
import 'package:deliveryapp/screens/views/home/order_list/order_detail/write_review.dart';
import 'package:deliveryapp/screens/views/home/store_list/character_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import 'order_detail/check_order.dart';
import 'order_detail/order_status.dart';

class ordersListItem extends StatefulWidget {
  const ordersListItem({
    required this.stores,
    required this.orders,
    Key? key,
  }) : super(key: key);
  final StoreData stores;
  final OrderData orders;

  @override
  State<ordersListItem> createState() => orderListItemState();
}

class orderListItemState extends State<ordersListItem> {
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () async {
          Navigator.push<Widget>(
            context,
            MaterialPageRoute(
              builder: (context) => storeDetail(stores: widget.stores),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                //crossAxisAlignment:CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(widget.stores.store_img,
                        width: 80, height: 80, fit: BoxFit.fill),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(widget.stores.store_name,
                            style: TextStyle(
                              color: white_color,
                              fontSize: 18,
                              fontFamily: 'fontnoto',
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1),
                      ),
                      Row(children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 8.0),
                          child:
                              Icon(Icons.star, size: 12, color: Colors.yellow),
                        ),
                        Container(
                          child: Text(widget.stores.star.toStringAsFixed(1),
                              style: TextStyle(
                                color: white_color,
                                fontSize: 12,
                                fontFamily: 'fontnoto',
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                              '리뷰수 : ${widget.stores.review_count.toString()}',
                              style: TextStyle(
                                color: white_color,
                                fontSize: 12,
                                fontFamily: 'fontnoto',
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1),
                        ),
                      ]),
                      Container(
                        padding: const EdgeInsets.only(top: 5.0, left: 8.0),
                        child: Text(
                            '배달팁 : ${widget.stores.delivery_fee.toString()}원',
                            style: TextStyle(
                              color: white_color,
                              fontSize: 12,
                              fontFamily: 'fontnoto',
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 5.0, left: 8.0),
                        child: Text('주문상태: ${widget.orders.order_status}',
                            style: TextStyle(
                              color: white_color,
                              fontSize: 12,
                              fontFamily: 'fontnoto',
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    padding:EdgeInsets.only(top:8),
                    height: 28,
                    child: FlatButton(
                      color: on_color,
                     // height: 25,
                      child: Text(
                        '주문확인',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'fontnoto',
                          fontWeight: FontWeight.w500,
                          color: white_color,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.push<Widget>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  checkOrder(orders: widget.orders,),
                          ),);

                      },
                    ),
                  ),
                  Container(
                    height: 28,
                    padding:EdgeInsets.only(top:8),
                    child: FlatButton(
                      color: on_color,
                      //height: 28,
                      child: Text(
                        '리뷰쓰기',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'fontnoto',
                          fontWeight: FontWeight.w500,
                          color: white_color,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.push<Widget>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  writeReview(stores: widget.stores,),
                          ),);

                      },
                    ),
                  ),
                  Container(
                    height: 28,
                    padding:EdgeInsets.only(top:8),
                    child: FlatButton(
                      color: on_color,
                      //height: 25,
                      child: Text(
                        '배달현황',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'fontnoto',
                          fontWeight: FontWeight.w500,
                          color: white_color,
                        ),
                      ),
                      onPressed: () async {
                        // 이미 배달이 완료된 주문입니다. ( 배달 완료 시! )
                        Navigator.push<Widget>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  orderStatus(orders: widget.orders,),
                          ),);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
