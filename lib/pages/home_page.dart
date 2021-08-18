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
  int homePageIndex = 0;
  List<HomeItemModel> list = [];
  ScrollController _scrollController = new ScrollController();
  bool isRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<HomeListModel>(
        future: NetService.getHomeList(homePageIndex, "userName"),
        builder: (BuildContext context, AsyncSnapshot<HomeListModel> snapshot) {
          // connectionState表示异步计算的状态
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Text('列表即将展示');
            case ConnectionState.done:
              if (isRefresh) {
                list.clear();
                isRefresh = false;
              }
              list.addAll(snapshot.data.homeListModel);
              return _listView();
            default:
              return Text('bad case');
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isRefresh = false;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          homePageIndex++;
        });
      }
    });
  }

  Widget _listView() {
    int itemIndex = 0;
    return RefreshIndicator(
      onRefresh: () {
        setState(() {
          homePageIndex = 0;
          isRefresh = true;
        });
        return null;
      },
      child: ListView(
          controller: _scrollController,
          children: list.map((model) {
            itemIndex++;
            String author = model.user.name;
            String text = model.text;
            return Container(
              decoration: BoxDecoration(color: Colors.indigo),
              margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
}
