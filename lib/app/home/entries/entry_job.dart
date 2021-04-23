import 'package:flutter/cupertino.dart';
import 'package:time_tracker/app/home/models/entry.dart';
import 'package:time_tracker/app/home/jobs/job.dart';

class JobEntry {
  JobEntry({@required this.entry, @required this.job});

  final Entry entry;
  final Job job;
}
