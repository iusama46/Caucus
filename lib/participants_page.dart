import 'package:flutter/material.dart';
class ParticipantsPage extends StatefulWidget {
  ParticipantsPage({Key? key}) : super(key: key);

  @override
  _ParticipantsPageState createState() => _ParticipantsPageState();
}

class _ParticipantsPageState extends State<ParticipantsPage> {

  @override
  Widget build(BuildContext context) {
    var participants;
    var participantsCount = participants.length;
    var size = MediaQuery.of(context).size;
    return new Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Padding(padding:const EdgeInsets.only(top:20,left:10),
            child: Text(
              "Close",
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color:Colors.blue[600]),
            ),
          ),
        ),
        centerTitle: true,
        title: Text("Participants($participantsCount)",style: TextStyle(color: Colors.black,
            fontSize: 16,fontWeight:FontWeight.w600 )),
      ),
      bottomSheet: Container(
        width: size.width, height: 55, decoration: BoxDecoration(color: Colors.grey[50]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:10,top:5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffe4e4ed),
                    borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text("Invite",style: TextStyle(fontSize: 15,fontWeight:FontWeight.w600 ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10,top: 5),
                child:  Container(
                 decoration: BoxDecoration(
                   color: Color(0xffe4e4ed),
                   borderRadius: BorderRadius.circular(8)),
                     child: Text("Mute all",style: TextStyle(fontSize: 15,fontWeight:FontWeight.w600 )
                 ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    }
}