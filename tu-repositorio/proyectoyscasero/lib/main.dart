import 'package:flutter/material.dart';
import 'package:proyectoyscasero/screens/main/inicio_sesion.dart';
import 'package:proyectoyscasero/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tu Aplicación',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        brightness: Brightness.dark,
      ),
      home: SplashScreen(), // Pantalla inicial
    );
  }
}
