import 'package:cm_flutter_app/screens/login_screen.dart';
import 'package:cm_flutter_app/screens/resgister_screen.dart';
import 'package:cm_flutter_app/splashScreen/splash_screen.dart';
import 'package:cm_flutter_app/themeProvider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async{
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(

      ),
    );
  }
}
