import 'package:flutter/material.dart';

class FavsWidget extends StatefulWidget{
  const FavsWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Favs();
  }
}

class _Favs extends State<FavsWidget>{
  @override
  Widget build(BuildContext context) {
    return Text("FAVORITOS");
  }

}