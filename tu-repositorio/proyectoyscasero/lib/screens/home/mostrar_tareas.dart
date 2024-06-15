import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyectoyscasero/models/proyecto.dart';
import 'package:proyectoyscasero/models/tarea.dart';
import 'package:proyectoyscasero/services/api_service.dart';

class MostrarTareas extends StatefulWidget {
  final Proyecto proyecto;

  MostrarTareas(this.proyecto);

  @override
  _MostrarTareasState createState() => _MostrarTareasState();
}

class _MostrarTareasState extends State<MostrarTareas> {
  List<Tarea> _tareas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTareas();
  }

  Future<void> _fetchTareas() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Tarea> tareas = await ApiService().getTareasPorProyecto(widget.proyecto.id);
      setState(() {
        _tareas = tareas;
      });
    } catch (e) {
      print('Error al obtener tareas: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _mostrarDialogoCrearTarea() async {
    final _formKey = GlobalKey<FormState>();
    String _nombre = '';
    String _descripcion = '';
    DateTime _fechaInicio = DateTime.now();
    DateTime _fechaFinPrevista = DateTime.now();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Crear nueva tarea'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un nombre';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _nombre = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Descripción'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese una descripción';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _descripcion = value!;
                    },
                  ),
                  ListTile(
                    title: Text("Fecha de Inicio: ${DateFormat('yyyy-MM-dd').format(_fechaInicio)}"),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _fechaInicio,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _fechaInicio) {
                        setState(() {
                          _fechaInicio = picked;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text("Fecha Fin Prevista: ${DateFormat('yyyy-MM-dd').format(_fechaFinPrevista)}"),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _fechaFinPrevista,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _fechaFinPrevista) {
                        setState(() {
                          _fechaFinPrevista = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Crear'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  try {
                    final resultado = await ApiService().crearTarea(
                      widget.proyecto.id,
                      _nombre,
                      _descripcion,
                      DateFormat('yyyy-MM-dd').format(_fechaInicio),
                      DateFormat('yyyy-MM-dd').format(_fechaFinPrevista),
                    );
                    if (resultado.containsKey('error')) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Error al crear tarea: ${resultado['error']}'),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Tarea creada con éxito'),
                      ));
                      await _fetchTareas();
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    print('Error al crear tarea: $e');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error al crear tarea: $e'),
                    ));
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas del Proyecto ${widget.proyecto.nombre}'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _tareas.length,
        itemBuilder: (context, index) {
          final tarea = _tareas[index];
          return ListTile(
            title: Text(tarea.nombre),
            subtitle: Text(tarea.descripcion),
            trailing: Text(tarea.estado),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoCrearTarea,
        child: Icon(Icons.add),
      ),
    );
  }
}
