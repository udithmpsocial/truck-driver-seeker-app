import 'dart:convert';

import 'package:adastar/config/const.dart';
import 'package:adastar/models/truckstatus.dart';
import 'package:adastar/screens/driverlogin.dart';
import 'package:adastar/screens/userhome.dart';
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

class DriverHome extends StatefulWidget {
  static String tag = 'login-page';

  const DriverHome({
    Key key,
  }) : super(key: key);

  @override
  _DriverHomeState createState() => new _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  LocationResult _pickedLocation,
      _pickedDestinationLocation,
      _pickedsecondDestinationLocation,
      _pickedthiredDestinationLocation;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();


  var firstPrefDestinationTxt = TextEditingController();
  var firstPrefDestinationCoordinatesTxt = TextEditingController();

  var secondPrefDestinationTxt = TextEditingController();
  var secondPrefDestinationCoordinatesTxt = TextEditingController();

  var thiredPrefDestinationTxt = TextEditingController();
  var thiredPrefDestinationCoordinatesTxt = TextEditingController();

  var bitPriceTxt = TextEditingController();

  List<dynamic> stats;
  List<Map<String, dynamic>> listview = [];
  List<String> truckStatusDropdown = ["Ready", "Ern route", "Yard"];
  var selectedTruckStatus = "Ready";
  List<String> cargoStatusDropdown = [
    "Empty",
    "Partial Empty",
    "Partial Full",
    "Full"
  ];
  var selectedcargoStatus = "Empty";
  bool _isLastLocation = true;

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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButton<String>(
                        value: selectedTruckStatus,
                        icon: Icon(Icons.keyboard_arrow_down),
                        iconSize: 24,
                        elevation: 16,
                        isExpanded: true,
                        onChanged: (String newValue) {
                          setState(() {
                            selectedTruckStatus = newValue;
                          });
                        },
                        items: truckStatusDropdown
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
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
                            onLongPress: () {
                              firstPrefDestinationTxt.text = "";
                              firstPrefDestinationCoordinatesTxt.text = "";
                            },
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
                                List<Placemark> placemark = await Geolocator()
                                    .placemarkFromCoordinates(
                                        _pickedDestinationLocation
                                            .latLng.latitude,
                                        _pickedDestinationLocation
                                            .latLng.longitude);

                                _pickedDestinationLocation.address == null
                                    ? firstPrefDestinationTxt.text = "" +
                                        placemark[0].name +
                                        ", " +
                                        placemark[0].country +
                                        ", " +
                                        placemark[0].subLocality
                                    : firstPrefDestinationTxt.text =
                                        _pickedDestinationLocation.address;
                                firstPrefDestinationCoordinatesTxt.text = "" +
                                    placemark[0].position.longitude.toString() +
                                    "," +
                                    placemark[0].position.latitude.toString();
                              });

                              //new location code----------------------------
                            },
                            child: Icon(Icons.add_location),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              enabled: false,
                              controller: secondPrefDestinationTxt,
                              decoration: InputDecoration(
                                hintText: 'Second Destination',
                              ),
                            ),
                          ),
                          GestureDetector(
                            onLongPress: () {
                              secondPrefDestinationTxt.text = "";
                              secondPrefDestinationCoordinatesTxt.text = "";
                            },
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
                                _pickedsecondDestinationLocation = result;
                                List<Placemark> placemark = await Geolocator()
                                    .placemarkFromCoordinates(
                                        _pickedsecondDestinationLocation
                                            .latLng.latitude,
                                        _pickedsecondDestinationLocation
                                            .latLng.longitude);

                                _pickedsecondDestinationLocation.address == null
                                    ? secondPrefDestinationTxt.text = "" +
                                        placemark[0].name +
                                        ", " +
                                        placemark[0].country +
                                        ", " +
                                        placemark[0].subLocality
                                    : secondPrefDestinationTxt.text =
                                        _pickedsecondDestinationLocation
                                            .address;
                                secondPrefDestinationCoordinatesTxt.text = "" +
                                    placemark[0].position.longitude.toString() +
                                    "," +
                                    placemark[0].position.latitude.toString();
                              });

                              //new location code----------------------------
                            },
                            child: Icon(Icons.add_location),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              enabled: false,
                              controller: thiredPrefDestinationTxt,
                              decoration: InputDecoration(
                                hintText: 'Thired Destination',
                              ),
                            ),
                          ),
                          GestureDetector(
                            onLongPress: () {
                              thiredPrefDestinationTxt.text = "";
                              thiredPrefDestinationCoordinatesTxt.text = "";
                            },
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
                                _pickedthiredDestinationLocation = result;
                                List<Placemark> placemark = await Geolocator()
                                    .placemarkFromCoordinates(
                                        _pickedthiredDestinationLocation
                                            .latLng.latitude,
                                        _pickedthiredDestinationLocation
                                            .latLng.longitude);

                                _pickedthiredDestinationLocation.address == null
                                    ? thiredPrefDestinationTxt.text = "" +
                                        placemark[0].name +
                                        ", " +
                                        placemark[0].country +
                                        ", " +
                                        placemark[0].subLocality
                                    : thiredPrefDestinationTxt.text =
                                        _pickedthiredDestinationLocation
                                            .address;
                                thiredPrefDestinationCoordinatesTxt.text = "" +
                                    placemark[0].position.longitude.toString() +
                                    "," +
                                    placemark[0].position.latitude.toString();
                              });

                              //new location code----------------------------
                            },
                            child: Icon(Icons.add_location),
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
                                _getTruckStatusList();
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
                                _getTruckStatusListByFilter();
