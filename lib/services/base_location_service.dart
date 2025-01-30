import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_settings/app_settings.dart';

class BaseLocationService {
  bool hasPermission = false;
  LocationPermission? permission;
  bool serviceStatus = false;

  Future<void> getLocationPermission() async {
    // Check if location services are enabled
    serviceStatus = await Geolocator.isLocationServiceEnabled();
    if (!serviceStatus) {
      debugPrint("GPS SERVICE IS NOT ENABLED, TURN ON GPS LOCATION.");
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('LOCATION PERMISSIONS ARE DENIED.');
      } else if (permission == LocationPermission.deniedForever) {
        debugPrint("LOCATION PERMISSIONS ARE PERMANENTLY DENIED.");
        // Redirect user to app settings
        _openAppSettings();
      } else {
        hasPermission = true;
      }
    } else if (permission == LocationPermission.deniedForever) {
      debugPrint("LOCATION PERMISSIONS ARE PERMANENTLY DENIED.");
      // Redirect user to app settings
      _openAppSettings();
    } else {
      hasPermission = true;
    }
  }

  void _openAppSettings() {
    // Open the app's settings page
    AppSettings.openAppSettings();
  }
}