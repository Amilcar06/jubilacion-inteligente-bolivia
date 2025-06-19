import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/modelo_meta_ahorro.dart';

class GraficoProyeccionScreen extends StatelessWidget {
  final MetaAhorro meta;

  const GraficoProyeccionScreen({super.key, required this.meta});

  List<FlSpot> _generarPuntos(MetaAhorro meta) {
    final puntos = <FlSpot>[];
    double ahorro = meta.ahorroActual;
    int anios = (meta.edadJubilacion - meta.edadActual).toInt();

    for (int i = 0; i <= anios; i++) {
      puntos.add(FlSpot(i.toDouble(), ahorro));
      ahorro = ahorro * (1 + meta.interesAnual / 100) + (meta.aporteMensual * 12);
    }

    return puntos;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actual = meta;
    final conservador = meta.copiarConInteres(meta.interesAnual - 2);
    final optimista = meta.copiarConInteres(meta.interesAnual + 2);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gráfico de Proyección"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "Proyección desde ${meta.edadActual} hasta ${meta.edadJubilacion} años",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF004D40),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // 📈 Gráfico de líneas
          AspectRatio(
            aspectRatio: 1.5,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (meta.edadJubilacion - meta.edadActual).toDouble(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      getTitlesWidget: (value, _) => Text(
                        '${meta.edadActual + value.toInt()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20000,
                      getTitlesWidget: (value, _) => Text(
                        'Bs ${value ~/ 1000}k',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  rightTitles: AxisTitles(),
                  topTitles: AxisTitles(),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 20000,
                  verticalInterval: 5,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withAlpha(128),
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.withAlpha(128),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(color: Colors.black38),
                    bottom: BorderSide(color: Colors.black38),
                  ),
                ),
                lineBarsData: [
                  _crearLinea(_generarPuntos(actual), const Color(0xFF003366)),
                  _crearLinea(_generarPuntos(conservador), Colors.redAccent),
                  _crearLinea(_generarPuntos(optimista), const Color(0xFF4CAF50)),
                ],
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.white,
                    tooltipRoundedRadius: 10,
                    tooltipPadding: const EdgeInsets.all(10),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final year = meta.edadActual + spot.x.toInt();
                        final monto = spot.y.toStringAsFixed(2);
                        return LineTooltipItem(
                          'Edad: $year\nBs $monto',
                          const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // 🏷️ Leyenda clara
          _etiqueta("Escenarios de Proyección"),
          const SizedBox(height: 12),
          _leyenda("Escenario Actual", const Color(0xFF003366)),
          _leyenda("Conservador (-2%)", Colors.redAccent),
          _leyenda("Optimista (+2%)", const Color(0xFF4CAF50)),
        ],
      ),
    );
  }

  LineChartBarData _crearLinea(List<FlSpot> puntos, Color color) {
    return LineChartBarData(
      spots: puntos,
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(
        show: false,
      ),
      dotData: FlDotData(show: false),
    );
  }

  Widget _etiqueta(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF004D40),
      ),
    );
  }

  Widget _leyenda(String texto, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            texto,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
