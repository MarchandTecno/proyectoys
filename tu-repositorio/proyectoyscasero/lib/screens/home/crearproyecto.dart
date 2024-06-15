import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Para formateo de fechas
import 'package:proyectoyscasero/services/api_service.dart';
import '../home/interfaz.dart';  // Importa la pantalla de interfaz principal

class CrearProyecto extends StatefulWidget {
  @override
  _CrearProyectoState createState() => _CrearProyectoState();
}

class _CrearProyectoState extends State<CrearProyecto> {
  final ApiService apiService = ApiService();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController fechaInicioController = TextEditingController();
  final TextEditingController fechaFinController = TextEditingController();
  bool isLoading = false;

  Future<void> createProject() async {
    setState(() {
      isLoading = true;
    });

    // Formatear las fechas al formato esperado (YYYY-MM-DD)
    String formattedFechaInicio = DateFormat('yyyy-MM-dd').format(DateTime.parse(fechaInicioController.text));
    String formattedFechaFin = DateFormat('yyyy-MM-dd').format(DateTime.parse(fechaFinController.text));

    final response = await apiService.createProject(
      nombreController.text,
      descripcionController.text,
      formattedFechaInicio,
      formattedFechaFin,
    );

    setState(() {
      isLoading = false;
    });

    if (response.containsKey('resultado')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['resultado'] ?? 'Proyecto creado exitosamente')),
      );
      // Navegar de regreso a la interfaz principal después de crear el proyecto
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Interfaz()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['error'] ?? 'Error al crear proyecto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Proyecto'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre del Proyecto'),
            ),
            TextField(
              controller: descripcionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: fechaInicioController,
              decoration: InputDecoration(labelText: 'Fecha de Inicio (YYYY-MM-DD)'),
            ),
            TextField(
              controller: fechaFinController,
              decoration: InputDecoration(labelText: 'Fecha Fin Prevista (YYYY-MM-DD)'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: createProject,
              child: Text('Crear Proyecto'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Volver atrás a la interfaz principal
              },
              child: Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
