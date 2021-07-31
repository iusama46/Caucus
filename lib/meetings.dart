
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_final_app_caucus/login.dart';
import 'package:the_final_app_caucus/meeting_screen.dart';


class Meetings extends StatefulWidget {
  Meetings({Key? key}) : super(key: key);

  @override
  _MeetingsState createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;
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
          new Form(
            child: new Theme(
              data: new ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.teal,
                inputDecorationTheme: new InputDecorationTheme(
                  labelStyle: new TextStyle(color: Colors.teal, fontSize: 30.0),
                ),
              ),
              child: new Container(
                //padding: const EdgeInsets.only(top: 10.0, left: 30.0),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new MaterialButton(
                      color: Colors.teal,
                      textColor: Colors.white,
                      child: new Text("Start"),
                      onPressed: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginPage()))
                      },
                      splashColor: Colors.blueAccent,
                    ),
                    new MaterialButton(
                      color: Colors.teal,
                      textColor: Colors.white,
                      child: new Text("Send Invitation"),
                      onPressed: () {},
                      splashColor: Colors.blueAccent,
                    ),
                    new MaterialButton(
                      color: Colors.teal,
                      textColor: Colors.white,
                      child: new Text("Edit"),
                      onPressed: () {},
                      splashColor: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
