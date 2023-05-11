import 'package:flutter/material.dart';
import 'package:hambrout/paginas/crear_cuenta_view.dart';
import 'package:hambrout/utils/formatos_disenio.dart';
import 'package:hambrout/utils/formularios.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enum/enumUsuario.dart';
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


  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _textEditingControllers = [];
  final List<Widget> _widgets = [];
  late List usuarioRegistrado;

  late TextEditingController userContr;
  late TextEditingController passwContr;

  @override
  initState(){
    userContr = TextEditingController(text: "");
    passwContr = TextEditingController(text: "");

    _textEditingControllers.add(userContr);
    _widgets.add(Padding(
      padding: const EdgeInsets.all(0),
      child: _createTextFormField("Usuario", userContr),
    ));
    _widgets.add(const SizedBox(height: 7));

    _textEditingControllers.add(passwContr);
    _widgets.add(Padding(padding: const EdgeInsets.all(0),
      child: _createTextFormField("Contraseña", passwContr),
    ));
    _widgets.add(const SizedBox(height: 7));

    _widgets.add(ElevatedButton(
      style: formatosDisenio.btnBurdeos(),
      onPressed: () async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        usuarioRegistrado = await conexionDatos.existeUsuario(userContr.text, passwContr.text);
        //existeUser=conexionDatos.existeUsu;
        //_formKey.currentState!.validate();
        if(_formKey.currentState!.validate()){
          prefs.setString(dU(DatosUsuario.username), userContr.text);
          prefs.setBool(dU(DatosUsuario.sesionIniciada),true);
          Navigator.push(
            context!,
            MaterialPageRoute(builder: (context) {
              return const AppPrincipalWidget();
            }),
          );
        }
      },
      child: const Text('Iniciar sesión'),
    ),
    );
  }

  bool oscurecerTexto(String fieldName){
    if(fieldName=="Contraseña"){
      return true;
    } else {
      return false;
    }
  }

  TextFormField _createTextFormField(
      String fieldName, TextEditingController controller) {
    return TextFormField(
      validator: (value) {

        if (value!.isEmpty) {
          return 'El campo no puede estar vacio';
        } else if (usuarioRegistrado.isEmpty){
          //print("------------------------------------> VACIO --> $usuarioRegistrado");
          return 'Usuario no valido';
        }
        bool exist = false;
        for(int i = 0; i<usuarioRegistrado.length; i++){
          // print(usuarioRegistrado[i]);
          //print(usuarioRegistrado[i]['username']);
          if(usuarioRegistrado[i]['username']==userContr.text && usuarioRegistrado[i]['password']==passwContr.text){
            exist = true;
          }
        }
        if(!exist){
          return 'Usuario no valido';
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: fieldName,
          labelText: fieldName),
      controller: controller,
      obscureText: oscurecerTexto(fieldName),
    );
  }

  @override
  Widget build(BuildContext context) {

  Size media = MediaQuery.of(context).size;
  double tamanioLogo = media.width/12;




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
                  Image(image: const AssetImage("images/icons/write.png"), width: tamanioLogo,),
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


