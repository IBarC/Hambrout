import 'package:flutter/material.dart';
import 'package:hambrout/utils/formatosDisenio.dart';
import 'package:hambrout/utils/formularios.dart';

class LogInWidget extends StatefulWidget{
  const LogInWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LogIn();
  }
}

class _LogIn extends State<LogInWidget>{
  FormatosDisenio formatosDisenio=FormatosDisenio();

  @override
  Widget build(BuildContext context) {

  Size media = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        ///Fondo degradado
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
              end: Alignment(0.0, 1.0),
              colors: <Color>[
                Color(0xFFF5B067),Color(0xFFAE7575),
              ])),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Image(image: AssetImage("images/icons/write.png"), width: 30,),
                    SizedBox(width: 20,),
                    Text("Hambrout")
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: media.height,
                      width: media.width,
                      child: FormWidget(),
                    )],
                ),
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


