import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuite/model/home_item_model.dart';
import 'package:tuite/model/home_list_model.dart';
import '../service/net_service.dart';

class UserPage extends StatefulWidget {
  final User _userData;

  UserPage(this._userData) : super();

  @override
  State<StatefulWidget> createState() {
    return _UserPageState(_userData);
  }
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin {
  final User _userData;
  TabController _tabController;

  _UserPageState(this._userData) : super();

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
    _loadData();
  }

  _loadData({isRefresh = false, int maxId = 0}) async {
    print('_loadData call, isRefresh == $isRefresh');
    HomeListModel homeListModel = await NetService.getUseTimeLine(0, _userData.id);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        height: 150,
                        filterQuality: FilterQuality.none,
                        imageUrl: _userData.profileBannerUrl,
                        placeholder: (context, url) => ColoredBox(
                              color: Colors.grey[400],
                            ))),
                Positioned(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 41,
                        backgroundColor: Colors.white,
                      ),
                      // 实现图片白边
                      Container(
                          height: 82,
                          width: 82,
                          child: Center(
                            child: CircleAvatar(
                              radius: 38,
                              backgroundImage:
                                  NetworkImage(_userData.profileImageUrlHttps),
                            ),
                          ))
                    ],
                  ),
                  bottom: 0,
                  left: 15,
                ),
                Positioned(
                  child: titleIcon(Icons.arrow_back_rounded, popPage),
                  left: 13,
                  top: 38,
                ),
                Positioned(
                  child: titleIcon(Icons.more_vert_sharp, null),
                  right: 13,
                  top: 38,
                ),
                Positioned(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 3, 12, 5),
                    child: Text(
                      _userData.following ? '正在关注' : '关注',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  right: 15,
                  bottom: 5,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 3, 0, 0),
              child: Row(
                children: [
                  Text(
                    _userData.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                  Offstage(
                    child: Icon(
                      Icons.verified,
                      color: Colors.blue,
                      size: 15,
                    ),
                    // 认证用户才展示认证标签
                    offstage: !_userData.verified,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
              child: Text(
                '@' + _userData.screenName,
                maxLines: 1,
                style: TextStyle(color: Color(0xFF616161), fontSize: 13),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Text(
                _userData.description,
                style: TextStyle(color: Colors.black87, fontSize: 15),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(12, 10, 0, 0),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFF616161),
                    size: 17,
                  ),
                  Container(width: 3),
                  Text(
                    _userData.location,
                    style: TextStyle(color: Color(0xFF616161), fontSize: 15),
                  )
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                child: RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                        text: _userData.friendsCount?.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' 正在关注',
                        style:
                            TextStyle(color: Color(0xFF616161), fontSize: 15)),
                    TextSpan(
                        text: '    ' + _userData.followersCount?.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' 关注者',
                        style:
                            TextStyle(color: Color(0xFF616161), fontSize: 15)),
                  ],
                ))),
            Container(
              child: TabBar(
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                controller: _tabController,
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
              ),
            ),
            Flexible(
              child: TabBarView(controller: _tabController, children: [
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
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> popPage() {
    Navigator.pop(context);
    return null;
  }
}

// 顶部标题icon
Widget titleIcon(IconData iconData, Future<void> Function() fu) {
  return GestureDetector(
    onTap: fu,
    child: Stack(
      children: [
        Opacity(
            opacity: 0.5,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.black,
            )),
        Container(
          height: 36,
          width: 36,
          child: Center(
            child: Opacity(
              child: Icon(
                iconData,
                size: 24,
                color: Color(0xFFFFEBEE),
              ),
              opacity: 0.9,
            ),
          ),
        )
      ],
    ),
  );
}
