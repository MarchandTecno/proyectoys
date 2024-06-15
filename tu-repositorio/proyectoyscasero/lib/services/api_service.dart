import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyectoyscasero/models/proyecto.dart';
import 'package:proyectoyscasero/models/tarea.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class ApiService {
  final String baseUrl = 'http://10.126.1.63:5000'; // Ajusta la URL según tu backend

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'contrasena': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', responseData['access_token']);
      return responseData;
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    }
  }

  Future<Map<String, dynamic>> register(String nombre, String email, String password) async {
    final url = Uri.parse('$baseUrl/usuarios');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'email': email,
        'contrasena': password,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    }
  }

  Future<Map<String, dynamic>> createProject(String nombre, String descripcion, String fechaInicio, String fechaFinPrevista) async {
    final url = Uri.parse('$baseUrl/proyectos');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'nombre': nombre,
        'descripcion': descripcion,
        'fecha_inicio': fechaInicio,
        'fecha_fin_prevista': fechaFinPrevista,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    }
  }

  Future<void> eliminarProyecto(int idProyecto) async {
    final url = Uri.parse('$baseUrl/proyectos/$idProyecto');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // El proyecto se eliminó correctamente
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      throw Exception(responseData['error'] ?? 'Error al eliminar proyecto');
    }
  }

  Future<List<Proyecto>> getProyectos() async {
    final url = Uri.parse('$baseUrl/proyectos');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> proyectosJson = jsonDecode(response.body);
      return proyectosJson.map((json) => Proyecto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener proyectos');
    }
  }

  Future<Map<String, dynamic>> actualizarProyecto(int idProyecto, String nombre, String descripcion, DateTime fechaInicio, DateTime fechaFinPrevista) async {
    final url = Uri.parse('$baseUrl/detalles-proyecto/actualizar');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'idProyecto': idProyecto,
        'nombre': nombre,
        'descripcion': descripcion,
        'fechaInicio': DateFormat('yyyy-MM-dd').format(fechaInicio),
        'fechaFinPrevista': DateFormat('yyyy-MM-dd').format(fechaFinPrevista),
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }




  Future<Map<String, dynamic>> obtenerDetallesUsuario() async {
    final url = Uri.parse('$baseUrl/usuario/detalles');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    }
  }
  Future<List<Tarea>> getTareasPorProyecto(int idProyecto) async {
    final url = Uri.parse('$baseUrl/tareas?idProyecto=$idProyecto');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Iterable lista = json.decode(response.body);
      List<Tarea> tareas = lista.map((model) => Tarea.fromJson(model)).toList();
      return tareas;
    } else {
      throw Exception('Error al obtener tareas por proyecto');
    }
  }

  Future<Map<String, dynamic>> crearTarea(
      int idProyecto,
      String nombre,
      String descripcion,
      String fechaInicio,
      String fechaFinPrevista,
      ) async {
    final url = Uri.parse('$baseUrl/tareas');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'p_idProyecto': idProyecto,
        'p_nombre': nombre,
        'p_descripcion': descripcion,
        'p_fechaInicio': fechaInicio,
        'p_fechaFinPrevista': fechaFinPrevista,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    }
  }
}