import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../secrets.dart';

class MapboxService {
  static const String _accessToken = mapboxToken;

  static Future<LatLng?> geocodeAddress(String address) async {
    final query = Uri.encodeComponent(address);
    // Bounding box for South West Nigeria: 2.6,5.8,6.0,9.2
    final url = 'https://api.mapbox.com/search/geocode/v6/forward?q=$query&access_token=$_accessToken&limit=1&bbox=2.6,5.8,6.0,9.2&country=ng';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'] != null && data['features'].isNotEmpty) {
          final geometry = data['features'][0]['geometry'];
          if (geometry['type'] == 'Point') {
             final coordinates = geometry['coordinates'];
             return LatLng(coordinates[1], coordinates[0]);
          }
        }
      } else {
        print('Geocoding error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Geocoding exception: $e');
    }
    return null;
  }

  static Future<List<String>> autocompletePlaces(String query) async {
    if (query.isEmpty) return [];
    final encodedQuery = Uri.encodeComponent(query);
    // Bounding box for South West Nigeria: 2.6,5.8,6.0,9.2
    // Using Photon (OpenStreetMap) for completely free autocomplete!
    final url = 'https://photon.komoot.io/api/?q=$encodedQuery&limit=5&bbox=2.6,5.8,6.0,9.2';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'NetsDispatchCustomerApp/1.0 (contact@nets.com)'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'] != null) {
          final features = data['features'] as List;
          return features.map((f) {
            final props = f['properties'];
            final name = props['name'] ?? '';
            final street = props['street'] ?? '';
            final city = props['city'] ?? props['county'] ?? '';
            final state = props['state'] ?? '';
            
            // Build a readable address string
            List<String> parts = [];
            if (name.isNotEmpty) parts.add(name);
            if (street.isNotEmpty && street != name) parts.add(street);
            if (city.isNotEmpty) parts.add(city);
            if (state.isNotEmpty) parts.add(state);
            
            return parts.join(', ');
          }).where((s) => s.isNotEmpty).toList();
        }
      }
    } catch (e) {
      print('Autocomplete exception: $e');
    }
    return [];
  }

  static Future<String?> reverseGeocode(LatLng latLng) async {
    final url = 'https://api.mapbox.com/search/geocode/v6/reverse?longitude=${latLng.longitude}&latitude=${latLng.latitude}&access_token=$_accessToken&limit=1';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'] != null && data['features'].isNotEmpty) {
          return data['features'][0]['properties']['full_address'] ?? data['features'][0]['properties']['name'] ?? data['features'][0]['properties']['place_formatted'];
        }
      }
    } catch (e) {
      print('Reverse geocoding exception: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getRoute(LatLng origin, LatLng destination) async {
    final coords = '${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}';
    final url = 'https://api.mapbox.com/directions/v5/mapbox/driving/$coords?geometries=geojson&access_token=$_accessToken';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          
          final List<dynamic> coordinates = route['geometry']['coordinates'];
          final List<LatLng> polyline = coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();

          final distance = route['distance'] as double; // in meters
          final duration = route['duration'] as double; // in seconds

          return {
            'polyline': polyline,
            'distance': distance,
            'duration': duration,
          };
        }
      } else {
        print('Routing error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Routing exception: $e');
    }
    return null;
  }
}
