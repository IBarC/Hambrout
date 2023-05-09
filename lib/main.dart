import 'package:flutter/material.dart';
import 'package:hambrout/paginas/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //funcion que decida si abre al inicio la pagina principal o el login
  //dependiendo de si el token ya existe

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hambrout',
      //home: const LogInWidget(),
      initialRoute: '/',
      routes: {
        '/': (context) => const LogInWidget(),
      },
    );
  }
}