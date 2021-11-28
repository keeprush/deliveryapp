import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryapp/databases/replys_provider.dart';
import 'package:deliveryapp/models/stores.dart';
import 'package:deliveryapp/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../colors.dart';

class review extends StatefulWidget {
  final StoreData stores;

  const review({
    required this.stores,
    Key? key,
  }) : super(key: key);

  @override
  reviewState createState() => reviewState();
}

class reviewState extends State<review> {
  final TextEditingController _textController = new TextEditingController();
  final TextEditingController _textController2 = new TextEditingController();
  final TextEditingController _textController3 = new TextEditingController();
  int is_reply_index = -1;
  int is_fix_index = -1;
  int reply_number = 0;
  ReplyProvider rp = ReplyProvider();
  List<int> scores = [0, 0, 0, 0, 0];

  @override
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    get_star();
  }

  get_star() async {
    List<int> _scores = await rp.getStarCounts(
        {'store_uid': widget.stores.uid, 'date': widget.stores.date});

    if (mounted) {
      setState(() {
        scores = _scores;
      });
    }
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            star_view(context),
            group(context),
            //replyInput(context),
          ],
        ),
      ),
    );
  }

  Widget star_view(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 16.0, right: 16.0, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                '${widget.stores.star.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 30,
                  color: white_color,
                  fontFamily: 'fontnoto',
                  fontWeight: FontWeight.w700,
                ),
              ),
              //TODO
              Container(height: 10),
              star_view_star(context, widget.stores.star),
            ],
          ),
          Column(
            children: [
              Text(
                '5점 : ${scores[4]}',
                style: TextStyle(
                  color: white_color,
                  fontSize: 12,
                ),
              ),
              Text(
                '4점 : ${scores[3]}',
                style: TextStyle(
                  color: white_color,
                  fontSize: 12,
                ),
              ),
              Text(
                '3점 : ${scores[2]}',
                style: TextStyle(
                  color: white_color,
                  fontSize: 12,
                ),
              ),
              Text(
                '2점 : ${scores[1]}',
                style: TextStyle(
                  color: white_color,
                  fontSize: 12,
                ),
              ),
              Text(
                '1점 : ${scores[0]}',
                style: TextStyle(
                  color: white_color,
                  fontSize: 12,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget star_view_star(BuildContext context, double star) {
    return star <= 0.5
        ? Row(children: <Widget>[
            Icon(Icons.star, size: 12.5, color: down_color),
            Icon(Icons.star, size: 12.5, color: down_color),
            Icon(Icons.star, size: 12.5, color: down_color),
            Icon(Icons.star, size: 12.5, color: down_color),
            Icon(Icons.star, size: 12.5, color: down_color),
          ])
        : star <= 1.5
            ? Row(children: <Widget>[
                Icon(Icons.star, size: 12.5, color: Colors.yellow),
                Icon(Icons.star, size: 12.5, color: down_color),
                Icon(Icons.star, size: 12.5, color: down_color),
                Icon(Icons.star, size: 12.5, color: down_color),
                Icon(Icons.star, size: 12.5, color: down_color),
              ])
            : star <= 2.5
                ? Row(children: <Widget>[
                    Icon(Icons.star, size: 12.5, color: Colors.yellow),
                    Icon(Icons.star, size: 12.5, color: Colors.yellow),
                    Icon(Icons.star, size: 12.5, color: down_color),
                    Icon(Icons.star, size: 12.5, color: down_color),
                    Icon(Icons.star, size: 12.5, color: down_color),
                  ])
                : star <= 3.5
                    ? Row(children: <Widget>[
                        Icon(Icons.star, size: 12.5, color: Colors.yellow),
                        Icon(Icons.star, size: 12.5, color: Colors.yellow),
                        Icon(Icons.star, size: 12.5, color: Colors.yellow),
                        Icon(Icons.star, size: 12.5, color: down_color),
                        Icon(Icons.star, size: 12.5, color: down_color),
                      ])
                    : star <= 4.5
                        ? Row(children: <Widget>[
                            Icon(Icons.star, size: 12.5, color: Colors.yellow),
                            Icon(Icons.star, size: 12.5, color: Colors.yellow),
                            Icon(Icons.star, size: 12.5, color: Colors.yellow),
                            Icon(Icons.star, size: 12.5, color: Colors.yellow),
                            Icon(Icons.star, size: 12.5, color: down_color),
                          ])
                        : star <= 5.0
                            ? Row(children: <Widget>[
                                Icon(Icons.star,
                                    size: 12.5, color: Colors.yellow),
                                Icon(Icons.star,
                                    size: 12.5, color: Colors.yellow),
                                Icon(Icons.star,
                                    size: 12.5, color: Colors.yellow),
                                Icon(Icons.star,
                                    size: 12.5, color: Colors.yellow),
                                Icon(Icons.star,
                                    size: 12.5, color: Colors.yellow),
                              ])
                            : Text('잘못 설정 되었습니다.');
  }

  Widget group(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Stores')
          .doc('${widget.stores.uid}${widget.stores.date.seconds}')
          .collection('Replys')
          .where('is_deleted', isEqualTo: false)
          .orderBy('bundle_id', descending: false)
          .orderBy('bundle_order', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              // Non - scroll
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                if (doc['depth'] == 0) {
                  return reply(context, doc, index);
                } else {
                  return reply_reply(context, doc, index);
                }
              });
        } else {
          return Text("댓글이 없습니다.", style: TextStyle(color: white_color));
        }
      },
    );
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
      'star_count': 4,
      'depth': 0,
      'created_date': time,
      'updated_date': time,
      'deleted_date': time
    };
    ReplyProvider.setReply(data);

    _textController.clear();
    FocusScope.of(context).unfocus();
    EasyLoading.showToast('댓글 작성이 완료되었습니다.',
        dismissOnTap: true,
        maskType: EasyLoadingMaskType.custom,
        toastPosition: EasyLoadingToastPosition.center);
  }

  void setReplyReply(String text, Timestamp ts) {
    UserData user = Provider.of<UserData>(context, listen: false);
    // 댓글 보내기
    //create, update, delete : Datetime now
    Timestamp time = Timestamp.fromDate(DateTime.now());

    Map<String, dynamic> data = {
      'store_uid': widget.stores.uid,
      'date': widget.stores.date,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'nickname': user.nickname,
      'bundle_id': ts,
      'bundle_order': time,
      'is_deleted': false,
      'reply': text,
      'star_count': 0.0,
      'created_date': time,
      'depth': 1,
      'updated_date': time,
      'deleted_date': time
    };
    ReplyProvider.setReply(data);
    setState(() => is_reply_index = -1);
    _textController2.clear();
    FocusScope.of(context).unfocus();
    EasyLoading.showToast('대댓글 작성이 완료되었습니다.',
        dismissOnTap: true,
        maskType: EasyLoadingMaskType.custom,
        toastPosition: EasyLoadingToastPosition.center);
  }

  Widget replyInput(BuildContext context) {
    var user = Provider.of<UserData>(context, listen: false);
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              minLines: 1,
              maxLines: 4,
              //onSubmitted: setReply,
              style: TextStyle(
                color: white_color,
                fontSize: 15,
                fontFamily: 'fontnoto',
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                labelText: '댓글 입력',
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
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
                icon: Icon(Icons.send),
                color: white_color,
                onPressed: () => setReply(_textController.text)),
          ),
        ],
      ),
    );
  }

  Widget reply_replyInput(BuildContext context, Timestamp ts) {
    var user = Provider.of<UserData>(context, listen: false);
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController2,
              minLines: 4,
              maxLines: 4,
              style: TextStyle(
                color: white_color,
                fontSize: 15,
                fontFamily: 'fontnoto',
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                labelText: '대댓글 입력',
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
                  borderSide: BorderSide(color: white_color, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: white_color, width: 3.0),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              children: [
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => setReplyReply(_textController2.text, ts)),
                IconButton(
                    icon: Icon(Icons.cancel_rounded),
                    onPressed: () async {
                      setState(() => is_reply_index = -1);
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget fixInput(
      BuildContext context, String text, String uid, Timestamp created_date) {
    var user = Provider.of<UserData>(context, listen: false);
    _textController3.text = text;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController3,
              minLines: 4,
              maxLines: 4,
              style: TextStyle(
                color: white_color,
                fontSize: 15,
                fontFamily: 'fontnoto',
                fontWeight: FontWeight.w300,
              ),
              decoration: InputDecoration(
                hoverColor: on_color,
                focusColor: color_red1,
                contentPadding: const EdgeInsets.all(16.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: white_color, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: white_color, width: 3.0),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              children: [
                IconButton(
                    icon: Icon(Icons.send, color: white_color),
                    onPressed: () async {
                      Map<String, dynamic> data = {
                        'store_uid': widget.stores.uid,
                        'date': widget.stores.date,
                        'uid': FirebaseAuth.instance.currentUser!.uid,
                        'reply': _textController3.text,
                        'updated_date': Timestamp.fromDate(DateTime.now()),
                        'created_date': created_date,
                      };
                      await ReplyProvider.setReply(data);
                      setState(() => is_fix_index = -1);
                      //수정이 완료되었습니다.
                      FocusScope.of(context).unfocus();
                      EasyLoading.showToast('수정이 완료되었습니다.',
                          dismissOnTap: true,
                          maskType: EasyLoadingMaskType.custom,
                          toastPosition: EasyLoadingToastPosition.center);
                    }),
                IconButton(
                    icon: Icon(Icons.cancel_rounded, color: white_color),
                    onPressed: () async {
                      setState(() => is_fix_index = -1);
                      FocusScope.of(context).unfocus();
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void dialog_delete(BuildContext context, Timestamp bundle_id, int depth) {
    showDialog(
      context: context,
      barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Center(
            child: Text(
              '정말로 삭제하시겠습니까?',
              style: TextStyle(
                fontFamily: 'fontnoto',
                fontWeight: FontWeight.w700,
                color: on_color,
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  child: Text(
                    '아니요',
                    style: TextStyle(
                        fontFamily: 'fontnoto',
                        fontWeight: FontWeight.w900,
                        color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text(
                    '예',
                    style: TextStyle(
                      fontFamily: 'fontnoto',
                      fontWeight: FontWeight.w900,
                      color: on_color,
                    ),
                  ),
                  onPressed: () async {
                    if (depth == 0) {
                      Map<String, dynamic> data = {
                        'store_uid': widget.stores.uid,
                        'date': widget.stores.date,
                        'uid': FirebaseAuth.instance.currentUser!.uid,
                        'bundle_id': bundle_id,
                      };
                      await ReplyProvider.deleteReply(data);
                      Navigator.pop(context);
                    } else {
                      Map<String, dynamic> data = {
                        'store_uid': widget.stores.uid,
                        'date': widget.stores.date,
                        'uid': FirebaseAuth.instance.currentUser!.uid,
                        'created_date': bundle_id,
                      };
                      await ReplyProvider.deleteReplyReply(data);
                      Navigator.pop(context);
                    }
                    FocusScope.of(context).unfocus();
                    EasyLoading.showToast('삭제가 완료되었습니다.',
                        dismissOnTap: true,
                        maskType: EasyLoadingMaskType.custom,
                        toastPosition: EasyLoadingToastPosition.center);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget reply(BuildContext context, DocumentSnapshot doc, int idx) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16.0,
          top: 16.0,
          bottom: 8.0,
          right: MediaQuery.of(context).size.width * 0.1),
      child: Container(
        decoration: new BoxDecoration(
            color: on_color,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(9.0),
              topRight: const Radius.circular(9.0),
              bottomLeft: const Radius.circular(9.0),
              bottomRight: const Radius.circular(9.0),
            )),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage("images/google.png"),
                        ),
                        Container(
                          width: 15,
                        ),
                        Text(
                          '${doc['nickname']}',
                          style: TextStyle(
                            fontFamily: 'fontnoto',
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: white_color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /*
                      SizedBox(
                        height: 20,
                        width: 50,
                        child: TextButton(
                            onPressed: () {
                              //index에 들어있으면 삭제 없으면 추가
                              if (is_reply_index == idx) {
                                setState(() {
                                  is_reply_index = -1;
                                });
                              } else {
                                setState(() {
                                  is_reply_index = idx;
                                });
                              }
                            },
                            child: Text(
                              '답변',
                              style: TextStyle(
                                fontFamily: 'fontnoto',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: white_color,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero)),
                      ),

                      SizedBox(
                        height: 20,
                        width: 50,
                        child: TextButton(
                            onPressed: () {
                              if (is_fix_index == idx) {
                                setState(() {
                                  is_fix_index = -1;
                                });
                              } else if (doc['uid'] ==
                                  FirebaseAuth.instance.currentUser!.uid) {
                                setState(() {
                                  is_fix_index = idx;
                                });
                              } else {
                                EasyLoading.showToast('다른 사람의 댓글은 수정할 수 없습니다.',
                                    dismissOnTap: true,
                                    maskType: EasyLoadingMaskType.custom,
                                    toastPosition:
                                        EasyLoadingToastPosition.center);
                              }
                            },
                            child: Text(
                              '수정',
                              style: TextStyle(
                                fontFamily: 'fontnoto',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: white_color,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero)),
                      ),

                      SizedBox(
                        height: 20,
                        width: 50,
                        child: TextButton(
                            onPressed: () {
                              if (doc['uid'] ==
                                  FirebaseAuth.instance.currentUser!.uid)
                                dialog_delete(context, doc['created_date'], 0);
                              else {
                                EasyLoading.showToast('다른 사람의 댓글은 삭제가 불가능합니다.',
                                    dismissOnTap: true,
                                    maskType: EasyLoadingMaskType.custom,
                                    toastPosition:
                                        EasyLoadingToastPosition.center);
                              }
                            },
                            child: Text(
                              '삭제',
                              style: TextStyle(
                                fontFamily: 'fontnoto',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: white_color,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero)),
                      ),

                       */
                    ],
                  ),
                ]),
            //TODO
            star(context, doc),
            Text(
              DateFormat('yyyy년 MM월 dd일 kk시 mm분 ss초').format(
                  DateTime.fromMillisecondsSinceEpoch(
                          doc['updated_date'].seconds * 1000)
                      .add(Duration(hours: 9))),
              style: TextStyle(
                fontFamily: 'fontnoto',
                fontWeight: FontWeight.w400,
                fontSize: 12.5,
                color: white_color,
              ),
            ),
            Container(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: is_fix_index == idx
                      ? fixInput(context, doc['reply'], doc['uid'],
                          doc['created_date'])
                      : Text(
                          "${doc['reply']}",
                          style: TextStyle(
                            fontFamily: 'fontnoto',
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                            color: white_color,
                          ),
                        ),
                ),
              ],
            ),
            is_reply_index == idx
                ? reply_replyInput(context, doc['bundle_id'])
                : Text(''),
          ],
        ),
      ),
    );
  }

  Widget star(BuildContext context, DocumentSnapshot doc) {
    return doc['star_count'] == 0
        ? Row(children: <Widget>[
            Icon(Icons.star, size: 12.5, color: down_color),
            Icon(Icons.star, size: 12.5, color: down_color),
            Icon(Icons.star, size: 12.5, color: down_color),
            Icon(Icons.star, size: 12.5, color: down_color),
            Icon(Icons.star, size: 12.5, color: down_color),
          ])
        : doc['star_count'] == 1
            ? Row(children: <Widget>[
                Icon(Icons.star, size: 12.5, color: Colors.yellow),
                Icon(Icons.star, size: 12.5, color: down_color),
                Icon(Icons.star, size: 12.5, color: down_color),
                Icon(Icons.star, size: 12.5, color: down_color),
                Icon(Icons.star, size: 12.5, color: down_color),
              ])
            : doc['star_count'] == 2
                ? Row(children: <Widget>[
                    Icon(Icons.star, size: 12.5, color: Colors.yellow),
                    Icon(Icons.star, size: 12.5, color: Colors.yellow),
                    Icon(Icons.star, size: 12.5, color: down_color),
                    Icon(Icons.star, size: 12.5, color: down_color),
                    Icon(Icons.star, size: 12.5, color: down_color),
                  ])
                : doc['star_count'] == 3
                    ? Row(children: <Widget>[
                        Icon(Icons.star, size: 12.5, color: Colors.yellow),
                        Icon(Icons.star, size: 12.5, color: Colors.yellow),
                        Icon(Icons.star, size: 12.5, color: Colors.yellow),
                        Icon(Icons.star, size: 12.5, color: down_color),
                        Icon(Icons.star, size: 12.5, color: down_color),
                      ])
                    : doc['star_count'] == 4
                        ? Row(children: <Widget>[
                            Icon(Icons.star, size: 12.5, color: Colors.yellow),
                            Icon(Icons.star, size: 12.5, color: Colors.yellow),
                            Icon(Icons.star, size: 12.5, color: Colors.yellow),
                            Icon(Icons.star, size: 12.5, color: Colors.yellow),
                            Icon(Icons.star, size: 12.5, color: down_color),
                          ])
                        : doc['star_count'] == 5
                            ? Row(children: <Widget>[
                                Icon(Icons.star,
                                    size: 12.5, color: Colors.yellow),
                                Icon(Icons.star,
                                    size: 12.5, color: Colors.yellow),
                                Icon(Icons.star,
                                    size: 12.5, color: Colors.yellow),
                                Icon(Icons.star,
                                    size: 12.5, color: Colors.yellow),
                                Icon(Icons.star,
                                    size: 12.5, color: Colors.yellow),
                              ])
                            : Text('잘못 설정 되었습니다.');
  }

  Widget reply_reply(BuildContext context, DocumentSnapshot doc, int idx) {
    return Padding(
      padding: EdgeInsets.only(
          right: 16.0,
          top: 8.0,
          bottom: 8.0,
          left: MediaQuery.of(context).size.width * 0.1),
      child: Container(
        decoration: new BoxDecoration(
            color: on_color,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(9.0),
              topRight: const Radius.circular(9.0),
              bottomLeft: const Radius.circular(9.0),
              bottomRight: const Radius.circular(9.0),
            )),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.subdirectory_arrow_right,
                          size: 25,
                        ),
                        Container(
                          width: 5,
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage("images/google.png"),
                        ),
                        Container(
                          width: 15,
                        ),
                        Text(
                          '${doc['nickname']}',
                          style: TextStyle(
                            fontFamily: 'fontnoto',
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: white_color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 50,
                        child: TextButton(
                            onPressed: () {
                              if (is_fix_index == idx) {
                                setState(() {
                                  is_fix_index = -1;
                                });
                              } else {
                                setState(() {
                                  is_fix_index = idx;
                                });
                              }
                            },
                            child: Text(
                              '수정',
                              style: TextStyle(
                                fontFamily: 'fontnoto',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: white_color,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero)),
                      ),
                      SizedBox(
                        height: 20,
                        width: 50,
                        child: TextButton(
                            onPressed: () {
                              if (doc['uid'] ==
                                  FirebaseAuth.instance.currentUser!.uid)
                                dialog_delete(context, doc['created_date'], 1);
                              else {
                                EasyLoading.showToast('다른 사람의 댓글은 삭제가 불가능합니다.',
                                    dismissOnTap: true,
                                    maskType: EasyLoadingMaskType.custom,
                                    toastPosition:
                                        EasyLoadingToastPosition.center);
                              }
                            },
                            child: Text(
                              '삭제',
                              style: TextStyle(
                                fontFamily: 'fontnoto',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: white_color,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero)),
                      ),
                    ],
                  ),
                ]),
            Text(
              DateFormat('yyyy년 MM월 dd일 kk시 mm분 ss초').format(
                  DateTime.fromMillisecondsSinceEpoch(
                          doc['updated_date'].seconds * 1000)
                      .add(Duration(hours: 9))),
              style: TextStyle(
                fontFamily: 'fontnoto',
                fontWeight: FontWeight.w400,
                fontSize: 12.5,
                color: white_color,
              ),
            ),
            Container(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: is_fix_index == idx
                      ? fixInput(context, doc['reply'], doc['uid'],
                          doc['created_date'])
                      : Text(
                          "${doc['reply']}",
                          style: TextStyle(
                            fontFamily: 'fontnoto',
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                            color: white_color,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
