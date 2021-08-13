import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_final_app_caucus/utils.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;
  TextEditingController emailController = new TextEditingController();

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

  _resetPassword(String email) {
    if (email.isEmpty) {
      Utils.showToast("Email Required");
      return;
    }

    isLoading = true;
    setState(() {});
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.sendPasswordResetEmail(email: email).then((value) {
      isLoading = false;
      setState(() {});
      Utils.showToast('Check email for password reset');
    }).catchError((onError) {
      isLoading = false;
      setState(() {});
      Utils.showToast("Unable to send reset email ${onError.toString()}");
    });
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
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlutterLogo(
                  size: _iconAnimation.value * 100,
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      )
                    : new Form(
                        child: new Theme(
                          data: new ThemeData(
                              brightness: Brightness.dark,
                              primarySwatch: Colors.teal,
                              inputDecorationTheme: new InputDecorationTheme(
                                  labelStyle: new TextStyle(
                                      color: Colors.teal, fontSize: 20.0))),
                          child: new Container(
                            padding: const EdgeInsets.all(40.0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new TextFormField(
                                  controller: emailController,
                                  decoration: new InputDecoration(
                                    labelText: "Enter email(required)",
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                new Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                ),
                                new MaterialButton(
                                  color: Colors.teal,
                                  textColor: Colors.white,
                                  child: new Text("Reset"),
                                  onPressed: () => _resetPassword(
                                      emailController.text.toString()),
                                  splashColor: Colors.blueAccent,
                                ),
                                new MaterialButton(
                                  color: Colors.teal,
                                  textColor: Colors.white,
                                  child: new Text("Cancel"),
                                  onPressed: () => Navigator.pop(context),
                                  splashColor: Colors.blueAccent,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ));
  }
}
