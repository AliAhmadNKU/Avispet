import 'dart:convert';

import 'package:avispets/models/locations/get_location_name_address.dart';
import 'package:avispets/utils/apis/all_api.dart';
import 'package:avispets/utils/apis/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BaseLocationUtils{
  static double latitude = 0;
  static double longitude = 0;
  LocationData? locationDataMap;

  static Future<List<LocationData>> updateSuggestionsNew(String query) async {
    print(query);
    if (query.isNotEmpty) {
      return await getLocationByNameNew(query);
      // await GoogleMapsService.getPlaceSuggestions(query);
    }
    return [];
  }

  static Future<List<LocationData>> getLocationByNameNew(
      String query
      ) async {
    try {
      Map<String, dynamic> data = {
        "latitude": latitude,
        "longitude": longitude,
        "query": query,
        "radius": 500
      };

      print('getLocationByName => $data');
      var res = await AllApi.postMethodApi(
          ApiStrings.getLocationByNameAndAddress, data);
      print('========================$res');

      var result = res is String ? jsonDecode(res) : res;

      if (result['status'] == 201) {
        // Parse the response into the GetAllCategories model
        GetLocatioByName location = GetLocatioByName.fromJson(result);
        return location.data!;
        // setState(() {
        //   locationListByName = location.data ?? [];
        // });
      }
    } catch (e) {
      debugPrint("Error: {$e");
    }
    return [];
  }
}