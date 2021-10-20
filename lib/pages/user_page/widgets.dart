import 'package:flutter/material.dart';

Widget nameView(userName, verified) {
  return Row(
    children: [
      Text(
        userName,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
      ),
      Offstage(
        child: Icon(
          Icons.verified,
          color: Colors.blue,
          size: 15,
        ),
        // 认证用户才展示认证标签
        offstage: !verified,
      ),
    ],
  );
}

Widget locationView(location) {
  return location != ''
      ? Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: Color(0xFF616161),
              size: 17,
            ),
            Container(width: 3),
            Text(
              location,
              style: TextStyle(color: Color(0xFF616161), fontSize: 15),
            )
          ],
        )
      : null;
}

Widget favView(friendsCnt, followsCnt) {
  return RichText(
      text: TextSpan(
    children: [
      TextSpan(
          text: friendsCnt?.toString(),
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
      TextSpan(
          text: ' 正在关注',
          style: TextStyle(color: Color(0xFF616161), fontSize: 15)),
      TextSpan(
          text: '    ' + followsCnt?.toString(),
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
      TextSpan(
          text: ' 关注者',
          style: TextStyle(color: Color(0xFF616161), fontSize: 15)),
    ],
  ));
}

Widget tabBar(TabController tabController) {
  return TabBar(
    labelStyle: TextStyle(fontWeight: FontWeight.bold),
    controller: tabController,
    labelColor: Colors.black,
    tabs: [
      Tab(
        text: '推文',
      ),
      Tab(
        text: '回复',
      ),
      Tab(
        text: '媒体',
      ),
      Tab(text: '喜欢')
    ],
  );
}

Widget tabBarView(TabController tabController) {
  return TabBarView(controller: tabController, children: [
    Tab(
      text: '推文',
    ),
    Tab(
      text: '回复',
    ),
    Tab(
      text: '媒体',
    ),
    Tab(text: '喜欢')
  ]);
}
