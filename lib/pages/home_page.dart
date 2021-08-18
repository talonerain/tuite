import 'package:flutter/material.dart';
import 'package:tuite/model/home_item_model.dart';
import 'package:tuite/model/home_list_model.dart';

import '../service/net_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;
  List<HomeItemModel> list = [];
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _listView());
  }

  @override
  void initState() {
    super.initState();
    _loadData(true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent - 3) {
        _pageIndex++;
        _loadData(false);
      }
    });
  }

  Widget _listView() {
    int itemIndex = 0;
    return RefreshIndicator(
      onRefresh: _handlerRefresh,
      child: ListView(
          controller: _scrollController,
          children: list.map((model) {
            itemIndex++;
            return _item(model, itemIndex);
          }).toList()),
    );
  }

  Future<Null> _handlerRefresh() async {
    _loadData(true);
    return null;
  }

  _loadData(bool isRefresh) async {
    if (isRefresh) {
      _pageIndex = 0;
      list.clear();
    }
    HomeListModel homeListModel =
        await NetService.getHomeList(_pageIndex, "userName");
    setState(() {
      list.addAll(homeListModel.homeList);
    });
  }

  Widget _item(HomeItemModel itemModel, int itemIndex) {
    return Container(
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              itemModel.user.profileImageUrlHttps,
              width: 20,
              height: 20,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
}
