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
      title: 'FlightWall',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF9F),
          secondary: Color(0xFFFF3366),
          surface: Color(0xFF111111),
        ),
        fontFamily: 'monospace',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Color(0xFF00FF9F), letterSpacing: 2),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF00FF9F)),
          bodyLarge: TextStyle(fontSize: 18, color: Color(0xFF00FF9F), letterSpacing: 1.5),
          bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF00FF9F)),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF111111),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: BorderSide(color: Color(0xFF00FF9F).withOpacity(0.4), width: 1),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

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
      debugPrint('Error: $e');
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