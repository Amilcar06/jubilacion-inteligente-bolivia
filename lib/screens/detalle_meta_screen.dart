import 'package:flutter/material.dart';
import '../models/modelo_meta_ahorro.dart';
import 'comparacion_escenarios_screen.dart';
import 'grafico_proyeccion_screen.dart';
import '../utils/historial_simulaciones.dart';

class DetalleMetaScreen extends StatelessWidget {
  final MetaAhorro meta;

  const DetalleMetaScreen({super.key, required this.meta});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    HistorialSimulaciones.agregar(meta);

    final montoFinal = meta.calcularMontoFinal();
    final montoAjustado = meta.ajustarPorInflacion(montoFinal);
    final totalAportado = meta.calcularTotalAportado();
    final intereses = meta.calcularInteresesGenerados(montoFinal);
    final porcentajeProgreso = (totalAportado / montoFinal).clamp(0.0, 1.0);
    final aniosRestantes = meta.aniosRestantes;
    final tieneObjetivo = meta.objetivoFinal != null && meta.objetivoFinal! > 0;
    final alcanzaMeta = tieneObjetivo ? meta.alcanzaMeta() : null;
    final aporteNecesario = tieneObjetivo ? meta.calcularAporteNecesarioParaMeta() : null;

    Color colorRecomendacion;
    if (porcentajeProgreso >= 0.9) {
      colorRecomendacion = Colors.green.shade700;
    } else if (porcentajeProgreso >= 0.5) {
      colorRecomendacion = Colors.orange.shade700;
    } else {
      colorRecomendacion = Colors.red.shade700;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resumen de tu Simulación"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _etiqueta("Años restantes hasta tu jubilación"),
            _valorTexto("$aniosRestantes años", icono: Icons.calendar_today),

            const SizedBox(height: 16),
            _etiqueta("Proyección Final"),
            _datoMonto("Total estimado acumulado", montoFinal),
            const Text(
              "💡 Este es el capital estimado si mantienes tus aportes actuales hasta la edad de jubilación.",
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            _datoMonto("Ajustado por inflación", montoAjustado),
            const Text(
              "📉 Este valor refleja el poder adquisitivo real en el futuro, considerando la inflación.",
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),

            const Divider(height: 40),

            _etiqueta("Detalles de tu Ahorro"),
            _datoMonto("Total aportado por ti", totalAportado),
            _datoMonto("Intereses generados", intereses),

            const Divider(height: 40),

            _etiqueta("Recomendación Inteligente"),
            _recomendacion(_mensajeRecomendado(montoFinal, totalAportado, aniosRestantes), colorRecomendacion),

            const SizedBox(height: 24),
            _etiqueta("Progreso hacia tu Meta"),
            LinearProgressIndicator(
              value: porcentajeProgreso,
              backgroundColor: Colors.grey[300],
              color: theme.colorScheme.primary,
              minHeight: 12,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 8),
            Text(
              "Avance: ${(porcentajeProgreso * 100).toStringAsFixed(1)}%",
              style: theme.textTheme.bodyMedium,
            ),

            if (tieneObjetivo) ...[
              _etiqueta("Meta de Ahorro Definida"),
              _datoMonto("Objetivo de jubilación", meta.objetivoFinal!),
              const SizedBox(height: 6),
              _recomendacionMeta(alcanzaMeta!, aporteNecesario!, meta.objetivoFinal!),
              const Divider(height: 40),
            ],

            const SizedBox(height: 32),
            _botonPrincipal(
              context,
              label: "Nueva Simulación",
              icon: Icons.refresh,
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
            _botonSecundario(
              context,
              label: "Comparar Escenarios",
              icon: Icons.compare,
              color: const Color(0xFF00796B),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ComparacionEscenariosScreen(meta: meta),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _botonSecundario(
              context,
              label: "Ver Gráfica de Evolución",
              icon: Icons.show_chart,
              color: const Color(0xFF004D99),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GraficoProyeccionScreen(meta: meta),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _etiqueta(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Color(0xFF004D40),
      ),
    );
  }

  Widget _valorTexto(String texto, {IconData? icono}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          if (icono != null) Icon(icono, size: 20, color: Color(0xFF00796B)),
          const SizedBox(width: 8),
          Text(
            texto,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _datoMonto(String titulo, double valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              titulo,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Text(
            "Bs ${valor.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00796B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recomendacion(String mensaje, Color color) {
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withAlpha(64),
        border: Border.all(color: color.withAlpha(128)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mensaje,
              style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonPrincipal(BuildContext context,
      {required String label, required IconData icon, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF43A047),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _botonSecundario(BuildContext context,
      {required String label,
        required IconData icon,
        required Color color,
        required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _mensajeRecomendado(double montoFinal, double aportado, int aniosRestantes) {
    double diferencia = montoFinal - aportado;

    if (diferencia <= 0) {
      return "¡Excelente! Ya has alcanzado o superado tu objetivo.";
    }

    double sugerenciaAumento = diferencia / (aniosRestantes * 12);

    return "Con tu ritmo actual, te faltarían aproximadamente Bs ${diferencia.toStringAsFixed(2)} para tu objetivo. "
        "Considera aumentar tus aportes en Bs ${sugerenciaAumento.toStringAsFixed(2)} por mes.";
  }

  Widget _recomendacionMeta(bool alcanza, double aporteNecesario, double objetivo) {
    final color = alcanza ? Colors.green.shade700 : Colors.red.shade700;
    final mensaje = alcanza
        ? "✅ ¡Felicidades! Tu ahorro proyectado supera tu objetivo de Bs ${objetivo.toStringAsFixed(2)}."
        : "⚠️ Con tus aportes actuales no alcanzarás los Bs ${objetivo.toStringAsFixed(2)}. Deberías aportar al menos Bs ${aporteNecesario.toStringAsFixed(2)} mensuales.";

    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withAlpha(64),
        border: Border.all(color: color.withAlpha(128)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.flag_outlined, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mensaje,
              style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

}