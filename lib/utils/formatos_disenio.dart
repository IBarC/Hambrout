import 'package:flutter/material.dart';

class FormatosDisenio{

  ButtonStyle btnBurdeos(){
    return ElevatedButton.styleFrom(
      shadowColor: Colors.black,
      elevation: 7,
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromRGBO(101, 62, 61, 100)
    );
  }

  SizedBox separacionNormal(BuildContext context){
    return SizedBox(height: MediaQuery.of(context).size.width/20);
  }

  SizedBox separacionPequenia(BuildContext context){
    return SizedBox(height: MediaQuery.of(context).size.width/20);
  }
}