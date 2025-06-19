import 'dart:math';
import 'package:flutter/material.dart';

class EstimarObjetivoScreen extends StatefulWidget {
  const EstimarObjetivoScreen({super.key});

  @override
  State<EstimarObjetivoScreen> createState() => _EstimarObjetivoScreenState();
}

class _EstimarObjetivoScreenState extends State<EstimarObjetivoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _edadActualCtrl     = TextEditingController(text: "30");
  final _edadJubilacionCtrl = TextEditingController(text: "60");
  final _aniosRetiroCtrl    = TextEditingController(text: "20");
  final _gastoMensualCtrl   = TextEditingController(text: "3000");
  final _inflacionCtrl      = TextEditingController(text: "2");
  final _rendimientoCtrl    = TextEditingController(text: "5");  // NUEVO

  double? resultadoObjetivo;

  void _calcularObjetivo() {
    if (_formKey.currentState!.validate()) {
      final edadActual     = int.parse(_edadActualCtrl.text);
      final edadJubilacion = int.parse(_edadJubilacionCtrl.text);
      final aniosRetiro    = int.parse(_aniosRetiroCtrl.text);
      final gastoMensual   = double.parse(_gastoMensualCtrl.text);
      final inflacionAnual = double.tryParse(_inflacionCtrl.text) ?? 0.0;
      final rendimientoAnual = double.tryParse(_rendimientoCtrl.text) ?? 0.0;

      final aniosHastaJubilar = edadJubilacion - edadActual;

      // 1) Ajuste por inflación
      final gastoMensualFuturo =
          gastoMensual * pow(1 + inflacionAnual / 100, aniosHastaJubilar);

      final gastoAnualFuturo = gastoMensualFuturo * 12;

      // 2) Cálculo de valor presente de anualidad
      final r = rendimientoAnual / 100;
      final n = aniosRetiro;

      double montoObjetivo;
      if (r == 0) {
        // Si no hay rendimiento, solo multiplicas
        montoObjetivo = gastoAnualFuturo * n;
      } else {
        montoObjetivo = gastoAnualFuturo *
            (1 - pow(1 + r, -n)) / r;
      }

      setState(() {
        resultadoObjetivo = montoObjetivo;
      });
    }
  }

  void _usarObjetivo() {
    if (resultadoObjetivo != null) {
      Navigator.pop(context, resultadoObjetivo!.toStringAsFixed(2));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Estimar Objetivo de Jubilación')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "📊 Completa los siguientes campos para estimar cuánto dinero necesitas al jubilarte.",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),

              _campoTexto(_edadActualCtrl, "Edad actual"),
              _campoTexto(_edadJubilacionCtrl, "Edad de jubilación deseada"),
              _campoTexto(_aniosRetiroCtrl,    "Años de retiro esperados"),
              _campoTexto(_gastoMensualCtrl,   "Gasto mensual actual (Bs)"),
              _campoTexto(_inflacionCtrl,      "Inflación anual (%)", requerido: false),
              _campoTexto(_rendimientoCtrl,    "Rendimiento anual (%) deseado"),

              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _calcularObjetivo,
                icon: const Icon(Icons.calculate_rounded),
                label: const Text("Calcular Objetivo"),
              ),
              const SizedBox(height: 20),

              if (resultadoObjetivo != null)
                Column(
                  children: [
                    Text(
                      "💰 Necesitarás aproximadamente:",
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Bs. ${resultadoObjetivo!.toStringAsFixed(2)}",
                      style: theme.textTheme.headlineSmall!.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _usarObjetivo,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text("Usar este valor"),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(TextEditingController ctrl, String label, {bool requerido = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (!requerido) return null;
          if (value == null || value.isEmpty) return "Este campo es obligatorio.";
          if (double.tryParse(value) == null || double.parse(value) < 0) {
            return "Ingresa un número válido.";
          }
          return null;
        },
      ),
    );
  }
}
