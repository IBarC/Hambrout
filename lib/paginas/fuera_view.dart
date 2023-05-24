import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class FueraWidget extends StatefulWidget{
  const FueraWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return FueraState();
  }
}

class FueraState extends State<FueraWidget>{

  @override
  Widget build(BuildContext context) {
    return Text("FUERA");
  }

}