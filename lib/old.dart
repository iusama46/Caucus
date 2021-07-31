import 'package:email_auth/email_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:the_final_app_caucus/forgot_passowrd.dart';
import 'package:the_final_app_caucus/utils.dart';

import 'login.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/signUp';

  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  TextEditingController passwordController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController confirm = new TextEditingController();
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;

  void sendOtp() async {
    FocusScope.of(context).requestFocus(FocusNode());
    EmailAuth.sessionName = "Caucus";

    var data =
    await EmailAuth.sendOtp(receiverMail: 'iusama46@gmail.com');
    if (!data) {
      Utils.showToast('Unable to send otp ${data.toString()}');
    } else {
      Utils.showToast('Check your email for verification code');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ForgotPassword(
                  nameController.text.toString(),
                  emailController.text.toString(),
                  passwordController.text.toString())));
    }
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

  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.black,
        body: new Stack(fit: StackFit.expand, children: <Widget>[
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
                new Form(
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
                                  controller: nameController,
                                  decoration: new InputDecoration(
                                    labelText: "Enter Name",
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                                new TextFormField(
                                  controller: emailController,
                                  decoration: new InputDecoration(
                                    labelText: "Enter email",
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty || value.contains('@')) {
                                      return 'invalid email';
                                    }
                                    return null;
                                  },
                                ),
                                new TextFormField(
                                  decoration: new InputDecoration(
                                      labelText: "Password", hintText: "xxxx"),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length <= 5) {
                                      return 'invalid password';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: confirm,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      labelText: "Confirm Password",
                                      hintText: "xxxx"),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        value != passwordController.text) {
                                      return 'invalid password';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {},
                                ),
                                new MaterialButton(
                                  color: Colors.teal,
                                  textColor: Colors.white,
                                  child: new Text("Sign up"),
                                  onPressed: () {
                                    if (passwordController.text ==
                                        confirm.text &&
                                        confirm.text.isNotEmpty) {
                                      if (passwordController.text.length > 5) {
                                        sendOtp();
                                      } else {
                                        Utils.showToast(
                                            'Password must has 6 or more characters');
                                      }
                                    } else {
                                      Utils.showToast(
                                          'Password mismatch or missing');
                                    }
                                  },
                                  splashColor: Colors.blueAccent,
                                ),
                                new MaterialButton(
                                  color: Colors.teal,
                                  textColor: Colors.white,
                                  child: new Text("Cancel"),
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()))
                                  },
                                  splashColor: Colors.blueAccent,
                                ),
                              ]),
                        ))),
              ]),
        ]));
  }
}
