import 'package:flutter/material.dart';

class EmptyPageContents extends StatelessWidget {
  const EmptyPageContents({Key key, this.title="No Job added", this.message="Click the button to add a job"}) : super(key: key);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 16.0,),
          Text(
            message,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
