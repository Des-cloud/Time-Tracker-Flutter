
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/jobs/add_edit_job_page.dart';
import 'package:time_tracker/app/home/jobs/job.dart';
import 'package:time_tracker/app/home/jobs/job_listView.dart';
import 'package:time_tracker/services/Authentication.dart';
import 'package:time_tracker/widgets/alertDialog.dart';
import 'package:time_tracker/services/database.dart';
import 'package:time_tracker/widgets/list_item_builder.dart';

class JobsPage extends StatelessWidget {

  Future<void> _logout(BuildContext context) async {
    final auth= Provider.of<AuthBaseClass>(context, listen: false);
    try {
      await auth.logout();
    } catch (e){
      print(e.toString());
    }
  }

  Future<void> confirmSignOut(BuildContext context) async{
    final bool hasRequestSignOut=
        await showAlertDialog(context, title: "Logout", content: "Confirm logout?", actionText: "Confirm", cancelActionText: "Cancel");
    if(hasRequestSignOut==true){
      _logout(context);
    }
  }

  Future<void> _delete(BuildContext context, Job job) async{
    final database= Provider.of<Database>(context, listen: false);
    await database.deleteJob(context, job);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jobs"),
        centerTitle: true,
        elevation: 2.0,
        actions: [
          TextButton(
              onPressed: ()=>confirmSignOut(context),
              child: Text(
                  "Logout",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                ),
              ),
          ),
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>AddOrEditJobPage.show(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context)
  {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobStream(),
      builder: (context, snapshot){
        return ListItemBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job)=>Dismissible(
            key: Key("job-${job.jobID}"),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction)=>_delete(context, job),
            child: JobListView(
                  job: job,
                  onTap: () => AddOrEditJobPage.show(context, job: job),
            ),
          )
        );
      },
    );
  }

}

