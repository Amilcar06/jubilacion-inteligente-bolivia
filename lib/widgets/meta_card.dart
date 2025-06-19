import 'package:flutter/material.dart';
import '../models/modelo_meta_ahorro.dart';

class TarjetaMeta extends StatelessWidget {
  final MetaAhorro meta;

  const TarjetaMeta({super.key, required this.meta});

  @override
  Widget build(BuildContext context) {
    final total = meta.calcularMontoFinal();
    final ajustado = meta.ajustarPorInflacion(total);
    final aportado = meta.calcularTotalAportado();

    return Card(
      margin: EdgeInsets.all(12),
      child: ListTile(
        title: Text("Meta a los ${meta.edadJubilacion.toInt()} años"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total estimado: \$${total.toStringAsFixed(2)}"),
            Text("Con inflación: \$${ajustado.toStringAsFixed(2)}"),
            Text("Aportado: \$${aportado.toStringAsFixed(2)}"),
          ],
        ),
        trailing: Icon(Icons.show_chart, color: Colors.teal),
      ),
    );
  }
}
