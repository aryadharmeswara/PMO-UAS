import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:no_garco/utils/toast_util.dart';

Future<bool> handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Toast().showToastMessage('Ijin akses lokasi diperlukan!');
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Toast().showToastMessage('Ijin akses lokasi diperlukan!');
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    Toast().showToastMessage('Ijin akses lokasi ditolak. Anda tidak akan dapat membuat antrean!');
    return false;
  }
  return true;
}

Future<String> getCurrentPositions() async {
  final hasPermission = await handleLocationPermission();
  late String address;

  if (!hasPermission) return 'error';
  try{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    address = '${placemark.street}, ${placemark.subLocality}, ${placemark.subAdministrativeArea}, ${placemark.postalCode}';
  } catch (e) {
    debugPrint(e as String?);
    return 'error';
  }
  return address;
}