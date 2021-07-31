import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:the_final_app_caucus/meeting_screen.dart';
import 'package:the_final_app_caucus/models/meeting.dart';
import 'package:the_final_app_caucus/models/user.dart';
import 'package:the_final_app_caucus/utils.dart';

import 'main.dart';

class JoinMeetingLInk extends StatefulWidget {
  @override
  _JoinMeetingLInkState createState() => _JoinMeetingLInkState();
}

class _JoinMeetingLInkState extends State<JoinMeetingLInk>
    with SingleTickerProviderStateMixin {
  bool isSwitchedAudio = false;
  bool isSwitchedVideo = false;
  final nameController = TextEditingController();
  final urlController = TextEditingController();


  late MeetingUser meetingUser;
  late Meeting meeting;



  get primary => null;
  bool isLoading = false;

  String text = '';

  @override
  void dispose() {
    nameController.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    meeting = new Meeting('id', 'name',' room',' url',false);
    meetingUser = new MeetingUser('id',' name',' email');
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => MyApp()));
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                )),
            SizedBox(
              width: 45,
            ),
            Text(
              "Join a Meeting",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: Text(
              '$text',
              style: TextStyle(fontSize: 20.0, color: Colors.red),
            ))
          : Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                    height: 50,
                    decoration: BoxDecoration(color: Colors.teal),
                    child: Row(
                      children: [
                        Container(
                          width: size.width * 0.1,
                          height: 40,
                        ),
                        Container(
                          width: size.width * 0.9,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: TextField(
                              textAlign: TextAlign.center,
                              cursorColor: primary,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Meeting Id",
                                hintStyle: TextStyle(color: Colors.white),
                                suffixIcon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                    height: 50,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      children: [
                        Container(
                          width: size.width * 0.1,
                          height: 40,
                        ),
                        Container(
                          width: size.width * 0.9,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: TextField(
                              controller: urlController,
                              textAlign: TextAlign.center,
                              cursorColor: primary,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter personal meeting url ',
                                hintStyle: TextStyle(color: Colors.teal),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                    height: 50,
                    decoration: BoxDecoration(color: Colors.teal),
                    child: Row(
                      children: [
                        Container(
                          width: size.width * 0.1,
                          height: 40,
                        ),
                        Container(
                          width: size.width * 0.9,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: TextField(
                              controller: nameController,
                              textAlign: TextAlign.center,
                              cursorColor: primary,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Your Name",
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new MaterialButton(
                        color: Colors.teal,
                        textColor: Colors.white,
                        child: new Text("Join"),
                        onPressed: () => _connectMeeting(
                            nameController.text.toString(),
                            urlController.text.toString()),
                        splashColor: Colors.blueAccent,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 100,
                  thickness: 0.2,
                  color: Colors.white,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(color: Colors.teal),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Turn Off My Video",
                          style: TextStyle(
                              color: Colors.white,
                              height: 1.3,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        Switch.adaptive(
                          activeColor: primary,
                          value: isSwitchedVideo,
                          onChanged: (value) {
                            setState(() =>
                                {this.isSwitchedVideo = !this.isSwitchedVideo});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  decoration: BoxDecoration(color: Colors.teal),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Don't Connect to Audio",
                          style: TextStyle(
                              color: Colors.white,
                              height: 1.3,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        Switch.adaptive(
                          activeColor: primary,
                          value: isSwitchedAudio,
                          onChanged: (value) {
                            setState(() =>
                                {this.isSwitchedAudio = !this.isSwitchedAudio});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  _connectMeeting(var name,var url) async {
    FocusScope.of(context).requestFocus(FocusNode());
    await Permission.microphone.request();
    await Permission.camera.request();
    print('clima 2');

    if (url.toString().isEmpty) {
      Utils.showToast('Url is missing');
      return;
    }

    if (name.toString().isEmpty) {
      Utils.showToast('Name is missing');
      return;
    }

    bool isCorrect = Uri.tryParse(url.toString())?.hasAbsolutePath ?? false;

    if (!isCorrect) {
      Utils.showToast('Url is invalid');
      return;
    } else {
      text = 'Checking Url..';
      isLoading = true;
      setState(() {});

      http.Request req = http.Request("Get", Uri.parse(url.toString()))
        ..followRedirects = false;
      http.Client baseClient = http.Client();
      http.StreamedResponse response = await baseClient.send(req);

      Uri redirectUri = Uri.parse(response.headers['location'].toString());
      print(redirectUri.toString());

      var meetingId = '';
      redirectUri.queryParameters.forEach((k, id) {
        print('key: $k - value: $id');
        meetingId = id;
      });

      var document =
          FirebaseFirestore.instance.collection('meetings').doc(meetingId);
      document.get().then((value) {
        print(value["link"].toString());

        meeting.id = meetingId;
        meeting.name = value['meetingName'].toString();

        meeting.url = value['link'].toString();
        meeting.room = value['channel'].toString();
        isLoading = true;
        text = 'Getting Meeting Details...';
        setState(() {});

        //text = 'Connecting...';
        final FirebaseAuth auth = FirebaseAuth.instance;
        final User user = auth.currentUser!;

        meetingUser.id = user.uid;
        meetingUser.email = user.email.toString();
        meetingUser.name = name;

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MeetingScreen(meeting, meetingUser))).whenComplete(() {
          //isLoading = false;
          Navigator.pop(context);

        CollectionReference meetings = FirebaseFirestore.instance
            .collection('meetings')
            .doc(meetingId)
            .collection("users");
        meetings.add({
          "name": meetingUser.name,
          "id": meetingUser.id,
        }).whenComplete(() {
          print('clima added');


            //setState(() {});
          });
        }).catchError((error) {
          isLoading = false;
          setState(() {});
          print("Failed : $error");
          Utils.showToast("Failed : $error");
        });
      }).catchError((error) {
        isLoading = false;
        setState(() {});
        print("Failed : $error");
        Utils.showToast("Failed : $error");
      });
    }
  }
}
