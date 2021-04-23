import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/jobEntries/entry_list_item.dart';
import 'package:time_tracker/app/home/jobEntries/entry_page.dart';
import 'package:time_tracker/app/home/jobs/add_edit_job_page.dart';
import 'package:time_tracker/app/home/jobs/job.dart';
import 'package:time_tracker/app/home/models/entry.dart';
import 'package:time_tracker/services/database.dart';
import 'package:time_tracker/widgets/list_item_builder.dart';


class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({@required this.database, @required this.job});
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
      await database.deleteEntry(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
        stream: database.jobStream(jobID: job.jobID),
        builder: (context, snapshot) {
          final job = snapshot.data;
          final jobName = job?.name ?? '';
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(jobName),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () => AddOrEditJobPage.show(
                    context,
                    database: database,
                    job: job,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () => EntryPage.show(
                    context: context,
                    database: database,
                    job: job,
                  ),
                ),
              ],
            ),
            body: _buildBody(context, job),
            // floatingActionButton: FloatingActionButton(
            //   child: Icon(Icons.add, color: Colors.white),
            //   onPressed: () => EntryPage.show(context: context,
            //       database: database,
            //       job: job,
            //     ),
            // ),
          );
        });
  }

  Widget _buildBody(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.streamOfEntries(job: job),
      builder: (context, snapshot) {
        return ListItemBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}