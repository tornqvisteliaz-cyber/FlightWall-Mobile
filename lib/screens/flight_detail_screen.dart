import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flight.dart';
import '../main.dart';

class FlightDetailScreen extends StatefulWidget {
  final Flight flight;
  const FlightDetailScreen({super.key, required this.flight});

  @override
  State<FlightDetailScreen> createState() => _FlightDetailScreenState();
}

class _FlightDetailScreenState extends State<FlightDetailScreen> {
  late Flight _flight;

  @override
  void initState() {
    super.initState();
    _flight = widget.flight;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlightProvider>();
    if (provider.currentFlight != null) {
      _flight = provider.currentFlight!;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF00FF9F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('FLIGHTWALL', style: TextStyle(color: Color(0xFF00FF9F), letterSpacing: 2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Color(0xFF00FF9F)),
            onPressed: _shareFlight,
          )
        ],
      ),
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [Color(0xFF0033A0), Color(0xFFFF0000)]),
                      ),
                      child: const Center(child: Icon(Icons.favorite, color: Colors.white, size: 28)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('FLIGHTWALL', style: TextStyle(fontSize: 14, color: Color(0xFF00FF9F), letterSpacing: 3, fontWeight: FontWeight.w700)),
                          Text(_flight.callsign, style: const TextStyle(fontSize: 28, color: Color(0xFF00FF9F), fontWeight: FontWeight.w700, letterSpacing: 2)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF00FF9F).withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                      child: const Text('LIVE', style: TextStyle(color: Color(0xFF00FF9F), fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0A),
                    border: Border.all(color: const Color(0xFF00FF9F).withOpacity(0.3), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_flight.origin}-${_flight.destination}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFF00FF9F), letterSpacing: 4, height: 1.0)),
                      const SizedBox(height: 8),
                      Text(_flight.aircraftType.toUpperCase(), style: const TextStyle(fontSize: 22, color: Color(0xFF00FF9F), letterSpacing: 2)),
                      Text(_flight.registration, style: const TextStyle(fontSize: 18, color: Color(0xFF00FF9F), letterSpacing: 1)),
                      const SizedBox(height: 20),
                      Text(_flight.origin == 'ARN' ? 'Stockholm Arlanda' : _flight.origin, style: const TextStyle(fontSize: 20, color: Color(0xFF00FF9F))),
                      Text(_flight.destination == 'LHR' ? 'London Heathrow' : _flight.destination, style: const TextStyle(fontSize: 20, color: Color(0xFF00FF9F))),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.black, border: Border.all(color: const Color(0xFF00FF9F).withOpacity(0.2))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _ledDataColumn('ALT', '${(_flight.altitude / 1000).toStringAsFixed(1)} km'),
                            _ledDataColumn('SPD', '${_flight.speed.round()} km/h'),
                            _ledDataColumn('TRK', '${_flight.heading.round()}°'),
                            _ledDataColumn('VR', '+${(_flight.speed * 0.1).round()} m/s'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(color: const Color(0xFF111111), border: Border.all(color: const Color(0xFF00FF9F).withOpacity(0.4)), borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.flight_takeoff, color: Color(0xFF00FF9F), size: 20),
                      const SizedBox(width: 12),
                      Text(_flight.status.toUpperCase(), style: const TextStyle(fontSize: 20, color: Color(0xFF00FF9F), fontWeight: FontWeight.w700, letterSpacing: 3)),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF00FF9F)), padding: const EdgeInsets.symmetric(vertical: 16)),
                    onPressed: _shareFlight,
                    child: const Text('SHARE FLIGHT', style: TextStyle(color: Color(0xFF00FF9F), letterSpacing: 2, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ledDataColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF00FF9F), letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, color: Color(0xFF00FF9F), fontWeight: FontWeight.w700)),
      ],
    );
  }

  void _shareFlight() {
    final text = 'Följ ${_flight.flightNumber} ${_flight.origin}-${_flight.destination} live på FlightWall!';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delar: $text')));
  }
}