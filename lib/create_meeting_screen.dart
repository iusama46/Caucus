import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_final_app_caucus/meeting_screen.dart';
import 'package:the_final_app_caucus/models/meeting.dart';
import 'package:the_final_app_caucus/models/user.dart';
import 'package:the_final_app_caucus/utils.dart';

class CreateMeeting extends StatefulWidget {
  CreateMeeting({Key? key}) : super(key: key);

  @override
  _CreateMeetingState createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting>
    with SingleTickerProviderStateMixin {
  TextEditingController nameController = new TextEditingController();
  TextEditingController sectionController = new TextEditingController();
  TextEditingController roomController = new TextEditingController();
  TextEditingController subjectController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;
  late var text;

  Future createMeeting(className, section, room, subject, meetingPass) async {
    if (className.toString().isEmpty ||
        section.toString().isEmpty ||
        room.toString().isEmpty ||
        subject.toString().isEmpty ||
        meetingPass.toString().isEmpty) {
      Utils.showToast('All Fields Required');
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    await Permission.microphone.request();
    await Permission.camera.request();

    text = 'Creating Meeting...';
    isLoading = true;

    setState(() {});

    String channel = Utils.channelId;

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;

    MeetingUser meetingUser = new MeetingUser(user.uid.toString(), '', user.email.toString());
    DocumentReference users = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid);
    users.get().then((value) {

      meetingUser.name = value.get('name').toString();

      text = 'Please Wait';
      setState(() {});

      var meetingName = '$className [$section] [$subject]';
      CollectionReference meetings =
          FirebaseFirestore.instance.collection('meetings');
      meetings.add({
        "class_name": className,
        "section": section,
        "room": room,
        "subject": subject,
        "pass": meetingPass,
        'channel': channel,
        'meetingName': meetingName,
        'createdBy': user.uid
      }).then((value) {
        String meetingId = value.id;
        print(meetingId);
        print("meeting Added to firebase");
        final DynamicLinkParameters parameters = DynamicLinkParameters(
          uriPrefix: 'https://caucusflutter.page.link/',
          link: Uri.parse(
              'https://subdomainapp.example.com/product?id=$meetingId'),
          androidParameters: AndroidParameters(
            packageName: 'com.example.the_final_app_caucus',
            minimumVersion: 1,
          ),
          iosParameters: IosParameters(
            bundleId: 'com.example.ios',
            minimumVersion: '1.0.1',
            appStoreId: '123456789',
          ),
          googleAnalyticsParameters: GoogleAnalyticsParameters(
            campaign: 'example-promo',
            medium: 'social',
            source: 'orkut',
          ),
          itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
            providerToken: '123456',
            campaignToken: 'example-promo',
          ),
          socialMetaTagParameters: SocialMetaTagParameters(
            title: 'Caucus ',
            description: 'Meeting Application',
          ),
        );

        parameters.buildShortLink().then((value) {
          final Uri shortUrl = value.shortUrl;
          print(shortUrl);
          meetings.doc(meetingId).update({
            'link': shortUrl.toString(),
          }).whenComplete(() {

            Clipboard.setData(ClipboardData(text: shortUrl.toString())).whenComplete(() {
              Utils.showToast('Meeting Invitation Link Copied to Clipboard');
            });
            Meeting meeting = new Meeting(
                meetingId, meetingName, channel, shortUrl.toString(), true);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MeetingScreen(meeting, meetingUser))).then((value) {
              Navigator.pop(context);
              //isLoading=false;
              // setState(() {
              //
              // });
            });
          });
        });
      }).catchError((error) {
        isLoading = false;
        setState(() {});
        print("Failed to add meeting: $error");
        Utils.showToast("Failed to add meeting: $error");
      });
    }).catchError((error) {
      isLoading = false;
      setState(() {});
      print("Failed to add meeting: $error");
      Utils.showToast("Failed to add meeting: $error");
    });
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
  }

  bool isLoading = false;
  bool _passwordVisible = true;

  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("assets/pic2.jpg"),
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          isLoading
              ? Center(
                  child: Text(
                  text,
                  style: TextStyle(fontSize: 20.0, color: Colors.red),
                ))
              : new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new FlutterLogo(
                      size: _iconAnimation.value * 50,
                    ),
                    new Form(
                      child: new Theme(
                        data: new ThemeData(
                            brightness: Brightness.dark,
                            primarySwatch: Colors.teal,
                            inputDecorationTheme: new InputDecorationTheme(
                                labelStyle: new TextStyle(
                                    color: Colors.teal, fontSize: 20.0))),
                        child: new Container(
                          padding: const EdgeInsets.all(22.0),
                          alignment: Alignment.center,
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new TextFormField(
                                controller: nameController,
                                decoration: new InputDecoration(
                                  labelText: "Class Name(required)",
                                ),
                                keyboardType: TextInputType.text,
                              ),
                              new TextFormField(
                                controller: sectionController,
                                decoration: new InputDecoration(
                                  labelText: "Section",
                                ),
                                keyboardType: TextInputType.text,
                                obscureText: false,
                              ),
                              new TextFormField(
                                controller: roomController,
                                decoration: new InputDecoration(
                                  labelText: "Room",
                                ),
                                keyboardType: TextInputType.text,
                              ),
                              new TextFormField(
                                controller: subjectController,
                                decoration: new InputDecoration(
                                  labelText: "Subject",
                                ),
                                keyboardType: TextInputType.text,
                              ),
                              new TextFormField(
                                obscureText: _passwordVisible,
                                decoration: new InputDecoration(
                                  labelText: "Meeting Password",
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                controller: passwordController,
                                validator: (value) {
                                  if (value!.isEmpty || value.length <= 5) {
                                    return 'invalid password';
                                  }
                                  return null;
                                },
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                              ),
                              new MaterialButton(
                                color: Colors.teal,
                                textColor: Colors.white,
                                child: new Text("Done"),
                                onPressed: () => {
                                  print(nameController.text),
                                  createMeeting(
                                      nameController.text,
                                      sectionController.text,
                                      roomController.text,
                                      subjectController.text,
                                      passwordController.text),
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
