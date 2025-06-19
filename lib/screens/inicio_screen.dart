import 'package:flutter/material.dart';
import '../models/modelo_meta_ahorro.dart';
import '../utils/validador_campos.dart';
import 'ayuda_screen.dart';
import 'detalle_meta_screen.dart';
import 'estimar_objetivo_screen.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final _formKey = GlobalKey<FormState>();

  final _edadActualCtrl = TextEditingController(text: "30");
  final _edadJubilacionCtrl = TextEditingController(text: "60");
  final _ahorroActualCtrl = TextEditingController(text: "0");
  final _aporteMensualCtrl = TextEditingController(text: "500");
  final _interesAnualCtrl = TextEditingController(text: "5");
  final _inflacionCtrl = TextEditingController(text: "3");
  final _objetivoFinalCtrl = TextEditingController(text: "200000");

  @override
  void dispose() {
    _edadActualCtrl.dispose();
    _edadJubilacionCtrl.dispose();
    _ahorroActualCtrl.dispose();
    _aporteMensualCtrl.dispose();
    _interesAnualCtrl.dispose();
    _inflacionCtrl.dispose();
    _objetivoFinalCtrl.dispose();
    super.dispose();
  }

  void _calcular() {
    if (_formKey.currentState!.validate()) {
      final edad = int.parse(_edadActualCtrl.text);
      final jubilacion = int.parse(_edadJubilacionCtrl.text);
      final aporte = double.parse(_aporteMensualCtrl.text);

      if (edad >= jubilacion) {
        _mostrarAlerta("La edad actual debe ser menor a la edad de jubilación.");
        return;
      }

      if (aporte <= 0) {
        _mostrarAlerta("El aporte mensual debe ser mayor a Bs 0.");
        return;
      }

      final meta = MetaAhorro(
        edadActual: double.parse(_edadActualCtrl.text),
        edadJubilacion: double.parse(_edadJubilacionCtrl.text),
        ahorroActual: double.parse(_ahorroActualCtrl.text),
        aporteMensual: double.parse(_aporteMensualCtrl.text),
        interesAnual: double.parse(_interesAnualCtrl.text),
        inflacionAnual: double.tryParse(_inflacionCtrl.text) ?? 0.0,
        objetivoFinal: double.tryParse(_objetivoFinalCtrl.text),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalleMetaScreen(meta: meta),
        ),
      );
    }
  }

  void _mostrarAlerta(String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Validación"),
        content: Text(mensaje),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Jubilación Inteligente'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              switch (value) {
                case 'historial':
                  Navigator.pushNamed(context, '/historial');
                  break;
                case 'ayuda':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AyudaScreen()),
                  );
                  break;
                case 'estimar':
                  final resultado = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EstimarObjetivoScreen()),
                  );
                  if (resultado != null) {
                    setState(() {
                      _objetivoFinalCtrl.text = resultado;
                    });
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'historial', child: Text('Ver Historial')),
              const PopupMenuItem(value: 'ayuda', child: Text('Ayuda')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(
                  "💼 Ingresa tus datos para estimar cuánto deberías ahorrar para tu jubilación en Bolivia.",
                  style: theme.textTheme.bodyMedium!.copyWith(color: Colors.grey.shade800),
                ),
                const SizedBox(height: 20),

                // Grupo: Edad actual y jubilación
                Row(
                  children: [
                    Expanded(
                      child: _buildCampo(_edadActualCtrl, "Edad actual", tipo: 'edadActual'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCampo(_edadJubilacionCtrl, "Edad de jubilación deseada", tipo: 'edadJubilacion'),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                _buildCampo(_ahorroActualCtrl, "Ahorros actuales (Bs)", tipo: 'ahorro'),
                const SizedBox(height: 12),
                _buildCampo(_aporteMensualCtrl, "Aportes mensuales (Bs)", tipo: 'aporte'),
                const SizedBox(height: 12),

                // Grupo: Interés e Inflación
                Row(
                  children: [
                    Expanded(
                      child: _buildCampo(_interesAnualCtrl, "Rentabilidad anual (%)", tipo: 'interes'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCampo(_inflacionCtrl, "Inflación anual (%)", tipo: 'inflacion', requerido: false),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                _buildCampo(_objetivoFinalCtrl, "Objetivo de ahorro para jubilación (Bs)", tipo: 'objetivo', requerido: false),

                const SizedBox(height: 24),
                Text(
                  "💡 Consejo: En Bolivia, la edad promedio de jubilación es 60 años y la rentabilidad anual de fondos conservadores ronda el 5%.",
                  style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    final resultado = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EstimarObjetivoScreen()),
                    );
                    if (resultado != null) {
                      setState(() {
                        _objetivoFinalCtrl.text = resultado;
                      });
                    }
                  },
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text("Estimar Objetivo"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                ),
                const SizedBox(height: 15),

                ElevatedButton.icon(
                  onPressed: _calcular,
                  icon: const Icon(Icons.bar_chart_rounded),
                  label: const Text("Calcular Proyección"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCampo(TextEditingController ctrl, String label,
      {bool requerido = true, required String tipo}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF004D40)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00796B), width: 2),
          ),
        ),
        validator: (value) => requerido
            ? validarCampo(tipo, value, edadActualRef: _edadActualCtrl.text)
            : null,
      ),
    );
  }
}
