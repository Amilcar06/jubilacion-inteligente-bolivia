import 'package:flutter/material.dart';
import '../models/modelo_meta_ahorro.dart';

class ComparacionEscenariosScreen extends StatelessWidget {
  final MetaAhorro meta;

  const ComparacionEscenariosScreen({super.key, required this.meta});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final actual = meta;
    final conservador = meta.copiarConInteres(meta.interesAnual - 2);
    final optimista = meta.copiarConInteres(meta.interesAnual + 2);

    final conceptos = [
      _ConceptoDato(
        titulo: "Total acumulado",
        actual: actual.calcularMontoFinal(),
        conservador: conservador.calcularMontoFinal(),
        optimista: optimista.calcularMontoFinal(),
        icono: Icons.savings,
      ),
      _ConceptoDato(
        titulo: "Total aportado",
        actual: actual.calcularTotalAportado(),
        conservador: conservador.calcularTotalAportado(),
        optimista: optimista.calcularTotalAportado(),
        icono: Icons.account_balance_wallet,
      ),
      _ConceptoDato(
        titulo: "Intereses ganados",
        actual: actual.calcularInteresesGenerados(actual.calcularMontoFinal()),
        conservador: conservador.calcularInteresesGenerados(conservador.calcularMontoFinal()),
        optimista: optimista.calcularInteresesGenerados(optimista.calcularMontoFinal()),
        icono: Icons.trending_up,
      ),
      _ConceptoDato(
        titulo: "Ajustado por inflación",
        actual: actual.ajustarPorInflacion(actual.calcularMontoFinal()),
        conservador: conservador.ajustarPorInflacion(conservador.calcularMontoFinal()),
        optimista: optimista.ajustarPorInflacion(optimista.calcularMontoFinal()),
        icono: Icons.trending_down,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comparación de Escenarios"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "ℹ️ Escenario conservador reduce la rentabilidad en -2%, el optimista incrementa en +2%.",
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 10),
          // Cards de conceptos
          ...conceptos.map((c) => _buildConceptoCard(c, theme)).toList(),
        ],
      ),
    );
  }

  Widget _buildConceptoCard(_ConceptoDato concepto, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(concepto.icono, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  concepto.titulo,
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
            const Divider(height: 20),

            // Valores por escenario
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 12,
              spacing: 12,
              children: [
                _buildDatoEscenario("Actual", concepto.actual, const Color(0xFF003366)),
                _buildDatoEscenario("Conservador", concepto.conservador, Colors.redAccent),
                _buildDatoEscenario("Optimista", concepto.optimista, const Color(0xFF4CAF50)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatoEscenario(String titulo, double valor, Color color) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: color.withAlpha(128)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Bs ${valor.toStringAsFixed(2)}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _ConceptoDato {
  final String titulo;
  final double actual;
  final double conservador;
  final double optimista;
  final IconData icono;

  _ConceptoDato({
    required this.titulo,
    required this.actual,
    required this.conservador,
    required this.optimista,
    required this.icono,
  });
}