//                                _validate();
//                                _getTruckStatusList();
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
                  : ListView.builder(
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
                                        CrossAxisAlignment
                                            .end,
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment
                                                .centerRight,
                                            child:
                                            GestureDetector(
                                                onTap: () {
                                                  _addBid(
                                                      listview[i]["userId"]
                                                          .toString(),
                                                      listview[i]["lineId"]
                                                          .toString());
                                                },
                                                child: Icon(
                                                  Icons
                                                      .monetization_on,
                                                  color: Colors
                                                      .green,
                                                )),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style:
                                          DefaultTextStyle.of(
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
                          Divider()
                        ],
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getTruckStatusList() {
    setState(() {
      listview.clear();
    });
    databaseMethods.getUserAll().then((value) {
      QuerySnapshot snapshot = value;
      if (snapshot.documents.length > 0) {
        snapshot.documents.forEach((elementUser) {
          databaseMethods
              .getUserRquestAllById(elementUser.documentID)
              .then((value) {
            setState(() {
//              listview.clear();
              QuerySnapshot requestByseeker = value;
              stats = requestByseeker.documents;
              stats.forEach((element) {
                DocumentSnapshot elementRequest = element;
                Map<String, dynamic> driverResponse = {};
                Map<String, dynamic> line = {
                  "userId": "" + elementUser.documentID,
                  "lineId": "" + elementRequest.documentID,
                  "data": elementRequest.data,
                };
                //driverResponse
                String mapstr = json.encode(line);
                print("Driver Res>>>>>" + mapstr);
                listview.add(line);
              });
            });
          });
        });
      }
    });
  }

  _getTruckStatusListByFilter() {
    Doalog.sinner(context);
    setState(() {
      listview.clear();
    });
    databaseMethods.getUserAll().then((value) {
      QuerySnapshot snapshot = value;
      Navigator.pop(context);
      if (snapshot.documents.length > 0) {
        snapshot.documents.forEach((elementUser) {
          databaseMethods
              .getUserRquestAllById(elementUser.documentID)
              .then((value) {
            setState(() {
              QuerySnapshot requestByseeker = value;
              stats = requestByseeker.documents;
              stats.forEach((element) {
                DocumentSnapshot elementRequest = element;

                elementRequest.data["currentLocationCoordinates"];
                elementRequest.data["prefDestinationCoordinates"];
                elementRequest.data["cargoStatus"];

                if (elementRequest.data["cargoStatus"] == selectedcargoStatus &&
                    (firstPrefDestinationCoordinatesTxt == null ||
                        firstPrefDestinationCoordinatesTxt.text
                                    .toString()
                                    .length ==
                                0 &&
                            secondPrefDestinationCoordinatesTxt == null ||
                        secondPrefDestinationCoordinatesTxt.text
                                    .toString()
                                    .length ==
                                0 &&
                            thiredPrefDestinationCoordinatesTxt == null ||
                        thiredPrefDestinationCoordinatesTxt.text
                                .toString()
                                .length ==
                            0)) {
                  Map<String, dynamic> line = {
                    "userId": "" + elementUser.documentID,
                    "lineId": "" + elementRequest.documentID,
                    "data": elementRequest.data,
                  };
                  //driverResponse
                  String mapstr = json.encode(line);
                  print("Driver Res>>>>>" + mapstr);
                  listview.add(line);
                } else if (elementRequest.data["cargoStatus"] ==
                    selectedcargoStatus) {
                  if (elementRequest.data["prefDestinationCoordinates"] ==
                          firstPrefDestinationCoordinatesTxt.text.toString() ||
                      elementRequest.data["prefDestinationCoordinates"] ==
                          secondPrefDestinationCoordinatesTxt.text.toString() ||
                      elementRequest.data["prefDestinationCoordinates"] ==
                          thiredPrefDestinationCoordinatesTxt.text.toString() ||
                      elementRequest.data["prefDestination"] ==
                          firstPrefDestinationTxt.text.toString() ||
                      elementRequest.data["prefDestination"] ==
                          secondPrefDestinationTxt.text.toString() ||
                      elementRequest.data["prefDestination"] ==
                          thiredPrefDestinationTxt.text.toString()) {
                    Map<String, dynamic> line = {
                      "userId": "" + elementUser.documentID,
                      "lineId": "" + elementRequest.documentID,
                      "data": elementRequest.data,
                    };
                    //driverResponse
                    String mapstr = json.encode(line);
                    print("Driver Res>>>>>" + mapstr);
                    listview.add(line);
                  }
                }
              });
            });
          });
        });
      }
    });
  }

  _reset() {
    setState(() {
      selectedTruckStatus = truckStatusDropdown[0];
      selectedcargoStatus = cargoStatusDropdown[0];
      firstPrefDestinationTxt.text = "";
      secondPrefDestinationTxt.text = "";
      thiredPrefDestinationTxt.text = "";
    });
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

  _addBid(String userLineIdTxt, String requestLineIdTxt) async {
    await Geolocator().isLocationServiceEnabled().then((value){
      if(value){
        Doalog.sinner(context);
        Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .then((value) {
          Navigator.pop(context);
          var currentLocation =
              "" + value.longitude.toString() + "," + value.latitude.toString();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Hello, " +
                      (Const.UMAP != null
                          ? Const.UMAP["fullname"].toString()
                          : "")),
                  content: Wrap(
                    children: <Widget>[
                      Text("Add you bid here, "),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        controller: bitPriceTxt,
                        decoration: InputDecoration(
                          hintText: 'Price',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    new FlatButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new FlatButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Map<String, dynamic> truckStatusMap = {};
                        truckStatusMap = {
                          "currentLocation": "",
                          "currentLocationCoordinates": currentLocation,
                          "truckStatus": "" + selectedTruckStatus,
                          "cargoStatus": "" + selectedcargoStatus,
                          "prefDestination": "",
                          "prefDestinationCoordinates": currentLocation,
                          "price": bitPriceTxt.text
                        };

                        if (bitPriceTxt.text.trim() != "" &&
                            bitPriceTxt.text.trim().length != 0) {
                          Doalog.sinner(context);
                          databaseMethods
                              .addDriverResponseDynamic(userLineIdTxt, Const.UID,
                              requestLineIdTxt, truckStatusMap)
                              .then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            bitPriceTxt.clear();
                            _getTruckStatusList();
                          });
                        }
                        _reset();
                      },
                    ),
                  ],
                );
              });
        }).catchError((onError) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Something wrong..."),
                  content: Wrap(
                    children: <Widget>[
                      Text("ERROR: \n" + onError.toString()),
                    ],
                  ),
                  actions: [
                    new FlatButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        });
      }else{
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Something wrong..."),
                content: Wrap(
                  children: <Widget>[
                    Text("ERROR: Turn on GPS"),
                  ],
                ),
                actions: [
                  new FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }

    }).catchError((onError){

    });


  }
}
