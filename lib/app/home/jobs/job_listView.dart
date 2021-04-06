import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/jobs/job.dart';

class JobListView extends StatelessWidget {
  const JobListView({Key key, @required this.job, this.onTap}) : super(key: key);
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
