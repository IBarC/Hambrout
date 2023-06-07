import 'package:flutter/material.dart';
import 'package:hambrout/paginas/crear_cuenta_view.dart';
import 'package:hambrout/utils/formatos_disenio.dart';
import 'package:hambrout/utils/formularios.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enum/enum_usuario.dart';
import 'app_principal_view.dart';

class LogInWidget extends StatefulWidget{
  const LogInWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LogIn();
  }
}

class _LogIn extends State<LogInWidget>{
  FormatosDisenio formatosDisenio=FormatosDisenio();

  void cambiarPagina(){
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/principal',
        (route)=>false
    );
  }

  @override
  Widget build(BuildContext context) {

  Size media = MediaQuery.of(context).size;
  double tamanioLogo = media.width/5;

  return Scaffold(
      body: Container(
        width: media.width,
        height: media.height,
        ///Fondo degradado
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
              end: Alignment(0.0, 1.0),
              colors: <Color>[
                Color(0xFFF5B067),Color(0xFFAE7575),
              ])),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(40.0),
            scrollDirection: Axis.vertical,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: const AssetImage("images/icons/logo-blanco.png"), width: tamanioLogo,),
                  SizedBox(width: media.width/13,),
                  const Text("Hambrout")
                ],
              ),
              formatosDisenio.separacionNormal(context),
              FormularioLogInWidget(),
              formatosDisenio.separacionNormal(context),
              /**TextButton(
                  onPressed: (){},
                  child: const Text("He olvidado la contraseña",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ))),**/
              formatosDisenio.separacionNormal(context),
              ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const CrearCuentaWidget();
                        })
                    );
                  },
                  style: formatosDisenio.btnBurdeos(),
                  child: const Text('No tengo cuenta'))
            ],
          ),
        )
      )
    );
  }
}


