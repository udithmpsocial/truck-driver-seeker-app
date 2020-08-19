import 'dart:async';

import 'package:adastar/config/const.dart';
import 'package:adastar/models/truckstatus.dart';
import 'package:adastar/screens/driverlogin.dart';
import 'package:adastar/screens/userhome.dart';
import 'package:adastar/screens/userrequestresponsehome.dart';
import 'package:adastar/screens/userrole.dart';
import 'package:adastar/services/auth.dart';
import 'package:adastar/services/database.dart';
import 'package:adastar/util/dialog.dart';
import 'package:adastar/util/location.dart';
import 'package:adastar/util/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class UserRequestHome extends StatefulWidget {
  static String tag = 'login-page';

  const UserRequestHome({
    Key key,
  }) : super(key: key);

  @override
  _UserRequestState createState() => new _UserRequestState();
}

class _UserRequestState extends State<UserRequestHome> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  LocationResult _pickedLocation, _pickedDestinationLocation;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();

  var userRequestLineIdTxt = TextEditingController();
  var currentLocationTxt = TextEditingController();
  var currentLocationCoordinatesTxt = TextEditingController();
  var firstPrefDestinationTxt = TextEditingController();
  var firstPrefDestinationCoordinatesTxt = TextEditingController();

  List<dynamic> stats;
  List<Map<String, dynamic>> listview = [];
  List<String> cargoStatusDropdown = [
    "Empty",
    "Partial Empty",
    "Partial Full",
    "Full"
  ];
  var selectedcargoStatus = "Empty";
  bool _isLastLocation = true;

  List<dynamic> responseListdynamic;
  List<Map<String, dynamic>> responseListMap = [];

  bool isVisible = false;

  @override
  void initState() {
    super.initState();

    _getTruckStatusList();
//    currentLocationTxt.text = Gps.address.toString();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF6F7Fb),
      appBar: new AppBar(
        backgroundColor: Color(0xFFF6F7Fb),
        leading: new IconButton(
          icon: new Icon(
            Icons.supervised_user_circle,
            color: Colors.brown,
          ),
          onPressed: () => _driverProfileDialog(),
        ),
        title: Text("Hello, " +
            (Const.UMAP != null ? Const.UMAP["fullname"].toString() : "")),
        titleSpacing: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
//              Icons.more_vert,
              Icons.exit_to_app,
              color: Colors.brown,
            ),
            onPressed: () {
              _logOut();
            },
          ),
        ],
      ),
      drawer: Drawer(
      ),
      body: WillPopScope(
        onWillPop: () {
          return;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: new Card(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: false,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          controller: userRequestLineIdTxt,
                          decoration: InputDecoration(
                            hintText: 'List Line ID',
                          ),
                        ),
                      ),
                      DropdownButton<String>(
                        value: selectedcargoStatus,
                        icon: Icon(Icons.keyboard_arrow_down),
                        iconSize: 24,
                        elevation: 16,
                        isExpanded: true,
                        onChanged: (String newValue) {
                          setState(() {
                            selectedcargoStatus = newValue;
                          });
                        },
                        items: cargoStatusDropdown
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),

                      Row(
                        children: <Widget>[
                          Expanded(child:  TextFormField(
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            enabled: false,
                            controller: currentLocationTxt,
                            decoration: InputDecoration(
                              hintText: 'Current Location',
                            ),
                          ),),
                          GestureDetector(
                            onTap: () async {
                              //new location code----------------------------

                              LocationResult result = await showLocationPicker(
                                context,
                                "AIzaSyA4xfzmVOnAqZeTqmQuydC7R1S4x5WLfvE",
                                initialCenter: LatLng(31.1975844, 29.9598339),
                                automaticallyAnimateToCurrentLocation: true,
                                myLocationButtonEnabled: true,
                                layersButtonEnabled: true,
                                resultCardAlignment: Alignment.bottomCenter,
                              );
                              print("result = $result");
                              setState(() async {
                                _pickedLocation = result;
                                List<Placemark> placemark = await Geolocator().placemarkFromCoordinates( _pickedLocation.latLng.latitude,  _pickedLocation.latLng.longitude);

                                _pickedLocation.address == null ?
                                currentLocationTxt.text = ""+placemark[0].name+", "+placemark[0].country+", "+placemark[0].subLocality
                                    :
                                currentLocationTxt.text = _pickedLocation.address;

                                currentLocationCoordinatesTxt.text = ""+placemark[0].position.longitude.toString()+","+placemark[0].position.latitude.toString();

                              }
                              );

                              //new location code----------------------------

                            },
                            child: Icon(Icons.add_location),
                          ),
                        ],
                      ),


                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              enabled: false,
                              controller: firstPrefDestinationTxt,
                              decoration: InputDecoration(
                                hintText: 'Fist Destination',
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () async {
                              //new location code----------------------------

                              LocationResult result = await showLocationPicker(
                                context,
                                "AIzaSyA4xfzmVOnAqZeTqmQuydC7R1S4x5WLfvE",
                                initialCenter: LatLng(31.1975844, 29.9598339),
                                automaticallyAnimateToCurrentLocation: true,
                                myLocationButtonEnabled: true,
                                layersButtonEnabled: true,
                                resultCardAlignment: Alignment.bottomCenter,
                              );
                              print("result = $result");
                              setState(() async {
                                _pickedDestinationLocation = result;
                                List<Placemark> placemark = await Geolocator().placemarkFromCoordinates( _pickedDestinationLocation.latLng.latitude,  _pickedDestinationLocation.latLng.longitude);


                                _pickedDestinationLocation.address == null ?
                                firstPrefDestinationTxt.text = ""+placemark[0].name+", "+placemark[0].country+", "+placemark[0].subLocality
                                    :
                                firstPrefDestinationTxt.text = _pickedDestinationLocation.address;
                                firstPrefDestinationCoordinatesTxt.text = ""+placemark[0].position.longitude.toString()+","+placemark[0].position.latitude.toString();

                              }
                              );

                              //new location code----------------------------
                            },
                            child: Icon(Icons.add_location ),
                          )

                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              onPressed: () {
                                _reset();
                              },
                              padding: EdgeInsets.all(16),
                              color: Colors.brown[300],
                              child: Text('RESET',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              onPressed: () {
                                _validate();
                              },
                              padding: EdgeInsets.all(16),
                              color: Colors.brown,
                              child: Text('UPDATE',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child:
              listview == null || listview.length == 0
                  ? Container(
                child: Image.asset('assets/img/noresult.jpg'),
              )
                  : ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: listview.length,
                itemBuilder: (context, i) {
                  return Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: <Widget>[
                          Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10))),
                              color: Colors.white,
                              elevation: 7,
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: <Widget>[
                                          Align(
                                            alignment:
                                            Alignment.centerRight,
                                            child: GestureDetector(
                                                onTap: () {
                                                  Const.USERREQUESTLINEID = listview[i]["lineId"];
                                                  Const.USERREQUESTDESTINATION = listview[i]["data"]["prefDestination"];
                                                  Const.USERREQUESTDESTINATIONCOD = listview[i]["data"]["prefDestinationCoordinates"];
                                                  Navigator.of(
                                                      context)
                                                      .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder:
                                                              (BuildContext context) =>
                                                              UserRequestRespose()));
                                                },
                                                child: Icon(Icons
                                                    .open_in_new)),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Align(
                                            alignment:
                                            Alignment.centerRight,
                                            child: GestureDetector(
                                                onTap: () {
                                                  _reset();
                                                  setState(() {
                                                    userRequestLineIdTxt
                                                        .text =
                                                    listview[i][
                                                    "lineId"];
                                                    currentLocationTxt
                                                        .text = listview[
                                                    i]["data"]
                                                    [
                                                    "currentLocation"];

                                                    currentLocationCoordinatesTxt
                                                        .text = listview[
                                                    i]["data"]
                                                    [
                                                    "currentLocationCoordinates"];
                                                    selectedcargoStatus =
                                                    listview[i][
                                                    "data"]
                                                    [
                                                    "cargoStatus"];
                                                    firstPrefDestinationTxt
                                                        .text = listview[
                                                    i]["data"]
                                                    [
                                                    "prefDestination"];

                                                    firstPrefDestinationCoordinatesTxt
                                                        .text = listview[
                                                    i]["data"]
                                                    [
                                                    "prefDestinationCoordinates"];

                                                  });
                                                },
                                                child:
                                                Icon(Icons.edit)),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Align(
                                            alignment:
                                            Alignment.centerRight,
                                            child: GestureDetector(
                                                onTap: () {
                                                  _delete(listview[i]["lineId"].toString());
                                                },
                                                child: Icon(
                                                    Icons.close)),
                                          ),
                                        ],
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(
                                              context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '' +
                                                    listview[i]["data"]
                                                    [
                                                    "currentLocation"]
                                                        .toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                    fontSize: 17)),
                                            TextSpan(
                                                text: ' to ',
                                                style: TextStyle(
                                                    fontSize: 15)),
                                            TextSpan(
                                                text: '' +
                                                    listview[i]["data"]
                                                    [
                                                    "prefDestination"]
                                                        .toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                    fontSize: 17)),
                                            TextSpan(
                                                text: ' with ',
                                                style: TextStyle(
                                                    fontSize: 15)),
                                            TextSpan(
                                                text: '' +
                                                    listview[i]["data"]
                                                    [
                                                    "cargoStatus"]
                                                        .toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                    fontSize: 17)),
                                            TextSpan(
                                                text: ' cargo.',
                                                style: TextStyle(
                                                    fontSize: 15)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),

                                    ],
                                  ))),
                        ],
                      ));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(
                      color: Colors.black26,
                      thickness: 0.5,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _validate() {
    if (selectedcargoStatus.trim().length == 0) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please fill Cargo Status'),
        ),
      );
      return;
    } else if (currentLocationTxt.text.trim().length == 0) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please fill Current Location'),
        ),
      );
      return;
    } else if (firstPrefDestinationTxt.text.trim().length == 0) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please fill any destination with price'),
        ),
      );
      return;
    } else {
      _save();
      return;
    }
  }

  _save() {
    Doalog.sinner(context);
    Map<String, dynamic> truckStatusMap = {};
    truckStatusMap = {
      "currentLocation": currentLocationTxt.text.trim(),
      "currentLocationCoordinates": currentLocationCoordinatesTxt.text.trim(),
      "cargoStatus": selectedcargoStatus.trim(),
      "prefDestination": firstPrefDestinationTxt.text,
      "prefDestinationCoordinates": firstPrefDestinationCoordinatesTxt.text,
      "price": ""
    };

    if (userRequestLineIdTxt.text.trim() == "") {
      //insert
//      if(listview.length < 4){
      databaseMethods
          .addUserRequest(Const.UID, listview.length.toString(), truckStatusMap)
          .then((value) {
        Navigator.pop(context);
      });
//      }
    } else {
      //update

      databaseMethods
          .updateUserRequestDynamic(
              Const.UID, userRequestLineIdTxt.text, truckStatusMap)
          .then((value) {
        Navigator.pop(context);
      });
      userRequestLineIdTxt.text = "";
    }
    _getTruckStatusList();
    _reset();
  }

  _delete(String userRequestLineIdTxt) {
//    print("DELETE LINE:>>>"+userRequestLineIdTxt.text);return;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Hello, " +
                (Const.UMAP != null ? Const.UMAP["fullname"].toString() : "")),
            content: Text("Are you sure to delete ?"),
            actions: [
              new FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Doalog.sinner(context);
                  databaseMethods
                      .deleteUserRequestDynamic(
                          Const.UID, userRequestLineIdTxt)
                      .then((value) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    _getTruckStatusList();
                  }).catchError((onError){
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });

    _reset();
  }

  _getTruckStatusList() {
    setState(() {
      listview.clear();
    });
    databaseMethods.getUserRequestAllByUid(context, Const.UID).then((value) {
      QuerySnapshot snapshot = value;
      if (snapshot.documents.length > 0) {
        setState(() {
          listview.clear();
          stats = snapshot.documents;
          stats.forEach((element) {
            DocumentSnapshot documentSnapshot = element;
            print("USER_DOCID>>>" + documentSnapshot.documentID);
            Map<String, dynamic> line = {
              "lineId": "" + documentSnapshot.documentID,
              "data": documentSnapshot.data
            };
            listview.add(line);
          });
        });
      }
    });
  }

  _reset() {
    userRequestLineIdTxt.text = "";
    currentLocationTxt.text = "";
    selectedcargoStatus = cargoStatusDropdown[0];
    firstPrefDestinationTxt.text = "";
    firstPrefDestinationCoordinatesTxt.text = "";
    currentLocationCoordinatesTxt.text = "";
  }

  _driverProfileDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 350,
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: SizedBox.expand(
                child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/icon/app_icon.png'),
                  backgroundColor: Colors.transparent,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Text(
                            "Name : " +
                                (Const.UMAP != null
                                    ? Const.UMAP["fullname"]
                                    : ""),
                            style: TextStyle(
                                color: Colors.black26, fontSize: 18))),
                    Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Text(
                            "Email : " +
                                (Const.UMAP != null ? Const.UMAP["email"] : ""),
                            style: TextStyle(
                                color: Colors.black26, fontSize: 18))),
                    Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Text(
                            "Phone : " +
                                (Const.UMAP != null
                                    ? Const.UMAP["phoneNo"]
                                    : ""),
                            style: TextStyle(
                                color: Colors.black26, fontSize: 18))),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () {},
                            padding: EdgeInsets.all(16),
                            color: Colors.brown,
                            child: Text('UPDATE',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            padding: EdgeInsets.all(16),
                            color: Colors.brown[300],
                            child: Text('CLOSE',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  _logOut() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Hello, " +
                (Const.UMAP != null ? Const.UMAP["fullname"].toString() : "")),
            content: Text("Do you want to log out ? "),
            actions: [
              new FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  authMethods.signOut().then((value) {
                    Const.crearConst();
                    Pref.saveUserLoginInSharedPreference(false);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => DriverLogin()));
                  });
                },
              ),
            ],
          );
        });
  }



}
