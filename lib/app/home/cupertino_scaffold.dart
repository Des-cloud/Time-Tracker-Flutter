import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/page_tabs.dart';

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({Key key, @required this.currentTab, @required this.onSelectTab, @required this.pageBuilders, @required this.navigatorKeys}) : super(key: key);
  final PageTab currentTab;
  final ValueChanged<PageTab> onSelectTab;
  final Map<PageTab, WidgetBuilder> pageBuilders;
  final Map<PageTab, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            _navigationBarItem(PageTab.jobs),
            _navigationBarItem(PageTab.entries),
            _navigationBarItem(PageTab.account),
          ],
          onTap: (index)=> onSelectTab(PageTab.values[index]),
        ),
        tabBuilder: (context, index){
          final tab= PageTab.values[index];
          return CupertinoTabView(
            navigatorKey: navigatorKeys[tab],
            builder: (context){
              return pageBuilders[tab](context);
            },
          );
        },
    );
  }

  BottomNavigationBarItem _navigationBarItem(PageTab tab){
    final tabData= PageTabData.allTabs[tab];
    final color= currentTab == tab? Colors.indigo : Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(
          tabData.icon,
          color: color,
      ),
      label: tabData.label,
    );
  }
}
