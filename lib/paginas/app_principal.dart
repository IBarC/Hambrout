import 'package:flutter/material.dart';
import 'package:hambrout/paginas/fuera.dart';

class AppPrincipalWidget extends StatelessWidget{
  const AppPrincipalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hambrout',
      home: PaginaBaseWidget(),
    );
  }

}