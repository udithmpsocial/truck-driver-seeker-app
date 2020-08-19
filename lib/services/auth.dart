import 'package:adastar/config/const.dart';
import 'package:adastar/models/user.dart';
import 'package:adastar/util/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'database.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future signInDynamic(BuildContext context, String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content:
                  Text(
                      "The email address is already in use by another account"),
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
        }
        else if (e.code == 'ERROR_INVALID_EMAIL') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("The email address is not valid"),
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
        }

        else if (e.code == 'ERROR_WEAK_PASSWORD') {
          showDialog(
              context: context,
              builder: (BuildContext context)
              {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("The password is weak"),
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
        }
      }
      return e.message;
    }
  }

  Future signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      Const.FIREDB = _auth;
      Const.UID = authResult.user.uid;
      databaseMethods.getUserById(context, authResult.user.uid).then((value){
        DocumentSnapshot documentSnapshot = value;
        Const.UMAP = {
          "uid": documentSnapshot.data["id"],
          "fullname": documentSnapshot.data["fullName"],
          "email": documentSnapshot.data["email"],
          "phoneNo": documentSnapshot.data["phoneNo"],
          "userType": documentSnapshot.data["userType"],
        };
        print(">>>"+documentSnapshot.data["fullName"]);
        _setPref(Const.UID, Const.UMAP);
      });

      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content:
                  Text(
                      "The email address is already in use by another account"),
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
        }
        else if (e.code == 'ERROR_INVALID_EMAIL') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("The email address is not valid"),
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
        }

        else if (e.code == 'ERROR_WEAK_PASSWORD') {
          showDialog(
              context: context,
              builder: (BuildContext context)
              {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("The password is weak"),
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
        }
      }
      return e.message;
    }
  }

  Future signUpWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content:
                  Text(
                      "The email address is already in use by another account"),
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
        }
        else if (e.code == 'ERROR_INVALID_EMAIL') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("The email address is not valid"),
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
        }

        else if (e.code == 'ERROR_WEAK_PASSWORD') {
          showDialog(
              context: context,
              builder: (BuildContext context)
          {
            return AlertDialog(
              title: Text("Error"),
              content: Text("The password is weak"),
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
        }
      }
      return e.message;
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  _setPref(String uid, Map map){
    Pref.saveUserIdInSharedPreference(uid).then((value){
      Pref.saveUserMapInSharedPreference(map);
    });

  }
}
