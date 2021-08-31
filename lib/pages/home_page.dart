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

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
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
        await NetService.getHomeList(_pageIndex, "QoogZuwdghUwO6h");
    setState(() {
      list.addAll(homeListModel.homeList);
    });
  }

  Widget _item(HomeItemModel itemModel, int itemIndex) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 8, 10, 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: EdgeInsets.only(top: 2),
            child: CircleAvatar(
              radius: 24,
              backgroundImage:
                  NetworkImage(itemModel.user.profileImageUrlHttps),
            )),
        SizedBox(width: 10),
        Expanded(
            child: Column(
              // 如果不设置这个属性，text文字会居中，不会从开始展示
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  itemModel.user.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(width: 2),
                Icon(
                  Icons.verified,
                  color: Colors.blue,
                  size: 15,
                ),
                SizedBox(width: 2),
                Expanded(
                    child: Text(
                  '@' + itemModel.user.screenName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Color(0xFF616161), fontSize: 13),
                )),
                Text(
                  '· 2天',
                  style: TextStyle(color: Color(0xFF616161)),
                ),
                Opacity(
                  opacity: 0.4,
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                    size: 19,
                  ),
                )
              ],
            ),
            Text(
              itemModel.content,
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            // 动态控制widget是否展示
            Offstage(
                offstage: itemModel.entities == null ||
                    itemModel.entities.getMediaList().length == 0,
                child: _parseItemImgUrl(itemModel) == null
                    ? null
                    : Image.network(_parseItemImgUrl(itemModel))),
            SizedBox(height: 10),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _itemIconBox(Icons.mode_comment_outlined, ''),
                  _itemIconBox(Icons.repeat, itemModel.retweetCount.toString()),
                  _itemIconBox(Icons.favorite_border,
                      itemModel.favoriteCount.toString()),
                  Icon(
                    Icons.share_outlined,
                    color: Color(0xFF616161),
                    size: 15,
                  )
                ],
              ),
              margin: EdgeInsets.only(right: 35),
            )
          ],
        )),
      ]),
    );
  }

  String _parseItemImgUrl(HomeItemModel itemModel) {
    List<Media> mediaList = itemModel.entities.getMediaList();
    if (mediaList.isNotEmpty) {
      print('itemImgUrl == ${mediaList[0].mediaUrlHttps}');
      return mediaList[0].mediaUrlHttps;
    }
    return null;
  }

  Widget _itemIconBox(IconData iconData, String num) {
    return Row(
      children: [
        Icon(iconData, color: Color(0xFF616161), size: 18),
        SizedBox(width: 6),
        Offstage(
          // offstage为true隐藏控件
          offstage: num.endsWith('0'),
          child: Text(
            num,
            style: TextStyle(color: Color(0xFF616161), fontSize: 13),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('home_page.dispose()');
  }

  /// pageView切换时页面不重绘
  @override
  bool get wantKeepAlive => true;
}
