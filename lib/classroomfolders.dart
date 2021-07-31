import 'package:flutter/material.dart';

class Classroomfolders extends StatefulWidget {
  Classroomfolders({Key? key}) : super(key: key);

  @override
  _ClassroomfoldersState createState() => _ClassroomfoldersState();
}

class _ClassroomfoldersState extends State<Classroomfolders> with SingleTickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;

// Sign Up for User

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
      ),
      floatingActionButton:FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          print('clicked');
        },

      ) ,
    );
  }
  // Widget card(){
  //   return Container(
  //     color: Colors.red,
  //     height: 60,
  //     width: double.infinity,
  //   );
  // }
}