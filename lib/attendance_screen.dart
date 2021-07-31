import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_final_app_caucus/attendance.dart';
import 'package:the_final_app_caucus/models/meeting.dart';
import 'package:the_final_app_caucus/utils.dart';

class AttendanceScreen extends StatefulWidget {
  final Meeting meeting;

  AttendanceScreen(this.meeting);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool isLoading = true;
  var text = 'Getting Data';
  List<Attendance> students = [];

  @override
  void initState() {
    super.initState();

    this._uploadData();
  }

  _uploadData() async {
    isLoading = true;
    setState(() {});
    text = 'Getting Data';

    CollectionReference users = FirebaseFirestore.instance
        .collection('meetings')
        .doc(widget.meeting.id.toString())
        .collection('users');
    users.get().then((value) {
      for (DocumentSnapshot document in value.docs) {
        students.add(Attendance('id', document.get('name').toString(),
            document.get('join').toString(), document.get('left').toString()));
      }
      if(value.docs.isNotEmpty) {
        isLoading = false;

      } else{
        isLoading = true;
        setState(() {});
        text='No participant was in meeting';
      }

      setState(() {

      });
    }).catchError((error) {
      isLoading = true;
      setState(() {});
      text='Unable to Load Data';
      print(" $error");
      Utils.showToast(" $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Attendance'),
        ),
        body: isLoading
            ? Center(
                child: Text(
                  '$text',
                  style: TextStyle(color: Colors.red, fontSize: 20.0),
                ),
              )
            : ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, position) {
                  Attendance attendance = students[position];
                  return AttendanceTile(attendance.name, attendance.startTime,
                      attendance.endTime);
                },
              ),
      ),
    );
  }
}

class AttendanceTile extends StatelessWidget {
  final String name;
  final String startDate;
  final String endDate;

  AttendanceTile(this.name, this.startDate, this.endDate);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '$name',
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Join:$startDate \t\tEnd:$endDate'),
    );
  }
}
