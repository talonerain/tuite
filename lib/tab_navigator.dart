import 'package:flutter/material.dart';
import 'package:tuite/pages/home_page.dart';
import 'package:tuite/pages/msg_page.dart';
import 'package:tuite/pages/notify_page.dart';
import 'package:tuite/pages/search_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() {
    return new _TabNavigatorState();
  }
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _curIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [HomePage(), SearchPage(), NotifyPage(), MsgPage()],
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            _curIndex = index;
          });
        },
        items: [
          _bottomItem(Icons.home, 0),
          _bottomItem(Icons.search, 1),
          _bottomItem(Icons.notifications, 2),
          _bottomItem(Icons.email, 3)
        ],
      ),
    );
  }

  _bottomItem(IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        activeIcon: Icon(
          icon,
          color: _activeColor,
        ),
        title: new Container());
  }
}
