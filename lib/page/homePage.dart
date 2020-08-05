import 'package:flutter/material.dart';
import 'package:polka_wallet/page/assets/drawerMenu.dart';
import 'package:polka_wallet/page/assets/index.dart';
import 'package:polka_wallet/page/staking/index.dart';
import 'package:polka_wallet/page/governance/index.dart';
import 'package:polka_wallet/page/profile/index.dart';
import 'package:polka_wallet/service/notification.dart';
import 'package:polka_wallet/store/app.dart';

import 'package:polka_wallet/utils/i18n/index.dart';

class HomePage extends StatefulWidget {
  HomePage(this.store);

  static final String route = '/';
  final AppStore store;

  @override
  _HomePageState createState() => new _HomePageState(store);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.store);

  final AppStore store;

  final PageController _pageController = PageController();

  NotificationPlugin _notificationPlugin;

  final List<String> _tabList = [
    'Mining',
    'Staking',
    'Governance',
    'Profile',
  ];

  List<BottomNavigationBarItem> _navBarItems(int activeItem) {
    Map<String, String> tabs = I18n.of(context).home;
    return _tabList
        .map((i) => BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/public/${i}_dark.png',
                color: _tabList[activeItem] == i
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              title: Text(
                tabs[i.toLowerCase()],
                style: TextStyle(
                  fontSize: 14,
                  color: _tabList[activeItem] == i
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
            ))
        .toList();
  }

  Widget _getPage(i) {
    switch (i) {
      case 0:
        return Assets(store);
      case 1:
        return Staking(store);
      case 2:
        return Governance(store);
      default:
        return Profile(store.account);
    }
  }

  List<Widget> _buildPages() {
    return [0, 1, 2, 3].map((i) {
      if (i == 0) {
        // return assets page
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Theme.of(context).canvasColor,
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Image.asset(
                  'assets/images/assets/logo_dark.png',
                  height: 34,
                ),
                automaticallyImplyLeading: false,
                centerTitle: false,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              endDrawer: Drawer(
                child: DrawerMenu(store),
              ),
              bottomNavigationBar: BottomNavigationBar(
                  currentIndex: i,
                  iconSize: 22.0,
                  onTap: (index) {
                    _pageController.jumpToPage(index);
                  },
                  type: BottomNavigationBarType.fixed,
                  items: _navBarItems(i)),
              body: _getPage(i),
            )
          ],
        );
      }
      // return staking page
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).canvasColor,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: i,
                iconSize: 22.0,
                onTap: (index) {
                  _pageController.jumpToPage(index);
                },
                type: BottomNavigationBarType.fixed,
                items: _navBarItems(i)),
            body: _getPage(i),
          )
        ],
      );
    }).toList();
  }

  @override
  void initState() {
    if (_notificationPlugin == null) {
      _notificationPlugin = NotificationPlugin();
      _notificationPlugin.init(context);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: _buildPages(),
    );
  }
}
