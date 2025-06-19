import 'package:flutter/material.dart';
import '../utils/historial_simulaciones.dart';
import 'detalle_meta_screen.dart';
import 'editar_meta_screen.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  List historial = [];

  @override
  void initState() {
    super.initState();
    historial = HistorialSimulaciones.obtenerTodo();
  }

  void _actualizarHistorial() {
    setState(() {
      historial = HistorialSimulaciones.obtenerTodo();
    });
  }

  void _confirmarEliminacion(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("¿Eliminar simulación?"),
        content: const Text("Esta acción no se puede deshacer."),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
            onPressed: () {
              HistorialSimulaciones.eliminar(index);
              Navigator.pop(context);
              _actualizarHistorial();
            },
          ),
        ],
      ),
    );
  }

  void _confirmarLimpiarTodo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("¿Limpiar historial?"),
        content: const Text("Esta acción eliminará todas las simulaciones guardadas."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              HistorialSimulaciones.limpiar();
              Navigator.pop(context);
              _actualizarHistorial();
            },
            child: const Text("Confirmar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('📚 Historial de Simulaciones')),
      body: historial.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            "📭 Aún no has guardado simulaciones.\n\n¡Comienza a planificar tu futuro con confianza!",
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 17),
            textAlign: TextAlign.center,
          ),
        ),
      )
          : ListView.separated(
        itemCount: historial.length,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final meta = historial[index];
          return Card(
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: const Icon(Icons.bar_chart_rounded, size: 36, color: Color(0xFF00796B)),
              title: Text(
                "Edad: ${meta.edadActual} → ${meta.edadJubilacion}",
                style: theme.textTheme.titleLarge,
              ),
              subtitle: Text(
                "Bs ${meta.aporteMensual} / mes • Interés: ${meta.interesAnual}%",
                style: theme.textTheme.bodyMedium,
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'editar') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditarMetaScreen(meta: meta, index: index),
                      ),
                    ).then((_) => _actualizarHistorial());
                  } else if (value == 'eliminar') {
                    _confirmarEliminacion(context, index);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'editar',
                    child: ListTile(
                      leading: Icon(Icons.edit, color: Colors.teal),
                      title: Text("Editar"),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'eliminar',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text("Eliminar"),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetalleMetaScreen(meta: meta)),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: historial.isNotEmpty
          ? FloatingActionButton.extended(
        icon: const Icon(Icons.clear_all),
        label: const Text("Limpiar todo"),
        onPressed: _confirmarLimpiarTodo,
      )
          : null,
    );
  }
}
