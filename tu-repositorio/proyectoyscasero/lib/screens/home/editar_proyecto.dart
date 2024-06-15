import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa para formatear fechas
import 'package:proyectoyscasero/models/proyecto.dart';
import 'package:proyectoyscasero/services/api_service.dart';

class EditarProyecto extends StatefulWidget {
  final Proyecto proyecto;

  EditarProyecto({required this.proyecto});

  @override
  _EditarProyectoState createState() => _EditarProyectoState();
}

class _EditarProyectoState extends State<EditarProyecto> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _fechaInicioController;
  late TextEditingController _fechaFinPrevistaController;
  late TextEditingController _estadoController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.proyecto.nombre);
    _descripcionController = TextEditingController(text: widget.proyecto.descripcion);
    _fechaInicioController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.proyecto.fechaInicio));
    _fechaFinPrevistaController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.proyecto.fechaFinPrevista));
    _estadoController = TextEditingController(text: widget.proyecto.estado);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _fechaInicioController.dispose();
    _fechaFinPrevistaController.dispose();
    _estadoController.dispose();
    super.dispose();
  }

  void _actualizarProyecto() async {
    if (_formKey.currentState!.validate()) {
      try {
        await apiService.actualizarProyecto(
          widget.proyecto.id,
          _nombreController.text,
          _descripcionController.text,
          DateTime.parse(_fechaInicioController.text),
          DateTime.parse(_fechaFinPrevistaController.text),
        );
        Navigator.pop(context, true); // Volver a la pantalla anterior con éxito
      } catch (e) {
        // Manejar el error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar el proyecto: $e')));
      }
    }
  }

  void _eliminarProyecto() async {
    try {
      await apiService.eliminarProyecto(widget.proyecto.id);
      Navigator.pop(context, true); // Volver a la pantalla anterior con éxito
    } catch (e) {
      // Manejar el error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar el proyecto: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Proyecto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la descripción';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fechaInicioController,
                decoration: InputDecoration(labelText: 'Fecha de Inicio (yyyy-MM-dd)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la fecha de inicio';
                  }
                  // Validar formato de fecha aquí si es necesario
                  return null;
                },
              ),
              TextFormField(
                controller: _fechaFinPrevistaController,
                decoration: InputDecoration(labelText: 'Fecha Fin Prevista (yyyy-MM-dd)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la fecha fin prevista';
                  }
                  // Validar formato de fecha aquí si es necesario
                  return null;
                },
              ),
              TextFormField(
                controller: _estadoController,
                decoration: InputDecoration(labelText: 'Estado'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el estado';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _actualizarProyecto,
                child: Text('Actualizar Proyecto'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _eliminarProyecto,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Eliminar Proyecto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
