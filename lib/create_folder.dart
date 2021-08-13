import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_string/random_string.dart';
import 'package:share_plus/share_plus.dart';
import 'package:the_final_app_caucus/utils.dart';

class CreateFolder extends StatefulWidget {
  @override
  _CreateFolderState createState() => _CreateFolderState();
}

class _CreateFolderState extends State<CreateFolder>
    with SingleTickerProviderStateMixin {
  TextEditingController subjectController = new TextEditingController();
  TextEditingController classNameController = new TextEditingController();
  TextEditingController sectionController = new TextEditingController();
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;
  bool isLoading = false;

  Future createFolder(String name, String section, String subject) async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (name.isEmpty || subject.isEmpty || section.isEmpty) {
      Utils.showToast('All fields required');
      return;
    }
    isLoading = true;
    setState(() {});
    try {
      String classCode = randomAlphaNumeric(6);
      String classPassword = randomAlphaNumeric(6);

      User? user = FirebaseAuth.instance.currentUser;

      CollectionReference folderCollection =
          FirebaseFirestore.instance.collection('folders');

      folderCollection.add({
        "name": name.toLowerCase(),
        "section": section,
        "subject": subject,
        "uId": user!.uid,
        "classCode": classCode,
        "classPassword": classPassword,
        'date': DateTime.now().toIso8601String(),
      }).then((value) {
        isLoading = false;
        setState(() {});

        ///dialog
        showAlertDialog(context, classCode, classPassword);
      }).catchError((error) {
        print("Failed to create folder: ${error.toString()}");
        isLoading = false;
        setState(() {});
        Utils.showToast("Failed to create folder: ${error.toString()}");
      });
    } catch (e) {
      isLoading = false;
      setState(() {});
      Utils.showToast('${e.toString()}');
      print(e);
    }
  }

  showAlertDialog(
      BuildContext context, String classCode, String classPassword) {
    String text = "Class Code: $classCode \nClass Password: $classPassword";
    Widget shareButton = TextButton(
      child: Text("Share"),
      onPressed: () => Share.share('ClassRoom Folder on Caucus \n$text'),
    );
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    Widget copyButton = TextButton(
      child: Text("Copy"),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: text.toString()))
            .whenComplete(() {
          Utils.showToast('Class Code and Class Password Copied to Clipboard');
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Folder Created Successfully"),
      content: Text(text),
      actions: [
        shareButton,
        copyButton,
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
            : Column(
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
                                  controller: classNameController,
                                  decoration: new InputDecoration(
                                    labelText: "Enter Class Name",
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                                new TextFormField(
                                  controller: sectionController,
                                  decoration: new InputDecoration(
                                    labelText: "Enter Section Name",
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                                new TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "Enter Subject",
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: subjectController,
                                ),
                                SizedBox(height: 10.0,),
                                new MaterialButton(
                                  color: Colors.teal,
                                  textColor: Colors.white,
                                  child: new Text("Create Class Folder"),
                                  onPressed: () => createFolder(
                                      classNameController.text,
                                      sectionController.text,
                                      subjectController.text),
                                  splashColor: Colors.blueAccent,
                                ),
                                new MaterialButton(
                                  color: Colors.teal,
                                  textColor: Colors.white,
                                  child: new Text("Cancel"),
                                  onPressed: () => Navigator.pop(context),
                                  splashColor: Colors.blueAccent,
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ]),
      ]),
    );
  }
}
