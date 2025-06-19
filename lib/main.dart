import 'package:flutter/material.dart';
import 'package:jubilacion_inteligente/screens/bienvenida_screen.dart';
import 'package:jubilacion_inteligente/screens/historial_screen.dart';

void main() {
  runApp(const PlanificadorApp());
}

class PlanificadorApp extends StatelessWidget {
  const PlanificadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jubilación Inteligente',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00796B), // Verde esmeralda
          primary: const Color(0xFF00796B),
          secondary: const Color(0xFF4CAF50),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F9F4), // Fondo cálido
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00796B),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF004D40)),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
          labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF43A047),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF00796B),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          margin: const EdgeInsets.all(12),
          color: Colors.white,
        ),
      ),
      home: const BienvenidaScreen(),
      routes: {
        '/historial': (context) => const HistorialScreen(),
        // Agrega aquí más rutas como '/detalle', '/ajustes', etc.
      },
    );
  }
}
