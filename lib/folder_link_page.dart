import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_final_app_caucus/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'create_link.dart';

class OpenFolderPage extends StatefulWidget {
  final folderId;
  final isModerator;

  OpenFolderPage(this.folderId, this.isModerator);

  @override
  _OpenFolderPageState createState() => _OpenFolderPageState();
}

class _OpenFolderPageState extends State<OpenFolderPage>
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
      appBar: AppBar(
        title: Text('Folders'),
      ),
      floatingActionButton: Visibility(
        visible: widget.isModerator,
        child: FloatingActionButton(
          child: Icon(Icons.add_link),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateLink(widget.folderId)));
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('folders')
                  .doc(widget.folderId)
                  .collection('data')
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

                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                return ListView(
                    children: documents
                        .map((doc) => Card(
                              child: UrlTile(doc['date'], doc['details'],
                                  doc['url'], doc.id, widget.folderId, widget.isModerator),
                            ))
                        .toList());
              }),
        ),
      ),
    );
  }
}

class UrlTile extends StatefulWidget {
  final date;
  final details;
  final url;
  final id;
  final folderId;
  final isModerator;

  UrlTile(this.date, this.details, this.url, this.id, this.folderId,this.isModerator);

  @override
  _UrlTileState createState() => _UrlTileState();
}

class _UrlTileState extends State<UrlTile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await canLaunch(widget.url)
            ? await launch(widget.url)
            : Utils.showToast('Could not launch ${widget.url}');
      },
      onDoubleTap: () {
        Clipboard.setData(ClipboardData(text: widget.url.toString()))
            .whenComplete(() {
          Utils.showToast('Url Copied to Clipboard');
        });
      },
      child: Column(
        children: [
          ListTile(
            title: Text(
              '${widget.details.toString()}\n',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0),
            ),
            subtitle: Text(
              'Url: ${widget.url}\n\nDate: ${widget.date.toString()} ',
              style: TextStyle(fontSize: 14.0),
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'view',
                    child: Text('View'),
                  ),
                  PopupMenuItem(
                    value: 'copy',
                    child: Text('Copy'),
                  ),
                  PopupMenuItem(
                    enabled: widget.isModerator,
                    value: 'edit',
                    child: Text('Modify'),
                  ),
                  PopupMenuItem(
                    enabled:widget.isModerator,
                    value: 'delete',
                    child: Text('Remove'),
                  )
                ];
              },
              onSelected: (String value) async {
                if (value == "delete") {
                  _remove();
                } else if (value == "edit") {
                  _modify();
                } else if (value == "copy") {
                  Clipboard.setData(ClipboardData(text: widget.url.toString()))
                      .whenComplete(() {
                    Utils.showToast('Url Copied to Clipboard');
                  });
                } else if (value == "view") {
                  await canLaunch(widget.url)
                      ? await launch(widget.url)
                      : Utils.showToast('Could not launch ${widget.url}');
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
            .doc(widget.folderId)
            .collection('data')
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
      content: Text("Are you sure you wanna delete this ?"),
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

  void _modify() {
    TextEditingController _textFieldController = TextEditingController();
    TextEditingController _linkController = TextEditingController();

    _textFieldController.text = widget.details;
    _linkController.text = widget.url;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifications'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Details"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _linkController,
                decoration: InputDecoration(hintText: "Url"),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Modify'),
              onPressed: () {
                //print(_textFieldController.text);

                if (_textFieldController.text.isEmpty ||
                    _linkController.text.isEmpty) {
                  Utils.showToast('All fields required');
                  return;
                }

                bool isCorrect = Uri.tryParse(_linkController.text.toString())
                        ?.hasAbsolutePath ??
                    false;

                if (!isCorrect) {
                  Utils.showToast('Url is invalid');
                  return;
                }
                Navigator.pop(context);
                FirebaseFirestore.instance
                    .collection('folders')
                    .doc(widget.folderId)
                    .collection('data')
                    .doc(widget.id)
                    .update({
                  'details': _textFieldController.text,
                  'url': _linkController.text,
                }).then((value) {
                  Utils.showToast('Modified successfully');
                }).catchError((onError) {
                  Utils.showToast('Unable to modify ${onError.toString()}');
                });
              },
            ),
          ],
        );
      },
    );
  }
}
