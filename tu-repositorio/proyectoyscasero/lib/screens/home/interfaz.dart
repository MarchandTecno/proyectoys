import 'package:flutter/material.dart';
import 'package:proyectoyscasero/models/proyecto.dart';
import 'package:proyectoyscasero/screens/home/crearproyecto.dart';
import 'package:proyectoyscasero/screens/home/editar_proyecto.dart';
import 'package:proyectoyscasero/screens/home/mostrarproyectos.dart';
import 'package:proyectoyscasero/screens/home/perfil.dart';
import 'package:proyectoyscasero/services/api_service.dart';

class Interfaz extends StatefulWidget {
  @override
  _InterfazState createState() => _InterfazState();
}

class _InterfazState extends State<Interfaz> {
  final ApiService apiService = ApiService();
  late Future<List<Proyecto>> futureProyectos;

  @override
  void initState() {
    super.initState();
    futureProyectos = apiService.getProyectos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¡Bienvenido!'),
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
              padding: EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Proyecto proyecto = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MostrarProyectos(),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'proyecto_${proyecto.id}',
                    child: Card(
                      color: Colors.pink.shade50,
                      margin: EdgeInsets.only(bottom: 16.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${proyecto.id} - ${proyecto.nombre}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Descripción: ${proyecto.descripcion}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Estado: ${proyecto.estado}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Fecha de Inicio: ${proyecto.fechaInicio}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Fecha Fin Prevista: ${proyecto.fechaFinPrevista}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: _buildAnimatedFAB(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Perfil',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Perfil(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildAnimatedFAB() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.add_circle_outline),
                  title: Text('Crear Nuevo Proyecto'),
                  onTap: () {
                    Navigator.pop(context); // Cerrar el BottomSheet
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CrearProyecto(),
                      ),
                    ).then((value) {
                      if (value == true) {
                        setState(() {
                          futureProyectos = apiService.getProyectos();
                        });
                      }
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.folder_open),
                  title: Text('Mis Proyectos'),
                  onTap: () {
                    Navigator.pop(context); // Cerrar el BottomSheet
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MostrarProyectos(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Editar Proyecto'),
                  onTap: () async {
                    Navigator.pop(context); // Cerrar el BottomSheet
                    final Proyecto proyecto = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MostrarProyectos(),
                      ),
                    );
                    if (proyecto != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarProyecto(proyecto: proyecto),
                        ),
                      ).then((value) {
                        if (value == true) {
                          setState(() {
                            futureProyectos = apiService.getProyectos();
                          });
                        }
                      });
                    }
                  },
                ),
              ],
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
  }
}
