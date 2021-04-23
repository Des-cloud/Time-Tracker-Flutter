
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/jobs/job.dart';
import 'package:time_tracker/app/home/models/entry.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore.dart';
import 'package:time_tracker/widgets/alertDialog.dart';

abstract class Database {
  Future<void> setJob(Job job, BuildContext context);
  Future<void> deleteJob(BuildContext context, Job job);
  Stream<List<Job>> jobsStream();
  Stream<Job> jobStream({@required String jobID});
  Future<bool> checkExisting(BuildContext context, String name, bool flag);

  Future<void> setEntry(BuildContext context, Entry entry);
  Future<void> deleteEntry(BuildContext context, Entry entry);
  // Stream<List<Entry>> entriesStream({Job job});
  Stream<List<Entry>> streamOfEntries({Job job});
}
String documentID ()=> DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.userID}): assert(userID!=null);
  final String userID;

  final service= FirestoreService.instance;

  @override
  Future<void> setJob(Job job, BuildContext context) async{
    service.setData(
      context,
        path: APIPath.job(userID, job.jobID),
        data: job.toMap(),
    );
  }

  @override
  Future<void> deleteJob(BuildContext context, Job job) async{
    final allEntries= await streamOfEntries(job: job).first;
    for(Entry entry in allEntries){
      if(entry.jobID == job.jobID){
        await deleteEntry(context, entry);
      }
    }
    await service.deleteData(context, path: APIPath.job(userID, job.jobID));
  }

  @override
  Stream<Job> jobStream({@required String jobID}){
    return service.documentStream(
      path: APIPath.job(userID, jobID),
      builder: (data, documentID)=>Job.fromMap(data, documentID),
    );
  }

  @override
  Future<bool> checkExisting(BuildContext context, String name, bool flag) async{
    final jobs= await jobsStream().first;
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

  @override
  Stream<List<Job>> jobsStream()=>
    service.collectionStream(
        path: APIPath.jobs(userID),
        builder: (data, documentID)=>Job.fromMap(data, documentID),
    );

  @override
  Stream<List<Entry>> streamOfEntries({Job job}){
      return service.collectionStream(
        path: APIPath.entries(userID),
        builder: (data, documentID)=>Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
        queryBuilder: job!=null? (query)=>query.where("jobID", isEqualTo: job.jobID): null,
      );
  }

  @override
  Future<void> setEntry(BuildContext context, Entry entry){
    return service.setData(
      context,
      path: APIPath.entry(userID, entry.id),
      data: entry.toMap(),
    );
  }

  @override
  Future<void> deleteEntry(BuildContext context, Entry entry){
    return service.deleteData(context,
    path: APIPath.entry(userID, entry.id),
    );
  }

  // @override
  // Stream<List<Entry>> entriesStream({Job job}) {
  //     return service.collectionStream<Entry>(
  //       path: APIPath.entries(userID),
  //       // queryBuilder: job != null
  //       //     ? (query) => query.where('jobID', isEqualTo: job.jobID)
  //       //     : null,
  //       builder: (data, documentID) => Entry.fromMap(data, documentID),
  //       // sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
  //     );
  // }
}