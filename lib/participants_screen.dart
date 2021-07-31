import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_final_app_caucus/models/user.dart';

class ParticipantsScreen extends StatefulWidget {
  List<MeetingUser> users = [];
  MeetingUser user;

  ParticipantsScreen(this.users, this.user);

  @override
  _ParticipantsScreenState createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends State<ParticipantsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Participants'),
        ),
        body: ListView.builder(
          itemCount: widget.users.length,
          itemBuilder: (context, position) {
            MeetingUser user = widget.users[position];
            return AttendanceTile(user.name == widget.user.name
                ? '${user.name} (Me)'
                : user.name);
          },
        ),
      ),
    );
  }
}

class AttendanceTile extends StatelessWidget {
  String name;

  AttendanceTile(this.name);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(margin: EdgeInsets.only(top: 8.0),),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 4.0),
          child: Text(
            '$name',
            style: TextStyle(color: Colors.black, fontSize: 22.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          child: Divider(thickness: 2,color: Colors.black,),
        )
      ],
    );
  }
}
