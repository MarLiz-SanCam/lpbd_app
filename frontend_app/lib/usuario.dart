class Usuario {
  final int idusuario;
  final String nombre_usuario;
  final String nombre;
  final String apellido;

  Usuario({
    required this.idusuario,
    required this.nombre_usuario,
    required this.nombre,
    required this.apellido,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idusuario: json['idusuario'],
      nombre_usuario: json['nombre_usuario'],
      nombre: json['nombre'],
      apellido: json['apellido'],
    );
  }
}
