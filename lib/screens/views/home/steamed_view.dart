import 'package:deliveryapp/databases/stores_provider.dart';
import 'package:deliveryapp/databases/users_provider.dart';
import 'package:deliveryapp/screens/views/home/store_list/character_detail.dart';
import 'package:deliveryapp/screens/views/home/store_list/character_list_item.dart';
import 'package:deliveryapp/screens/views/home/store_list/character_sliver_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../colors.dart';
import 'package:deliveryapp/models/stores.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../colors.dart';


class steamedView extends StatefulWidget {
  const  steamedView({Key? key}) : super(key: key);
  @override
  steamed createState() => steamed();
}

class steamed extends State<steamedView> {
  static const _pageSize =10;
  var check = true;
  final PagingController<int, StoreData> _pagingController =
  PagingController(firstPageKey: 0);
  UserProvider up = UserProvider();
  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _pagingController.addStatusListener((status) {

    });
  }

  Future<void> _fetchPage(pageKey) async {
    try {
      final newItems = await up.getSteamedInfiniteScroll(
        pageKey,
        _pageSize,
      );
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void dispose() {
    // 세로 화면 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return WillPopScope(    // <-  WillPopScope로 감싼다.
      onWillPop: () {
        return Future(() => false);
      },
      child :Scaffold(
        backgroundColor:  background_color,
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          slivers: <Widget>[
            /*
            TabBar(
              tabs: [
                Text('First', style: TextStyle(color: Colors.black)),
                Text('Second', style: TextStyle(color: Colors.black)),
              ],
              indicator: ContainerTabIndicator(
                width: 16,
                height: 16,
                radius: BorderRadius.circular(8.0),
                padding: const EdgeInsets.only(left: 36),
                borderWidth: 2.0,
                borderColor: Colors.black,
              ),
            ),
            */
            PagedSliverList<int, StoreData>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<StoreData>(
                animateTransitions: true,
                newPageProgressIndicatorBuilder: (context) => SpinKitRing(color: on_color,size:50.0,lineWidth: 7.0),
                firstPageProgressIndicatorBuilder: (context) =>SpinKitRing(color: on_color,size:50.0,lineWidth: 7.0),
                itemBuilder: (context, item, index) => storesListItem(
                  stores: item,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}