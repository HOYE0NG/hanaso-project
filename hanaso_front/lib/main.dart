
import 'package:flutter/material.dart';
import 'package:hanaso_front/page/sign_in/sign_in.dart';
import 'package:hanaso_front/page/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Mudol',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            fontFamily: 'NanumSquareBold',
            useMaterial3: true),
        //home: LoginScreen()
      home: Home()
    );

  }
}