String? validarCampo(String tipo, String? value, {String? edadActualRef}) {
  if (value == null || value.trim().isEmpty) {
    return 'Este campo es obligatorio';
  }

  final numero = double.tryParse(value);
  if (numero == null) {
    return 'Ingrese un número válido';
  }

  switch (tipo) {
    case 'edadActual':
      if (numero < 18 || numero > 64) {
        return 'Edad debe estar entre 18 y 64 años';
      }
      break;

    case 'edadJubilacion':
      final edadActual = double.tryParse(edadActualRef ?? '');
      if (numero < 30 || numero > 70) {
        return 'Edad de jubilación debe estar entre 30 y 70 años';
      }
      if (edadActual != null && numero <= edadActual) {
        return 'Debe ser mayor que la edad actual';
      }
      break;

    case 'ahorro':
      if (numero < 0) {
        return 'Debe ser igual o mayor a 0';
      }
      break;

    case 'aporte':
      if (numero < 50) {
        return 'El aporte mensual debe ser mínimo Bs 50';
      }
      break;

    case 'interes':
      if (numero < 0 || numero > 15) {
        return 'Rentabilidad anual debe ser entre 0% y 15%';
      }
      break;

    case 'inflacion':
      if (numero < 0 || numero > 10) {
        return 'Inflación debe estar entre 0% y 10%';
      }
      break;

    default:
      return null;
  }

  return null; // Si todo está bien
}
