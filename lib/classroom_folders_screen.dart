import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:the_final_app_caucus/create_folder.dart';
import 'package:the_final_app_caucus/folder_link_page.dart';
import 'package:the_final_app_caucus/utils.dart';

class ClassroomFolderScreen extends StatefulWidget {
  ClassroomFolderScreen({Key? key}) : super(key: key);

  @override
  _ClassroomFolderScreenState createState() => _ClassroomFolderScreenState();
}

class _ClassroomFolderScreenState extends State<ClassroomFolderScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;
  bool isLoading = true;
  bool isStudent = true;

  @override
  void initState() {
    super.initState();

    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeOut);
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();

    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('moderators').get().then((value) {
      for (var doc in value.docs) {
        Map<String, dynamic> map = doc.data();
        if (map.containsValue(user!.email.toString())  ||map.containsValue('${user.email.toString()} ')) {
          print('found');
          isLoading = false;
          break;
        }
      }

      if (!isLoading) {
        isStudent = false;
      }
      isLoading = false;
      setState(() {});
    }).catchError((onError) {
      print('clima');
      print(onError.toString());
      isLoading = false;
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Folders'),
      ),
      floatingActionButton: Visibility(
        visible: !isStudent,
        child: FloatingActionButton(
          child: Icon(Icons.add_to_drive),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateFolder()));
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: isLoading
              ? Center(
                  child: Text(
                    'Loading...',
                    style: TextStyle(fontSize: 16.0),
                  ),
                )
              : isStudent
                  ? StudentPanel()
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('folders')
                          .orderBy('name')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError || !snapshot.hasData) {
                          print(snapshot.error.toString());
                          return Center(
                            child: Text(
                              'Loading...',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          );
                        } else if (snapshot.data!.docs.length == 0) {
                          return Center(
                            child: Text(
                              'No Data..',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          );
                        }

                        final List<DocumentSnapshot> documents =
                            snapshot.data!.docs;
                        return ListView(
                            children: documents
                                .map((doc) => Card(
                                      child: FolderItem(
                                          doc['name'],
                                          doc['section'],
                                          doc['subject'],
                                          doc.id.toString()),
                                    ))
                                .toList());
                      }),
        ),
      ),
    );
  }
}

class StudentPanel extends StatefulWidget {
  const StudentPanel({
    Key? key,
  }) : super(key: key);

  @override
  _StudentPanelState createState() => _StudentPanelState();
}

class _StudentPanelState extends State<StudentPanel> {
  TextEditingController codeController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
        child: new Card(
          color: Colors.white,
          elevation: 6.0,
          margin: EdgeInsets.only(right: 15.0, left: 15.0),
          child: new Wrap(
            children: <Widget>[
              Center(
                child: new Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: new Text(
                    'Class Room',
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                child: TextFormField(
                  decoration: new InputDecoration(
                    labelText: 'Class Code',
                  ),
                  controller: codeController,
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                child: new TextFormField(
                  controller: passwordController,
                  decoration: new InputDecoration(
                    labelText: 'Class Password',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                ),
              ),
              SizedBox(height: 18.0),
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 15.0),
                child: Center(
                  child: new MaterialButton(
                    minWidth: MediaQuery.of(context).size.width / 1.7,
                    color: Colors.red,
                    textColor: Colors.white,
                    child: new Text("Get Access"),
                    onPressed: () => _loginUser(
                        codeController.text, passwordController.text),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _loginUser(String code, String pass) {
    if (code.isEmpty || pass.isEmpty) {
      Utils.showToast('All fields required');
      return;
    }
    Utils.showToast("Please wait.");
    bool isFound = false;
    var foundId;
    FirebaseFirestore.instance.collection('folders').get().then((value) {
      for (var doc in value.docs) {
        Map<String, dynamic> map = doc.data();

        if (map['classCode'].toString() == code && map['classPassword'].toString()==pass) {
          isFound = true;
          foundId = doc.id;
          break;
        }
      }

      if (isFound) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OpenFolderPage(foundId, false),
          ),
        );
      } else {
        Utils.showToast('Incorrect credentials');
      }
    }).catchError((onError) {
      print(onError.toString());
      Utils.showToast('Incorrect credentials ${onError.toString()}');
    });
  }
}

class FolderItem extends StatefulWidget {
  final name;
  final section;
  final subject;
  final id;

  FolderItem(this.name, this.section, this.subject, this.id);

  @override
  _FolderItemState createState() => _FolderItemState();
}

class _FolderItemState extends State<FolderItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OpenFolderPage(widget.id,true),
          ),
        );
      },
      child: Column(
        children: [
          ListTile(
            title: Text(
              '${widget.name.toString().toUpperCase()}  [${widget.section.toString().toUpperCase()}]',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0),
            ),
            subtitle: Text(
              widget.subject,
              style: TextStyle(fontSize: 14.0),
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) {
                return [

                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Remove'),
                  )
                ];
              },
              onSelected: (String value) async {
                if (value == "delete") {
                  _remove();
                }

                print('You Click on po up menu item $value');
              },
            ),
          )
        ],
      ),
    );
  }

  void _remove() {
    Widget cancelButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.pop(context);
        FirebaseFirestore.instance
            .collection('folders')
            .doc(widget.id)
            .delete()
            .then((value) {
          Utils.showToast('Removed successfully');
        }).catchError((onError) {
          Utils.showToast('Unable to remove ${onError.toString()}');
        });
      },
    );
    Widget denyButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Are you sure you wanna remove this ?"),
      actions: [
        cancelButton,
        denyButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
