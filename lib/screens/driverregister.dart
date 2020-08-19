import 'dart:io';

import 'package:adastar/models/user_.dart';
import 'package:adastar/screens/driverlogin.dart';
import 'package:adastar/screens/driverloginfromseekerlogin.dart';
import 'package:adastar/services/auth.dart';
import 'package:adastar/services/database.dart';
import 'package:adastar/services/imageupload.dart';
import 'package:adastar/util/dialog.dart';
import 'package:adastar/util/formvalidation.dart';
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
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var fullNameTxt = TextEditingController();
  var phoneNumberTxt = TextEditingController();
  var addressTxt = TextEditingController();
  var linenseNumberTxt = TextEditingController();
//  var truckTypeTxt = TextEditingController();
  var capacityTxt = TextEditingController();
  var plateNumberTxt = TextEditingController();
  var companyOwnerTxt = TextEditingController();
  var usernameTxt = TextEditingController();
  var passwordTxt = TextEditingController();

  File _pickedImageDriver = null;
  File _pickedImageLicFront = null;
  File _pickedImageLicBack = null;
  File _pickedImageTruck = null;
  File _pickedImageTruckCard = null;


  List<String> truckTypeDropdown = [
    "Caterpillar Trucks",
    "DAF Trucks",
    "Iveco",
    "Mercedes-Benz",
    "Fuso",
    "RFW",
    "Scania",
    "UD Trucks",
    "Volvo",
    "AWD",
    "FAR",
    "Fiat",
    "Ford",
    "Leyland",
    "MAN",
    "Star",
    "Toyota",
    "Tata",
  ];
  var selectedTruckType = "Caterpillar Trucks";


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
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your full name'),
        ),
      );
      return;
    } else if (phoneNumberTxt.text.trim().length == 0) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your phone number'),
        ),
      );
      return;
    } else if (!isValidMobile(phoneNumberTxt.text.trim())) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter Valid Phone Number'),
        ),
      );
      return;
    } else if (addressTxt.text.trim().length == 0) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your Address'),
        ),
      );
      return;
    }else if (usernameTxt.text.trim().length == 0) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your Email'),
        ),
      );
      return;
    } else if (!isValidateEmail(usernameTxt.text.trim())) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter Valid Email'),
        ),
      );
      return;
    } else if (passwordTxt.text.trim().length == 0) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your password'),
        ),
      );
      return;
    } else if (passwordTxt.text.trim().length < 6) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Password must include more that 6 characters'),
        ),
      );
      return;
    } else if (linenseNumberTxt.text.trim().length == 0) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your license number'),
        ),
      );
      return;
    } else if (selectedTruckType.trim().length == 0) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your truck type'),
        ),
      );
      return;
    } else if (capacityTxt.text.trim().length == 0) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your capacity'),
        ),
      );
      return;
    } else if (plateNumberTxt.text.trim().length == 0) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your plate number'),
        ),
      );
      return;
    } else if (companyOwnerTxt.text.trim().length == 0) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter your owner name'),
        ),
      );
      return;
    } else if (_pickedImageDriver == null) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please add your photo'),
        ),
      );
      return;
    } else if (_pickedImageLicFront == null) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please add license front photo'),
        ),
      );
      return;
    } else if (_pickedImageLicBack == null) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please add license back photo'),
        ),
      );
      return;
    } else if (_pickedImageTruck == null) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please add truck photo'),
        ),
      );
      return;
    } else if (_pickedImageTruckCard == null) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please add truck card photo'),
        ),
      );
      return;
    } else {
      _save();
    }
  }

  void _save() {
    Doalog.sinner(context);
    AuthMethods authMethods = new AuthMethods();
    authMethods
        .signUpWithEmailAndPassword(
            context, '' + usernameTxt.text.trim(), '' + passwordTxt.text.trim())
        .then((value) {
      if (value != null) {
        if (value is String) {
          print(value);
        } else {
          User user = new User(
              value.userId,
              "DRIVER",
              fullNameTxt.text.trim(),
              phoneNumberTxt.text.trim(),
              addressTxt.text.trim(),
              linenseNumberTxt.text.trim(),
              usernameTxt.text.trim(),
              passwordTxt.text.trim(),
              selectedTruckType.trim(),
              capacityTxt.text.trim(),
              plateNumberTxt.text.trim(),
              companyOwnerTxt.text.trim(),
              _pickedImageDriver.path.split('/').last.toString(),
              _pickedImageLicFront.path.split('/').last.toString(),
              _pickedImageLicBack.path.split('/').last.toString(),
              _pickedImageTruck.path.split('/').last.toString(),
              _pickedImageTruckCard.path.split('/').last);
          DatabaseMethods databaseMethods = new DatabaseMethods();
          ImageUploadMethods imageUploadMethods = new ImageUploadMethods();
          List<File> images = [
            _pickedImageDriver,
            _pickedImageLicFront,
            _pickedImageLicBack,
            _pickedImageTruck,
            _pickedImageTruckCard
          ];
          imageUploadMethods.createImageUpload(context, value.userId, images);
          databaseMethods.createUser(context, user.toJson(), value.userId);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => DriverLoginFromSeeker()));
      },
      child: new Scaffold(
          key: scaffoldKey,
          backgroundColor: Color(0xffffaa00),
          appBar: new AppBar(
            backgroundColor: Color(0xffffaa00),
            leading: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/icon/app_icon.png',
                    width: 100, height: 100, fit: BoxFit.fill)),
            title: Text("Adastra"),
            titleSpacing: 0,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.brown,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Driver Details",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    /*decoration: TextDecoration.underline,
                                decorationThickness: 1,*/
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
                GestureDetector(
                  onTap: () {
                    _pickImage("Driver");
                  },
                  onLongPress: () {
                    _RemoveImage("Driver");
                  },
                  child: Center(
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: _pickedImageDriver == null
                          ? AssetImage('assets/img/blankimage.png')
                          : FileImage(_pickedImageDriver),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  controller: fullNameTxt,
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  controller: phoneNumberTxt,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  controller: addressTxt,
                  decoration: InputDecoration(
                    hintText: 'Address',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  controller: usernameTxt,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  controller: passwordTxt,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
//                    initialValue: '',
                  controller: linenseNumberTxt,
                  decoration: InputDecoration(
                    hintText: 'License number',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
                  child: Text("License images(Fron / Back):"),
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _pickImage("LicFront");
                      },
                      onLongPress: () {
                        _RemoveImage("LicFront");
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              _pickedImageLicFront == null
                                  ? Image.asset('assets/img/blankimage.png',
                                      width: 100, height: 100, fit: BoxFit.fill)
                                  : Image.file(_pickedImageLicFront,
                                      width: 100, height: 100, fit: BoxFit.fill),
                            ],
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pickImage("LicBack");
                      },
                      onLongPress: () {
                        _RemoveImage("LicBack");
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              _pickedImageLicBack == null
                                  ? Image.asset('assets/img/blankimage.png',
                                      width: 100, height: 100, fit: BoxFit.fill)
                                  : Image.file(_pickedImageLicBack,
                                      width: 100, height: 100, fit: BoxFit.fill),
                            ],
                          )),
                    ),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),
                Text(
                  "Truck Details",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    /*decoration: TextDecoration.underline,
                                decorationThickness: 1,*/
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black,
                ),

                DropdownButton<String>(
                  value: selectedTruckType,
                  icon: Icon(Icons.keyboard_arrow_down),
                  iconSize: 24,
                  elevation: 16,
                  isExpanded: true,
                  underline: Container(
                    color: Colors.black38,
                    height: 1,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      selectedTruckType = newValue;
                    });
                  },
                  items: truckTypeDropdown
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  controller: capacityTxt,
                  decoration: InputDecoration(
                    hintText: 'Capacity',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  controller: plateNumberTxt,
                  decoration: InputDecoration(
                    hintText: 'Plate Numbr',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  controller: companyOwnerTxt,
                  decoration: InputDecoration(
                    hintText: 'Company / Owner',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Truck & Truck Card images"),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _pickImage("Truck");
                      },
                      onLongPress: () {
                        _RemoveImage("Truck");
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              _pickedImageTruck == null
                                  ? Image.asset('assets/img/blankimage.png',
                                      width: 100, height: 100, fit: BoxFit.fill)
                                  : Image.file(_pickedImageTruck,
                                      width: 100, height: 100, fit: BoxFit.fill),
                            ],
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pickImage("TruckCard");
                      },
                      onLongPress: () {
                        _RemoveImage("TruckCard");
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              _pickedImageTruckCard == null
                                  ? Image.asset('assets/img/blankimage.png',
                                      width: 100, height: 100, fit: BoxFit.fill)
                                  : Image.file(_pickedImageTruckCard,
                                      width: 100, height: 100, fit: BoxFit.fill),
                            ],
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Color(0xffffaa00), width: 3)),
                  onPressed: () {
                    _formValidate();
                  },
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  color: Colors.black,
                  child: Text('Register',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ))),
    );
  }
}
