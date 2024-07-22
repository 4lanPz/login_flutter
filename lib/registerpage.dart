import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginpage.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State createState() => _RegistroState();
}

class _RegistroState extends State<RegistroPage> {
  late String email, password;
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Correo",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Este campo es obligatorio";
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
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
                onSaved: (value) {
                  password = value!;
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      UserCredential? userCredential =
                          await register(email, password);
                      if (userCredential != null) {
                        setState(() {
                          error =
                              ''; // Limpiar error al registrar correctamente
                        });
                        // Registro exitoso, redirigir a la pantalla de login
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      }
                    }
                  },
                  child: const Text("Registrarse"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<UserCredential?> register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          error = 'Correo en uso, pruebe otro correo';
        } else {
          error = 'Error al registrar al usuario';
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
