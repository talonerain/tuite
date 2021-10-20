import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tuite/model/content_text_model.dart';
import 'package:tuite/model/home_item_model.dart';
import 'package:tuite/model/home_list_model.dart';
import 'package:tuite/pages/user_page/user_page.dart';
import '../service/net_service.dart';
import 'package:tuite/utils/navigator_util.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int _pageIndex = 0;
  List<HomeItemModel> _list = [];
  ScrollController _scrollController = new ScrollController();

  // 正在请求列表接口
  var _isLoading = false;

  // 正在请求收藏接口
  var _isRequestLiking = false;

  // 正在请求转发接口
  var _isRequestRetweeting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(
                child: Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                    ),
                    height: 40,
                    width: 40))
            : _listView());
  }

  @override
  void initState() {
    super.initState();
    _loadData(isRefresh: true);
    _scrollController.addListener(() {
      /*print('pixels == ${_scrollController.position.pixels}, max == '
          '${_scrollController.position.maxScrollExtent}');*/
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pageIndex++;
        _loadData(maxId: _list[_list.length - 1].id);
      }
    });
  }

  Widget _listView() {
    int itemIndex = 0;
    return RefreshIndicator(
      onRefresh: _handlerRefresh,
      child: ListView(
          controller: _scrollController,
          children: _list.map((model) {
            itemIndex++;
            return _item(model, itemIndex);
          }).toList()),
    );
  }

  Future<Null> _handlerRefresh() async {
    _loadData(isRefresh: true);
    return null;
  }

  _loadData({isRefresh = false, int maxId = 0}) async {
    print('_loadData call, isRefresh == $isRefresh');
    _isLoading = true;
    if (isRefresh) {
      _pageIndex = 0;
      _list.clear();
    }
    HomeListModel homeListModel =
        await NetService.getHomeList(_pageIndex, maxId: maxId);
    setState(() {
      _isLoading = false;
      _list.addAll(homeListModel.homeList);
      //removeRepeat(list);
    });
  }

  Widget _item(HomeItemModel homeItemModel, int itemIndex) {
    var itemModel = homeItemModel;
    var isRetweeted = homeItemModel.retweetedStatus != null;
    if (isRetweeted) {
      itemModel = homeItemModel.retweetedStatus;
    }
    return Container(
      padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
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
                child: GestureDetector(
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          NetworkImage(itemModel.user.profileImageUrlHttps),
                    ),
                    onTap: () => NavigatorUtil.push(context, UserPage(itemModel.user)))),
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
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(width: 2),
                    Offstage(
                      child: Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 15,
                      ),
                      // 认证用户才展示认证标签
                      offstage: !itemModel.user.verified,
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
                    GestureDetector(
                      child: Opacity(
                        opacity: 0.4,
                        child: Icon(
                          Icons.more_vert,
                          color: Colors.grey,
                          size: 19,
                        ),
                      ),
                      onTap: () {
                        /*showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                child: Row(
                                  children: [

                                  ],
                                )
                              );
                            });*/
                        Fluttertoast.showToast(msg: '功能暂未开放');
                      },
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: getContentTxt(itemModel.content),
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
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.none,
                                    imageUrl: _parseItemImgUrl(itemModel),
                                    placeholder: (context, url) => ColoredBox(
                                          color: Colors.grey[400],
                                        )),
                              )),
                        ),
                  margin: EdgeInsets.fromLTRB(0, 8, 10, 0),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _itemIconBox(Icons.mode_comment_outlined, '', 0,
                          itemModel, Color(0xFF616161)),
                      _itemIconBox(
                          Icons.repeat,
                          itemModel.retweetCnt,
                          1,
                          itemModel,
                          itemModel.retweeted
                              ? Colors.green
                              : Color(0xFF616161)),
                      _itemIconBox(
                          itemModel.favorited
                              ? Icons.favorite
                              : Icons.favorite_border,
                          itemModel.favCount,
                          2,
                          itemModel,
                          itemModel.favorited
                              ? Colors.redAccent
                              : Color(0xFF616161)),
                      _itemIconBox(Icons.share_outlined, '', 3, itemModel,
                          Color(0xFF616161)),
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

  Widget _itemIconBox(iconData, num, index, itemModel, iconColor) {
    return GestureDetector(
        onTap: () {
          print('icon click');
          switch (index) {
            case 2:
              if (_isRequestLiking) {
                print('return by isRequestLiking');
                return;
              }
              _isRequestLiking = true;
              if (itemModel.favorited) {
                setState(() {
                  itemModel.favorited = false;
                  itemModel.setFavCount(itemModel.favoriteCount - 1);
                });
                doLike(false, itemModel.id);
              } else {
                setState(() {
                  itemModel.favorited = true;
                  itemModel.setFavCount(itemModel.favoriteCount + 1);
                });
                doLike(true, itemModel.id);
              }
              break;
            case 1:
              if (_isRequestRetweeting) {
                print('return by isRequestRetweeting');
                return;
              }
              _isRequestRetweeting = true;
              if (itemModel.retweeted) {
                setState(() {
                  itemModel.retweeted = false;
                  itemModel.setRetweetCnt(itemModel.retweetCount - 1);
                });
                doRetweet(false, itemModel.id);
              } else {
                setState(() {
                  itemModel.retweeted = true;
                  itemModel.setRetweetCnt(itemModel.retweetCount + 1);
                });
                doRetweet(true, itemModel.id);
              }
              break;
            case 3:
              Fluttertoast.showToast(msg: '功能暂未开放');
          }
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            children: [
              Icon(iconData, color: iconColor, size: 18),
              SizedBox(width: 6),
              Offstage(
                // offstage为true隐藏控件
                offstage: num == '0',
                child: Text(
                  num,
                  style: TextStyle(color: iconColor, fontSize: 13),
                ),
              )
            ],
          ),
        ));
  }

  Future<Null> doLike(like, id) async {
    bool result = await NetService.postFavCreate(like, id);
    _isRequestLiking = false;
  }

  Future<Null> doRetweet(retweet, id) async {
    bool result = await NetService.postRetweet(retweet, id);
    _isRequestRetweeting = false;
  }

  Widget itemBottomSheet(iconData, text) {
    return GestureDetector(
      child: Row(
        children: [Icon(iconData), Text(text)],
      ),
      onTap: () {},
    );
  }

  Widget getContentTxt(String text) {
    List<String> splitList = text.split(' ');
    // 只有一个item，说明不存在话题
    if (splitList.length == 1) {
      return Text(
        text,
        style: TextStyle(fontSize: 15, color: Colors.black),
      );
    } else {
      return RichText(
          text: TextSpan(
              children: splitList
                  .map((e) => TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('text == ${e} click');
                        },
                      text: e + ' ',
                      style: TextStyle(
                          fontSize: 15,
                          color:
                              e.startsWith('#') ? Colors.blue : Colors.black)))
                  .toList()));
    }
  }

  List<TextSpan> getItemTxt(List<ContentTextModel> results) {}

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
