import 'package:flutter/material.dart';
import 'package:frontend_app/usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsuarioDetalle extends StatefulWidget {
  final Usuario usuario;

  UsuarioDetalle({required this.usuario});

  @override
  _UsuarioDetalleState createState() => _UsuarioDetalleState();
}

class _UsuarioDetalleState extends State<UsuarioDetalle> {
  final _idUsuarioController = TextEditingController();
  final _nombreUsuarioController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  String message = '';

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los datos del usuario
    _idUsuarioController.text = widget.usuario.idusuario.toString(); // Asegúrate de que sea un String
    _nombreUsuarioController.text = widget.usuario.nombre_usuario;
    _nombreController.text = widget.usuario.nombre;
    _apellidoController.text = widget.usuario.apellido;
  }

    Future<void> _actualizarUsuario() async {
    setState(() {
      _isLoading = true;
      message = '';
    });

    try {
      final response = await http.put(
        Uri.parse('http://localhost:8000/usuarios/${widget.usuario.idusuario}'), // Cambia a tu endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nombre_usuario': _nombreUsuarioController.text,
          'nombre': _nombreController.text,
          'apellido': _apellidoController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Regresa a la lista si se actualiza correctamente
      } else {
        setState(() {
          message = 'Error al actualizar usuario: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _eliminarUsuario() async {
    setState(() {
      _isLoading = true;
      message = '';
    });

    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8000/usuarios/${widget.usuario.idusuario}'), // Cambia a tu endpoint
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Regresar a la lista si se elimina correctamente
      } else {
        setState(() {
          message = 'Error al eliminar usuario: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Usuario'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _idUsuarioController,
                    decoration: InputDecoration(labelText: 'ID de Usuario'),
                    enabled: false, // Hace que el campo sea solo lectura
                  ),
                  TextField(
                    controller: _nombreUsuarioController,
                    decoration: InputDecoration(labelText: 'Nombre de Usuario'),
                  ),
                  TextField(
                    controller: _nombreController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                  ),
                  TextField(
                    controller: _apellidoController,
                    decoration: InputDecoration(labelText: 'Apellido'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _actualizarUsuario,
                    child: Text('Actualizar Usuario'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _eliminarUsuario,
                    child: Text('Eliminar Usuario'),
                    //style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                  SizedBox(height: 20),
                  if (message.isNotEmpty) Text(message, style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
    );
  }
}
