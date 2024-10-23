import 'package:flutter/material.dart';
import 'package:frontend_app/design/app_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lavandería APP',
      theme: ThemeData.light().copyWith(
        extensions: const[
          AppColors(
            accentuated: Color(0xFFA06CD5),
            overlay: Color(0xFFC19EE0),
            hint: Color(0xFFDAC3E8),),
        ],
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xffA06CD5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: const Color(0xffA06CD5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
        ),
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
  //NOTE: Controladores para los campos de texto
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String message = ''; // Mensaje de respuesta del servidor
  bool _isLoading = false; // Indicador de carga


  //NOTE: Función para enviar los datos de login al servidor
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
      
      final data = jsonDecode(response.body);
      setState(() {
        message = 'Login exitoso: ${data[0]['nombre_usuario']}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login exitoso')),
      );
      //TODO: Importar la página de inicio del sistema
      //Navigator.push(context, MaterialPageRoute(builder: (context) => Sistema()));
    } else {
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
    var colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.accentuated,
        title: Text('Iniciar Sesión'),),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'User_name'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text('Iniciar Sesión'),
            ),
            SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}
