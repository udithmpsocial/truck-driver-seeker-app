import 'package:adastar/config/const.dart';
import 'package:adastar/models/truckstatus.dart';
import 'package:adastar/screens/driverlogin.dart';
import 'package:adastar/screens/userrole.dart';
import 'package:adastar/services/auth.dart';
import 'package:adastar/services/database.dart';
import 'package:adastar/util/dialog.dart';
import 'package:adastar/util/location.dart';
import 'package:adastar/util/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class UserHome extends StatefulWidget {
  static String tag = 'login-page';

  const UserHome({
    Key key,
  }) : super(key: key);

  @override
  _UserHomeState createState() => new _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static const kGoogleApiKey = "Api_key";


  Stream driverStatusStream;

  var destinationTxt = TextEditingController();
  var priceTxt = TextEditingController();

  DatabaseMethods databaseMethods = new DatabaseMethods();
  List<Map<String, dynamic>> listview = [];
  List<String> destinationList = [];

  List<Map<String, dynamic>> listviewData = [];

  List<String> cargoStatusDropdown = [
    "Empty",
    "Partial Empty",
    "Partial Full",
    "Full"
  ];
  var selectedcargoStatus = "Empty";

  @override
  void initState() {
    super.initState();
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
              Icons.person,
              color: Colors.brown,
            ),
          ),
          title: Text("Find A Truck"),
          titleSpacing: 0,
          actions: <Widget>[
            
            Card(
              color: Color(0xffffaa00),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: (){
                    _switchToDriver();
                  },
                  child: Row(
                    children: <Widget>[
                      Text("User as Driver", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
                      IconButton(
                        icon: Icon(
//              Icons.more_vert,
                          Icons.airport_shuttle,
                          color: Colors.white,
                        ),
                        onPressed: () {
//                _logOut();


                        },
                      ),
                    ],
                  ),
                ),
              ),
            )

          ],
        ),
        body: WillPopScope(
            onWillPop: () {
              return;
            },
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    new Card(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),



                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    autofocus: false,
                                    controller: destinationTxt,
                                    decoration: InputDecoration(
                                      hintText: 'Destination',
                                      prefixIcon:
                                          Icon(Icons.not_listed_location),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              children: <Widget>[
                                Container(
                                  height: 60,
                                  margin: EdgeInsets.only(left: 45),
                                  child: DropdownButton<String>(
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
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 60,
                                    margin: EdgeInsets.only(left: 12),
                                    child: Icon(
                                      Icons.card_travel,
                                      color: Colors.grey,
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            /*
                            TextFormField(
                              keyboardType: TextInputType.number,
                              autofocus: false,
                              controller: priceTxt,
                              decoration: InputDecoration(
                                hintText: 'Price',
                                prefixIcon: Icon(Icons.monetization_on),
                              ),
                            ),
*/
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
                                      _getDriverStatus(
                                          destinationTxt.text.trim(),
                                          selectedcargoStatus.trim(),
                                          priceTxt.text.trim());
                                    },
                                    padding: EdgeInsets.all(16),
                                    color: Colors.brown,
                                    child: Text('SEARCH',
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
                    Visibility(
                      visible: listviewData.length > 0 ? true : false,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: listviewData.length,
                            itemBuilder: (context, i) {
                              return Card(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                              "" +
                                                  listviewData[i]
                                                          ["currentLocation"]
                                                      .toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18,
                                              )),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                                'Tsh. ' +
                                                    listviewData[i]["price"]
                                                        .toString() +
                                                    ".00",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 30)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                '' +
                                                    listviewData[i]["capacity"]
                                                        .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text('Time: 5.25Hr',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons.call,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text: '\t\t' +
                                                          listviewData[i]
                                                                  ["name"]
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 20)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ]),
            ))));
  }

  _getDriverStatus(String destination, String cargoStatus, String price) {
    Doalog.sinner(context);
    print(""+destination+""+cargoStatus+""+price);
    listviewData.clear();
    databaseMethods.getDriverAll().then((value) {
      if (value != null) {
        QuerySnapshot querySnapshot = value;
        querySnapshot.documents.forEach((element) {
          var uid = element.data["id"];
          var name = element.data["fullName"];
          var number = element.data["phoneNo"];
          var type = element.data["truckType"];
          var capacity = element.data["capacity"];
//          "colombo", "gampaha", "100"
          databaseMethods
              .getTruckStatusAllByFilters(uid, destination, cargoStatus, price)
              .then((value) {
            if (value != null) {
              QuerySnapshot querySnapshot = value;
              querySnapshot.documents.forEach((element) {
                Map<String, dynamic> status = {
                  "name": name,
                  "number": number,
                  "type": type,
                  "capacity": capacity,
                  "cargoStatus": element.data["cargoStatus"],
                  "currentLocation": element.data["currentLocation"],
                  "price": element.data["price"],
                };
                setState(() {
                  listviewData.add(status);
                });
              });
            }
          });
        });
        Navigator.pop(context);
      }
    });
  }

  _reset() {
    destinationTxt.text = "";
    selectedcargoStatus = cargoStatusDropdown[0].toString();
    priceTxt.text = "";
    setState(() {
      listviewData.clear();
    });
  }

  _logOut() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Hello"),
            content: Text("Do you want to quit ? "),
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
                  Const.crearConst();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => UserRole()));
                },
              ),

            ],
          );
        });
  }

  Future<void> _makePhoneCall() async {
    var _phone = 111111;
    if (await canLaunch('tel:$_phone')) {
      await launch('tel:$_phone');
    } else {
      throw 'Could not launch ';
    }
  }

  void _switchToDriver() {
    Pref.saveUserLoginInSharedPreference(false).then((value){
      Pref.saveUserTypeInSharedPreference("SEEKER");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => DriverLogin()));
    });

  }


}
