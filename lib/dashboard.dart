import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_final_app_caucus/join_meeting.dart';
import 'package:the_final_app_caucus/join_meeting_screen.dart';
import 'package:the_final_app_caucus/login.dart';
import 'package:the_final_app_caucus/main_attendance_screen.dart';

import 'calendar.dart';
import 'classroom_folders_screen.dart';
import 'create_meeting_screen.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;

  _permissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.camera,
    ].request();
  }

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeOut);
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();

    this._permissions();
    initDynamicLinks();
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        print(deepLink.toString());
        var uri = Uri.parse(deepLink.toString());
        uri.queryParameters.forEach((k, id) {
          print('key: $k - value: $id');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => JoinMeeting(id)));
        });
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      print(deepLink.toString());
      var uri = Uri.parse(deepLink.toString());
      uri.queryParameters.forEach((k, id) {
        print('key: $k - value: $id');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => JoinMeeting(id)));
      });
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Caucus')),
        drawer: new Drawer(
          child: ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: Text("Caucus"),
                accountEmail: Text("Learn for GOOD "),
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: AssetImage("assets/pic2.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.class_),
                title: Text('Classes'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClassroomFolderScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Calendar'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Calendar()));
                },
              ),
              ListTile(
                leading: Icon(Icons.notification_important),
                title: Text('Notifications'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.book),
                title: Text('Attendance'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainAtdPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('Todo'),
                onTap: () => null,
              ),
              ListTile(
                  leading: Icon(Icons.folder),
                  title: Text('Classroom Folders'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClassroomFolderScreen()));
                  }),
              ListTile(
                leading: Icon(Icons.arrow_downward),
                title: Text('Downloads'),
                onTap: () => null,
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
                onTap: () => null,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () => null,
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
                onTap: () => null,
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  FirebaseAuth.instance.signOut().whenComplete(() {
                    doUserLogout();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false);
                  });
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset(
                    "assets/pic2.jpg",
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width - 25,
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.darken,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "Caucus",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0),
                  ),
                ),
                Center(
                  child: new MaterialButton(
                    color: Colors.teal,
                    textColor: Colors.white,
                    child: new Text("Join Meeting"),
                    onPressed: () async {
                      Map<Permission, PermissionStatus> statuses = await [
                        Permission.microphone,
                        Permission.camera,
                      ].request();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JoinMeetingLInk()));
                    },
                    splashColor: Colors.blueAccent,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                new MaterialButton(
                  color: Colors.teal,
                  textColor: Colors.white,
                  child: new Text("Create Meeting"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateMeeting()));
                  },
                  splashColor: Colors.blueAccent,
                ),
              ],
            ),
          ],
        )));
  }

  void doUserLogout() async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout();


  }
}
