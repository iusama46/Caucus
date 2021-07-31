import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:the_final_app_caucus/dashboard.dart';
import 'package:the_final_app_caucus/login.dart';
import 'package:the_final_app_caucus/signup.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _load();
  runApp(MyApp());
}

_load() async {
  final keyApplicationId = 'W4xuX02IVtdihzZXVcO4zy9t0duzwDbsXUFgMLAs';
  final keyClientKey = 'LWLlpCTnHvYuaBtvVeO8yFjeBfPAjFg8SP8UsEp7';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return App();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return FirebaseAuth.instance.currentUser == null
                ? LoginPage()
                : Dashboard();
          }

          return App();
        },
      ),
      theme: new ThemeData(
        backgroundColor: Colors.white,
      ),
      routes: {
        SignUp.routeName: (ctx) => SignUp(),
        LoginPage.routeName: (ctx) => LoginPage(),
      },
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Loading..'),
        ),
      ),
    );
  }
}

class CheckEmailPage extends StatefulWidget {
  const CheckEmailPage({Key? key}) : super(key: key);

  @override
  _CheckEmailPageState createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) async {
  //     if (user == null) {
  //       print('User is currently signed out!');
  //     } else {
  //
  //
  //       ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
  //       if (currentUser == null) {
  //         return ;
  //       }
  //
  //       final ParseResponse? parseResponse =
  //       await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);
  //       if (currentUser.emailAddress.toString() == 'true' ){
  //       Utils.showToast('Email is verified successfully');
  //       }
  //       // if (currentUser!.emailVerified) {
  //       //   Utils.showToast('Email is verified successfully');
  //       //   Navigator.push(
  //       //       context, MaterialPageRoute(builder: (context) => Dashboard()));
  //       // }
  //       print('User is signed in!');
  //       print('User is signed in!' + user.email.toString());
  //       print(user.emailVerified.toString());
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("assets/pic2.jpg"),
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Check verification email, received in your given email and then login',
                style: TextStyle(color: Colors.red, fontSize: 18.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
