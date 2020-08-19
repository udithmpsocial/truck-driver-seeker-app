import 'package:adastar/config/const.dart';
import 'package:adastar/models/user_.dart';
import 'package:adastar/screens/driverlogin.dart';
import 'package:adastar/screens/driverregister.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DatabaseMethods {
  createUser(context, userMap, uid) {
    try {
      Firestore.instance
          .collection("Users")
          .document(uid)
          .setData(userMap)
          .then((value) => {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => DriverLogin()))
              })
          .catchError((err) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("" + err),
              actions: [
                new FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("" + e.toString()),
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

  Future addTruckStatus(String uid, mapid, updatedMap) async {
    return await Firestore.instance
        .collection("Users")
        .document(uid)
        .collection("TruckStatus")
        .document(mapid)
        .setData(updatedMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future updateTruckStatusDynamic(String uid, mapid, updatedMap) async {
    return await Firestore.instance
        .collection("Users")
        .document(uid)
        .collection("TruckStatus")
        .document(mapid)
        .updateData(updatedMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future deleteTruckStatusDynamic(String uid, mapid) async {
    print(">>>>"+uid+">>>"+mapid);
    return await Firestore.instance
        .collection("Users")
        .document(uid)
        .collection("TruckStatus")
        .document(mapid)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future getTruckStatusAllByUid(context, uid) async {
    return await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection("TruckStatus")
        .getDocuments();
  }



  Future getUserById(context, uid) async {
    return await Firestore.instance.collection('Users').document(uid).get();
  }

  Future getTruckStatusAllByFilters(uid, destination, cargoStatus, price) async {
    return await Firestore.instance
        .collection('Users')
        .document(uid).collection("TruckStatus")
        .where('prefDestination', isEqualTo: destination)
        .where('cargoStatus', isEqualTo: cargoStatus)
//        .where('price', isEqualTo: price)
        .getDocuments();
  }

  Future getDriverAll() async {
    return await Firestore.instance
        .collection('Users')
        .getDocuments();
  }



// user / seeker side ----------------------------------------------------------
  Future addUserRequest(String uid, mapid, updatedMap) async {
    return await Firestore.instance
        .collection("Users")
        .document(uid)
        .collection("UserRequest")
        .document(mapid)
        .setData(updatedMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future updateUserRequestDynamic(String uid, mapid, updatedMap) async {
    return await Firestore.instance
        .collection("Users")
        .document(uid)
        .collection("UserRequest")
        .document(mapid)
        .updateData(updatedMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future deleteUserRequestDynamic(String uid, String mapid) async {
    print(">>>>"+uid+">>>"+mapid);
    return await Firestore.instance
        .collection("Users")
        .document(uid)
        .collection("UserRequest")
        .document(mapid)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future getUserRequestAllByUid(context, uid) async {
    return await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection("UserRequest")
        .getDocuments();
  }

  Future getDriverResponseAllByUserRquest(userId, requestId) async {
    return await Firestore.instance
        .collection('Users')
        .document(userId).collection("UserRequest")
        .document(requestId).collection("DriverResponse").getDocuments();
  }
// user / seeker side ----------------------------------------------------------


// driver side ----------------------------------------------------------
  Future getUserAll() async {
    return await Firestore.instance
        .collection('Users')
        .where('userType', isEqualTo: "USER")
        .getDocuments();
  }


  Future getUserRquestAllById(uid) async {
    return await Firestore.instance
        .collection('Users')
        .document(uid).collection("UserRequest")
        .getDocuments();
  }


  Future addDriverResponseDynamic(userId, driverId,  requestId, responseMap) async {
    return await Firestore.instance
        .collection("Users")
        .document(userId)
        .collection("UserRequest")
        .document(requestId)
        .collection("DriverResponse")
        .document(driverId)
        .setData(responseMap, merge: true)
        .catchError((e) {
      print(e.toString());
    });
  }


// driver side ----------------------------------------------------------

}
