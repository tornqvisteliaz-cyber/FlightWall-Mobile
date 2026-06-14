import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/flight.dart';
import 'package:latlong2/latlong.dart';

class OpenSkyService {
  static const String baseUrl = 'https://opensky-network.org/api';
  static const String authUrl = 'https://auth.opensky-network.org/auth/realms/opensky-network/protocol/openid-connect/token';

  static const String clientId = 'tornqvisteliaz@gmail.com-api-client';
  static const String clientSecret = 'kAoe9RbEI7sbIdXp8I0zHQvR9iUZmmzx';

  String? _accessToken;
  DateTime? _tokenExpiry;

  Future<String?> _getAccessToken() async {
    if (_accessToken != null && _tokenExpiry != null && DateTime.now().isBefore(_tokenExpiry!)) {
      return _accessToken;
    }
    try {
      final response = await http.post(
        Uri.parse(authUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'client_credentials',
          'client_id': clientId,
          'client_secret': clientSecret,
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access_token'];
        final expiresIn = data['expires_in'] ?? 1800;
        _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn - 60));
        return _accessToken;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Flight?> getFlightByNumber(String flightNumber) async {
    return _getMockFlight(flightNumber);
  }

  Flight _getMockFlight(String flightNumber) {
    switch (flightNumber.toUpperCase()) {
      case 'SK142':
        return Flight(flightNumber: 'SK142', callsign: 'SAS142', aircraftType: 'A320neo', registration: 'SE-ROE', icao24: '4ca9f3', currentPosition: const LatLng(57.5, 12.5), altitude: 11200, speed: 845, heading: 245, origin: 'ARN', destination: 'LHR', estimatedArrival: DateTime.now().add(const Duration(minutes: 85)), progress: 0.72, status: 'Cruising', distanceRemaining: 620, timeRemaining: 78);
      case 'BA117':
        return Flight(flightNumber: 'BA117', callsign: 'BAW117', aircraftType: 'A321', registration: 'G-EUXL', icao24: '400a0a', currentPosition: const LatLng(51.2, 0.5), altitude: 4500, speed: 420, heading: 270, origin: 'LHR', destination: 'JFK', estimatedArrival: DateTime.now().add(const Duration(hours: 6)), progress: 0.15, status: 'Climbing', distanceRemaining: 5200, timeRemaining: 380);
      default:
        return Flight(flightNumber: flightNumber, callsign: flightNumber, aircraftType: 'B737-800', registration: 'LN-XXX', icao24: '4ca123', currentPosition: const LatLng(59.65, 17.92), altitude: 9500, speed: 810, heading: 180, origin: 'ARN', destination: 'CPH', estimatedArrival: DateTime.now().add(const Duration(minutes: 45)), progress: 0.45, status: 'Cruising', distanceRemaining: 320, timeRemaining: 42);
    }
  }
}