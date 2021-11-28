import 'package:deliveryapp/databases/stores_provider.dart';
import 'package:deliveryapp/databases/users_provider.dart';
import 'package:deliveryapp/models/orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:deliveryapp/models/stores.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../colors.dart';
import 'order_list_item.dart';


class ordersListView extends StatefulWidget {
  const  ordersListView({Key? key}) : super(key: key);
  @override
  ordersList createState() => ordersList();
}

class ordersList extends State<ordersListView> {
  static const _pageSize =10;
  List<OrderData> orders_list = [];
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
      final newItems = await up.getOrdersInfiniteScroll(
        pageKey,
        _pageSize,
      );
      setState(() {
          orders_list.addAll(newItems[0]);
      });
      final isLastPage = newItems[1].length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems[1]);
      } else {
        final nextPageKey = pageKey + newItems[1].length;
        _pagingController.appendPage(newItems[1], nextPageKey);
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
            PagedSliverList<int, StoreData>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<StoreData>(
                animateTransitions: true,
                newPageProgressIndicatorBuilder: (context) => SpinKitRing(color: on_color,size:50.0,lineWidth: 7.0),
                firstPageProgressIndicatorBuilder: (context) =>SpinKitRing(color: on_color,size:50.0,lineWidth: 7.0),
                itemBuilder: (context, item, index) => ordersListItem(
                  stores: item,
                  orders: orders_list[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}