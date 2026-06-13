import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'flight_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = ['SK142', 'BA117', 'LH456'];

  @override
  Widget build(BuildContext context) {
    final flightProvider = context.watch<FlightProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0E17), Color(0xFF111827)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header - Apple Dynamic Island inspired
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1F2E),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flight_takeoff, color: Color(0xFF00D4FF), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'FLIGHTWALL',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.person_outline, color: Colors.white70),
                      onPressed: () {
                        // TODO: Profile / Premium screen
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Hero text
                const Text(
                  'Följ ditt flyg.',
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800, height: 1.1),
                ),
                const Text(
                  'Premium upplevelse för ett enda flyg.',
                  style: TextStyle(fontSize: 20, color: Colors.white70, height: 1.3),
                ),

                const SizedBox(height: 40),

                // Search bar - clean, modern
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F2E),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: 'Ange flightnummer t.ex. SK142',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF00D4FF), size: 28),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF00D4FF)),
                        onPressed: () => _performSearch(context),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    ),
                    onSubmitted: (_) => _performSearch(context),
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  'Exempel: SK142 • BA117 • LH456',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),

                const SizedBox(height: 40),

                // Recent searches
                if (_recentSearches.isNotEmpty) ...[
                  const Text(
                    'SENASTE SÖKNINGAR',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1, color: Colors.white54),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: _recentSearches.map((flight) {
                      return ActionChip(
                        label: Text(flight),
                        backgroundColor: const Color(0xFF1A1F2E),
                        labelStyle: const TextStyle(color: Colors.white),
                        onPressed: () {
                          _searchController.text = flight;
                          _performSearch(context);
                        },
                      );
                    }).toList(),
                  ),
                ],

                const Spacer(),

                // Premium teaser
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F2E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFF9500).withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFFF9500)),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Premium', style: TextStyle(fontWeight: FontWeight.w600)),
                            Text('Obegränsat + 3D Globe + Notiser', style: TextStyle(fontSize: 13, color: Colors.white70)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Show paywall
                        },
                        child: const Text('Uppgradera', style: TextStyle(color: Color(0xFFFF9500))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _performSearch(BuildContext context) {
    final flightNumber = _searchController.text.trim();
    if (flightNumber.isEmpty) return;

    final provider = context.read<FlightProvider>();
    provider.searchFlight(flightNumber).then((_) {
      if (provider.currentFlight != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FlightDetailScreen(flight: provider.currentFlight!),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kunde inte hitta flygningen. Försök igen.')),
        );
      }
    });
  }
}