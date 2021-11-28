import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:deliveryapp/databases/users_provider.dart';
import 'package:deliveryapp/models/orders.dart';
import 'package:deliveryapp/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../colors.dart';
import 'dart:ui' as ui;

// 현재 위치 구할 때 사용
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
class orderStatus extends StatefulWidget {
  final OrderData orders;

  const orderStatus({
    required this.orders,
    Key? key,
  }) : super(key: key);

  @override
  orderStatusState createState() => orderStatusState();
}

// 첫 로그인시 유저 정보 입력 페이지
class orderStatusState extends State<orderStatus> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String location = '';
  String location_gps = '';
  UserProvider db = UserProvider();
  // 구글 맵 api
  Completer<GoogleMapController> _controller = Completer();
  var pos;
  // 현재 위치
  var center_lng;
  var center_lat;
  //var lat = 37.5054;
  //var lng = 126.984244653;
  var lat = 37.5054;
  var lng = 126.984244653;
  // 드론 마커는 드론의 현재 상태가 배달 중인지 배달완료인지에 따라 이동하도록



  // 마커
  List<Marker> _markers = [];
  // 마커 아이콘
  Uint8List? user_marker;
  Uint8List? store_marker;
  Uint8List? drone_marker;


  Timer? _timer;
  UserProvider up = UserProvider();
  //가게 좌표 50m 떨어짐
  //var test = [37.5054, 126.983894653];
  Future<void> setCustomMapPin() async {
    user_marker = await getBytesFromAsset('images/marker.png', 130);
    store_marker = await getBytesFromAsset('images/store_marker.png', 130);
    drone_marker = await getBytesFromAsset('images/drone_marker.png', 130);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
  // 유저, 스토어, 드론 사이의 거리가 가장 짧은 드론의 위치를 받아오는 함수
  Future<void> getDrone(Position position) async {
    // 현재 유저의 좌표를 받아온다.
    //Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    // 현재 모든 드론들을 받아온다. (실제에서는 DB에서 받아오고, 배달가능인 드론의 리스트만 받아온다.)
    var drone_list = [[37.5054, 126.984244653],[37.5054, 126.984044653]];
    //var drone_lat;
    //var drone_lng;
    double min_distance=100000.0;
    // 현재 모든 드론들을 비교하여 드론 -> 가게 -> 유저 위치까지 가장 가까운 드론의 좌표를 받아온다.
    for(var i=0; i<drone_list.length;i++){
      double drone_to_store_distance = Geolocator.distanceBetween(drone_list[i][0], drone_list[i][1], widget.orders.store_location_gps[0], widget.orders.store_location_gps[1]);
      double store_to_user_distance = Geolocator.distanceBetween(widget.orders.store_location_gps[0], widget.orders.store_location_gps[1], position.latitude,position.longitude);
      double temp = min(drone_to_store_distance+store_to_user_distance, min_distance);
      if(temp == drone_to_store_distance+store_to_user_distance){
        // 가장 거리가 짧은 드론으로 결정
        setState(() {
          lat = drone_list[i][0];
          lng = drone_list[i][1];
        });
      }
    }
    print('가장 거리가 짧은 드론의 좌표 lat: $lat, lng: $lng');
    //이 후 store로 이동하라고 명령을 내린다.(실제 구현에서는)
    // 드론이 이동하고 물건을 점주가 올려주면 배달중으로 변경하고 유저로 이동한다.

  }

  @override
  void initState() {
        () async {
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
          await setCustomMapPin();
          await getDrone(position);
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            setState(() {
              _markers.add(Marker(
                markerId: MarkerId('1'),
                //position: LatLng(37.5054, 126.9836),
                icon: BitmapDescriptor.fromBytes(user_marker!),
                position: LatLng(position.latitude, position.longitude),
                alpha: 0.8,
              ));
              _markers.add(Marker(
                markerId: MarkerId('2'),
                icon: BitmapDescriptor.fromBytes(store_marker!),
                position: LatLng(widget.orders.store_location_gps[0],widget.orders.store_location_gps[1] ),
                alpha: 0.8,
              ));
              _markers.add(Marker(
                markerId: MarkerId('3'),
                icon: BitmapDescriptor.fromBytes(drone_marker!),
                position: LatLng(lat, lng),
                alpha: 0.8,
              ));
            });
            _timer = Timer.periodic(Duration(seconds: 3), (timer) {
              if (this.mounted) {
                print('작동');
                setState(() {
                  lng -= 0.00005;
                });
                _updatePosition();
              }
            });
          });
    }();
    super.initState();
    _determinePosition();
  }


  void _updatePosition() async{
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        // currentposition을 그 주문 목록 좌표 업데이트하기, 유저의 최근 좌표도 업데이트 하기

        // 만약 좌표가 겹친다면 배달 중, 배달 완료로 상태 변경
        // distance 함수 드론과 가게 토스트 메세지 띄우기
        double distanceInMeters = Geolocator.distanceBetween(lat, lng, widget.orders.store_location_gps[0], widget.orders.store_location_gps[1]);
        double distanceInMeters2 = Geolocator.distanceBetween(lat, lng, position.latitude,position.longitude);
        print(distanceInMeters);
        print(distanceInMeters2);

        if(distanceInMeters<4){
          Map<String, dynamic> data = {
            'user_uid': FirebaseAuth.instance.currentUser!.uid,
            'date': widget.orders.date,
            'order_status':'배달중',
          };
          UserProvider.setOrderStatus(data);
          EasyLoading.showToast('음식을 받고 배달을 시작했습니다.',
              dismissOnTap: false,
              maskType: EasyLoadingMaskType.custom,
              toastPosition: EasyLoadingToastPosition.center);
    }
    if(distanceInMeters2<6){
      Map<String, dynamic> data = {
        'user_uid': FirebaseAuth.instance.currentUser!.uid,
        'date': widget.orders.date,
        'order_status':'배달완료',
      };
      UserProvider.setOrderStatus(data);
      _timer?.cancel();
      Navigator.of(context).popUntil((route) => route.isFirst);
      EasyLoading.showToast('배달이 완료되었습니다!',
          dismissOnTap: false,
          maskType: EasyLoadingMaskType.custom,
          toastPosition: EasyLoadingToastPosition.center);
    }
    // distance 함수 드론과 유저 토스트 메세지 띄우기

    var m = _markers.firstWhere((p) => p.markerId == MarkerId('1'));
    _markers.remove(m);
    _markers.add(
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.fromBytes(user_marker!),
        alpha: 0.8,
      ),
    );
    var t = _markers.firstWhere((p) => p.markerId == MarkerId('3'));
    _markers.remove(t);
    _markers.add(
        Marker(
      markerId: MarkerId('3'),
      position: LatLng(lat, lng),
          icon: BitmapDescriptor.fromBytes(drone_marker!),
      alpha: 0.8,
    ));

  }

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
              "배달현황",
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
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children: <Widget>[
                center_lat!=null ? Container(
                    height: MediaQuery.of(context).size.height * 0.70,
                    child:GoogleMap(
                      markers:_markers.toSet(),
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(center_lat, center_lng),
                        zoom: 18.0,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                ):Container(height: MediaQuery.of(context).size.height * 0.70,),

                Container(
                  height:MediaQuery.of(context).size.height*0.08,
                 width:MediaQuery.of(context).size.width*1.0,
                 child:
                RaisedButton(
                  color: on_color,
                  onPressed: () async {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(
                    '돌아가기',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'fontnoto',
                      fontWeight: FontWeight.w700,
                      color: white_color,
                    ),
                  ),
                ),
                ),
          ],
        ),
      ),
    );
  }
}
