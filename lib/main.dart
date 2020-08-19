import 'package:adastar/screens/driverhome.dart';
import 'package:adastar/screens/driverlogin.dart';
import 'package:adastar/screens/driverregister.dart';
import 'package:adastar/screens/permition.dart';
import 'package:adastar/screens/splash.dart';
import 'package:adastar/screens/test.dart';
import 'package:adastar/screens/userhome.dart';
import 'package:adastar/screens/userregister.dart';
import 'package:adastar/screens/userrequesthome.dart';
import 'package:adastar/screens/userrole.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFffc90e),
        accentColor: Color(0xFFffc90e),
        canvasColor: Colors.white,
        fontFamily: 'SourceSansPro'
      ),
      initialRoute: '/Splash',
      routes: {
        '/Splash': (context) => Splash(),
        '/UserRole': (context) => UserRole(),
        '/DriverLogin': (context) => DriverLogin(),
        '/DriverRegister': (context) => DriverRegister(),
        '/DriverHome': (context) => DriverHome(),
        '/UserHome': (context) => UserHome(),
        '/UserRequestHome': (context) => UserRequestHome(),
        '/UserRegister': (context) => UserRegister(),
        '/Permition': (context) => Permition(),

      },
    );
  }
}
