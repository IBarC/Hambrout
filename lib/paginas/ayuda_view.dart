import 'package:flutter/material.dart';

class AyudaWidget extends StatefulWidget{
  const AyudaWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Ayuda();
  }
}

class _Ayuda extends State<AyudaWidget>{
  @override
  Widget build(BuildContext context) {
    return Text("AYUDA");
  }

}