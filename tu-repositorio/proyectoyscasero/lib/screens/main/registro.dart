import 'package:flutter/material.dart';
import 'package:proyectoyscasero/services/api_service.dart';
import 'package:animate_do/animate_do.dart';
import 'inicio_sesion.dart';

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final ApiService apiService = ApiService();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });
      final response = await apiService.register(
        nombreController.text,
        emailController.text,
        passwordController.text,
      );
      setState(() {
        isLoading = false;
      });

      if (response['p_resultado'].startsWith('Éxito')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario creado satisfactoriamente')),
        );
        // Navegar a la pantalla de inicio de sesión
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InicioSesion()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['p_resultado'] ?? 'Error al crear usuario')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
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
              "REGÍSTRATE",
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
              controller: nombreController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu nombre';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Ingresa tu nombre',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 16),
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
                    'Registrarse',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: register,
              ),
            ),
          ),
          SizedBox(height: 20),
          FadeInDown(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => InicioSesion()),
                );
              },
              child: Hero(
                tag: 'registro',
                child: Text(
                  '¿Ya tienes cuenta? Inicia sesión aquí',
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
