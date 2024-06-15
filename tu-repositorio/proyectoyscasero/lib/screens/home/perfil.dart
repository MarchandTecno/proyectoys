import 'package:flutter/material.dart';
import 'package:proyectoyscasero/screens/home/crearproyecto.dart';
import 'package:proyectoyscasero/screens/home/mostrarproyectos.dart';
import 'package:proyectoyscasero/screens/main/inicio_sesion.dart';
import 'package:proyectoyscasero/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final ApiService apiService = ApiService();
  late Future<Map<String, dynamic>> futureDetallesUsuario;

  @override
  void initState() {
    super.initState();
    _cargarDetallesUsuario();
  }

  Future<void> _cargarDetallesUsuario() async {
    futureDetallesUsuario = apiService.obtenerDetallesUsuario();
    await futureDetallesUsuario;
    if (mounted) {
      setState(() {}); // Actualiza el estado para que el widget se reconstruya
    }
  }

  void _logout() async {
    await apiService.logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => InicioSesion()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        centerTitle: true,
        backgroundColor: Colors.blue, // Cambia el color de fondo de la AppBar
        elevation: 0, // Quita la sombra de la AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureDetallesUsuario,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            if (data.containsKey('error')) {
              return Center(child: Text('Error: ${data['error']}'));
            } else {
              return _buildProfileView(data['nombre'], data['email']);
            }
          } else {
            return Center(child: Text('No se encontraron detalles del usuario.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CrearProyecto()),
          );
        },
        child: Icon(Icons.add_circle_outline),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CrearProyecto()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.folder_open),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MostrarProyectos()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileView(String nombre, String email) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue,
            child: Text(
              nombre.isNotEmpty ? nombre.substring(0, 1).toUpperCase() : '?',
              style: TextStyle(fontSize: 50, color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          Text(
            nombre,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            email,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
