import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'attendance_screen.dart';

class MainAtdPage extends StatefulWidget {
  const MainAtdPage({Key? key}) : super(key: key);

  @override
  _MainAtdPageState createState() => _MainAtdPageState();
}

class _MainAtdPageState extends State<MainAtdPage> {
  late User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: SafeArea(
        child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('meetings')
                .where('uId', isEqualTo: user.uid.toString())
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError || !snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                );
              } else if (snapshot.data!.docs.length == 0) {
                return Center(
                  child: Text(
                    'No Data..',
                    style: TextStyle(fontSize: 16.0),
                  ),
                );
              }
              final List<DocumentSnapshot> documents = snapshot.data!.docs;
              return ListView(
                  children: documents
                      .map((doc) => Card(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AttendanceScreen(doc.id)));
                              },
                              child: ListTile(
                                title: Text(doc['date']),
                              ),
                            ),
                          ))
                      .toList());
            }),
      ),
    );
  }
}

class AttendanceScreen extends StatefulWidget {
  final String meetingID;

  AttendanceScreen(this.meetingID);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: SafeArea(
        child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('meetings')
                .doc(widget.meetingID)
                .collection('users')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError ||
                  !snapshot.hasData ) {
                return Center(
                  child: Text(
                    'Loading...',
                    style: TextStyle(fontSize: 16.0),
                  ),
                );
              }

              else if (snapshot.data!.docs.length == 0) {
                return Center(
                  child: Text(
                    'No Data..',
                    style: TextStyle(fontSize: 16.0),
                  ),
                );
              }

              final List<DocumentSnapshot> documents = snapshot.data!.docs;
              return ListView(
                  children: documents
                      .map((doc) => Card(
                            child: AttendanceTile(
                                doc['name'], doc['join'], doc['left']),
                          ))
                      .toList());
            }),
      ),
    );
  }
}
