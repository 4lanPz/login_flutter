import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'registerpage.dart';
import 'ubicacion.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  late String email, password;
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Iniciar sesión",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
          Visibility(
            visible: error.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: formulario(),
          ),
          buttonLogin(),
          const SizedBox(height: 12),
          FractionallySizedBox(
            widthFactor: 0.6,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistroPage()),
                );
              },
              child: const Text("Registrarse"),
            ),
          ),
        ],
      ),
    );
  }

  Widget formulario() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmail(),
          const Padding(padding: EdgeInsets.only(top: 12)),
          buildPassword(),
        ],
      ),
    );
  }

  Widget buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Correo",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String? value) {
        email = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }

  Widget buildPassword() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Contraseña",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
      onSaved: (String? value) {
        password = value!;
      },
    );
  }

  Widget buttonLogin() {
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            UserCredential? credenciales = await login(email, password);
            if (credenciales != null) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const Ubicacion(title: 'Ubicación')),
                (Route<dynamic> route) => false,
              );
            }
          }
        },
        child: const Text("Iniciar sesión"),
      ),
    );
  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      setState(() {
        error = ''; // Limpiar error al iniciar sesión correctamente
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'wrong-password') {
          error = 'Contraseña incorrecta';
        } else {
          error = 'Usuario no existe o contraseña incorrecta';
        }
      });
      // Clear error after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          error = '';
        });
      });
      return null;
    }
  }
}
