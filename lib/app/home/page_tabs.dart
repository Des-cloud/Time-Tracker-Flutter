import 'package:flutter/material.dart';

enum PageTab {jobs, entries, account}

class PageTabData{
  const PageTabData({ @required this.label, @required this.icon});
  final String label;
  final IconData icon;

  static const Map<PageTab, PageTabData> allTabs= {
    PageTab.jobs: PageTabData(label: "Jobs", icon: Icons.work),
    PageTab.entries: PageTabData(label: "Entries", icon: Icons.view_headline),
    PageTab.account: PageTabData(label: "Account", icon: Icons.person),
  };
}