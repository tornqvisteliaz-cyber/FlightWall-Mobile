import 'package:latlong2/latlong.dart';

class Flight {
  final String flightNumber; // e.g. SK142
  final String callsign;
  final String aircraftType;
  final String registration;
  final String icao24; // for API calls
  final LatLng currentPosition;
  final double altitude; // meters
  final double speed; // km/h
  final double heading; // degrees
  final String origin; // e.g. ARN
  final String destination; // e.g. LHR
  final DateTime? estimatedArrival;
  final double progress; // 0.0 to 1.0
  final String status; // Boarding, Taxiing, etc.
  final double distanceRemaining; // km
  final double timeRemaining; // minutes

  Flight({
    required this.flightNumber,
    required this.callsign,
    required this.aircraftType,
    required this.registration,
    required this.icao24,
    required this.currentPosition,
    required this.altitude,
    required this.speed,
    required this.heading,
    required this.origin,
    required this.destination,
    this.estimatedArrival,
    required this.progress,
    required this.status,
    required this.distanceRemaining,
    required this.timeRemaining,
  });

  // Factory from OpenSky data (to be implemented with real API)
  factory Flight.fromOpenSky(Map<String, dynamic> data, String flightNumber) {
    // Placeholder - map OpenSky states/all or flights response to this model
    return Flight(
      flightNumber: flightNumber,
      callsign: data['callsign'] ?? flightNumber,
      aircraftType: 'A320', // Need additional lookup, OpenSky basic doesn't have type
      registration: data['registration'] ?? 'SE-XXX',
      icao24: data['icao24'] ?? '',
      currentPosition: LatLng(
        (data['latitude'] as num?)?.toDouble() ?? 59.65,
        (data['longitude'] as num?)?.toDouble() ?? 17.92,
      ),
      altitude: (data['altitude'] as num?)?.toDouble() ?? 10000,
      speed: (data['velocity'] as num?)?.toDouble() ?? 800,
      heading: (data['true_track'] as num?)?.toDouble() ?? 180,
      origin: 'ARN',
      destination: 'LHR',
      progress: 0.65,
      status: 'Cruising',
      distanceRemaining: 850,
      timeRemaining: 95,
    );
  }
}