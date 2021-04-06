import 'package:flutter/foundation.dart';

class Job{
  Job({@required this.jobID, @required this.name, @required this.ratePerHour});
  final String jobID;
  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data, String jobID){
    if(data==null) return null;
    final String name= data["name"];
    final int ratePerHour= data["ratePerHour"];

    return Job(name: name, ratePerHour: ratePerHour, jobID: jobID);
  }

  Map<String, dynamic> toMap(){
    return {
      "name": name,
      "ratePerHour": ratePerHour,
    };
  }
}