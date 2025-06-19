import 'package:flutter/material.dart';
import '../models/modelo_meta_ahorro.dart';
import '../widgets/meta_card.dart';

class AgregarMetaScreen extends StatefulWidget {
  const AgregarMetaScreen({super.key});

  @override
  State<AgregarMetaScreen> createState() => _AgregarMetaScreenState();
}

class _AgregarMetaScreenState extends State<AgregarMetaScreen> {
  List<MetaAhorro> metas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Metas Guardadas")),
      body: ListView.builder(
        itemCount: metas.length,
        itemBuilder: (context, index) {
          return TarjetaMeta(meta: metas[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
        },
      ),
    );
  }
}
