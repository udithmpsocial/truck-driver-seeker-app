import 'dart:io';
import 'package:adastar/config/const.dart';
import 'package:adastar/models/user_.dart';
import 'package:adastar/screens/driverhome.dart';
import 'package:adastar/screens/driverloginfromseekerlogin.dart';
import 'package:adastar/screens/userregister.dart';
import 'package:adastar/screens/userrequesthome.dart';
import 'package:adastar/screens/userrole.dart';
import 'package:adastar/services/auth.dart';
import 'package:adastar/services/database.dart';
import 'package:adastar/services/mobileauth.dart';
import 'package:adastar/util/dialog.dart';
import 'package:adastar/util/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'driverregister.dart';

class DriverLogin extends StatefulWidget {
  static String tag = 'login-page';

  const DriverLogin({
    Key key,
  }) : super(key: key);

  @override
  _DriverLoginState createState() => new _DriverLoginState();
}

class _DriverLoginState extends State<DriverLogin> {
  var unTxt = TextEditingController();
  var pwTxt = TextEditingController();

  var unUserTxt = TextEditingController();
  var pwUserTxt = TextEditingController();

  var unFocus = FocusNode();
  var pwFocus = FocusNode();
  var logBtnFocus = FocusNode();
  var passwordVisible = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  AuthMethods authMethods;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    super.initState();
    authMethods = new AuthMethods();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xffffaa00),
        body: WillPopScope(
          onWillPop: () {
            exit(0);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Hello there, ',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 50)),
                Text('Sign in to continue',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 40),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: unUserTxt,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          size: 24,
                          color: Colors.white60,
                        ),
                        hintText: 'Username',
                        hintStyle:
                        TextStyle(color: Colors.white60),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white60)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white60)),
                        contentPadding: EdgeInsets.fromLTRB(
                            20.0, 10.0, 20.0, 10.0),
                      ),
                    ),
                    TextFormField(
                      obscureText: !passwordVisible,
                      controller: pwUserTxt,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintStyle:
                        TextStyle(color: Colors.white60),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white60)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white60)),
                        icon: Icon(
                          Icons.lock,
                          color: Colors.white60,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white30,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible =
                              !passwordVisible;
                            });
                          },
                        ),
                        hintText: 'Password',
                        contentPadding: EdgeInsets.fromLTRB(
                            20.0, 10.0, 20.0, 10.0),
                      ),
                    ),
                    SizedBox(height: 30),
                    ButtonTheme(
                      height: 60,
                      child: RaisedButton(
                        elevation: 1,
                        focusNode: logBtnFocus,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                            side: BorderSide(
                                color: Color(0xf02a43),
                                width: 3)),
                        onPressed: () {
                          _validateUser();
                        },
//                  0xfff02a43  #f46231
                        padding: EdgeInsets.all(12),
                        color: Colors.white,
                        child: Text('SEEKER',
                            style: TextStyle(
                                color: Color(0xffffaa00),
                                fontWeight: FontWeight.bold,
                                fontSize: 24)),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "If you dont have seeker account,",
                                  style: TextStyle(
                                      color:
                                      Colors.white60),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext
                                            context) =>
                                                UserRegister()));
                                  },
                                  child: Text(
                                    '\tClick Here',
                                    style: TextStyle(
                                        color:
                                        Colors.white60,
                                        fontWeight:
                                        FontWeight
                                            .bold),
                                  ),
                                ),


                              ],
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (BuildContext context) => DriverLoginFromSeeker()));
                              },
                              child: Text(
                                "\tI'm Driver",
                                style: TextStyle(
                                    color:
                                    Colors.white60,
                                    fontWeight:
                                    FontWeight
                                        .bold),
                              ),
                            )

                          ],
                        )),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  _validate() {
    if (unTxt.text == null) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter Username'),
//        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
      return;
    } else if (pwTxt.text == null) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter Password'),
        ),
      );
      return;
    } else {
      _login();
    }
  }

  _validateUser() {
    if (unUserTxt.text == null) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter Username'),
//        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
      return;
    } else if (pwUserTxt.text == null) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter Password'),
        ),
      );
      return;
    } else {
      _loginUser();
    }
  }

  _login() {
    Doalog.sinner(context);
    authMethods
        .signInDynamic(context, unTxt.text.trim(), pwTxt.text.trim())
        .then((value) {
      Const.UID = value.user.uid;
      databaseMethods.getUserById(context, value.user.uid).then((value) {
        DocumentSnapshot documentSnapshot = value;
        Const.UMAP = {
          "uid": documentSnapshot.data["id"],
          "fullname": documentSnapshot.data["fullName"],
          "email": documentSnapshot.data["email"],
          "phoneNo": documentSnapshot.data["phoneNo"],
          "userType": documentSnapshot.data["userType"],
        };
        print(">>>" + documentSnapshot.data["fullName"]);
        print(">>>" + Const.UMAP.toString());
        _setPref(Const.UID, Const.UMAP);

        if (Const.UMAP["userType"] != null &&
            Const.UMAP["userType"] == "DRIVER") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => DriverHome()));
        } else {
          Navigator.of(context).pop();
          scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text('Please login from user'),
            ),
          );
        }
      });
    }).catchError((onError) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Wrong username or password \n Note:-"+onError.toString()),
              actions: [
                new FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    });
  }

  _setPref(String uid, Map map) {
    Pref.saveUserIdInSharedPreference(uid).then((value) {
      Pref.saveUserMapInSharedPreference(map);
    });

    Pref.saveUserLoginInSharedPreference(true).then((value) {
      Pref.saveUserTypeInSharedPreference("DRIVER");
    });
  }

  _setUserPref(String uid, Map map) {
    Pref.saveUserIdInSharedPreference(uid).then((value) {
      Pref.saveUserMapInSharedPreference(map);
    });

    Pref.saveUserLoginInSharedPreference(true).then((value) {
      Pref.saveUserTypeInSharedPreference("USER");
    });
  }

  _loginUser() {
    Doalog.sinner(context);
    authMethods
        .signInDynamic(context, unUserTxt.text.trim(), pwUserTxt.text.trim())
        .then((value) {
      Const.UID = value.user.uid;
      databaseMethods.getUserById(context, value.user.uid).then((value) {
        DocumentSnapshot documentSnapshot = value;
        Const.UMAP = {
          "uid": documentSnapshot.data["id"],
          "fullname": documentSnapshot.data["fullName"],
          "email": documentSnapshot.data["email"],
          "phoneNo": documentSnapshot.data["phoneNo"],
          "userType": documentSnapshot.data["userType"],
        };
        print(">>>" + documentSnapshot.data["fullName"]);
        _setUserPref(Const.UID, Const.UMAP);

        if (Const.UMAP["userType"] != null &&
            Const.UMAP["userType"] == "USER") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => UserRequestHome()));
        } else {
          Navigator.of(context).pop();
          scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text('Please login from driver'),
            ),
          );
        }
      });
    }).catchError((onError) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Wrong username or password \n Note:-"+onError.toString()),
              actions: [
                new FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    });

  }
}
