import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/services/Authentication.dart';
import 'package:time_tracker/widgets/alertDialog.dart';

class AccountPage extends StatelessWidget {

  Future<void> _logout(BuildContext context) async {
    final auth= Provider.of<AuthBaseClass>(context, listen: false);
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
      _logout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        centerTitle: true,
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
      body: _buildBody(context),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: ()=> AddOrEditJobPage.show(context, database: database),
      //   child: Icon(Icons.add),
      // ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container();
  }
}
