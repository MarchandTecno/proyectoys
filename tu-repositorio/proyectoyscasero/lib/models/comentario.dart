import 'proyecto.dart'; // Importamos el modelo Proyecto para la relación de clave foránea
import 'tarea.dart'; // Importamos el modelo Tarea para la relación de clave foránea
import 'usuario.dart'; // Importamos el modelo Usuario para la relación de clave foránea

class Comentario {
  final int id;
  final int idProyecto;
  final int idTarea;
  final int idUsuario;
  final String texto;
  final DateTime fechaHora;

  Comentario({
    required this.id,
    required this.idProyecto,
    required this.idTarea,
    required this.idUsuario,
    required this.texto,
    required this.fechaHora,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id: json['id'],
      idProyecto: json['idProyecto'],
      idTarea: json['idTarea'],
      idUsuario: json['idUsuario'],
      texto: json['texto'],
      fechaHora: DateTime.parse(json['fechaHora']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idProyecto': idProyecto,
      'idTarea': idTarea,
      'idUsuario': idUsuario,
      'texto': texto,
      'fechaHora': fechaHora.toIso8601String(),
    };
  }
}
