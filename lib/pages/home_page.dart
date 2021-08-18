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
            String author = model.user.name;
            String text = model.text;
            return Container(
              decoration: BoxDecoration(color: Colors.indigo),
              margin: EdgeInsets.only(bottom: 5),
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Column(
                children: [
                  Text('第$itemIndex个item的作者是$author',
                      style: TextStyle(color: Colors.black, fontSize: 15)),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(text,
                        style: TextStyle(color: Colors.black, fontSize: 15)),
                  )
                ],
              ),
            );
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
}
