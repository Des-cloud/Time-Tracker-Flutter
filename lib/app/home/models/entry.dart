import 'package:flutter/foundation.dart';

class Entry {

  Entry({@required this.id, @required this.jobID,
    @required this.workDone, @required this.start, @required this.end});
  String id;
  String jobID;
  String workDone;
  DateTime start;
  DateTime end;

  double get duration=> end.difference(start).inMinutes/60.0;

  factory Entry.fromMap(Map<dynamic, dynamic> value, String id){
    final int startInMilliseconds= value["start"];
    final int endInMilliseconds= value["end"];
    return Entry(
      id: id,
      jobID: value["jobID"],
      start: DateTime.fromMillisecondsSinceEpoch(startInMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endInMilliseconds),
      workDone: value["workDone"]
    );
  }

  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      "jobID": jobID,
      "start": start.millisecondsSinceEpoch,
      "end": end.millisecondsSinceEpoch,
      "workDone": workDone
    };
  }
}