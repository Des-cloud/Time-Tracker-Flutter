
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/widgets/alertDialog.dart';

Future<void> showExceptionAlertDialog(BuildContext context,
  {@required String title, @required Exception exception}){
    return showAlertDialog(context, title: title, content: message(exception), actionText: "OK");
}

String message(Exception exception){
    if(exception is FirebaseAuthException) {
        return exception.message;
    }else if(exception is FirebaseException){
        return exception.message;
    }
    return exception.toString();
}