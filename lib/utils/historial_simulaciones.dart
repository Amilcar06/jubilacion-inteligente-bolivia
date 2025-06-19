import '../models/modelo_meta_ahorro.dart';
class HistorialSimulaciones {
  static final List<MetaAhorro> _historial = [];

  static void agregar(MetaAhorro meta) {
    _historial.add(meta);
  }

  static List<MetaAhorro> obtenerTodo() {
    return _historial;
  }

  static void eliminar(int index) {
    _historial.removeAt(index);
  }

  static void limpiar() {
    _historial.clear();
  }
}
