import 'package:flutter/material.dart';

import '../models/receta.dart';

class RecetaWidget extends StatefulWidget{
  final Receta receta;

  const RecetaWidget({super.key,
    required this.receta
  });

  @override
  State<StatefulWidget> createState() {
    return _Receta(receta: receta);
  }
}

class _Receta extends State<RecetaWidget>{
  Receta receta;

  _Receta({
    required this.receta
  });

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: media.height,
        width: media.width,
        decoration: BoxDecoration(color: Colors.white70),
        child: Padding(
          padding: EdgeInsets.all(media.height/50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [ IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios_new))
                ],
              ),
              Row(children: [Text(receta.nombre)],)
            ],
          ),
        ),
      ) ,
    );
  }
}