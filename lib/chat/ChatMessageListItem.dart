import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

var currentUserUid = FirebaseAuth.instance.currentUser!.uid;

class ChatMessageListItem extends StatelessWidget {
  final DataSnapshot messageSnapshot;

  ChatMessageListItem(this.messageSnapshot);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        children: currentUserUid == messageSnapshot.value['uId']
            ? getSentMessageLayout()
            : getReceivedMessageLayout(),
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(messageSnapshot.value['senderName'],
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: messageSnapshot.value['imageUrl'] != null
                  ? new Image.network(
                      messageSnapshot.value['imageUrl'],
                      width: 250.0,
                    )
                  : new Text(messageSnapshot.value['text']),
            ),
          ],
        ),
      ),
      new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: new CircleAvatar(
                child: UserImage(messageSnapshot.value['senderName']),
              )),
        ],
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: new CircleAvatar(
                child: UserImage(messageSnapshot.value['senderName']),
              )),
        ],
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(messageSnapshot.value['senderName'],
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: messageSnapshot.value['imageUrl'] != null
                  ? new Image.network(
                      messageSnapshot.value['imageUrl'],
                      width: 250.0,
                    )
                  : new Text(messageSnapshot.value['text']),
            ),
          ],
        ),
      ),
    ];
  }
}

class UserImage extends StatelessWidget {
  final name;

  UserImage(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.teal,
      ),

      child: Center(
          child: Text(
        name.toString()[0].toUpperCase(),
        style: TextStyle(
            fontSize: 20.0, color: Colors.white),
      )),
    );
  }
}
