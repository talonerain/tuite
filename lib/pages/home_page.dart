import 'package:flutter/material.dart';
import 'package:tuite/model/home_item_model.dart';
import 'package:tuite/model/home_list_model.dart';
import 'package:transparent_image/transparent_image.dart';
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

  Widget _item(HomeItemModel homeItemModel, int itemIndex) {
    var itemModel = homeItemModel;
    var isRetweeted = homeItemModel.retweetedStatus != null;
    if (isRetweeted) {
      itemModel = homeItemModel.retweetedStatus;
    }
    return Container(
      padding: EdgeInsets.fromLTRB(10, 8, 10, 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: isRetweeted
                ? FractionallySizedBox(
                    widthFactor: 1,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          child: Align(
                            child: Icon(
                              Icons.repeat,
                              size: 15,
                              color: Colors.blueGrey,
                            ),
                            alignment: Alignment.centerRight,
                          ),
                          width: 48,
                          margin: EdgeInsets.only(top: 2.5),
                        ),
                        Positioned(
                            left: 58,
                            child: Text('${homeItemModel.user.name}转推了',
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12))),
                      ],
                    ),
                  )
                : null,
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      '${itemModel.showTime}',
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
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Text(
                    itemModel.content,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                // 动态控制widget是否展示
                Container(
                  child: _parseItemImgUrl(itemModel) == null
                      ? null
                      : FractionallySizedBox(
                          widthFactor: 1,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: AspectRatio(
                                aspectRatio: 1.5 / 1,
                                child: FadeInImage.memoryNetwork(
                                    // BoxFit.cover类似centerCrop
                                    fit: BoxFit.cover,
                                    image: _parseItemImgUrl(itemModel),
                                    placeholder: kTransparentImage),
                              )),
                        ),
                  margin: EdgeInsets.fromLTRB(0, 8, 10, 0),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _itemIconBox(Icons.mode_comment_outlined, ''),
                      _itemIconBox(
                          Icons.repeat, itemModel.retweetCount.toString()),
                      _itemIconBox(Icons.favorite_border,
                          itemModel.favoriteCount.toString()),
                      _itemIconBox(Icons.share_outlined, ''),
                    ],
                  ),
                  margin: EdgeInsets.only(right: 35),
                )
              ],
            )),
          ]),
        ],
      ),
    );
  }

  String _parseItemImgUrl(HomeItemModel itemModel) {
    List<Media> mediaList = itemModel.entities.getMediaList();
    if (mediaList.isNotEmpty) {
      return mediaList[0].mediaUrlHttps;
    }
    return null;
  }

  Widget _itemIconBox(IconData iconData, String num) {
    return GestureDetector(
        onTap: () => print('点击'),
        child: Row(
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
        ));
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
