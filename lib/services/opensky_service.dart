import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/flight.dart';
import 'package:latlong2/latlong.dart';

class OpenSkyService {
  static const String baseUrl = 'https://opensky-network.org/api';
  // For authenticated: use token or basic auth with client_id/secret
  // Anonymous has strict rate limits (e.g. 400 req/24h or so for some endpoints)

  Future<Flight?> getFlightByNumber(String flightNumber) async {
    // OpenSky doesn't have direct "flight number" search for live flights.
    // Strategy for MVP:
    // 1. Get all current states (limited area or all - but all is heavy)
    // 2. Filter states where callsign contains flightNumber (case insensitive)
    // 3. For better accuracy, use historical flights or other APIs like Flightradar24 (paid) or ADS-B Exchange.
    // For demo, we return mock data. Replace with real call.

    // Example real call for states (all current, very limited without auth):
    // final response = await http.get(Uri.parse('$baseUrl/states/all'));
    // But rate limited and returns huge list.

    // Better for specific: if you have icao24, use /states/all?icao24=XXXXXX
    // To get icao24 from flight number, you often need a lookup table or previous data.

    // For now: return mock flight for SK142, BA117, LH456 as in spec
    return _getMockFlight(flightNumber);
  }

  Flight _getMockFlight(String flightNumber) {
    // Realistic mock based on common routes
    switch (flightNumber.toUpperCase()) {
      case 'SK142':
        return Flight(
          flightNumber: 'SK142',
          callsign: 'SAS142',
          aircraftType: 'A320neo',
          registration: 'SE-ROE',
          icao24: '4ca9f3', // example
          currentPosition: const LatLng(57.5, 12.5), // Somewhere over Sweden/DK
          altitude: 11200,
          speed: 845,
          heading: 245,
          origin: 'ARN',
          destination: 'LHR',
          estimatedArrival: DateTime.now().add(const Duration(minutes: 85)),
          progress: 0.72,
          status: 'Cruising',
          distanceRemaining: 620,
          timeRemaining: 78,
        );
      case 'BA117':
        return Flight(
          flightNumber: 'BA117',
          callsign: 'BAW117',
          aircraftType: 'A321',
          registration: 'G-EUXL',
          icao24: '400a0a',
          currentPosition: const LatLng(51.2, 0.5),
          altitude: 4500,
          speed: 420,
          heading: 270,
          origin: 'LHR',
          destination: 'JFK',
          estimatedArrival: DateTime.now().add(const Duration(hours: 6)),
          progress: 0.15,
          status: 'Climbing',
          distanceRemaining: 5200,
          timeRemaining: 380,
        );
      case 'LH456':
        return Flight(
          flightNumber: 'LH456',
          callsign: 'DLH456',
          aircraftType: 'A340-300',
          registration: 'D-AIGX',
          icao24: '3c65a3',
          currentPosition: const LatLng(50.0, 8.5),
          altitude: 9800,
          speed: 780,
          heading: 90,
          origin: 'FRA',
          destination: 'SIN',
          estimatedArrival: DateTime.now().add(const Duration(hours: 10)),
          progress: 0.08,
          status: 'Climbing',
          distanceRemaining: 9800,
          timeRemaining: 620,
        );
      default:
        // Generic mock
        return Flight(
          flightNumber: flightNumber,
          callsign: flightNumber,
          aircraftType: 'B737-800',
          registration: 'LN-XXX',
          icao24: '4ca123',
          currentPosition: const LatLng(59.65, 17.92),
          altitude: 9500,
          speed: 810,
          heading: 180,
          origin: 'ARN',
          destination: 'CPH',
          estimatedArrival: DateTime.now().add(const Duration(minutes: 45)),
          progress: 0.45,
          status: 'Cruising',
          distanceRemaining: 320,
          timeRemaining: 42,
        );
    }
  }

  // Future: implement real polling for live updates
  // Use WebSocket or periodic http.get for /states/all?icao24=...
  Future<void> startLiveTracking(String icao24, Function(Flight) onUpdate) async {
    // Poll every 5-10 seconds
    // In real app use Timer.periodic
  }
}