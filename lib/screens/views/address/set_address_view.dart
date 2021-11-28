import 'dart:async';

import 'package:deliveryapp/databases/users_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../colors.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

// 현재 위치 구할 때 사용
import 'package:geolocator/geolocator.dart';

// 지오코딩, 리버스 지오코딩
import 'package:geocoding/geocoding.dart';

// 다음 우편번호 api
import 'package:kpostal/kpostal.dart';

class setAddressView extends StatefulWidget {
  const setAddressView({Key? key}) : super(key: key);

  @override
  setAddress createState() => setAddress();
}

// 첫 로그인시 유저 정보 입력 페이지
class setAddress extends State<setAddressView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String location = '';
  String location_gps = '';
  UserProvider db = UserProvider();
  // 네이버 맵 api
  Completer<NaverMapController> _controller = Completer();
  var pos;
//
  String postCode = '-';
  String address = '-';
  String latitude = '-';
  String longitude = '-';
  String kakaoLatitude = '-';
  String kakaoLongitude = '-';
  //
  var center_lng;
  var center_lat;
  //37.5942115158955, 127.020927884872
  // hi 37.5916933, 127.02008

  UserProvider up = UserProvider();

  // 현재 위치 함수
  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    try {
      setState(() {
        center_lat = position.latitude;
        center_lng = position.longitude;
      });
      print("hi ${position.latitude}, ${position.longitude}");
    } on PlatformException catch (e) {
      print(e);
    }
  }

  // 리버스 지오코딩

  @override
  void initState() {
    super.initState();
    _determinePosition();
    // 타이머
    /*
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });
     */
  }

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
      child:
      Scaffold(
        backgroundColor: background_color,
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45.0),
          child: AppBar(
            centerTitle: true,
            title: Text(
              "주소 설정",
              style: TextStyle(
                color: white_color,
                fontFamily: 'fontnoto',
                fontWeight: FontWeight.w700,
              ),
            ),
            backgroundColor: background_color,
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(
              color: Colors.black,//change your color here
            ),
            elevation: 0,
          ),
        ),
        body:Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  center_lat!=null ? Container(
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: NaverMap(
                        initialCameraPosition: CameraPosition(
                          //target: LatLng(37.5942115158955, 127.020927884872),
                          target: LatLng(center_lat,center_lng),
                          zoom: 17,
                        ),

                        onMapCreated: _onMapCreated,
                        onCameraChange: _onCameraChange,
                        onCameraIdle: _onCameraIdle,
                        //onMapTap: _onMapTap,
                        initLocationTrackingMode: LocationTrackingMode.NoFollow,
                      )):Container(height: MediaQuery.of(context).size.height * 0.20,),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.45,
                    top:MediaQuery.of(context).size.height * 0.10,
                    child: Image.asset('images/marker.png',fit:BoxFit.fill,width: MediaQuery.of(context).size.width * 0.10, height: MediaQuery.of(context).size.height * 0.05),
                  ),
                  Positioned(
                    top: 20,
                    right: 0,
                    child: RaisedButton(
                      color: on_color,
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KpostalView(
                              //useLocalServer: true,
                              //localPort: 8080,
                              kakaoKey: '889edc459bea519a91015e71431b4aa4',
                              callback: (Kpostal result) {
                                setState(() {
                                  this.postCode = result.postCode;
                                  this.address = result.address;
                                  this.latitude = result.kakaoLatitude.toString();
                                  this.longitude = result.kakaoLongitude.toString();
                                  this.kakaoLatitude = result.kakaoLatitude.toString();
                                  this.kakaoLongitude = result.kakaoLongitude.toString();
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        '주소검색',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

    SingleChildScrollView(
    keyboardDismissBehavior:ScrollViewKeyboardDismissBehavior.onDrag,
    child: Column(
    children:<Widget>[
              input_card(),
              RaisedButton(
                color: on_color,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    up.setAdress({'location_gps': [latitude,longitude]});
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                child: const Text(
                  '설정하기',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
                  ]),
    ),
            ],
          ),
        ),
    );
  }

//메소드 부분
  /// 지도 생성 완료시
  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }
  //TODO
  void _onCameraChange(LatLng? latLng, CameraChangeReason reason, bool? isAnimated) {
    print('카메라 움직임 >>> 위치 : ${latLng!.latitude}, ${latLng.longitude}'
        '\n원인: $reason'
        '\n에니메이션 여부: $isAnimated');
    setState(() {
      latitude = latLng.latitude.toString();
      longitude = latLng.longitude.toString();
    });
  }

  void _onCameraIdle() {
    print('카메라 움직임 멈춤');
    // 리버스 지오코딩
    print(pos);
  }

  Widget input_card() {
    return Card(
      color: background_color,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 8),
        child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 8,
                ),

                Text('좌표',
                  maxLines:1,
                  style: TextStyle(
                    fontFamily: 'fontnoto',
                    fontWeight: FontWeight.w700,
                    color: on_color,
                  ),
                ),
                Text('latitude : ${latitude}',
                  maxLines:1,
                  style: TextStyle(
                    fontFamily: 'fontnoto',
                    fontWeight: FontWeight.w700,
                    color: on_color,
                  ),
                ),
                Text('longitude : ${longitude}',
                  maxLines:1,
                  style: TextStyle(
                    fontFamily: 'fontnoto',
                    fontWeight: FontWeight.w700,
                    color: on_color,
                  ),
                ),
                /*
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
                    labelText: "상세주소",
                    labelStyle: TextStyle(
                      fontFamily: 'fontnoto',
                      fontWeight: FontWeight.w700,
                      color: on_color,
                    ),
                  ),
                  onSaved: (val) {
                    setState(() {
                      location = val!;
                    });
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return null;
                    }

                    if (val.length < 2) {
                      return null;
                    }

                    return null;
                  },
                  ),
                 */
              ],
            )),
      ),
    );
  }
}
