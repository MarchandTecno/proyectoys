import 'proyecto.dart'; // Importamos el modelo Proyecto para la relación de clave foránea

class Tarea {
  final int id;
  final int idProyecto;
  final String nombre;
  final String descripcion;
  final DateTime fechaInicio;
  final DateTime fechaFinPrevista;
  final String estado;

  Tarea({
    required this.id,
    required this.idProyecto,
    required this.nombre,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFinPrevista,
    required this.estado,
  });

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      id: json['id'],
      idProyecto: json['idProyecto'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      fechaInicio: DateTime.parse(json['fechaInicio']),
      fechaFinPrevista: DateTime.parse(json['fechaFinPrevista']),
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idProyecto': idProyecto,
      'nombre': nombre,
      'descripcion': descripcion,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFinPrevista': fechaFinPrevista.toIso8601String(),
      'estado': estado,
    };
  }
}
