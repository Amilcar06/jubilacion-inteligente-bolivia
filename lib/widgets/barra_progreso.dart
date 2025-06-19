// lib/widgets/barra_progreso.dart
import 'package:flutter/material.dart';

class BarraProgreso extends StatelessWidget {
  final double avance; // entre 0.0 y 1.0

  const BarraProgreso({super.key, required this.avance});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Progreso de la meta: ${(avance * 100).toStringAsFixed(1)}%"),
        SizedBox(height: 6),
        LinearProgressIndicator(
          value: avance.clamp(0.0, 1.0),
          backgroundColor: Colors.grey[300],
          color: avance < 0.5 ? Colors.red : Colors.green,
          minHeight: 10,
        ),
      ],
    );
  }
}
