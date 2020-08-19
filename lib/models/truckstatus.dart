import 'package:firebase_database/firebase_database.dart';

class TruckStatusList{
  String userId;
  List<TruckStatus> truckStatusList;

  TruckStatusList(this.truckStatusList);

  TruckStatusList.fromMap(Map snapshot,String id) :
        userId = id ?? '',
        truckStatusList = snapshot['truckStatusList'] ?? '';

  toJson() {
    return {
      "userId": userId,
      "truckStatusList": truckStatusList,
    };
  }

}

class TruckStatus {

  String id;
  String userId;
  String currentLocation;
  String truckStatus;
  String cargoStatus;
  String prefDestination;
  String price;


  TruckStatus(this.id, this.userId, this.currentLocation, this.truckStatus,
      this.cargoStatus, this.prefDestination, this.price);

  TruckStatus.fromMap(Map snapshot,String id) :
        userId = id ?? '',
        id = snapshot['id'] ?? '',
        currentLocation = snapshot['currentLocation'] ?? '',
        truckStatus = snapshot['truckStatus'] ?? '',
        cargoStatus = snapshot['cargoStatus'] ?? '',
        prefDestination = snapshot['prefDestination'] ?? '';


  toJson() {
    return {
      "userId": userId,
      "id": id,
      "currentLocation": currentLocation,
      "truckStatus": truckStatus,
      "cargoStatus": cargoStatus,
      "prefDestination": prefDestination,
    };
  }
}
