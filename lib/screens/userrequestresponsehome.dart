import 'package:adastar/config/const.dart';
import 'package:adastar/models/truckstatus.dart';
import 'package:adastar/screens/driverlogin.dart';
import 'package:adastar/screens/userhome.dart';
import 'package:adastar/screens/userrequesthome.dart';
import 'package:adastar/screens/userrole.dart';
import 'package:adastar/services/auth.dart';
import 'package:adastar/services/database.dart';
import 'package:adastar/util/dialog.dart';
import 'package:adastar/util/location.dart';
import 'package:adastar/util/preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class UserRequestRespose extends StatefulWidget {

  @override
  _UserRequestResposeState createState() => new _UserRequestResposeState();
}

class _UserRequestResposeState extends State<UserRequestRespose> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  List<dynamic> responseListdynamic;
  List<Map<String, dynamic>> responseListMap = [];


  GoogleMapController mapController;
  double _originLatitude = 6.5212402, _originLongitude = 3.3679965;
  double _destLatitude = 6.849660, _destLongitude = 3.648190;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyA4xfzmVOnAqZeTqmQuydC7R1S4x5WLfvE";
  Dio dio = new Dio();



  @override
  void initState() {
    super.initState();
    _open();
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
            Icons.arrow_back_ios,
            color: Colors.brown,
          ),
          onPressed: () =>  Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => UserRequestHome())),
        ),
        title: Text("Hello, " +
            (Const.UMAP != null ? Const.UMAP["fullname"].toString() : "")+"."),
        titleSpacing: 0,
      ),

      body: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => UserRequestHome()));
        },
        child:
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Row(

                children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Map markers - ", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),)),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.location_on, color: Colors.red),
                          Text("Driver", style: TextStyle(fontStyle: FontStyle.italic),),
                          SizedBox(width: 10,),
                          Icon(Icons.location_on, color: Colors.green),
                          Text("Seeker", style: TextStyle(fontStyle: FontStyle.italic),)
                        ],
                      )),

                ],
              ),
            ),

            responseListMap == null || responseListMap.length == 0
                ? Container(
              child: Image.asset('assets/img/noresult.jpg'),
            )
                :
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: responseListMap.length,
              itemBuilder: (context, i) {
                var src = responseListMap[i]["currentLocationCoordinates"].toString().split(",");
//                var des = responseListMap[i]["prefDestinationCoordinates"].toString().split(",");
                var des = Const.USERREQUESTDESTINATIONCOD.toString().split(",");
               // _getETA(responseListMap[i]["currentLocationCoordinates"].toString(), responseListMap[i]["prefDestinationCoordinates"].toString());

                return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: <Widget>[
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onLongPress: (){

                                    _addMarker(LatLng(double.parse(src[1]), double.parse(src[0])), "origin",
                                        BitmapDescriptor.defaultMarker);

                                    _addMarker(LatLng(double.parse(des[1]), double.parse(des[0])), "destination",
                                        BitmapDescriptor.defaultMarkerWithHue(90));
                                    _getPolyline();
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Route"),
                                            content: SizedBox(
                                              height: 400,
                                              width: 300,
                                              child: GoogleMap(
                                                initialCameraPosition: CameraPosition(
                                                    target: LatLng(double.parse(src[1]), double.parse(src[0])), zoom:5),
                                                myLocationEnabled: true,
                                                tiltGesturesEnabled: true,
                                                compassEnabled: true,
                                                scrollGesturesEnabled: true,
                                                zoomGesturesEnabled: true,
                                                onMapCreated: _onMapCreated,
                                                markers: Set<Marker>.of(markers.values),
                                                polylines: Set<Polyline>.of(polylines.values),
                                              ),
                                            ),
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
                                  },
                                  child: Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: SizedBox(
                                        height: 150,
                                        width: 200,
                                        child: GoogleMap(
                                          initialCameraPosition: CameraPosition(
                                              target: LatLng(double.parse(src[1]), double.parse(src[0])), zoom:10),
                                          myLocationEnabled: true,
                                          tiltGesturesEnabled: true,
                                          compassEnabled: true,
                                          scrollGesturesEnabled: true,
                                          zoomGesturesEnabled: true,
                                          onMapCreated: _onMapCreated,
                                          markers: Set<Marker>.of(markers.values),
                                          polylines: Set<Polyline>.of(polylines.values),
                                        ),
                                      ),
                                    ),
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
                                              responseListMap[i]["price"]
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
                                              responseListMap[i]["capacity"]
                                                  .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                     /* Text('Time: 5.25Hr',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18)),*/
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
                                              child: GestureDetector(
                                                onTap: (){
                                                  launch("tel://"+responseListMap[i]
                                                  ["number"]
                                                      .toString());
                                                },
                                                child: Icon(
                                                  Icons.call,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                                text: '\t\t' +
                                                    responseListMap[i]
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
                        ),
                        Divider()
                      ],
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }


  _open(){
    setState(() {
      responseListMap.clear();
    });
    if(Const.USERREQUESTLINEID !="" || Const.USERREQUESTLINEID !=null){
      databaseMethods.getDriverResponseAllByUserRquest(Const.UID,Const.USERREQUESTLINEID).then((value){
        QuerySnapshot snapshotRequest = value;
        setState(() {
          snapshotRequest.documents.forEach((documentRequest) {
            print("DOCID>>>>"+documentRequest.documentID);
            databaseMethods.getUserById(context,documentRequest.documentID).then((value){
              DocumentSnapshot documentSnapshotUser = value;
              var uid = documentSnapshotUser.data["id"];
              var name = documentSnapshotUser.data["fullName"];
              var number = documentSnapshotUser.data["phoneNo"];
              var type = documentSnapshotUser.data["truckType"];
              var capacity = documentSnapshotUser.data["capacity"];
              Map<String, dynamic> line = {
                "cargoStatus": documentRequest.data["cargoStatus"],
                "currentLocation": documentRequest.data["currentLocation"],
                "currentLocationCoordinates": documentRequest.data["currentLocationCoordinates"],
                "prefDestination": documentRequest.data["prefDestination"],
                "prefDestinationCoordinates": documentRequest.data["prefDestinationCoordinates"],
                "price": documentRequest.data["price"],
                "name": name,
                "number": number,
                "type": type,
                "capacity": capacity,
              };
              setState(() {
                responseListMap.add(line);
              });
            });
          });
        });

      });
    }
  }



  // draw map data----------------------
  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        width: 5,
        consumeTapEvents: true,
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() { polylines[id] = polyline;});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyA4xfzmVOnAqZeTqmQuydC7R1S4x5WLfvE",
        PointLatLng(_originLatitude, _originLongitude),
        PointLatLng(_destLatitude, _destLongitude),

        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]
    ).then((value) {
      setState(() {
        if (value.points.isNotEmpty) {
          value.points.forEach((PointLatLng point) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });
        }
        _addPolyLine();
      });
    });
  }

  _getETA(var start, var dest) async {
    Response response=await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins="+start+"&destinations="+dest+"&key=AIzaSyA4xfzmVOnAqZeTqmQuydC7R1S4x5WLfvE");
    response=await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial"
        "&origins="+start+""
        "&destinations="+dest+""
        "&key=AIzaSyA4xfzmVOnAqZeTqmQuydC7R1S4x5WLfvE");
    print("ETA S>>"+start);
    print("ETA E>>"+dest);
    print("ETA T>>"+response.data.toString());

  }
}

