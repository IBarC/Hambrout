import 'package:flutter/material.dart';


class Lista{
  String titulo;
  List elementos;

  Lista({required this.titulo, required this.elementos});
}

class Elemento{
  String nombre;
  bool tachado;
  TextEditingController controlador;

  Elemento({required this.nombre, required this.tachado, required this.controlador});
}