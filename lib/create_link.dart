import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:the_final_app_caucus/utils.dart';

class CreateLink extends StatefulWidget {
  final folderId;

  CreateLink(this.folderId);

  @override
  _CreateLinkState createState() => _CreateLinkState();
}

class _CreateLinkState extends State<CreateLink>
    with SingleTickerProviderStateMixin {
  TextEditingController detailsController = new TextEditingController();
  TextEditingController linkController = new TextEditingController();
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;
  bool isLoading = false;

  Future createLink(String details, String link) async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (details.isEmpty || link.isEmpty) {
      Utils.showToast('All fields required');
      return;
    }

    bool isCorrect = Uri.tryParse(link.toString())?.hasAbsolutePath ?? false;

    if (!isCorrect) {
      Utils.showToast('Url is invalid');
      return;
    }
    isLoading = true;
    setState(() {});
    try {
      final df = new DateFormat('dd-MM-yyyy hh:mm a');
      var tempDate =
          df.format(new DateTime.fromMillisecondsSinceEpoch(1558432747 * 1000));
      CollectionReference folderCollection = FirebaseFirestore.instance
          .collection('folders')
          .doc(widget.folderId)
          .collection('data');

      folderCollection.add({
        "details": details,
        "url": link,
        'date': tempDate,
      }).then((value) {
        // isLoading = false;
        // setState(() {});
        Utils.showToast("Saved Successfully");
        Navigator.pop(context);
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

  @override
  void initState() {
    super.initState();

    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeOut);
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
    _checkClipboard();
  }

  _checkClipboard() async {
    ClipboardData? data = await Clipboard.getData('text/plain');

    try {
      bool isCorrect =
          Uri.tryParse(data!.text.toString())?.hasAbsolutePath ?? false;
      if (isCorrect) {
        linkController.text = data.text.toString();
        print(data.toString());
      }
    } catch (e) {}
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
                                  controller: detailsController,
                                  decoration: new InputDecoration(
                                    labelText: "Enter Short Details",
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                                new TextFormField(
                                  controller: linkController,
                                  decoration: new InputDecoration(
                                    labelText: "Enter Url",
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                new MaterialButton(
                                  color: Colors.teal,
                                  textColor: Colors.white,
                                  child: new Text("Create Class Folder"),
                                  onPressed: () => createLink(
                                      detailsController.text,
                                      linkController.text),
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
