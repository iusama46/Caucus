import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:the_final_app_caucus/main.dart';
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
  bool isLoading = false;

  Future createUser(String name, String email, String password) async {
    FocusScope.of(context).requestFocus(FocusNode());

    if(name.isEmpty || password.isEmpty||email.isEmpty){
      Utils.showToast('All fields required');
      return;
    }
    isLoading = true;
    setState(() {});
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      ParseUser user = ParseUser.createUser(userCredential.user!.uid.toString(), userCredential.user!.uid.toString(), email);

      var response = await user.signUp();
      if (response.success) {
        FocusScope.of(context).requestFocus(FocusNode());
        DocumentReference meetings = FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid.toString());
        meetings.set({
          "name": name,
          "email": email,
        }).then((value) {
          isLoading = false;
          setState(() {});
          //Utils.showToast("User Registered");
          //Utils.showToast('Check your email for verification');
          print("user Added");
           FirebaseAuth.instance.signOut();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CheckEmailPage()));
        }).catchError((error) {
          print("Failed to add user: ${error.toString()}");
          isLoading = false;
          setState(() {});

          Utils.showToast("Failed to add user: ${error.toString()}");
        });
      } else {
        isLoading=false;
        setState(() {

        });
        Utils.showToast( response.error!.message);
      }



    } on FirebaseAuthException catch (e) {
      isLoading = false;
      setState(() {});
      if (e.code == 'weak-password') {
        Utils.showToast('The password provided is too weak.');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Utils.showToast('The account already exists for that email.');
        print('The account already exists for that email.');
      }
    } catch (e) {
      isLoading = false;
      setState(() {});
      Utils.showToast('${e.toString()}');
      print(e);
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
        body: Stack(fit: StackFit.expand, children: <Widget>[
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
              : Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
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
                                      if (value!.isEmpty ||
                                          value.contains('@')) {
                                        return 'invalid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  new TextFormField(
                                    decoration: new InputDecoration(
                                        labelText: "Password",
                                        hintText: "xxxx"),
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
                                    onPressed: () => {
                                      if (passwordController.text ==
                                              confirm.text &&
                                          confirm.text.isNotEmpty)
                                        {
                                          createUser(
                                              nameController.text,
                                              emailController.text,
                                              passwordController.text),
                                          print("user created")
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
                                              builder: (context) =>
                                                  LoginPage()))
                                    },
                                    splashColor: Colors.blueAccent,
                                  ),
                                ]),
                          ))),
                ]),
        ]));
  }
}
