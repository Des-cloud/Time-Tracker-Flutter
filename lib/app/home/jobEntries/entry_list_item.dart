
import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/jobEntries/format.dart';
import 'package:time_tracker/app/home/jobs/job.dart';
import 'package:time_tracker/app/home/models/entry.dart';

class EntryListItem extends StatelessWidget {

  const EntryListItem({Key key, this.entry, this.job, this.onTap}) : super(key: key);
  final Entry entry;
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(child: _buildChildren(context)),
            Icon(Icons.chevron_right, color: Colors.grey,)
          ],
        ),
      ),
    );
  }

  Widget _buildChildren(BuildContext context){
    final weekDay= Format.dayOfWeek(entry.start);
    final startDate= Format.date(entry.start);
    final startTime= TimeOfDay.fromDateTime(entry.start).format(context);
    final endTime= TimeOfDay.fromDateTime(entry.end).format(context);
    final durationFormatted= Format.hours(entry.duration);

    final pay= job.ratePerHour * entry.duration;
    final payFormatted= Format.currency(pay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(weekDay, style: TextStyle(fontSize: 18.0, color: Colors.grey)),
          SizedBox(width: 15.0),
          Text(startDate, style: TextStyle(fontSize: 18.0)),
          if (job.ratePerHour > 0.0) ...<Widget>[
            Expanded(child: Container()),
            Text(
              payFormatted,
              style: TextStyle(fontSize: 16.0, color: Colors.green[700]),
            ),
          ],
        ]),
        Row(children: <Widget>[
          Text('$startTime - $endTime', style: TextStyle(fontSize: 16.0)),
          Expanded(child: Container()),
          Text(durationFormatted, style: TextStyle(fontSize: 16.0)),
        ]),
        if (entry.workDone.isNotEmpty)
          Text(
            entry.workDone,
            style: TextStyle(fontSize: 12.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
      ],
    );
  }
}

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem({
    this.key,
    this.entry,
    this.job,
    this.onDismissed,
    this.onTap,
  });

  final Key key;
  final Entry entry;
  final Job job;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(),
      child: EntryListItem(
        entry: entry,
        job: job,
        onTap: onTap,
      ),
    );
  }
}
