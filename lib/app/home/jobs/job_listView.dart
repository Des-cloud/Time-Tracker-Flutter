import 'package:flutter/material.dart';

class JobListView extends StatelessWidget {
  const JobListView({Key key, @required this.jobName, this.onTap}) : super(key: key);
  final String jobName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(jobName),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
