import 'dart:async';

import 'package:adastar/config/const.dart';
import 'package:adastar/screens/driverhome.dart';
import 'package:adastar/screens/driverlogin.dart';
import 'package:adastar/screens/userhome.dart';
import 'package:adastar/screens/userrequesthome.dart';
import 'package:adastar/screens/userrole.dart';
import 'package:adastar/util/preferences.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    /*Future.delayed(Duration(seconds: 1),(){

    });*/

    Timer(
        Duration(seconds: 3),
            () => _getPref());

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/icon/app_icon.png')
        ],
      ),
    );
  }

  _getPref(){
    Pref.getUserLoginFromSharedPreference().then((value){
      if(value != null && value == true){
        Pref.getUserIdFromSharedPreference().then((value){
          if(value != null){
            Const.UID = value;
          }
        });
        Pref.getUserMapFromSharedPreference();

        Pref.getUserTypeFromSharedPreference().then((value){
          if(value != null && value == "USER"){
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => UserRequestHome()));
          }else{
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => DriverHome()));
          }
        });


      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => DriverLogin()));
      }
    });
  }
}
