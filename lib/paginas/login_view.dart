import 'package:flutter/material.dart';
import 'package:hambrout/paginas/crear_cuenta_view.dart';
import 'package:hambrout/utils/formatos_disenio.dart';
import 'package:hambrout/utils/formularios.dart';

/// Clase que genera la vista de LogIn
class LogInWidget extends StatefulWidget {
  const LogInWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LogIn();
  }
}

class _LogIn extends State<LogInWidget> {

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    double tamanioLogo = media.width/9;

    if (media.width < 350) {
      tamanioLogo = 60;
    }
    if (media.width > 700) {
      tamanioLogo = 85;
    }

    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(40),
            width: media.width,
            height: media.height,
            decoration: const BoxDecoration(
                //Fondo degradado
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment(0.0, 1.0),
                    colors: <Color>[
                  Color(0xFFF5B067),
                  Color(0xFFAE7575),
                ])),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    width: 450,
                    decoration: const BoxDecoration(color: Colors.white38,boxShadow: [
                      BoxShadow(color: Colors.white38, blurRadius: 10)
                    ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image:
                          const AssetImage("images/icons/logo.png"),
                          width: tamanioLogo,
                        ),
                        const SizedBox(width: 20,),
                        const Text(
                          "Hambrout",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 70,
                              fontFamily: 'AlumniSans',
                              fontWeight: FontWeight.w400,
                              letterSpacing: -3),
                        ),
                      ],
                    ),
                  ),
                  FormatosDisenio().separacionGrande(context),
                  const FormularioLogInWidget(),
                  FormatosDisenio().separacionGrande(context),
                  Container(
                    width: 300,
                    height: 100,
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.black38, width: 1))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿No tienes una cuenta?',
                          style:
                              FormatosDisenio().txtInfoLogin2(context, false),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const CrearCuentaWidget();
                              }));
                            },
                            child: Text(
                              '¡Registrate aquí!',
                              style: FormatosDisenio()
                                  .txtInfoLogin2(context, true),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
