import 'proyecto.dart'; // Importamos el modelo Proyecto para la relación de clave foránea
import 'usuario.dart'; // Importamos el modelo Usuario para la relación de clave foránea

class Colaborador {
  final int id;
  final int idProyecto;
  final int idUsuario;
  final String rol;

  Colaborador({
    required this.id,
    required this.idProyecto,
    required this.idUsuario,
    required this.rol,
  });

  factory Colaborador.fromJson(Map<String, dynamic> json) {
    return Colaborador(
      id: json['id'],
      idProyecto: json['idProyecto'],
      idUsuario: json['idUsuario'],
      rol: json['rol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idProyecto': idProyecto,
      'idUsuario': idUsuario,
      'rol': rol,
    };
  }
}
