import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';
  bool _isLoading = false;

  Future<void> login() async {

    setState(() {
      _isLoading = true;
      message = '';
    });
    try{
      final response = await http.post(
        Uri.parse('http://localhost:8000/usuarios/login'), // Cambia localhost si usas un dispositivo móvil
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nombre_usuario': usernameController.text,
          'password': passwordController.text,
        }),
      
    );
    if (response.statusCode == 200) {
      // Login exitoso
      final data = jsonDecode(response.body);
      setState(() {
        message = 'Login exitoso: ${data[0]['nombre_usuario']}';
      });
    } else {
      // Error en el login
      setState(() {
        message = 'Error: ${response.body}';
      });
    }
    }catch(e){
      setState(() {
        message = 'Error: $e';
      });
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'User_name'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}
