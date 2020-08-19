import 'dart:io';

import 'package:adastar/screens/driverlogin.dart';
import 'package:adastar/screens/userhome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserRole extends StatefulWidget {
  static String tag = 'login-page';

  const UserRole({
    Key key,
  }) : super(key: key);

  @override
  _UserRoleState createState() => new _UserRoleState();
}

class _UserRoleState extends State<UserRole> {
  var unTxt = TextEditingController();
  var pwTxt = TextEditingController();

  var unFocus = FocusNode();
  var pwFocus = FocusNode();
  var logBtnFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 100,
        child: Image.asset('assets/icon/app_icon.png'),
      ),
    );

    final driverButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: RaisedButton(
        focusNode: logBtnFocus,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Color(0xffffaa00), width: 3)
        ),
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => DriverLogin()));
        },
        padding: EdgeInsets.all(12),
        color: Colors.black,
        child:
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(width:30,child: Icon(Icons.airport_shuttle, size: 24, color: Color(0xffffaa00),)),
              Expanded(
                child: Center(
                  child: Text("Use as a Driver", style: TextStyle(
                      color: Color(0xffffaa00),
                      fontSize: 24)),
                ),
              ),

            ],
          ),
        )

      ),
    );

    final seekerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
      child: RaisedButton(
        focusNode: logBtnFocus,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Color(0xffffaa00),  width: 3)
        ),
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => UserHome()));
        },
        padding: EdgeInsets.all(12),
        color: Colors.black,
        child:
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(width:30,child: Icon(Icons.search, size: 24, color: Color(0xffffaa00),)),
              Expanded(
                child: Center(
                  child: Text("Use as a Seeker", style: TextStyle(
                      color: Color(0xffffaa00),
                      fontSize: 24)),
                ),
              ),

            ],
          ),
        )


      ),
    );




    return Scaffold(
        backgroundColor: Colors.black,
        body: WillPopScope(
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  logo,
                  seekerButton,
                  driverButton,
                ],
              ),
            ),
            onWillPop: () {
              exit(0);
            }));
  }
}
