import 'dart:io';

import 'package:adastar/screens/driverlogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class DriverRegister extends StatefulWidget {
  static String tag = 'login-page';

  const DriverRegister({
    Key key,
  }) : super(key: key);

  @override
  _DriverRegisterState createState() => new _DriverRegisterState();
}

class _DriverRegisterState extends State<DriverRegister> {
  final globalKey = GlobalKey<ScaffoldState>();

  var fullNameTxt = TextEditingController();
  var phoneNumberTxt = TextEditingController();
  var linenseNumberTxt = TextEditingController();
  var truckTypeTxt = TextEditingController();
  var capacityTxt = TextEditingController();
  var plateNumberTxt = TextEditingController();
  var companyOwnerTxt = TextEditingController();
  var usernameTxt = TextEditingController();
  var passwordTxt = TextEditingController();

  var unFocus = FocusNode();
  var pwFocus = FocusNode();
  var logBtnFocus = FocusNode();

  File _pickedImageDriver = null;
  File _pickedImageLicFront = null;
  File _pickedImageLicBack = null;
  File _pickedImageTruck = null;
  File _pickedImageTruckCard = null;

  void _pickImage(String imgFor) async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file != null) {
        if (imgFor == "Driver") {
          setState(() => _pickedImageDriver = file);
        }
        if (imgFor == "LicFront") {
          setState(() => _pickedImageLicFront = file);
        }
        if (imgFor == "LicBack") {
          setState(() => _pickedImageLicBack = file);
        }
        if (imgFor == "Truck") {
          setState(() => _pickedImageTruck = file);
        }
        if (imgFor == "TruckCard") {
          setState(() => _pickedImageTruckCard = file);
        }
      }
    }
  }

  void _RemoveImage(String imgFor) async {
    if (imgFor == "Driver") {
      setState(() => _pickedImageDriver = null);
    }
    if (imgFor == "LicFront") {
      setState(() => _pickedImageLicFront = null);
    }
    if (imgFor == "LicBack") {
      setState(() => _pickedImageLicBack = null);
    }
    if (imgFor == "Truck") {
      setState(() => _pickedImageTruck = null);
    }
    if (imgFor == "TruckCard") {
      setState(() => _pickedImageTruckCard = null);
    }
  }

  void _formValidate() {
    if (fullNameTxt.text.trim().length == 0) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your full name'),
        ),
      );
      return;
    }
    if (phoneNumberTxt.text.trim().length == 0) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your phone number'),
        ),
      );
      return;
    }
    if (linenseNumberTxt.text.trim().length == 0) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your license number'),
        ),
      );
      return;
    }
    if (usernameTxt.text.trim().length == 0) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your username'),
        ),
      );
      return;
    }
    if (passwordTxt.text.trim().length == 0) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your password'),
        ),
      );
      return;
    }
    if (truckTypeTxt.text.trim().length == 0) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your truck type'),
        ),
      );
      return;
    }
    if (capacityTxt.text.trim().length == 0) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your capacity'),
        ),
      );
      return;
    }
    if (plateNumberTxt.text.trim().length == 0) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your plate number'),
        ),
      );
      return;
    }
    if (companyOwnerTxt.text.trim().length == 0) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your owner name'),
        ),
      );
      return;
    }

    if (_pickedImageDriver == null) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please add your photo'),
        ),
      );
      return;
    }

    if (_pickedImageLicFront == null) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please add license front photo'),
        ),
      );
      return;
    }
    if (_pickedImageLicBack == null) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please add license back photo'),
        ),
      );
      return;
    }
    if (_pickedImageTruck == null) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please add truck photo'),
        ),
      );
      return;
    }
    if (_pickedImageTruckCard == null) {
      globalKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please add truck card photo'),
        ),
      );
      return;
    }
  }

  void _save(){

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        backgroundColor: Colors.yellow,
        body: WillPopScope(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 30.0, left: 0, right: 0),
                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Builder(
                          builder: (BuildContext c) => IconButton(
                            icon: Icon(
                              Icons.chevron_left,
                              size: 30,
                              color: Colors.brown,
                            ),
                            onPressed: () => Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DriverLogin())),
                          ),
                        ),
                        Text(
                          "New Driver",
                          style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 10),
                    children: <Widget>[
                      Row(
                          children: <Widget>[
                        Text(
                          "Driver Details",
                          style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            /*decoration: TextDecoration.underline,
                              decorationThickness: 1,*/
                          ),
                        ),
                      ]),
                      Divider(
                        thickness: 1,
                        color: Colors.black38,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0),
                                      bottomLeft: Radius.circular(8.0),
                                      bottomRight: Radius.circular(8.0),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        _pickedImageDriver == null
                                            ? Image.asset(
                                                'assets/icon/app_icon.png',
                                                width: 150,
                                                height: 70,
                                                fit: BoxFit.fill)
                                            : Image.file(_pickedImageDriver,
                                                width: 150,
                                                height: 70,
                                                fit: BoxFit.fill),
                                        Container(
                                          width: 150,
                                          height: 40,
                                          color: Colors.brown[300],
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              new Positioned(
                                                  right: 0.0,
                                                  bottom: 0.0,
                                                  child: new IconButton(
                                                    icon: new Icon(
                                                        Icons
                                                            .add_photo_alternate,
                                                        color: Colors.white),
                                                    onPressed: () {
                                                      _pickImage("Driver");
                                                    },
                                                  )),
                                              new Positioned(
                                                  right: 0.0,
                                                  bottom: 0.0,
                                                  child: new IconButton(
                                                    icon: new Icon(Icons.clear,
                                                        color: Colors.white),
                                                    onPressed: () {
                                                      _RemoveImage("Driver");
                                                    },
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ]),
                          SizedBox(width: 5),
                          Expanded(
                              child: Column(
                            children: <Widget>[
                              TextFormField(
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                controller: fullNameTxt,
                                decoration: InputDecoration(
                                  hintText: 'Full Name',
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                controller: phoneNumberTxt,
                                decoration: InputDecoration(
                                  hintText: 'Phone Number',
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              autofocus: false,
//                    initialValue: '',
                              controller: linenseNumberTxt,
                              decoration: InputDecoration(
                                hintText: 'License number',
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              controller: usernameTxt,
                              decoration: InputDecoration(
                                hintText: 'Username',
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextFormField(
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            controller: passwordTxt,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text("License Front",
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                    )),
                                Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0),
                                            bottomLeft: Radius.circular(8.0),
                                            bottomRight: Radius.circular(8.0),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              _pickedImageLicFront == null
                                                  ? Image.asset(
                                                      'assets/icon/app_icon.png',
                                                      width: 150,
                                                      height: 100,
                                                      fit: BoxFit.fill)
                                                  : Image.file(
                                                      _pickedImageLicFront,
                                                      width: 150,
                                                      height: 100,
                                                      fit: BoxFit.fill),
                                              Container(
                                                width: 150,
                                                height: 40,
                                                color: Colors.brown[300],
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    new Positioned(
                                                        right: 0.0,
                                                        bottom: 0.0,
                                                        child: new IconButton(
                                                          icon: new Icon(
                                                              Icons
                                                                  .add_photo_alternate,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: () {
                                                            _pickImage(
                                                                "LicFront");
                                                          },
                                                        )),
                                                    new Positioned(
                                                        right: 0.0,
                                                        bottom: 0.0,
                                                        child: new IconButton(
                                                          icon: new Icon(
                                                              Icons.clear,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: () {
                                                            _RemoveImage(
                                                                "LicFront");
                                                          },
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ]),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text("License Back",
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                    )),
                                Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0),
                                            bottomLeft: Radius.circular(8.0),
                                            bottomRight: Radius.circular(8.0),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              _pickedImageLicBack == null
                                                  ? Image.asset(
                                                      'assets/icon/app_icon.png',
                                                      width: 150,
                                                      height: 100,
                                                      fit: BoxFit.fill)
                                                  : Image.file(
                                                      _pickedImageLicBack,
                                                      width: 150,
                                                      height: 100,
                                                      fit: BoxFit.fill),
                                              Container(
                                                width: 150,
                                                height: 40,
                                                color: Colors.brown[300],
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    new Positioned(
                                                        right: 0.0,
                                                        bottom: 0.0,
                                                        child: new IconButton(
                                                          icon: new Icon(
                                                              Icons
                                                                  .add_photo_alternate,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: () {
                                                            _pickImage(
                                                                "LicBack");
                                                          },
                                                        )),
                                                    new Positioned(
                                                        right: 0.0,
                                                        bottom: 0.0,
                                                        child: new IconButton(
                                                          icon: new Icon(
                                                              Icons.clear,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: () {
                                                            _RemoveImage(
                                                                "LicBack");
                                                          },
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ]),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(children: <Widget>[
                        Text(
                          "Truck Details",
                          style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            /*decoration: TextDecoration.underline,
                              decorationThickness: 1,*/
                          ),
                        ),
                      ]),
                      Divider(
                        thickness: 1,
                        color: Colors.black38,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              controller: truckTypeTxt,
                              decoration: InputDecoration(
                                hintText: 'Truck Type',
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextFormField(
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            controller: capacityTxt,
                            decoration: InputDecoration(
                              hintText: 'Capacity',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ))
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              controller: plateNumberTxt,
                              decoration: InputDecoration(
                                hintText: 'Plate Numbr',
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextFormField(
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            controller: companyOwnerTxt,
                            decoration: InputDecoration(
                              hintText: 'Company / Owner',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text("Truck",
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                    )),
                                Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0),
                                            bottomLeft: Radius.circular(8.0),
                                            bottomRight: Radius.circular(8.0),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              _pickedImageTruck == null
                                                  ? Image.asset(
                                                      'assets/icon/app_icon.png',
                                                      width: 150,
                                                      height: 100,
                                                      fit: BoxFit.fill)
                                                  : Image.file(
                                                      _pickedImageTruck,
                                                      width: 150,
                                                      height: 100,
                                                      fit: BoxFit.fill),
                                              Container(
                                                width: 150,
                                                height: 40,
                                                color: Colors.brown[300],
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    new Positioned(
                                                        right: 0.0,
                                                        bottom: 0.0,
                                                        child: new IconButton(
                                                          icon: new Icon(
                                                              Icons
                                                                  .add_photo_alternate,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: () {
                                                            _pickImage("Truck");
                                                          },
                                                        )),
                                                    new Positioned(
                                                        right: 0.0,
                                                        bottom: 0.0,
                                                        child: new IconButton(
                                                          icon: new Icon(
                                                              Icons.clear,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: () {
                                                            _RemoveImage(
                                                                "Truck");
                                                          },
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ]),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text("Truck Card",
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                    )),
                                Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0),
                                            bottomLeft: Radius.circular(8.0),
                                            bottomRight: Radius.circular(8.0),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              _pickedImageTruckCard == null
                                                  ? Image.asset(
                                                      'assets/icon/app_icon.png',
                                                      width: 150,
                                                      height: 100,
                                                      fit: BoxFit.fill)
                                                  : Image.file(
                                                      _pickedImageTruckCard,
                                                      width: 150,
                                                      height: 100,
                                                      fit: BoxFit.fill),
                                              Container(
                                                width: 150,
                                                height: 40,
                                                color: Colors.brown[300],
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    new Positioned(
                                                        right: 0.0,
                                                        bottom: 0.0,
                                                        child: new IconButton(
                                                          icon: new Icon(
                                                              Icons
                                                                  .add_photo_alternate,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: () {
                                                            _pickImage(
                                                                "TruckCard");
                                                          },
                                                        )),
                                                    new Positioned(
                                                        right: 0.0,
                                                        bottom: 0.0,
                                                        child: new IconButton(
                                                          icon: new Icon(
                                                              Icons.clear,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: () {
                                                            _RemoveImage(
                                                                "TruckCard");
                                                          },
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ]),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          onPressed: () {
                            _formValidate();
                          },
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          color: Colors.brown,
                          child: Text('Register',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onWillPop: () {
              exit(0);
            }));
  }
}
