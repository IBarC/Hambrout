import 'package:flutter/material.dart';

class LogInWidget extends StatefulWidget{
  const LogInWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LogIn();
  }
}

class _LogIn extends State<LogInWidget>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        ///Fondo degradado
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
              end: Alignment(0.0, 1.0),
              colors: <Color>[
                Color(0xFFF5B067),Color(0xFFAE7575),
              ])
        ),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage("images/icons/write.png"), width: 30,),
                    SizedBox(width: 20,),
                    Text("Hambrout")
                  ],
                ),
                Row(),
                Row(),
                Row(),
                Row(),
                Row(),
              ],
            )
          ],
        ),
      )
    );
  }
}