import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/services/Authentication.dart';
import 'package:time_tracker/widgets/alertDialog.dart';
import 'package:time_tracker/widgets/avatar.dart';

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
    final auth= Provider.of<AuthBaseClass>(context, listen: false);
    User user= auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        centerTitle: true,
        elevation: 2.0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 30.0,
                  semanticLabel: "Logout",
              ),
              onPressed: ()=>confirmSignOut(context),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: Column(
            children: [
              Avatar(
                photoUrl: user.photoURL,
                radius: 50.0,
              ),
              SizedBox(height: 10.0,),
              if(user.displayName!=null)
                Text(
                  user.displayName,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              SizedBox(height: 8,),
            ],
          ),
        ),
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
