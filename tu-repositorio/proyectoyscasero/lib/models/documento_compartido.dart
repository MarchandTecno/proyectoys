import 'proyecto.dart'; // Importamos el modelo Proyecto para la relación de clave foránea

class DocumentoCompartido {
  final int id;
  final int idProyecto;
  final String nombre;
  final String? ubicacion;

  DocumentoCompartido({
    required this.id,
    required this.idProyecto,
    required this.nombre,
    this.ubicacion,
  });

  factory DocumentoCompartido.fromJson(Map<String, dynamic> json) {
    return DocumentoCompartido(
      id: json['id'],
      idProyecto: json['idProyecto'],
      nombre: json['nombre'],
      ubicacion: json['ubicacion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idProyecto': idProyecto,
      'nombre': nombre,
      'ubicacion': ubicacion,
    };
  }
}
