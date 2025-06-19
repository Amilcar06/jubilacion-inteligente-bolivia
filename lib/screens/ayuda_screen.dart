import 'package:flutter/material.dart';

class AyudaScreen extends StatelessWidget {
  const AyudaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final temas = [
      {
        'titulo': '💡 Interés Compuesto',
        'contenido':
        'Es el interés calculado sobre el capital inicial y también sobre los intereses acumulados de períodos anteriores. Es fundamental para el crecimiento del ahorro a largo plazo.',
      },
      {
        'titulo': '📉 Inflación',
        'contenido':
        'La inflación es el aumento generalizado de los precios con el tiempo. Reduce el poder adquisitivo del dinero. Por eso es importante que los intereses sean mayores que la inflación.',
      },
      {
        'titulo': '📈 Ahorro a Largo Plazo',
        'contenido':
        'Ahorrar con metas de largo plazo permite acumular más dinero gracias al interés compuesto y ayuda a cumplir metas como la jubilación, compra de vivienda o estudios.',
      },
      {
        'titulo': '📊 Interés Nominal vs Real',
        'contenido':
        'El interés nominal es el que te ofrecen, pero el real es el interés nominal menos la inflación. Por ejemplo: 8% de interés - 3% de inflación = 5% de interés real.',
      },
      {
        'titulo': '🕒 Importancia del Tiempo',
        'contenido':
        'Mientras más pronto comiences a ahorrar, mayor será el efecto del interés compuesto. El tiempo es uno de los factores más importantes en una inversión.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🧠 Ayuda y Conceptos'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: temas.length,
        itemBuilder: (context, index) {
          final tema = temas[index];
          return Card(
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                title: Text(
                  tema['titulo']!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      tema['contenido']!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
