
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/widgets/showExceptionAlertDialog.dart';

class FirestoreService{
  FirestoreService._();
  static final instance= FirestoreService._();

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String jobID) builder,
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort})
  {
    Query query= FirebaseFirestore.instance.collection(path);
    if(queryBuilder!=null){
      query= queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
    // final reference= FirebaseFirestore.instance.collection(path);
    // final snapshots= reference.snapshots();
    // return snapshots.map(
    //       (snapshot) => snapshot.docs.map(
    //           (e)=> builder(e.data(), e.id)
    //   ).toList(),
    // );
  }

  Future<void> setData(BuildContext context, {@required String path,
    @required Map<String, dynamic> data})
  async{
    final reference= FirebaseFirestore.instance.doc(path);
    try {
      await reference.set(data);
    }on FirebaseException catch(e){
      showExceptionAlertDialog(context, title: "Operation Failed", exception: e);
    }
  }

  Future<void> deleteData(BuildContext context, {@required String path}) async{
    final reference= FirebaseFirestore.instance.doc(path);
    try {
      await reference.delete();
    }on FirebaseException catch(e){
      showExceptionAlertDialog(context, title: "Operation Failed", exception: e);
    }
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

}