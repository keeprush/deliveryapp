import 'package:deliveryapp/colors.dart';
import 'package:deliveryapp/models/stores.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import 'character_detail.dart';

class storesListItem extends StatefulWidget {
  const storesListItem({
    required this.stores,
    Key? key,
  }) : super(key: key);
  final StoreData stores;

  @override
  State<storesListItem> createState() => _storesListItemState();
}

class _storesListItemState extends State<storesListItem> {
  @override
  Widget build(BuildContext context) =>
      InkWell(
      onTap: () async {

        Navigator.push<Widget>(
          context,
          MaterialPageRoute(
            builder: (context) =>  storeDetail(stores: widget.stores),
          ),);
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:
        Row(
          //crossAxisAlignment:CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
          borderRadius:BorderRadius.circular(50),

            child:Image.network(widget.stores.store_img,width: 80, height:80,fit:BoxFit.fill),
            ),
        Column(
          mainAxisAlignment:MainAxisAlignment.start,
            crossAxisAlignment:CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding:  const EdgeInsets.only(left:8.0),
              child: Text(widget.stores.store_name ,style: TextStyle(color: white_color, fontSize: 18, fontFamily: 'fontnoto', fontWeight: FontWeight.w700,),maxLines:1),
            ),
            Row(
            children: <Widget>[
              Container(
                padding:  const EdgeInsets.only(left:8.0),
                child: Icon(Icons.star,size: 12,color:  Colors.yellow),
              ),
              Container(
                child: Text(widget.stores.star.toStringAsFixed(1) ,style: TextStyle(color: white_color, fontSize: 12, fontFamily: 'fontnoto', fontWeight: FontWeight.w400,),maxLines:1),
              ),
              Container(
                padding:  const EdgeInsets.only(left:8.0),
                child: Text('리뷰수 : ${widget.stores.review_count.toString()}' ,style: TextStyle(color: white_color, fontSize: 12, fontFamily: 'fontnoto', fontWeight: FontWeight.w400,),maxLines:1),
              ),
            ]
            ),
            Container(
              padding:  const EdgeInsets.only(top:5.0,left:8.0),
              child: Text('배달팁 : ${widget.stores.delivery_fee.toString()}원' ,style: TextStyle(color: white_color, fontSize: 12, fontFamily: 'fontnoto', fontWeight: FontWeight.w400,),maxLines:1),
            ),

          ],
        ),
        ],
      ),
      ),
  );
}