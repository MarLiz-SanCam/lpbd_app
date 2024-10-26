import 'package:flutter/material.dart';
import 'package:frontend_app/pages/show_user_detail.dart';
import 'package:frontend_app/usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ConsultarUsuarios extends StatefulWidget {
  @override
  _ConsultarUsuariosState createState() => _ConsultarUsuariosState();
}

class _ConsultarUsuariosState extends State<ConsultarUsuarios> {
  List<Usuario> usuarios = [];
  bool _isLoading = false;
  String message = '';

  @override
  void initState() {
    super.initState();
    _fetchUsuarios();
  }

  Future<void> _fetchUsuarios() async {
    setState(() {
      _isLoading = true;
      message = '';
    });

    try {
      final response = await http.get(Uri.parse('http://localhost:8000/usuarios')); 

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          usuarios = data.map((json) => Usuario.fromJson(json)).toList();
        });
      } else {
        setState(() {
          message = 'Error al cargar usuarios: ${response.body}';
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
        title: Text('Consultar Usuarios'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : usuarios.isEmpty
              ? Center(child: Text(message.isNotEmpty ? message : 'No hay usuarios registrados.'))
              : ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = usuarios[index];
                    return ListTile(
                      title: Text(usuario.nombre_usuario),
                      subtitle: Text('${usuario.nombre} ${usuario.apellido}'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UsuarioDetalle(usuario: usuario))).then((shouldRefresh) {
          if (shouldRefresh == true) {
            _fetchUsuarios(); // Recargar la lista si se eliminó un usuario
          }
        });
                      },
                    );
                  },
                ),
    );
  }
}
