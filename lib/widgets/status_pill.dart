import 'package:flutter/material.dart';

class StatusPill extends StatelessWidget {
  final String status;

  const StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: statusConfig.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: statusConfig.color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusConfig.icon, color: statusConfig.color, size: 22),
          const SizedBox(width: 12),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: statusConfig.color,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'boarding':
        return _StatusConfig(Colors.blue, Icons.door_sliding_outlined);
      case 'taxiing':
        return _StatusConfig(Colors.amber, Icons.local_taxi_outlined);
      case 'takeoff':
        return _StatusConfig(Colors.greenAccent, Icons.flight_takeoff);
      case 'climbing':
        return _StatusConfig(Colors.lightBlue, Icons.trending_up);
      case 'cruising':
        return _StatusConfig(const Color(0xFF00D4FF), Icons.flight);
      case 'descending':
        return _StatusConfig(Colors.orange, Icons.trending_down);
      case 'landing':
        return _StatusConfig(Colors.redAccent, Icons.flight_land);
      default:
        return _StatusConfig(Colors.grey, Icons.info_outline);
    }
  }
}

class _StatusConfig {
  final Color color;
  final IconData icon;

  _StatusConfig(this.color, this.icon);
}