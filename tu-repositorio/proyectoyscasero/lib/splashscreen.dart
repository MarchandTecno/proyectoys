import 'package:flutter/material.dart';
import 'dart:async';
import 'package:proyectoyscasero/screens/main/inicio_sesion.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 5), () {});
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => InicioSesion()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/PROYECTOYS.png'),
      ),
    );
  }
}
