import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

final String googleAPIKey = DotEnv().env['GOOGLE_API_KEY'];
const String IMAGE_WIDTH = '600';
const String IMAGE_HEIGHT = '300';

class LocationHelper {
  static String generateLocationPreviewImage(
      {double latitude, double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=${IMAGE_WIDTH}x$IMAGE_HEIGHT&maptype=roadmap&markers=color:red%7Alabel:A%7C$latitude,$longitude&key=$googleAPIKey';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleAPIKey';

    final response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
