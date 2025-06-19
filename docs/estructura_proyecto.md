# Estructura General del Proyecto Flutter

## 📁 Estructura de Directorios

```bash
lib/
│
├── main.dart                       # Punto de entrada principal de la app
├── models/                         # Modelos de datos (como MetaAhorro)
│   └── modelo_meta_ahorro.dart
├── utils/                          # Funciones de utilidad
│   ├── historial_simulaciones.dart
│   └── validador_campos.dart
├── screens/                        # Todas las pantallas (UI)
│   ├── ayuda_screen.dart
│   ├── bienvenida_screen.dart
│   ├── agregar_meta_screen.dart
│   ├── comparacion_escenarios_screen.dart
│   ├── detalle_meta_screen.dart
│   ├── editar_meta_screen.dart
│   ├── estimar_objetivo_screen.dart
│   ├── grafico_proyeccion_screen.dart
│   └── historial_screen.dart
├── widgets/                        # Widgets reutilizables
│   ├── barra_progreso.dart
│   └── meta_card.dart
```

## 📌 Detalle por Archivo

### main.dart
- Inicia la aplicación
- Aplica el ThemeData personalizado verde esmeralda
- Define las rutas principales (/historial, etc.)
- Usa BienvenidaScreen como pantalla inicial

### 📁 models/modelo_meta_ahorro.dart
Contiene la clase MetaAhorro que:
- Calcula montos proyectados a futuro
- Ajusta por inflación
- Estima intereses generados
- Tiene métodos alternativos con fórmula cerrada y lógica realista para Bolivia

### 📁 utils/
#### historial_simulaciones.dart
- Guarda una lista global estática de simulaciones para el historial

#### validador_campos.dart
- Valida campos del formulario como edad, aporte, etc., devolviendo errores personalizados

### 📁 screens/
Aquí están todas las pantallas que forman el flujo de navegación:

#### bienvenida_screen.dart
- Pantalla introductoria amigable con mensaje motivacional

#### inicio_screen.dart
- Pantalla de ingreso de datos
- Formulario con validación
- Al presionar "Calcular" navega a detalle_meta_screen

#### detalle_meta_screen.dart
Muestra:
- Años hasta jubilación
- Total proyectado (con y sin inflación)
- Intereses generados
- Recomendaciones inteligentes
- Botones para comparar, graficar y reiniciar

#### editar_meta_screen.dart
- Permite modificar una meta existente desde el historial

#### agregar_meta_screen.dart
- Similar a inicio_screen pero orientada a añadir a lista de metas

#### historial_screen.dart
- Muestra todas las simulaciones guardadas
- Usa un ListView y tarjetas (MetaCard) con opción para editar o eliminar

#### grafico_proyeccion_screen.dart
- Muestra un gráfico de línea con la evolución del ahorro en el tiempo

#### comparacion_escenarios_screen.dart
- Compara el escenario actual con escenarios simulados (por ejemplo, con mejor tasa de interés o mayor aporte)

#### ayuda_screen.dart
- Pantalla informativa sobre el uso de la app

#### estimar_objetivo_screen.dart
- NUEVA pantalla: ayuda a definir cuánto necesitarías ahorrar para una jubilación ideal (a partir de un objetivo mensual deseado en Bs)

### 📁 widgets/
#### meta_card.dart
- Tarjeta personalizada para mostrar datos de cada simulación

#### barra_progreso.dart
- Widget reutilizable para mostrar visualmente el progreso hacia la meta

## 🧠 Flujo de Usuario
1. **Inicio**: El usuario llega a la pantalla de bienvenida
2. **Formulario**: Ingresa sus datos financieros
3. **Resultado**: Ve un resumen claro, progreso y recomendaciones
4. **Opciones**: Puede ver historial, editar metas, ver gráficos o comparar
5. **Extra**: Puede usar la pantalla de "estimar objetivo" si no sabe cuánto debería acumular