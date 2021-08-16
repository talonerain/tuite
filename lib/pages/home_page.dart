import 'package:flutter/material.dart';
import 'package:tuite/model/home_list_model.dart';

import '../service/net_ervice.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("HomePage"),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<Null> _fetchData()async{
    HomeListModel homeListModel = await NetService.getHomeList("userName");
    print(homeListModel.homeListModel.length);
  }
}
