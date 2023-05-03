import 'package:flutter/material.dart';

class CasaWidget extends StatefulWidget{
  const CasaWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Casa();
  }
}

class _Casa extends State<CasaWidget>{
  @override
  Widget build(BuildContext context) {
    return Text("CASA");
  }

}