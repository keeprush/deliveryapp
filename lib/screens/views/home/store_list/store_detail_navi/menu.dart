import 'package:deliveryapp/colors.dart';
import 'package:deliveryapp/databases/stores_provider.dart';
import 'package:deliveryapp/models/menus.dart';
import 'package:deliveryapp/models/stores.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 프로바이더
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class menu extends StatefulWidget {
  final StoreData stores;

  const menu({
    required this.stores,
    Key? key,
  }) : super(key: key);

  @override
  menuState createState() => menuState();
}

class menuState extends State<menu> {
  StoreProvider sp = StoreProvider();
  List<MenuData> recommend = [];
  List<MenuData> main = [];
  List<MenuData> side = [];

  @override
  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    get_menu();
  }

  Widget build(BuildContext context) {
    return
      menu(context);

  }

  get_menu() async {
    List<MenuData> _recommend = await sp.getRecommendMenus(
        {'store_uid': widget.stores.uid, 'date': widget.stores.date});
    List<MenuData> _main = await sp.getMainMenus(
        {'store_uid': widget.stores.uid, 'date': widget.stores.date});
    List<MenuData> _side = await sp.getSideMenus(
        {'store_uid': widget.stores.uid, 'date': widget.stores.date});

    if (mounted) {
      setState(() {
        recommend = _recommend;
        main = _main;
        side = _side;
      });
    }
  }

  Widget menu(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 16, top: 10),
          child: Text(
            '추천',
            style: TextStyle(
              fontSize: 26,
              fontFamily: 'fontnoto',
              fontWeight: FontWeight.w900,
              color: on_color,
            ),
          ),
        ),
        Container(
          height: 2,
          color: on_color,
        ),
        menu_item_recommend(context),
        Container(
          padding: EdgeInsets.only(left: 16, top: 10),
          child: Text(
            '메인',
            style: TextStyle(
              fontSize: 26,
              fontFamily: 'fontnoto',
              fontWeight: FontWeight.w900,
              color: on_color,
            ),
          ),
        ),
        Container(
          height: 2,
          color: on_color,
        ),
        menu_item_main(context),
        Container(
          padding: EdgeInsets.only(left: 16, top: 10),
          child: Text(
            '사이드',
            style: TextStyle(
              fontSize: 26,
              fontFamily: 'fontnoto',
              fontWeight: FontWeight.w900,
              color: on_color,
            ),
          ),
        ),
        Container(
          height: 2,
          color: on_color,
        ),
        menu_item_side(context),
        //메뉴 추가용 위젯
        //storeMenuPlus1(context),
        //storeMenuPlus2(context),
        //storeMenuPlus3(context),
        //storeMenuPlusRandom(context),
      ],
    );
  }

  Widget menu_item_recommend(BuildContext context) {
    List<MenuData> cart = Provider.of<List<MenuData>>(context, listen: true);
    List<StoreData> store_info = Provider.of<List<StoreData>>(context, listen: false);
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // Nonscroll
      padding: const EdgeInsets.all(16),
      itemCount: recommend.length,
      itemBuilder: (BuildContext context, int i) {
        return InkWell(
          onTap: () async {
            bool is_overlap = false;
            // 가게 이름이 설정이 안되어 있다면
            if(store_info[0].store_name==''){
              store_info[0] = widget.stores;
            }
            // 가게 이름이 설정이 되어 있지만 같은 가게가 아닐 경우
            if(store_info[0].store_name!=widget.stores.store_name){
              store_info[0] = widget.stores;
              cart.removeRange(0,cart.length);
            }
            for (var c in cart) {
                if (recommend[i].name == c.name) {
                  c.price += recommend[i].price;
                  c.count += 1;
                  is_overlap = true;
                  print(c.name);
                  break;
                }
            }
            if (!is_overlap) {
              cart.add(MenuData(
                  name: recommend[i].name,
                  price: recommend[i].price,
                  count: 1));
            }
            print(cart);
            EasyLoading.showToast('${recommend[i].name} 메뉴가 장바구니에 담겼습니다.',
                dismissOnTap: true,
                maskType: EasyLoadingMaskType.custom,
                toastPosition: EasyLoadingToastPosition.center);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${recommend[i].name}',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'fontnoto',
                    fontWeight: FontWeight.w400,
                    color: white_color,
                  ),
                ),
                Text(
                  '${recommend[i].price}원',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'fontnoto',
                    fontWeight: FontWeight.w400,
                    color: white_color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget menu_item_main(BuildContext context) {
    List<MenuData> cart = Provider.of<List<MenuData>>(context, listen: false);
    List<StoreData> store_info = Provider.of<List<StoreData>>(context, listen: false);
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // Nonscroll
      padding: const EdgeInsets.all(16),
      itemCount: main.length,
      itemBuilder: (BuildContext context, int i) {
        return InkWell(
          onTap: () async {
            bool is_overlap = false;
            if(store_info[0].store_name==''){
              store_info[0] = widget.stores;
            }
            // 가게 이름이 설정이 되어 있지만 같은 가게가 아닐 경우
            if(store_info[0].store_name!=widget.stores.store_name){
              store_info[0] = widget.stores;
              cart = [];
            }
            for (var c in cart) {
                if (main[i].name == c.name) {
                  c.price += main[i].price;
                  c.count += 1;
                  is_overlap = true;
                  print(c.count);
                  break;
                }
            }
            if (!is_overlap) {
              cart.add(MenuData(
                  name: main[i].name,
                  price: main[i].price,
                  count: 1));
            }
            EasyLoading.showToast('${main[i].name} 메뉴가 장바구니에 담겼습니다.',
                dismissOnTap: true,
                maskType: EasyLoadingMaskType.custom,
                toastPosition: EasyLoadingToastPosition.center);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${main[i].name}',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'fontnoto',
                    fontWeight: FontWeight.w400,
                    color: white_color,
                  ),
                ),
                Text(
                  '${main[i].price}원',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'fontnoto',
                    fontWeight: FontWeight.w400,
                    color: white_color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget menu_item_side(BuildContext context) {
    List<MenuData> cart = Provider.of<List<MenuData>>(context, listen: false);
    List<StoreData> store_info = Provider.of<List<StoreData>>(context, listen: false);
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // Nonscroll
      padding: const EdgeInsets.all(16),
      itemCount: side.length,
      itemBuilder: (BuildContext context, int i) {
        return InkWell(
          onTap: () async {
            bool is_overlap = false;
            if(store_info[0].store_name==''){
              store_info[0] = widget.stores;
              print(store_info[0].delivery_fee);
            }
            // 가게 이름이 설정이 되어 있지만 같은 가게가 아닐 경우
            if(store_info[0].store_name!=widget.stores.store_name){
              store_info[0] = widget.stores;
              cart = [];
            }
            for (var c in cart) {
                if (side[i].name == c.name) {
                  c.price += side[i].price;
                  c.count += 1;
                  is_overlap = true;
                  break;
                }
            }
            if (!is_overlap) {
              cart.add(MenuData(
                  name: side[i].name,
                  price: side[i].price,
                  count: 1));
            }
            EasyLoading.showToast('${side[i].name} 메뉴가 장바구니에 담겼습니다.',
                dismissOnTap: true,
                maskType: EasyLoadingMaskType.custom,
                toastPosition: EasyLoadingToastPosition.center);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${side[i].name}',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'fontnoto',
                    fontWeight: FontWeight.w400,
                    color: white_color,
                  ),
                ),
                Text(
                  '${side[i].price}원',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'fontnoto',
                    fontWeight: FontWeight.w400,
                    color: white_color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

// 상점 메뉴 추가용
  Widget storeMenuPlus1(BuildContext context) {
    double num = MediaQuery.of(context).size.width;
    double num2 = MediaQuery.of(context).size.height;
    return Container(
      width: num * 0.40,
      height: num2 * 0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
        color: white_color,
      ),
      child: OutlineButton(
        onPressed: () => {
          sp.addMenus1(
              {'store_uid': widget.stores.uid, 'date': widget.stores.date}),
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        borderSide: BorderSide(
          color: on_color,
        ),
        child: Row(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.logout, size: 40.0, color: on_color),
            ),
            Container(
              width: num * 0.05,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "메뉴추가",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'fontnoto',
                  fontWeight: FontWeight.w700,
                  color: on_color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 상점 메뉴 추가용
  Widget storeMenuPlus2(BuildContext context) {
    double num = MediaQuery.of(context).size.width;
    double num2 = MediaQuery.of(context).size.height;
    return Container(
      width: num * 0.40,
      height: num2 * 0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
        color: white_color,
      ),
      child: OutlineButton(
        onPressed: () => {
          sp.addMenus2(
              {'store_uid': widget.stores.uid, 'date': widget.stores.date}),
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        borderSide: BorderSide(
          color: on_color,
        ),
        child: Row(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.logout, size: 40.0, color: on_color),
            ),
            Container(
              width: num * 0.05,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "메인메뉴",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'fontnoto',
                  fontWeight: FontWeight.w700,
                  color: on_color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 상점 메뉴 추가용
  Widget storeMenuPlus3(BuildContext context) {
    double num = MediaQuery.of(context).size.width;
    double num2 = MediaQuery.of(context).size.height;
    return Container(
      width: num * 0.40,
      height: num2 * 0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
        color: white_color,
      ),
      child: OutlineButton(
        onPressed: () => {
          sp.addMenus3(
              {'store_uid': widget.stores.uid, 'date': widget.stores.date}),
        },
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        borderSide: BorderSide(
          color: on_color,
        ),
        child: Row(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.logout, size: 40.0, color: on_color),
            ),
            Container(
              width: num * 0.05,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "사이드",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'fontnoto',
                  fontWeight: FontWeight.w700,
                  color: on_color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // 상점 메뉴 추가용
  Widget storeMenuPlusRandom(BuildContext context) {
    double num = MediaQuery.of(context).size.width;
    double num2 = MediaQuery.of(context).size.height;
    return Container(
      width: num * 0.40,
      height: num2 * 0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
        color: white_color,
      ),
      child: OutlineButton(
        onPressed: () => {
          sp.addMenusRandom(
              {'store_uid': widget.stores.uid, 'date': widget.stores.date}),
        },
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        borderSide: BorderSide(
          color: on_color,
        ),
        child: Row(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.logout, size: 40.0, color: on_color),
            ),
            Container(
              width: num * 0.05,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "랜덤메뉴",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'fontnoto',
                  fontWeight: FontWeight.w700,
                  color: on_color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
