import 'package:flutter/material.dart';
import 'package:hambrout/paginas/crear_cuenta_view.dart';
import 'package:hambrout/utils/formatos_disenio.dart';
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

  void cambiarPagina(){
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/principal',
        (route)=>false
    );
  }

  @override
  Widget build(BuildContext context) {

  Size media = MediaQuery.of(context).size;
  double tamanioLogo=media.width-400;

  if(tamanioLogo<350) {
    tamanioLogo=250;
  } if (tamanioLogo>700){
    tamanioLogo=500;
  }

  return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(40),
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: const AssetImage("images/icons/logo-caramelo.png"), width: tamanioLogo,),
                  //SizedBox(width: 10,),
                  //Text("Hambrout", style: TextStyle(color: Colors.white, fontSize: 65, fontFamily: 'AlumniSans', fontWeight: FontWeight.w400, letterSpacing: -3),)
                ],
              ),
              formatosDisenio.separacionNormal(context),
              FormularioLogInWidget(),
              //formatosDisenio.separacionNormal(context),
              /**TextButton(
                  onPressed: (){},
                  child: const Text("He olvidado la contraseña",
                  style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  ))),**/
              formatosDisenio.separacionGrande(context),
              Container(
                height: 100,
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black38, width: 1))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿No tienes una cuenta?', style: FormatosDisenio().txtInfoLogin2(context, false),),
                    TextButton(
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const CrearCuentaWidget();
                              })
                          );
                        },
                        child: Text('¡Registrate aquí!', style: FormatosDisenio().txtInfoLogin2(context, true),))
                  ],
                ),
              )
            ],
          ),
        )
      )
    );
  }
}


