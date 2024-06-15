// lib/models/usuario.dart

class Usuario {
  final int id;
  String nombre;
  String email;
  final String contrasena;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.contrasena,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
      contrasena: json['contrasena'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'contrasena': contrasena,
    };
  }

  void setNombre(String nuevoNombre) {
    this.nombre = nuevoNombre;
  }

  void setEmail(String nuevoEmail) {
    this.email = nuevoEmail;
  }
}
