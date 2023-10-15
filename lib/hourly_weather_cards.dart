import "package:flutter/material.dart";

class HourlyForecastCards extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
  const HourlyForecastCards({
    super.key,
    required this.time,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              temperature,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
