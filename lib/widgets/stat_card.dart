import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subValue;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.subValue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF00D4FF), size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white54,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, height: 1.1),
            ),
            if (subValue.isNotEmpty)
              Text(
                subValue,
                style: const TextStyle(fontSize: 13, color: Colors.white54),
              ),
          ],
        ),
      ),
    );
  }
}