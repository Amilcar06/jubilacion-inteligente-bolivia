import 'package:flutter/material.dart';
import '../models/modelo_meta_ahorro.dart';
import '../utils/historial_simulaciones.dart';
import '../utils/validador_campos.dart';

class EditarMetaScreen extends StatefulWidget {
  final MetaAhorro meta;
  final int index;

  const EditarMetaScreen({super.key, required this.meta, required this.index});

  @override
  State<EditarMetaScreen> createState() => _EditarMetaScreenState();
}

class _EditarMetaScreenState extends State<EditarMetaScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController edadActualController;
  late TextEditingController edadJubilacionController;
  late TextEditingController ahorroActualController;
  late TextEditingController aporteMensualController;
  late TextEditingController interesAnualController;
  late TextEditingController inflacionAnualController;
  late TextEditingController objetivoFinalController;


  @override
  void initState() {
    super.initState();
    edadActualController = TextEditingController(text: widget.meta.edadActual.toString());
    edadJubilacionController = TextEditingController(text: widget.meta.edadJubilacion.toString());
    ahorroActualController = TextEditingController(text: widget.meta.ahorroActual.toString());
    aporteMensualController = TextEditingController(text: widget.meta.aporteMensual.toString());
    interesAnualController = TextEditingController(text: widget.meta.interesAnual.toString());
    inflacionAnualController = TextEditingController(text: widget.meta.inflacionAnual.toString());
    objetivoFinalController = TextEditingController(text: widget.meta.objetivoFinal.toString());
  }

  @override
  void dispose() {
    edadActualController.dispose();
    edadJubilacionController.dispose();
    ahorroActualController.dispose();
    aporteMensualController.dispose();
    interesAnualController.dispose();
    inflacionAnualController.dispose();
    objetivoFinalController.dispose();
    super.dispose();
  }

  void guardarCambios() {
    if (_formKey.currentState!.validate()) {
      final nuevaMeta = MetaAhorro(
        edadActual: double.parse(edadActualController.text),
        edadJubilacion: double.parse(edadJubilacionController.text),
        ahorroActual: double.parse(ahorroActualController.text),
        aporteMensual: double.parse(aporteMensualController.text),
        interesAnual: double.parse(interesAnualController.text),
        inflacionAnual: double.tryParse(inflacionAnualController.text) ?? 0.0,
        objetivoFinal: double.tryParse(objetivoFinalController.text),
      );

      final historial = HistorialSimulaciones.obtenerTodo();
      historial[widget.index] = nuevaMeta;

      Navigator.pop(context);
    }
  }

  Widget campoFormulario(String label, TextEditingController controller,
      {required String tipo, bool requerido = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.edit, color: Color(0xFF00796B)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        ),
        validator: (value) => requerido
            ? validarCampo(tipo, value, edadActualRef: edadActualController.text)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("✏️ Editar Meta de Ahorro"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: "Guardar",
            onPressed: guardarCambios,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Modifica los valores de tu simulación",
                      style: textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    campoFormulario("Edad Actual", edadActualController, tipo: 'edadActual'),
                    campoFormulario("Edad de Jubilación", edadJubilacionController, tipo: 'edadJubilacion'),
                    campoFormulario("Ahorro Actual (Bs)", ahorroActualController, tipo: 'ahorro'),
                    campoFormulario("Aporte Mensual (Bs)", aporteMensualController, tipo: 'aporte'),
                    campoFormulario("Interés Anual (%)", interesAnualController, tipo: 'interes'),
                    campoFormulario("Inflación Anual (%)", inflacionAnualController, tipo: 'inflacion', requerido: false),
                    campoFormulario("Objetivo de ahorro (Bs)", objetivoFinalController, tipo: 'objetivo', requerido: false),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle),
                      label: const Text("Guardar Cambios"),
                      onPressed: guardarCambios,
                      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}