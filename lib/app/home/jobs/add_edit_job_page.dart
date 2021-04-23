import 'dart:async';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/jobs/job.dart';
import 'package:time_tracker/services/database.dart';

class AddOrEditJobPage extends StatefulWidget {
  const AddOrEditJobPage({Key key, @required this.database, this.job}) : super(key: key);
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, {Database database, Job job}) async{
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_)=>AddOrEditJobPage(database: database, job: job,),
        fullscreenDialog: true,
      )
    );
  }

  @override
  _AddOrEditJobPageState createState() => _AddOrEditJobPageState();
}

class _AddOrEditJobPageState extends State<AddOrEditJobPage> {
  final FocusNode _jobFocus= FocusNode();
  final FocusNode _rateFocus= FocusNode();
  bool isLoading= false;

  final _formKey= GlobalKey<FormState>();
  String _name;
  int _ratePerHour;

  @override
  void initState(){
    super.initState();
    if(widget.job!=null){
      _name= widget.job.name;
      _ratePerHour= widget.job.ratePerHour;
    }
  }

  bool validateForm(){
    final form= _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  void _jobNameEditComplete(String value){
    final newFocus= value.isNotEmpty ? _rateFocus : _jobFocus;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Future<void> _submit() async{
    setState(() {
      isLoading= true;
    });
    if(validateForm()){
        _name= _name.trim();
        bool jobExists= await widget.database.checkExisting(context, _name,
            widget.job==null?false:true);
        if(!jobExists){
          final jobID= widget.job?.jobID??documentID();
          final job = Job(name: _name, ratePerHour: _ratePerHour, jobID: jobID);
          await widget.database.setJob(job, context);
          Navigator.of(context).pop();
        }
        setState(() {
          isLoading= false;
        });
    }
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading ?
              SizedBox(
                  height:400,
                  child: Center(child: CircularProgressIndicator())
              )
                : _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  List<Widget> _buildChildren() {
    return [
      _buildJobField(),
      SizedBox(height: 8.0),
      _buildRateField(),
    ];
  }

  Widget _buildJobField() {
    return TextFormField(
      onSaved: (value)=>_name= value,
      initialValue: _name,
      validator: (value)=>value.isNotEmpty? null: "Job name can't be empty",
      decoration: InputDecoration(
        labelText: "Job",
        enabled: !isLoading,
      ),
      textInputAction: TextInputAction.next,
      focusNode: _jobFocus,
      onFieldSubmitted: _jobNameEditComplete,
    );
  }

  Widget _buildRateField() {
    return TextFormField(
      onSaved: (value)=>_ratePerHour= int.tryParse(value)??0,
      initialValue: _ratePerHour==null ? "" : _ratePerHour.toString(),
      decoration: InputDecoration(
        labelText: "Rate",
        enabled: !isLoading,
        hintText: "0.00",
      ),
      autocorrect: false,
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
      textInputAction: TextInputAction.done,
      focusNode: _rateFocus,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        title: Text(widget.job==null?"Add Job":"Edit ${widget.job.name}"),
        actions: [
          TextButton(
            onPressed: isLoading?null:_submit,
            child: Text(
              "Save",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(),
      backgroundColor: Colors.grey[200],
    );
  }




}
