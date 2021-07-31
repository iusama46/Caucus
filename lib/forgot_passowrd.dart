import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_final_app_caucus/utils.dart';

import 'dashboard.dart';

class ForgotPassword extends StatefulWidget {
  final name;
  final email;
  final password;

  ForgotPassword(this.name, this.email, this.password);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController verificationController = new TextEditingController();


  bool verify() {
    return (EmailAuth.validate(
      receiverMail: widget.email.toString(),
      userOTP: verificationController.value.text,
    ));
  }

  Future createUser(String name, String email, String password) async {
    FocusScope.of(context).requestFocus(FocusNode());

    if(!verify()){
      Utils.showToast('Unable to verify email');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if(! userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();

      FocusScope.of(context).requestFocus(FocusNode());
      DocumentReference meetings =
      FirebaseFirestore.instance.collection('users').doc(
          userCredential.user!.uid.toString());
      meetings.set({"name": name, "email": email,}).then((
          value) {
        Utils.showToast("User Registered");
        print("user Added");
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      }).catchError((error) => print("Failed to add user: ${error.toString()}"));}
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Utils.showToast('The password provided is too weak.');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Utils.showToast('The account already exists for that email.');
        print('The account already exists for that email.');
      }
    } catch (e) {
      print('${e.toString()}');
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  decoration: new InputDecoration(
                                      labelText: "Verification Code",
                                      hintText: "xxxx"),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  controller: verificationController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'invalid verification code';
                                    }
                                    return null;
                                  },
                                ),
                                new MaterialButton(
                                  color: Colors.teal,
                                  textColor: Colors.white,
                                  child: new Text("SignUp"),
                                  onPressed: ()  {
                                    if (verificationController.text.isEmpty)
                                      {
                                        Utils.showToast('Verification Code Required');
                                      }
                                    else
                                      {
                                            createUser(
                                                widget.name,
                                                widget.email,
                                                widget.password);
                                      }
                                    // if ()
                                    //   {
                                    //     // createUser(
                                    //     //     nameController.text,
                                    //     //     emailController.text,
                                    //     //     verificationController.text),
                                    //     print("user created")
                                    //   } else{
                                    //
                                    // }
                                  },
                                  splashColor: Colors.blueAccent,
                                ),
                              ]),
                        ))),
              ]),
        ]));
  }
}
