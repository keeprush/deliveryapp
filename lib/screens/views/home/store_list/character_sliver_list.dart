
import 'package:deliveryapp/databases/stores_provider.dart';
import 'package:deliveryapp/models/stores.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:container_tab_indicator/container_tab_indicator.dart';

import '../../../../colors.dart';
import 'character_list_item.dart';

class VideoList extends StatefulWidget {
  final int index;
  const VideoList({Key? key, required this.index}) : super(key: key);

  @override
  _CharacterSliverListState createState() => _CharacterSliverListState();
}

class _CharacterSliverListState extends State<VideoList> {
  static const _pageSize =10;
  var check = true;
  final PagingController<int, StoreData> _pagingController =
      PagingController(firstPageKey: 0);
  StoreProvider sp = StoreProvider();

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
      final newItems = await sp.getStoreInfiniteScroll(
        pageKey,
        _pageSize,
        widget.index,
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
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(    // <-  WillPopScope로 감싼다.
        onWillPop: () {

      return Future(() => false);
    },
    child : MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor:  background_color,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45.0),
          child: AppBar(
            centerTitle: true,
            title: Text(
              "가게목록",
              style:  TextStyle(
                fontSize: 17,
                color: white_color,
                fontFamily: 'fontnoto', fontWeight: FontWeight.w900,
              ),
            ),
            backgroundColor: background_color,
            automaticallyImplyLeading: false,
            iconTheme:  IconThemeData(
              color: white_color, //change your color here
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            elevation: 0,
          ),
        ),
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
      ),),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _pagingController.dispose();
    super.dispose();
  }
}
