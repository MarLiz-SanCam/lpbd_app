import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistroUsuario extends StatefulWidget {
  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final _formKey = GlobalKey<FormState>();
  String idusuario = '';
  String nombre_usuario = '';
  String nombre = '';
  String apellido = '';
  String password = '';

  Future<void> crearUsuario() async {
    final url = 'http://localhost:8000/usuarios';

    final body = {
      'idusuario': idusuario,
      'nombre_usuario': nombre_usuario,
      'nombre': nombre,
      'apellido': apellido,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        // La solicitud fue exitosa
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuario creado')));
      } else {
        // Manejar errores de respuesta
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
      }
    } catch (e) {
      // Manejar errores de conexión
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'ID Usuario'),
                onChanged: (value) => idusuario = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un ID de usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre de Usuario'),
                onChanged: (value) => nombre_usuario = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre de usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                onChanged: (value) => nombre = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Apellido'),
                onChanged: (value) => apellido = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu apellido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una contraseña';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    crearUsuario(); // Llama a la función para crear el usuario
                  }
                },
                child: Text('Registrar Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
