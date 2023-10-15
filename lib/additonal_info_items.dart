import "package:flutter/material.dart";

class AdditionalinfoItems extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const AdditionalinfoItems(
      {super.key,
      required this.icon,
      required this.value,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 30,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(value),
        const SizedBox(
          height: 6,
        ),
        Text(
          label,
          style: const TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
