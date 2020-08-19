import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

class Gps {
  static Position _position_last;
  static Position _position_now;
  static String _address;
  bool _androidFusedLocation = true;

  Gps() {
    initLastKnownLocation();
    initCurrentLocation();
    if (_position_now != null) {
      initAddress(_position_now);
    }
  }

  static Position get position_last => _position_last;

  static set position_last(Position value) {
    _position_last = value;
  }

  static Position get position_now => _position_now;

  static set position_now(Position value) {
    _position_now = value;
  }

  static String get address => _address;

  static set address(String value) {
    _address = value;
  }

  static initLastKnownLocation() async {
    Position position;
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = !true;
      position = await geolocator.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.high);
      _position_last = position;
    } on PlatformException {
      position = null;
      _position_last = position;
    }
  }

  static initCurrentLocation() {
    Geolocator()
      ..forceAndroidLocationManager = !true
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).then((position) {
        _position_now = position;
      }).catchError((e) {
//        toastDanger('ERROR: ' + e.toString());
        _position_now = null;
      });
  }

  static initAddress(Position position) async {
    String address = 'unknown';
    final List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks != null && placemarks.isNotEmpty) {
      address = _buildAddressString(placemarks.first);
    }
    _address = '$address';
  }

  static String _buildAddressString(Placemark placemark) {
    final String name = placemark.name ?? '';
    final String city = placemark.locality ?? '';
    final String state = placemark.administrativeArea ?? '';
    final String country = placemark.country ?? '';
    final Position position = placemark.position;
    return '$name, $city, $state, $country.';
  }
}
