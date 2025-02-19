import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleMapsService {
  static const String apiKey = 'AIzaSyBANJJlDplrqmPbPM2CK6suomwcrRmI_sU';

  static Future<List<String>> getPlaceSuggestions(String query) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['predictions'] as List)
          .map((prediction) => prediction['description'] as String)
          .toList();
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }

  static Future<String> getAddressFromLatLng(double lat, double lng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'][0]['formatted_address'];
    } else {
      throw Exception('Failed to fetch address');
    }
  }

  static Future<Map<String, dynamic>?> getLocationInfo(
      double latitude, double longitude) async {
    try {
      final geocodeUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';
      final geocodeResponse = await http.get(Uri.parse(geocodeUrl));

      if (geocodeResponse.statusCode == 200) {
        final geocodeData = json.decode(geocodeResponse.body);
        print(
            '============================$geocodeData=======================');
        if (geocodeData['results'].isNotEmpty) {
          final placeId = geocodeData['results'][0]['place_id'];
          final placeDetailsUrl =
              'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';
          final placeDetailsResponse =
              await http.get(Uri.parse(placeDetailsUrl));

          if (placeDetailsResponse.statusCode == 200) {

            final openingClosingHours =  "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&fields=name,opening_hours&key=$apiKey";

            final openingClosingHoursResponse =
            await http.get(Uri.parse(openingClosingHours));

            final  openingClosingHoursData = json.decode( openingClosingHoursResponse.body);

            print("openingClosingHours ${openingClosingHoursData}");

            final placeDetailsData = json.decode(placeDetailsResponse.body);

              print("placeDetailsData asdasda ${placeDetailsData}");

            if (placeDetailsData['status'] == 'OK') {
              final result = placeDetailsData['result'];
              return {
                'placeId': placeId,
                'id': result['id'] ?? 'No id',
                'name': result['name'],
                'address': result['formatted_address'],
                'phone':
                    result['formatted_phone_number'] ?? 'No phone number found',
                'website': result['website'] ?? 'No website',
                'email': result['websemailite'] ?? 'No Email',
                'openingHours':
                    result['opening_hours']?['weekday_text'] ?? 'Not available',
              };
            } else {
              throw Exception(
                  'Failed to fetch place details: ${placeDetailsData['status']}');
            }
          } else {
            throw Exception(
                'Failed to fetch place details: ${placeDetailsResponse.statusCode}');
          }
        } else {
          throw Exception('No results found for the given coordinates');
        }
      } else {
        throw Exception(
            'Failed to fetch place ID: ${geocodeResponse.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }
}
