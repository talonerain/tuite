import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuite/model/home_item_model.dart';

class UserPage extends StatefulWidget {
  final User _userData;

  UserPage(this._userData) : super();

  @override
  State<StatefulWidget> createState() {
    return _UserPageState(_userData);
  }
}

class _UserPageState extends State<UserPage> {
  final User _userData;

  _UserPageState(this._userData) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
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
                  child: Text(
                    _userData.following ? '正在关注' : '关注',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  right: 15,
                  bottom: 10,
                )
              ],
            )
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
