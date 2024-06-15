import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyectoyscasero/models/proyecto.dart';
import 'package:proyectoyscasero/screens/home/mostrar_tareas.dart';
import 'package:proyectoyscasero/services/api_service.dart';

class MostrarProyectos extends StatefulWidget {
  @override
  _MostrarProyectosState createState() => _MostrarProyectosState();
}

class _MostrarProyectosState extends State<MostrarProyectos> {
  final ApiService apiService = ApiService();
  late Future<List<Proyecto>> futureProyectos;

  @override
  void initState() {
    super.initState();
    futureProyectos = apiService.getProyectos();
  }

  void _showEditarProyectoDialog(Proyecto proyecto) {
    TextEditingController nombreController = TextEditingController(text: proyecto.nombre);
    TextEditingController descripcionController = TextEditingController(text: proyecto.descripcion);
    TextEditingController fechaInicioController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(proyecto.fechaInicio));
    TextEditingController fechaFinController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(proyecto.fechaFinPrevista));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Proyecto'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
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
              ],
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
              child: Text('Guardar'),
              onPressed: () async {
                var fechaInicio = DateTime.parse(fechaInicioController.text);
                var fechaFin = DateTime.parse(fechaFinController.text);
                var resultado = await apiService.actualizarProyecto(proyecto.id, nombreController.text, descripcionController.text, fechaInicio, fechaFin);

                if (resultado.containsKey('resultado')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(resultado['resultado']),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.of(context).pop(); // Cerrar el diálogo
                  setState(() {
                    futureProyectos = apiService.getProyectos(); // Actualizar la lista de proyectos
                  });
                } else if (resultado.containsKey('error')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(resultado['error']),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmarEliminarProyecto(int idProyecto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Proyecto'),
          content: Text('¿Estás seguro de que quieres eliminar este proyecto?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar el diálogo
                await apiService.eliminarProyecto(idProyecto);
                setState(() {
                  futureProyectos = apiService.getProyectos(); // Actualizar la lista de proyectos
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _verTareas(Proyecto proyecto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MostrarTareas(proyecto),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Proyectos'),
      ),
      body: FutureBuilder<List<Proyecto>>(
        future: futureProyectos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay proyectos'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Proyecto proyecto = snapshot.data![index];
                return Hero(
                  tag: 'proyecto_${proyecto.id}',
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: ListTile(
                      title: Text('${proyecto.id} - ${proyecto.nombre}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Descripción: ${proyecto.descripcion}'),
                          Text('Estado: ${proyecto.estado}'),
                          Text('Fecha de Inicio: ${DateFormat('yyyy-MM-dd').format(proyecto.fechaInicio)}'),
                          Text('Fecha Fin Prevista: ${DateFormat('yyyy-MM-dd').format(proyecto.fechaFinPrevista)}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _confirmarEliminarProyecto(proyecto.id); // Confirmar eliminación
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.task),
                            onPressed: () {
                              _verTareas(proyecto); // Ver tareas del proyecto
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        _showEditarProyectoDialog(proyecto); // Mostrar diálogo para editar proyecto
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
