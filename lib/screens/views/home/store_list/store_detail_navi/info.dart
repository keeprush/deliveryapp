import 'package:deliveryapp/colors.dart';
import 'package:deliveryapp/models/stores.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget info(BuildContext context, StoreData stores){
  //var posts = Provider.of<List<PostData>>(context);
  var list = [];
  var img_url = '';
  return Column(
    children: [
      Container(
          alignment:Alignment.topLeft,
          padding: const EdgeInsets.only(left:16, top:20),
          child:Text(
            '사장님 안내사항',
            style: TextStyle(
              color: white_color,
              fontFamily: 'fontnoto',
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          )
      ),
      Container(
          alignment:Alignment.topLeft,
          padding: const EdgeInsets.only(left:16, top:8),
          child:Text(
            '${stores.store_notice}',
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
            '가게 통계',
            style: TextStyle(
              color: white_color,
              fontFamily: 'fontnoto',
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          )
      ),
      Container(
          alignment:Alignment.topLeft,
          padding: const EdgeInsets.only(left:16, top:8),
          child:Text(
            '총 주문 수 : ${stores.order_count}',
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
          padding: const EdgeInsets.only(left:16, top:8),
          child:Text(
            '전체 리뷰 수 : ${stores.review_count}',
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
          padding: const EdgeInsets.only(left:16, top:8),
          child:Text(
            '찜 : ${stores.steamed_count}',
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
            '음식점 정보',
            style: TextStyle(
              color: white_color,
              fontFamily: 'fontnoto',
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          )
      ),
      Container(
          alignment:Alignment.topLeft,
          padding: const EdgeInsets.only(left:16,top:8),
          child:Text(
            '운영시간 : ${stores.operation_time}',
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
          padding: const EdgeInsets.only(left:16,top:8),
          child:Text(
            '휴무일 : ${stores.no_operation_time}',
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
          padding: const EdgeInsets.only(left:16, top:8),
          child:Text(
            '전화번호 : ${stores.phone_number}',
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
          padding: const EdgeInsets.only(left:16,top:8),
          child:Text(
            '배달가능지역 : ${stores.possible_delivery}',
            style: TextStyle(
              color: white_color,
              fontFamily: 'fontnoto',
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          )
      ),

    ],

  );
}

