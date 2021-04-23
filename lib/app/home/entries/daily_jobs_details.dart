import 'package:flutter/foundation.dart';
import 'package:time_tracker/app/home/entries/entry_job.dart';

/// Temporary model class to store the time tracked and pay for a job
class JobDetails {
  JobDetails({
    @required this.name,
    @required this.durationInHours,
    @required this.pay,
  });
  final String name;
  double durationInHours;
  double pay;
}

/// Groups together all jobs/entries on a given day
class DailyJobsDetails {
  DailyJobsDetails({@required this.date, @required this.jobsDetails});
  final DateTime date;
  final List<JobDetails> jobsDetails;

  double get pay => jobsDetails
      .map((jobDuration) => jobDuration.pay)
      .reduce((value, element) => value + element);

  double get duration => jobsDetails
      .map((jobDuration) => jobDuration.durationInHours)
      .reduce((value, element) => value + element);

  /// splits all entries into separate groups by date
  static Map<DateTime, List<JobEntry>> _entriesByDate(List<JobEntry> entries) {
    Map<DateTime, List<JobEntry>> map = {};
    for (var entryJob in entries) {
      final entryDayStart = DateTime(entryJob.entry.start.year,
          entryJob.entry.start.month, entryJob.entry.start.day);
      if (map[entryDayStart] == null) {
        map[entryDayStart] = [entryJob];
      } else {
        map[entryDayStart].add(entryJob);
      }
    }
    return map;
  }

  /// maps an unordered list of EntryJob into a list of DailyJobsDetails with date information
  static List<DailyJobsDetails> all(List<JobEntry> entries) {
    final byDate = _entriesByDate(entries);
    List<DailyJobsDetails> list = [];
    for (var date in byDate.keys) {
      final entriesByDate = byDate[date];
      final byJob = _jobsDetails(entriesByDate);
      list.add(DailyJobsDetails(date: date, jobsDetails: byJob));
    }
    return list.toList();
  }

  /// groups entries by job
  static List<JobDetails> _jobsDetails(List<JobEntry> entries) {
    Map<String, JobDetails> jobDuration = {};
    for (var entryJob in entries) {
      final entry = entryJob.entry;
      final pay = entry.duration * entryJob.job.ratePerHour;
      if (jobDuration[entry.jobID] == null) {
        jobDuration[entry.jobID] = JobDetails(
          name: entryJob.job.name,
          durationInHours: entry.duration,
          pay: pay,
        );
      } else {
        jobDuration[entry.jobID].pay += pay;
        jobDuration[entry.jobID].durationInHours += entry.duration;
      }
    }
    return jobDuration.values.toList();
  }
}
