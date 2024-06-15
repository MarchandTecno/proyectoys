import 'package:flutter/material.dart';
import 'package:proyectoyscasero/screens/main/registro.dart';
import 'package:proyectoyscasero/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyectoyscasero/screens/home/interfaz.dart';
import 'package:animate_do/animate_do.dart';

class InicioSesion extends StatefulWidget {
  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  final ApiService apiService = ApiService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });
      final response = await apiService.login(
        emailController.text,
        passwordController.text,
      );
      setState(() {
        isLoading = false;
      });

      if (response['status'] == 'success') {
        // Navegar a la pantalla de inicio después de iniciar sesión
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Interfaz()),
        );
      } else {
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Error al iniciar sesión')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: isSmallScreen ? _buildSmallScreen() : _buildLargeScreen(),
        ),
      ),
    );
  }

  Widget _buildSmallScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLogo(),
        SizedBox(height: 20),
        _buildForm(),
      ],
    );
  }

  Widget _buildLargeScreen() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      constraints: const BoxConstraints(maxWidth: 800),
      child: Row(
        children: [
          Expanded(child: _buildLogo()),
          Expanded(
            child: Center(child: _buildForm()),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return ZoomIn(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(
            tag: 'logo',
            child: Image.asset(
              'assets/logo.png',
              width: MediaQuery.of(context).size.width < 700 ? 200 : 300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Inicio de sesion",
              textAlign: TextAlign.center,
              style: MediaQuery.of(context).size.width < 600
                  ? Theme.of(context).textTheme.headline5
                  : Theme.of(context).textTheme.headline4?.copyWith(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeInLeft(
            child: TextFormField(
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu correo electrónico';
                }
                bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return 'Por favor ingresa un correo electrónico válido';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                hintText: 'Ingresa tu correo electrónico',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 16),
          FadeInRight(
            child: TextFormField(
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu contraseña';
                }
                if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                hintText: 'Ingresa tu contraseña',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 16),
          FadeInUp(
            child: isLoading
                ? CircularProgressIndicator()
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: login,
              ),
            ),
          ),
          SizedBox(height: 20),
          FadeInDown(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Registro(),
                  ),
                );
              },
              child: Hero(
                tag: 'registro',
                child: Text(
                  '¿No tienes cuenta? Regístrate aquí',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
