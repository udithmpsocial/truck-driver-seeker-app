import 'package:firebase_auth/firebase_auth.dart';

class Const {
  static FirebaseAuth FIREDB = null;
  static String UID = null;
  static Map<String, dynamic>  UMAP = null;
  static crearConst(){
    FIREDB = null;
    UID = null;
    UMAP = null;
  }


  static var PREFERENCEKEY_USERLOGIN = "ISUERLGIN";
  static var PREFERENCEKEY_USERTYPE = "USERTYPE";
  static var PREFERENCEKEY_USERID = "USERID";
  static var PREFERENCEKEY_USERMAP = "USERMAP";

  //for view resposes of selected request
  static var USERREQUESTLINEID = null;
  static var USERREQUESTDESTINATION = null;
  static var USERREQUESTDESTINATIONCOD = null;
}
