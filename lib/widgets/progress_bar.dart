import 'package:flutter/material.dart';

class FlightProgressBar extends StatelessWidget {
  final double progress; // 0.0 - 1.0

  const FlightProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    
    return Column(
      children: [
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF2A3142),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              // Background track
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2A3142),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Progress fill - nice gradient like Tesla/Apple
              FractionallySizedBox(
                widthFactor: clamped,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00D4FF), Color(0xFF00A8CC)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00D4FF).withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              // Plane indicator on the bar
              if (clamped > 0.05 && clamped < 0.95)
                Positioned(
                  left: (MediaQuery.of(context).size.width - 64) * clamped - 12, // approximate centering
                  top: -2,
                  child: const Icon(
                    Icons.flight,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Optional: small labels under bar if needed
      ],
    );
  }
}