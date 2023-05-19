import 'package:flutter/material.dart';


class Lista{
  String titulo;
  List elementos;
  int id;

  Lista({required this.titulo, required this.elementos, required this.id});
}

class Elemento{
  String nombre;
  bool tachado;
  TextEditingController controlador;

  Elemento({required this.nombre, required this.tachado, required this.controlador});

}