
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showAlertDialog(
  BuildContext context,
  {@required String title, @required String content,
    @required String actionText, String cancelActionText }
){
  if(Platform.isAndroid){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              if(cancelActionText != null)
                TextButton(onPressed: ()=>Navigator.of(context).pop(false), child: Text(cancelActionText)),
              TextButton(onPressed: ()=>Navigator.of(context).pop(true), child: Text(actionText)),
            ],
          );
        }
    );
  }else{
    return showDialog(
        context: context,
        builder: (context){
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              if(cancelActionText != null)
                CupertinoDialogAction(onPressed: ()=>Navigator.of(context).pop(false), child: Text(cancelActionText)),
              CupertinoDialogAction(onPressed: ()=>Navigator.of(context).pop(true), child: Text(actionText)),
            ],
          );
        }
    );
  }
}