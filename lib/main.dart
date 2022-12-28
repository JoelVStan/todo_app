import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/auth/authscreen.dart';
import 'package:todo_app/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
   //initilization of Firebase app
  
  // other Firebase service initialization
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, usersnapshot){
        if(usersnapshot.hasData) {
          return Home();
        }
        else {
          return AuthScreen();
        }
        
      },),
      debugShowCheckedModeBanner: false,

      theme: 
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.yellowAccent),

    );
  }
}

