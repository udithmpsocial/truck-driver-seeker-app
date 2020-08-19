/*
import 'package:adastar/services/auth.dart';
import 'package:adastar/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: () {
          authMethods.signUpWithEmailAndPassword(context,
              'hello@gmail.com', '12345678')
              .then((value) {
            if (value != null) {
              if (value is String) {
                print(value);
              } else {
                Map<String, String> userMap = {
                  "userName": "Lahiru",
                  "uid": value.userId
                };

                databaseMethods.createUser(userMap, value.userId);
              }
            }
          });
        },
        child: Text('click'),
      ),
    );
  }
}
*/
