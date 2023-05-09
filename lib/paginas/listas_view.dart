import 'package:flutter/material.dart';

class ListasWidget extends StatefulWidget{
  const ListasWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Listas();
  }
}

class _Listas extends State<ListasWidget>{
  @override
  Widget build(BuildContext context) {
    return Text("LISTAS");
  }

}