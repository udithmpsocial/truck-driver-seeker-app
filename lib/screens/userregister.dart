import 'dart:io';

import 'package:adastar/models/user_.dart';
import 'package:adastar/screens/driverlogin.dart';
import 'package:adastar/services/auth.dart';
import 'package:adastar/services/database.dart';
import 'package:adastar/services/imageupload.dart';
import 'package:adastar/util/dialog.dart';
import 'package:adastar/util/formvalidation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class UserRegister extends StatefulWidget {
  static String tag = 'login-page';

  const UserRegister({
    Key key,
  }) : super(key: key);

  @override
  _UserRegisterState createState() => new _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var fullNameTxt = TextEditingController();
  var phoneNumberTxt = TextEditingController();
  var addressTxt = TextEditingController();
  var usernameTxt = TextEditingController();
  var passwordTxt = TextEditingController();

  File _pickedImageSeeker = null;





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
        if (imgFor == "Seeker") {
          setState(() => _pickedImageSeeker = file);
        }

      }
    }
  }

  void _RemoveImage(String imgFor) async {
    if (imgFor == "Seeker") {
      setState(() => _pickedImageSeeker = null);
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
    } else if (_pickedImageSeeker == null) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please add your photo'),
        ),
      );
      return;
    }  else {
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
              "USER",
              fullNameTxt.text.trim(),
              phoneNumberTxt.text.trim(),
              addressTxt.text.trim(),
              "",
              usernameTxt.text.trim(),
              passwordTxt.text.trim(),
              "",
              "",
              "",
              "",
              _pickedImageSeeker.path.split('/').last.toString(),
              "",
              "",
              "",
            "");
          DatabaseMethods databaseMethods = new DatabaseMethods();
          ImageUploadMethods imageUploadMethods = new ImageUploadMethods();
          List<File> images = [
            _pickedImageSeeker
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
            builder: (BuildContext context) => DriverLogin()));
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
                  "Seeker Details",
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
                    _pickImage("Seeker");
                  },
                  onLongPress: () {
                    _RemoveImage("Seeker");
                  },
                  child: Center(
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: _pickedImageSeeker == null
                          ? AssetImage('assets/img/blankimage.png')
                          : FileImage(_pickedImageSeeker),
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
