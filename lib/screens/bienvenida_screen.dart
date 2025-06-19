import 'package:flutter/material.dart';
import 'inicio_screen.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F4), // Fondo claro con tinte verde suave
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.savings,
                  size: 100,
                  color: const Color(0xFF00796B)), // Verde esmeralda

              const SizedBox(height: 24),

              Text(
                "Jubilación Inteligente",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF00796B),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Text(
                "Descubre cuánto necesitas ahorrar mes a mes para lograr una jubilación tranquila.\n\nSimula tu futuro, aprende sobre interés compuesto e inflación de forma interactiva.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 36),

              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/img/jubilacion.png',
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 36),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const InicioScreen()),
                  );
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text("Comenzar ahora"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF43A047), // Verde brillante
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
