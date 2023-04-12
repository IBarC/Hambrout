import 'package:flutter/material.dart';

class FormatosDisenio{
  ButtonStyle btnBurdeos(){
    return ElevatedButton.styleFrom(
      shadowColor: Colors.black,
      elevation: 10,
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromRGBO(101, 62, 61, 100)
    );
  }
}