import 'package:deliveryapp/databases/users_provider.dart';
import 'package:deliveryapp/screens/views/address/set_address_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class setUpNicknameView extends StatefulWidget {
  const setUpNicknameView({Key? key}) : super(key: key);

  @override
  setUpNickname createState() => setUpNickname();
}

// 첫 로그인시 유저 정보 입력 페이지
class setUpNickname extends State<setUpNicknameView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String nickname = '';
  UserProvider db = UserProvider();
  firstmeet() async {
    Map<String, dynamic> postData = {
      'nickname': nickname,
      'order_count':0,
      'order_month_count':0,
      'created_date':Timestamp.now(),
    };
    db.createUserInfo(postData);
  }

  @override
  void initState() {super.initState();}
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // <-  WillPopScope로 감싼다.
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: background_color,
        //resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45.0),
          child: AppBar(
            centerTitle: true,
            title: Text(
              "윙윙이 시작하기",
              style: TextStyle(
                color: white_color,
                fontFamily: 'fontnoto',
                fontWeight: FontWeight.w700,
              ),
            ),
            backgroundColor: background_color,
            automaticallyImplyLeading: false,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            elevation: 0,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              input_card(),
              RaisedButton(
                color: on_color,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    await firstmeet();
                    Navigator.push<Widget>(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  setAddressView(),
                      ),);
                    //Navigator.pop(context);
                  }
                },
                child: const Text(
                  '설정하기',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget input_card() {
    return Card(
        color:background_color,
      elevation: 0,
      child: Padding(
        padding:
        const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 8),
        child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 8,
                ),
                TextFormField(
                  style: TextStyle(
                    fontFamily: 'fontnoto',
                    fontWeight: FontWeight.w500,
                    color: white_color,
                  ),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.account_box,
                      color: on_color,
                    ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: on_color),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: on_color),
                      ),
                    labelText: "닉네임을 입력해주세요",
                    labelStyle: TextStyle(
                      fontFamily: 'fontnoto',
                      fontWeight: FontWeight.w700,
                      color: on_color,
                    ),
                  ),
                  onSaved: (val) {
                    setState(() {
                      nickname = val!;
                    });
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return '한글자 이하 닉네임은 사용할 수 없습니다.';
                    }

                    if (val.length < 2) {
                      return '닉네임은 두글자 이상 입력 해주셔야 합니다.';
                    }

                    return null;
                  },
                ),
                Container(
                  height: 8,
                ),
              ],
            )),
      ),
    );
  }
}
