import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _fechaInicioController = TextEditingController();
  final _fechaFinController = TextEditingController();

  Future<void> _crearProyecto() async {
    final String nombre = _nombreController.text;
    final String descripcion = _descripcionController.text;
    final String fechaInicio = _fechaInicioController.text;
    final String fechaFin = _fechaFinController.text;

    final response = await http.post(
      Uri.parse('http://192.168.1.8:5000/proyectos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nombre': nombre,
        'descripcion': descripcion,
        'fechaInicio': fechaInicio,
        'fechaFinPrevista': fechaFin,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Proyecto creado correctamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear proyecto: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Nuevo Proyecto'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Código para cerrar sesión
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre del Proyecto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del proyecto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción del proyecto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fechaInicioController,
                decoration: InputDecoration(labelText: 'Fecha de Inicio (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha de inicio del proyecto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fechaFinController,
                decoration: InputDecoration(labelText: 'Fecha de Fin Prevista (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha de fin prevista del proyecto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _crearProyecto();
                  }
                },
                child: Text('Crear Proyecto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
