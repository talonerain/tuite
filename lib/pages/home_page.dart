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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<HomeListModel>(
        future: NetService.getHomeList(homePageIndex++, "userName"),
        builder: (BuildContext context, AsyncSnapshot<HomeListModel> snapshot) {
          // connectionState表示异步计算的状态
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Text('列表即将展示');
            case ConnectionState.done:
              return _listView(snapshot.data.homeListModel);
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
  }

  Widget _listView(List<HomeItemModel> list) {
    int itemIndex = 0;
    return RefreshIndicator(
      onRefresh: () {
        setState(() {
          homePageIndex = 0;
        });
        return null;
      },
      child: ListView(
        children: list.map((model) {
          itemIndex++;
          String author = model.user.name;
          String text = model.text;
          return Padding(
              padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
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
              ));
        }).toList(),
      ),
    );
  }
}
