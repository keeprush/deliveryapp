import 'dart:convert';
import 'package:deliveryapp/join_or_login.dart';
import 'package:deliveryapp/login_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../../colors.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class loginView extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Widget get _logoImage => Image.asset("images/윙윙이.png",fit:BoxFit.fill,scale:6);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(    // <-  WillPopScope로 감싼다.
        onWillPop: () {

          return Future(() => false);
        },
        child : Scaffold(
          ///resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    CustomPaint(
                      size: size,
                      painter: LoginBackground(
                          isJoin: Provider.of<JoinOrLogin>(context).isJoin),
                    ),
                    Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: size.height * 0.09,
                        ),
                        ClipOval(
                          child:_logoImage,
                        ),
                        Container(
                          height: size.height * 0.055,
                        ),
                        Stack(
                          children: <Widget>[
                            _inputForm(size), // Input Form 위젯
                            _authButton(size), // authButton 위젯
                          ],
                        ),
                        Container(
                          height: size.height * 0.015,
                        ),
                        Consumer<JoinOrLogin>(
                          builder: (context, joinOrLogin, child) => GestureDetector(
                              onTap: () {
                                joinOrLogin.toggle();
                              },
                              child: Text(
                                joinOrLogin.isJoin
                                    ? "회원가입을 누르시면 계정이 만들어집니다."
                                    : "계정이 없으시다구요? 클릭하세요!",
                                style: TextStyle(
                                    fontFamily: 'fontnoto',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: joinOrLogin.isJoin
                                        ? color_red1
                                        : on_color),
                              )),
                        ),
                        Container(
                          height: size.height * 0.015,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          ///나중에 수정, 포지션이랑 스택 연관된거
                          children: <Widget>[
                            _googleButton(size),
                          ],
                        ),
                        Container(
                          height: size.height * 0.04,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }

  Widget _authButton(Size size) => Positioned(
    left: size.width * 0.15,
    right: size.width * 0.15,
    bottom: 0,
    child: SizedBox(
      height: 50,
      child: Consumer<JoinOrLogin>(
        builder: (context, joinOrLogin, child) => RaisedButton(
          child: Text(
            joinOrLogin.isJoin ? "회원가입" : "로그인",
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontFamily: 'fontnoto',
              fontWeight: FontWeight.w700,
            ),
          ),
          color: joinOrLogin.isJoin
              ? color_red1
              : on_color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              joinOrLogin.isJoin ? _register(context) : _login(context);
            }
          },
        ),
      ),
    ),
  );


  Widget _inputForm(Size size) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 1, bottom: 30),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 6,
        child: Padding(
          padding:
          const EdgeInsets.only(left: 12.0, right: 12, top: 12, bottom: 24),
          child: Form(
              key: _formKey, // 상태를 접근하게 해주는 역할
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.account_circle),
                      labelText: "Email",
                      labelStyle: TextStyle(
                        fontFamily: 'fontnoto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    validator: (var value) {
                      if (value!.isEmpty) {
                        return "이메일을 작성해주세요!";
                      }
                      return null; // 작성하면, pass 한다.
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      labelText: "Password",
                      labelStyle: TextStyle(
                        fontFamily: 'fontnoto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    validator: (var value) {
                      if (value!.isEmpty) {
                        return "패스워드를 작성해주세요!";
                      }
                      return null; // 작성하면, pass 한다.
                    },
                  ),
                  Container(
                    height: 8,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  goToForgetPw(BuildContext context) {

  }

// 계정 생성
  void _register(BuildContext context) async {
    // 회원가입
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {

      print(e.code);
      if (e.code == 'weak-password') {
        EasyLoading.showToast('패스워드가 보안에 취약합니다.',dismissOnTap: true, maskType: EasyLoadingMaskType.custom,toastPosition:EasyLoadingToastPosition.center);
      } else if (e.code == 'email-already-in-use') {
        EasyLoading.showToast('이메일 계정이 이미 있습니다.',dismissOnTap: true, maskType: EasyLoadingMaskType.custom,toastPosition:EasyLoadingToastPosition.center);
      }
      else if (e.code == 'invalid-email') {
        EasyLoading.showToast('이메일 형식이 맞지 않습니다.',dismissOnTap: true, maskType: EasyLoadingMaskType.custom,toastPosition:EasyLoadingToastPosition.center);
      }
      return;
    } catch (e) {
      EasyLoading.showToast('이메일 형식이 맞지 않습니다.',dismissOnTap: true, maskType: EasyLoadingMaskType.custom,toastPosition:EasyLoadingToastPosition.center);
      return;
    }
    // 자동 로그인
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
      } else if (e.code == 'wrong-password') {
      }
    }
    catch (e) {
      print('hi');
    }
  }

// 로그인(회원가입에서 복붙 후 수정)
  void _login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      EasyLoading.showToast('이메일과 비밀번호를 확인하세요.',dismissOnTap: true, maskType: EasyLoadingMaskType.custom,toastPosition:EasyLoadingToastPosition.center);
    }
  }

  Widget _googleButton(Size size) => SizedBox(
    height: 60,
    child: MaterialButton(
      shape: const CircleBorder(
          side: BorderSide(
              width: 0, color: Colors.white, style: BorderStyle.solid)),
        child:Image.asset('images/google.png'),
      onPressed: signInWithGoogle,
    ),
  );

  Future<UserCredential> signInWithGoogle() async {
    var credential;
    try{EasyLoading.show(status: '로그인중...');
    // Trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final googleAuth = await googleUser!.authentication;

    // Create a new credential
    credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    }catch(e){
      print(e);
      EasyLoading.dismiss();
    }
    //구글로그인이안돼 TODO
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
