
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/widgets/showExceptionAlertDialog.dart';

class FirestoreService{
  FirestoreService._();
  static final instance= FirestoreService._();

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String jobID) builder}){
    final reference= FirebaseFirestore.instance.collection(path);
    final snapshots= reference.snapshots();
    return snapshots.map(
          (snapshot) => snapshot.docs.map(
              (e)=> builder(e.data(), e.id)
      ).toList(),
    );
  }

  Future<void> setData(BuildContext context, {String path, Map<String, dynamic> data}) async{
    final reference= FirebaseFirestore.instance.doc(path);
    try {
      await reference.set(data);
    }on FirebaseException catch(e, s){
      print(s);
      showExceptionAlertDialog(context, title: "Operation Failed", exception: e);
    }
  }
}