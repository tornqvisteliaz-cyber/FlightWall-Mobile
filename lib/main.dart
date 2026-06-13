import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/opensky_service.dart';
import 'models/flight.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<OpenSkyService>(create: (_) => OpenSkyService()),
        ChangeNotifierProvider(create: (_) => FlightProvider()),
      ],
      child: const FlightWallApp(),
    ),
  );
}

class FlightWallApp extends StatelessWidget {
  const FlightWallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlightWall Mobile',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E17), // Deep dark blue-black like avionics
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00D4FF), // Cyan accent like modern avionics
          secondary: Color(0xFFFF9500), // Orange for highlights (Tesla-like)
          surface: Color(0xFF1A1F2E),
        ),
        fontFamily: 'SF Pro Display', // Apple-like, or use system
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.white60),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1A1F2E),
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// Simple state management for current flight
class FlightProvider extends ChangeNotifier {
  Flight? _currentFlight;
  bool _isLoading = false;

  Flight? get currentFlight => _currentFlight;
  bool get isLoading => _isLoading;

  final OpenSkyService _service = OpenSkyService();

  Future<void> searchFlight(String flightNumber) async {
    if (flightNumber.trim().isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final flight = await _service.getFlightByNumber(flightNumber.trim());
      _currentFlight = flight;
    } catch (e) {
      debugPrint('Error fetching flight: $e');
      _currentFlight = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateFlight(Flight updated) {
    _currentFlight = updated;
    notifyListeners();
  }
}