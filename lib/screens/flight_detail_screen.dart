import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/flight.dart';
import '../main.dart';
import '../widgets/progress_bar.dart';
import '../widgets/status_pill.dart';
import '../widgets/stat_card.dart';

class FlightDetailScreen extends StatefulWidget {
  final Flight flight;

  const FlightDetailScreen({super.key, required this.flight});

  @override
  State<FlightDetailScreen> createState() => _FlightDetailScreenState();
}

class _FlightDetailScreenState extends State<FlightDetailScreen> {
  late Flight _flight;
  bool _isLiveTracking = true;

  @override
  void initState() {
    super.initState();
    _flight = widget.flight;
    // In real app: start polling here using provider or service
    // context.read<FlightProvider>().startLiveUpdates(...);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlightProvider>();
    if (provider.currentFlight != null) {
      _flight = provider.currentFlight!;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              _flight.flightNumber,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            Text(
              '${_flight.origin} → ${_flight.destination}',
              style: const TextStyle(fontSize: 13, color: Colors.white54),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: _shareFlight,
          ),
          IconButton(
            icon: Icon(_isLiveTracking ? Icons.pause_circle_filled : Icons.play_circle_filled),
            onPressed: () {
              setState(() => _isLiveTracking = !_isLiveTracking);
              // TODO: pause/resume live updates
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === LIVE AIRCRAFT VIEW ===
            _buildSectionHeader('LIVE AIRCRAFT VIEW'),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // 3D Model placeholder - In production: use ModelViewer or three.js via webview / flutter_gl
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.2)),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.flight, size: 80, color: Color(0xFF00D4FF)),
                            const SizedBox(height: 12),
                            Text(
                              _flight.aircraftType,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              _flight.registration,
                              style: const TextStyle(fontSize: 16, color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00D4FF).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '3D MODEL • PREMIUM',
                                style: TextStyle(fontSize: 11, color: Color(0xFF00D4FF), fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _infoPill('Callsign', _flight.callsign),
                        _infoPill('ICAO24', _flight.icao24.toUpperCase()),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // === LIVE TRACKING ===
            _buildSectionHeader('LIVE TRACKING'),
            const SizedBox(height: 12),
            Card(
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: 280,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: _flight.currentPosition,
                    initialZoom: 6.5,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.flightwall.mobile',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _flight.currentPosition,
                          width: 50,
                          height: 50,
                          child: Transform.rotate(
                            angle: _flight.heading * 3.14159 / 180,
                            child: const Icon(
                              Icons.flight,
                              color: Color(0xFF00D4FF),
                              size: 42,
                              shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // TODO: Add Polyline for flight path from origin to destination + current
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Position uppdaterad • Realtid via OpenSky Network',
              style: TextStyle(fontSize: 11, color: Colors.white38),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // === FLIGHT STATS ===
            _buildSectionHeader('FLIGHT STATS'),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                StatCard(
                  icon: Icons.height,
                  label: 'HÖJD',
                  value: '${(_flight.altitude / 1000).toStringAsFixed(1)} km',
                  subValue: '${(_flight.altitude * 3.28084).round()} ft',
                ),
                StatCard(
                  icon: Icons.speed,
                  label: 'FART',
                  value: '${_flight.speed.round()} km/h',
                  subValue: '${(_flight.speed * 0.539957).round()} kn',
                ),
                StatCard(
                  icon: Icons.explore,
                  label: 'KURS',
                  value: '${_flight.heading.round()}°',
                  subValue: _getHeadingText(_flight.heading),
                ),
                StatCard(
                  icon: Icons.timer_outlined,
                  label: 'TID KVAR',
                  value: '${_flight.timeRemaining.round()} min',
                  subValue: _flight.estimatedArrival != null 
                    ? '${_flight.estimatedArrival!.hour.toString().padLeft(2, '0')}:${_flight.estimatedArrival!.minute.toString().padLeft(2, '0')}'
                    : '',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // === PROGRESS BAR ===
            _buildSectionHeader('FLYGNINGENS FRAMSTEG'),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('START', style: TextStyle(fontSize: 11, color: Colors.white54)),
                            Text(_flight.origin, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('DESTINATION', style: TextStyle(fontSize: 11, color: Colors.white54)),
                            Text(_flight.destination, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    FlightProgressBar(progress: _flight.progress),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${(_flight.progress * 100).round()}% avklarat', style: const TextStyle(fontSize: 13, color: Colors.white70)),
                        Text('${_flight.distanceRemaining.round()} km kvar', style: const TextStyle(fontSize: 13, color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // === DYNAMIC STATUS ===
            _buildSectionHeader('STATUS'),
            const SizedBox(height: 12),
            StatusPill(status: _flight.status),

            const SizedBox(height: 40),

            // Premium features teaser
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF1A1F2E), const Color(0xFF111827)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFF9500).withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.workspace_premium_rounded, color: Color(0xFFFF9500)),
                      SizedBox(width: 8),
                      Text('PREMIUM FUNKTIONER', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFFF9500))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Lås upp 3D Globe, Live Weather, Cockpit View & exakt ankomstprediktion för 39 kr/mån'),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9500),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        // TODO: Implement in-app purchase or Stripe via Supabase
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Premium kommer snart! (Stripe + Supabase)')),
                        );
                      },
                      child: const Text('Uppgradera till Premium', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: Color(0xFF00D4FF),
      ),
    );
  }

  Widget _infoPill(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white54)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }

  String _getHeadingText(double heading) {
    if (heading >= 337.5 || heading < 22.5) return 'Norr';
    if (heading < 67.5) return 'Nordöst';
    if (heading < 112.5) return 'Öster';
    if (heading < 157.5) return 'Sydöst';
    if (heading < 202.5) return 'Söder';
    if (heading < 247.5) return 'Sydväst';
    if (heading < 292.5) return 'Väster';
    return 'Nordväst';
  }

  void _shareFlight() {
    // TODO: Generate shareable link via Supabase or dynamic link
    // For now: share text + deep link concept
    final text = 'Följ mitt flyg ${_flight.flightNumber} från ${_flight.origin} till ${_flight.destination} live på FlightWall!';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Delar: $text'),
        action: SnackBarAction(label: 'KOPIERA', onPressed: () {}),
      ),
    );
  }
}