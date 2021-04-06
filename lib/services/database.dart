
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/jobs/job.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore.dart';
import 'package:time_tracker/widgets/alertDialog.dart';

abstract class Database {
  Future<void> setJob(Job job, BuildContext context);
  Stream<List<Job>> jobStream();
  Future<bool> checkExisting(BuildContext context, String name, bool flag);
}
String documentID ()=> DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.userID}): assert(userID!=null);
  final String userID;

  final service= FirestoreService.instance;

  Future<void> setJob(Job job, BuildContext context) async{
    service.setData(
      context,
        path: APIPath.job(userID, job.jobID),
        data: job.toMap(),
    );
  }

  Future<bool> checkExisting(BuildContext context, String name, bool flag) async{
    final jobs= await jobStream().first;
    final allNames= jobs.map((e) => e.name).toList();
    if(flag) allNames.remove(name);
    if(allNames.contains(name)){
      showAlertDialog(context,
          title: "Job already exist",
          content:"Add a new job or edit existing one",
          actionText: "OK",
      );
      return true;
    }
    return false;
  }

  Stream<List<Job>> jobStream()=>
    service.collectionStream(
        path: APIPath.jobs(userID),
        builder: (data, jobID)=>Job.fromMap(data, jobID),
    );

}