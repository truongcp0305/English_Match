import 'package:english_match/model/user.dart';
import 'package:english_match/screen/authentication/signInScreen.dart';
import 'package:english_match/screen/navigator/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future main() async{
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: {
        '/nav': (context)=> AppNavigation(user: UserModel(userId: '', userName: '', point: '', otherInfor: ''),)
      },
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      home: SignInScreen(),
    );
  }
}


