import 'package:flutter/material.dart';
import 'package:time_tracker/app/account/account_page.dart';
import 'package:time_tracker/app/home/cupertino_scaffold.dart';
import 'package:time_tracker/app/home/entries/entries_page.dart';
import 'package:time_tracker/app/home/jobs_page.dart';
import 'package:time_tracker/app/home/page_tabs.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageTab _currentTab= PageTab.jobs;
  final Map<PageTab, GlobalKey<NavigatorState>> navigatorKeys= {
    PageTab.jobs: GlobalKey<NavigatorState> (),
    PageTab.entries: GlobalKey<NavigatorState> (),
    PageTab.account: GlobalKey<NavigatorState> (),
  };

  Map<PageTab, WidgetBuilder> get pageBuilders{
    return {
      PageTab.jobs: (_)=>JobsPage(),
      PageTab.entries: (context)=>EntriesPage.create(context),
      PageTab.account: (_)=>AccountPage(),
    };
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async=> !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: HomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _selectedTab,
        pageBuilders: pageBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }

  void _selectedTab(PageTab value) {
    if(value==_currentTab){
      navigatorKeys[value].currentState.popUntil((route) => route.isFirst);
    }else {
      setState(() {
        _currentTab = value;
      });
    }
  }
}
