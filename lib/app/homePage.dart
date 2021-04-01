
import 'package:flutter/material.dart';
import 'package:time_tracker/services/Authentication.dart';
import 'package:time_tracker/widgets/alertDialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key, @required this.auth}) : super(key: key);
  final AuthBaseClass auth;

  Future<void> _logout() async {
    try {
      await auth.logout();
    } catch (e){
      print(e.toString());
    }
  }

  Future<void> confirmSignOut(BuildContext context) async{
    final bool hasRequestSignOut=
        await showAlertDialog(context, title: "Logout", content: "Confirm logout?", actionText: "Confirm", cancelActionText: "Cancel");
    if(hasRequestSignOut==true){
      _logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: false,
        elevation: 2.0,
        actions: [
          TextButton(
              onPressed: ()=>confirmSignOut(context),
              child: Text(
                  "Logout",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                ),
              ),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 100.0,
          height: 100.0,
          child: CircularProgressIndicator(
            value: null,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
            strokeWidth: 10.0,
          ),
        ),
      ),
    );
  }
}
