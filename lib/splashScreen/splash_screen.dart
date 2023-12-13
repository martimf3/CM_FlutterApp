import 'dart:async';
import 'package:cm_flutter_app/Assistants/assistant_method.dart';
import 'package:cm_flutter_app/global/global.dart';
import 'package:cm_flutter_app/screens/login_screen.dart';
import 'package:cm_flutter_app/screens/main_page_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer() {
    Timer(Duration(seconds: 3), () async {
      if(await firebaseAuth.currentUser != null){
        firebaseAuth.currentUser != null ? AssistantMethods.readCurrentOnlineUserInfo() : null;
        Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen()));
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (c) => LogInScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Computação Móvel \n Flutter App",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
