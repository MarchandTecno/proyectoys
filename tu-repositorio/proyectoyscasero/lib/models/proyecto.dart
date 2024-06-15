// lib/models/proyecto.dart
class Proyecto {
  final int id;
  final String nombre;
  final String descripcion;
  final DateTime fechaInicio;
  final DateTime fechaFinPrevista;
  final String estado;

  Proyecto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFinPrevista,
    required this.estado,
  });

  factory Proyecto.fromJson(Map<String, dynamic> json) {
    return Proyecto(
      id: json['id'],
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
      'nombre': nombre,
      'descripcion': descripcion,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFinPrevista': fechaFinPrevista.toIso8601String(),
      'estado': estado,
    };
  }
}
