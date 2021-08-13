import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:the_final_app_caucus/signup.dart';
import 'package:the_final_app_caucus/utils.dart';

import 'User_Model.dart';
import 'dashboard.dart';
import 'reset_password.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/Login';

  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  TextEditingController emailTC = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  bool isLoading = false;

  user_model us = new user_model();
  String user_pass = "";

  login() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (emailTC.text.isEmpty || pass.text.isEmpty) {
      Utils.showToast("All Fields are Required ");
      return;
    }
    try {
      isLoading = true;
      setState(() {});
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailTC.text, password: pass.text);

      final user = ParseUser(userCredential.user!.uid, userCredential.user!.uid,
          emailTC.text.toString());
      var response = await user.login();
      if (response.success) {
        Utils.showToast('Logged In');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        isLoading = false;
        setState(() {});
        Utils.showToast(response.error!.message);
        try {
          FirebaseAuth.instance.signOut();
        } catch (e) {}
      }
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      setState(() {});
      if (e.code == 'user-not-found') {
        Utils.showToast('No user found for that email.');
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Utils.showToast('Wrong password provided for that user.');
        print('Wrong password provided for that user.');
      }
    }

    // final String api = "http://localhost:3000/user/login";
    // final response = await http.post(Uri.parse(api), body: {"email": email});
    // print(response.body);
    // var decode = json.decode(response.body);
    // setState(() {
    //   us = user_model.fromJson(decode[0]);
    //   print(us.password);
    //   user_pass = us.password;
    // });

    isLoading = false;
    setState(() {});
  }

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
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                )
              : SingleChildScrollView(
                  child: new Column(
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
                                  controller: emailTC,
                                  decoration: new InputDecoration(
                                    labelText: "Enter Email",
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty || value.contains('@')) {
                                      return 'invalid email';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {},
                                ),
                                new TextFormField(
                                  controller: pass,
                                  decoration: new InputDecoration(
                                    labelText: "Password",
                                  ),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
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
                                  child: new Text("Login"),
                                  onPressed: () async {
                                    print(emailTC.text);
                                    await login();
                                  },
                                  splashColor: Colors.blueAccent,
                                ),
                                SizedBox(height: 10),
                                new MaterialButton(
                                  color: Colors.teal,
                                  textColor: Colors.white,
                                  child: new Text("Signup"),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignUp()));
                                  },
                                  splashColor: Colors.blueAccent,
                                ),
                                Container(
                                  alignment: Alignment(1.0, 0.0),
                                  padding:
                                      EdgeInsets.only(top: 15.0, left: 20.0),
                                  child: InkWell(
                                    child: Text(
                                      ("Forgot Password?"),
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Montserrat',
                                          decoration: TextDecoration.underline),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ResetPasswordScreen()));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
