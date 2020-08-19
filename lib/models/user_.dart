import 'package:firebase_database/firebase_database.dart';

class User {

  String id;
  String userType;
  String fullName;
  String phoneNo;
  String address;
  String licenseNo;
  String email;
  String password;
  String truckType;
  String capacity;
  String plateNo;
  String companyOwner;

  String imageDriver;
  String imageLicFront;
  String imageLicBack;
  String imageTruck;
  String imageTruckCard;


  User(
      this.id,
      this.userType,
      this.fullName,
      this.phoneNo,
      this.address,
      this.licenseNo,
      this.email,
      this.password,
      this.truckType,
      this.capacity,
      this.plateNo,
      this.companyOwner,
      this.imageDriver,
      this.imageLicFront,
      this.imageLicBack,
      this.imageTruck,
      this.imageTruckCard);



  User.fromMap(Map snapshot,String id) :
        id = id ?? '',
        userType = snapshot['userType'] ?? '',
        fullName = snapshot['fullName'] ?? '',
        phoneNo = snapshot['phoneNo'] ?? '',
        address = snapshot['address'] ?? '',
        licenseNo = snapshot['licenseNo'] ?? '',
        email = snapshot['email'] ?? '',
        password = snapshot['password'] ?? '',
        truckType = snapshot['truckType'] ?? '',
        capacity = snapshot['capacity'] ?? '',
        plateNo = snapshot['plateNo'] ?? '',
        companyOwner = snapshot['companyOwner'] ?? '',

        imageDriver = snapshot['imageDriver'] ?? '',
        imageLicFront = snapshot['imageLicFront'] ?? '',
        imageLicBack = snapshot['imageLicBack'] ?? '',
        imageTruck = snapshot['imageTruck'] ?? '',
        imageTruckCard = snapshot['imageTruckCard'] ?? '';


  toJson() {
    return {
      "id": id,
      "userType": userType,
      "fullName": fullName,
      "phoneNo": phoneNo,
      "address": address,
      "licenseNo": licenseNo,
      "email": email,
      "password": password,
      "truckType": truckType,
      "capacity": capacity,
      "plateNo": plateNo,
      "companyOwner": companyOwner,
      "imageDriver": imageDriver,
      "imageLicFront": imageLicFront,
      "imageLicBack": imageLicBack,
      "imageTruck": imageTruck,
      "imageTruckCard": imageTruckCard,
    };
  }
}
