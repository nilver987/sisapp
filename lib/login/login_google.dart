import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ventas_app/apis/usuario_api.dart';
import 'package:ventas_app/comp/Button.dart';
import 'package:ventas_app/drawer/navigation_home_screen.dart';
import 'package:ventas_app/modelo/UsuarioModelo.dart';
import 'package:ventas_app/util/TokenUtil.dart';

class MainLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<UsuarioApi>(
      create: (_) => UsuarioApi.create(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.blue),
        home: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _controllerUser = TextEditingController();
  final _controllerPass = TextEditingController();

  bool passwordVisible = true;
  bool modLocal = false;
  String? tokenx;
  String error = "";

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/imagen/logo_upeu2.png", height: 180),
                const SizedBox(height: 20),
                _buildForm(),
                const SizedBox(height: 20),
                _signInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _controllerUser,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: "Usuario",
                hintText: "Usuario",
                helperText: "Coloque un correo",
                filled: true,
              ),
              validator: (value) => value!.isEmpty ? 'Ingrese usuario' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controllerPass,
              obscureText: passwordVisible,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelText: "Password",
                hintText: "Password",
                helperText: "La contraseña debe contener un carácter especial",
                filled: true,
                suffixIcon: IconButton(
                  icon: Icon(passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () =>
                      setState(() => passwordVisible = !passwordVisible),
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Ingrese contraseña' : null,
            ),
            const SizedBox(height: 24),
            Button(
              label: 'Ingresar',
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  final prefs = await SharedPreferences.getInstance();
                  final api = Provider.of<UsuarioApi>(context, listen: false);
                  final user = UsuarioLogin(
                    username: _controllerUser.text.trim(),
                    password: _controllerPass.text,
                  );

                  try {
                    final value = await api.login(user);
                    tokenx = "Bearer ${value.token}";
                    TokenUtil.TOKEN = tokenx!;
                    prefs.setString("token", tokenx!);
                    prefs.setString("usernameLogin", _controllerUser.text);

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => NavigationHomeScreen(),
                      ),
                    );
                  } catch (e) {
                    print("Error en login: $e");
                    setState(() {
                      error = "Usuario o contraseña incorrectos.";
                    });
                  }
                }
              },
            ),
            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  error,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlinedButton(
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();

        try {
          final result = await _googleSignIn.signIn();
          if (result != null) {
            TokenUtil.localx = modLocal;
            if (!TokenUtil.localx) {
              final api = Provider.of<UsuarioApi>(context, listen: false);
              final user = UsuarioLogin(
                  username: "davidmp@upeu.edu.pe", password: "Da12345*");

              final value = await api.login(user);
              tokenx = "Bearer ${value.token}";
              TokenUtil.TOKEN = tokenx!;
              prefs.setString("token", tokenx!);
              prefs.setString("usernameLogin", result.email);
            }

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => NavigationHomeScreen()),
            );
          }
        } catch (e) {
          setState(() {
            error = "Error al iniciar sesión con Google.";
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/imagen/man-icon.png", height: 35.0),
            const SizedBox(width: 10),
            const Text(
              'Ingresar Google',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
