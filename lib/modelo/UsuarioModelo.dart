import 'package:json_annotation/json_annotation.dart';

/// Modelo principal que representa un usuario completo del backend
@JsonSerializable()
class UsuarioModelo {
  late final String nombre;
  late final String apellido;
  late final String username;
  late final String email;
  late final String password;
  late final List<String> roles;
  late final String estado;

  UsuarioModelo({
    required this.nombre,
    required this.apellido,
    required this.username,
    required this.email,
    required this.password,
    required this.roles,
    required this.estado,
  });

  factory UsuarioModelo.fromJson(Map<String, dynamic> json) {
    return UsuarioModelo(
      nombre: json['nombre'],
      apellido: json['apellido'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      roles: List<String>.from(json['roles'].map((e) => e.toString())),
      estado: json['estado'] ?? 'activo', // opcional, por si no se recibe
    );
  }

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'apellido': apellido,
    'username': username,
    'email': email,
    'password': password,
    'roles': roles,
    'estado': estado,
  };
}

/// Clase usada solo para enviar los datos de login (username y password)
class UsuarioLogin {
  UsuarioLogin({
    required this.username,
    required this.password,
  });

  late final String username;
  late final String password;

  factory UsuarioLogin.fromJson(Map<String, dynamic> json) {
    return UsuarioLogin(
      username: json["username"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
  };
}

/// Clase para recibir la respuesta del login (usuario + token + roles)
class UsuarioResp {
  UsuarioResp({
    required this.id,
    required this.username,
    required this.estado,
    required this.token,
    required this.roles,
  });

  late final int id;
  late final String username;
  late final String estado;
  late final String token;
  late final List<String> roles;

  factory UsuarioResp.fromJson(Map<String, dynamic> json) {
    return UsuarioResp(
      id: json["id"],
      username: json["username"],
      estado: json["estado"] ?? "activo",
      token: json["token"],
      roles: List<String>.from(json['roles'].map((e) => e.toString())),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "estado": estado,
    "token": token,
    "roles": roles,
  };

  @override
  String toString() {
    return "$id, $username, $estado, $token, $roles";
  }
}
