import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chat_model.dart';


class ChatScreen extends StatefulWidget{
  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
  }
  class ChatScreenState extends State<ChatScreen>{
  @override
  Widget build (BuildContext context){
    return new ListView.builder(
        itemBuilder: (context,i)=> new Column(
          children: <Widget>[
            new Divider(
              height: 10.0,
            ),
            new ListTile(
              leading: new CircleAvatar(foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.black,
              ),
            ),
          ],
        ),
    );
  }
}