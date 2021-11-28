import 'package:deliveryapp/colors.dart';
import 'package:deliveryapp/databases/replys_provider.dart';
import 'package:deliveryapp/models/orders.dart';
import 'package:deliveryapp/models/stores.dart';
import 'package:deliveryapp/models/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// 프로바이더
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
class writeReview extends StatefulWidget {
  final StoreData stores;

  const writeReview({
    required this.stores,
    Key? key,
  }) : super(key: key);

  @override
  writeReviewState createState() => writeReviewState();
}

class writeReviewState extends State<writeReview> {
  final TextEditingController _textController = new TextEditingController();
  int star = 1;

  @override
  Widget build(BuildContext context) {
    return main(context);
  }

  Widget main(BuildContext context){
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(    // <-  WillPopScope로 감싼다.
      onWillPop: () {
        return Future(() => false);
      },
      child :
      GestureDetector(
      onTap: () {
      FocusScope.of(context).unfocus();
      },
    child:Stack(
        children: [
      Scaffold(
        backgroundColor: background_color,
        //resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45.0),
          child: AppBar(
            centerTitle: true,
            title: Text(
              "리뷰쓰기",
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
        body: replyInput(context),

        ),
          Positioned(
            bottom: 0,
            left:0,
            width:MediaQuery.of(context).size.width * 1.0,
            child: FlatButton(
              height:60,
              color:on_color,
              child: Text(
                '리뷰 작성',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'fontnoto',
                  fontWeight: FontWeight.w900,
                  color: white_color,
                ),
              ),
              onPressed: () async {
                setReply(_textController.text);
              },
            ),
          ),
      ],
    ),
      ),
    );
  }

  Widget replyInput(BuildContext context) {
    var user = Provider.of<UserData>(context, listen: false);
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(height:16),
          Text(
            "별점을 선택하세요",
            style: TextStyle(
              fontSize: 20,
              color: on_color,
              fontFamily: 'fontnoto',
              fontWeight: FontWeight.w700,
            ),
          ),
          star_view_star(context),
            TextField(
              controller: _textController,
              minLines: 8,
              maxLines: 12,
              //onSubmitted: setReply,
              style: TextStyle(
                color: white_color,
                fontSize: 20,
                fontFamily: 'fontnoto',
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                labelText: '입력',
                labelStyle: TextStyle(
                  color: white_color,
                ),
                hoverColor: on_color,
                focusColor: color_red1,
                hintText: "메세지를 입력하세요.",
                hintStyle: TextStyle(
                  color: white_color,
                ),
                contentPadding: const EdgeInsets.all(16.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: on_color, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: on_color, width: 3.0),
                ),
              ),
            ),
        ],
      ),
    );
  }
  Widget star_view_star(BuildContext context) {
    return Row(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: <Widget>[
      IconButton(
        padding: const EdgeInsets.all(0.0),
        iconSize: 20,
        icon: Icon(Icons.star, size: 20, color: Colors.yellow),
        onPressed: () => setState(() {
          star = 1;
        }),
      ),
      IconButton(
        padding: const EdgeInsets.all(0.0),
        iconSize: 20,
        icon: star>=2 ? Icon(Icons.star, size: 20, color: Colors.yellow) : Icon(Icons.star, size: 25, color: down_color),
        onPressed: () => setState(() {
          star = 2;
        }),
      ),
      IconButton(
        padding: const EdgeInsets.all(0.0),
        iconSize: 20,
        icon: star>=3 ? Icon(Icons.star, size: 20, color: Colors.yellow) : Icon(Icons.star, size: 25, color: down_color),
        onPressed: () => setState(() {
          star = 3;
        }),
      ),
      IconButton(
        padding: const EdgeInsets.all(0.0),
        iconSize: 20,
        icon: star>=4 ? Icon(Icons.star, size: 20, color: Colors.yellow) : Icon(Icons.star, size: 25, color: down_color),
        onPressed: () => setState(() {
          star = 4;
        }),
      ),
      IconButton(
        padding: const EdgeInsets.all(0.0),
        iconSize: 20,
        icon: star>=5 ? Icon(Icons.star, size: 20, color: Colors.yellow) : Icon(Icons.star, size: 25, color: down_color),
        onPressed: () => setState(() {
          star = 5;
        }),
      ),
    ]);
  }

  // 만약 크리에이티드 데이트랑 수정된 날짜랑 일치 X 시 수정됨 표시.
  void setReply(String text) {
    // 댓글 보내기
    UserData user = Provider.of<UserData>(context, listen: false);

    //create, update, delete : Datetime now
    Timestamp time = Timestamp.fromDate(DateTime.now());

    Map<String, dynamic> data = {
      'store_uid': widget.stores.uid,
      'date': widget.stores.date,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'nickname': user.nickname,
      'bundle_id': time,
      'bundle_order': time,
      'is_deleted': false,
      'reply': text,
      'star_count': star,
      'depth': 0,
      'created_date': time,
      'updated_date': time,
      'deleted_date': time
    };
    ReplyProvider.setReply(data);

    _textController.clear();
    FocusScope.of(context).unfocus();
    EasyLoading.showToast('리뷰 작성이 완료되었습니다.',
        dismissOnTap: true,
        maskType: EasyLoadingMaskType.custom,
        toastPosition: EasyLoadingToastPosition.center);
    Navigator.pop(context);
  }
}