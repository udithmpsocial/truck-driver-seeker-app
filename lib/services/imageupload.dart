
import 'dart:io';
import 'package:adastar/models/user_.dart';
import 'package:adastar/screens/driverlogin.dart';
import 'package:adastar/screens/driverregister.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageUploadMethods {
  createImageUpload(context, userId, List<File> images) async {
    List<String> _urllist = [];
    try {
    await images.forEach((image) async {

        StorageReference storageReference = FirebaseStorage.instance.ref().child("Adastra/"+userId+"/");
        StorageUploadTask storageUploadTask = storageReference.child(""+image.path.split('/').last.toString()).putFile(image);
        if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
          final String url = await storageReference.getDownloadURL();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Alert"),
                content: Text("Upload Successfull"),
                actions: [
                  new FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else if (storageUploadTask.isInProgress) {

          storageUploadTask.events.listen((event) {
            double percentage = 100 *(event.snapshot.bytesTransferred.toDouble()
                / event.snapshot.totalByteCount.toDouble());
            print("THe percentage " + percentage.toString());
          });

          StorageTaskSnapshot storageTaskSnapshot =await storageUploadTask.onComplete;
          final String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
          print("Download URL " + downloadUrl.toString());

        } else{
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Alert"),
                content: Text("Upload Error"),
                actions: [
                  new FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }

      }
    );
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("" + e.toString()),
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
    }

  }


}
