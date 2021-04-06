
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore.dart';

abstract class Database {
  Future<void> createJob(Job job, BuildContext context);
  Stream<List<Job>> jobStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.userID}): assert(userID!=null);
  final String userID;

  final service= FirestoreService.instance;

  Future<void> createJob(Job job, BuildContext context) async{
    service.setData(
        context,
        path: APIPath.job(userID, "job_abc"),
        data: job.toMap(),
    );
  }

  Stream<List<Job>> jobStream()=>
    service.collectionStream(path: APIPath.jobs(userID), builder: (data)=>Job.fromMap(data));

}