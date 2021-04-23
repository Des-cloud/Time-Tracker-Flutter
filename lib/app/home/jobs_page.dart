
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/jobEntries/job_entries.dart';
import 'package:time_tracker/app/home/jobs/add_edit_job_page.dart';
import 'package:time_tracker/app/home/jobs/job.dart';
import 'package:time_tracker/app/home/jobs/job_listView.dart';
import 'package:time_tracker/services/database.dart';
import 'package:time_tracker/widgets/list_item_builder.dart';

class JobsPage extends StatelessWidget {

  Future<void> _delete(BuildContext context, Job job) async{
    final database= Provider.of<Database>(context, listen: false);
    await database.deleteJob(context, job);
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Jobs"),
        centerTitle: true,
        elevation: 2.0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: ()=> AddOrEditJobPage.show(context, database: database),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context)
  {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot){
        return ListItemBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job)=>Dismissible(
            key: Key("job-${job.jobID}"),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction)=>_delete(context, job),
            child: JobListView(
                  jobName: job.name,
                  onTap: () => JobEntriesPage.show(context, job),
            ),
          )
        );
      },
    );
  }

}

