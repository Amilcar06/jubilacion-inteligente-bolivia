import 'dart:math';

class MetaAhorro {
  double edadActual;
  double edadJubilacion;
  double ahorroActual;
  double aporteMensual;
  double interesAnual;     // Interés nominal (ej: 5%)
  double inflacionAnual;   // Inflación estimada (ej: 2%)
  double? objetivoFinal;   // Meta de ahorro (opcional)

  MetaAhorro({
    required this.edadActual,
    required this.edadJubilacion,
    required this.ahorroActual,
    required this.aporteMensual,
    required this.interesAnual,
    required this.inflacionAnual,
    this.objetivoFinal,
  });

  int get aniosRestantes => (edadJubilacion - edadActual).floor();

  double get interesRealAnual {
    return ((1 + interesAnual / 100) / (1 + inflacionAnual / 100)) - 1;
  }

  double calcularMontoFinal() {
    double total = ahorroActual;
    double interesMensual = interesRealAnual / 12;

    for (int i = 0; i < aniosRestantes * 12; i++) {
      total = (total + aporteMensual) * (1 + interesMensual);
    }
    return total;
  }

  double ajustarPorInflacion(double montoNominal) {
    return montoNominal / pow(1 + (inflacionAnual / 100), aniosRestantes);
  }

  double calcularTotalAportado() {
    return ahorroActual + (aporteMensual * aniosRestantes * 12);
  }

  double calcularInteresesGenerados(double montoFinal) {
    return montoFinal - calcularTotalAportado();
  }

  MetaAhorro copiarConInteres(double nuevoInteres) {
    return MetaAhorro(
      edadActual: edadActual,
      edadJubilacion: edadJubilacion,
      ahorroActual: ahorroActual,
      aporteMensual: aporteMensual,
      interesAnual: nuevoInteres,
      inflacionAnual: inflacionAnual,
      objetivoFinal: objetivoFinal,
    );
  }

  double calcularMontoFinalFormula() {
    double r = interesRealAnual / 12;
    int n = aniosRestantes * 12;

    double ahorroCrecido = ahorroActual * pow(1 + r, n);
    double aportesCrecidos = aporteMensual * ((pow(1 + r, n) - 1) / r);

    return ahorroCrecido + aportesCrecidos;
  }

  /// Evalúa si se alcanza la meta (si está definida)
  bool alcanzaMeta() {
    if (objetivoFinal == null) return false;
    return calcularMontoFinalFormula() >= objetivoFinal!;
  }

  /// Calcula el aporte mensual necesario para alcanzar la meta
  double? calcularAporteNecesarioParaMeta() {
    if (objetivoFinal == null) return null;

    double r = interesRealAnual / 12;
    int n = aniosRestantes * 12;
    double ahorroCrecido = ahorroActual * pow(1 + r, n);

    double restante = objetivoFinal! - ahorroCrecido;
    if (restante <= 0) return 0.0;

    return restante * r / (pow(1 + r, n) - 1);
  }
}
