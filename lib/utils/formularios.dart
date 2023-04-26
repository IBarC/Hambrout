import 'package:flutter/material.dart';
import 'package:hambrout/firebase/conexion_firebase.dart';
import 'formatos_disenio.dart';

class FormWidget extends StatelessWidget {

  final FormatosDisenio formatosDisenio=FormatosDisenio();

  final ConexionDatos conexionDatos = ConexionDatos();

  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _textEditingControllers = [];
  final List<Widget> _widgets = [];
  ///Se convertira en comprobacion de si exsite en la base de datos el usuario dado
  final String usuario = "usuario";
  final String password = "1234";

  late bool existeUser;
  late List usuarioRegistrado;

  TextEditingController controladorUser = TextEditingController(text: "");
  TextEditingController controladorPassw = TextEditingController(text: "");

  FormWidget({Key? key}) : super(key: key) {

    _textEditingControllers.add(controladorUser);
    _widgets.add(Padding(
      padding: const EdgeInsets.all(0),
      child: _createTextFormField("Usuario", controladorUser, usuario),
    ));
    _widgets.add(const SizedBox(height: 7));

    _textEditingControllers.add(controladorPassw);
    _widgets.add(Padding(padding: const EdgeInsets.all(0),
      child: _createTextFormField("Contraseña", controladorPassw, password),
    ));
    _widgets.add(const SizedBox(height: 7));

    _widgets.add(ElevatedButton(
        style: formatosDisenio.btnBurdeos(),
        onPressed: () async{
          usuarioRegistrado = await conexionDatos.existeUsuario(controladorUser.text, controladorPassw.text);
          //existeUser=conexionDatos.existeUsu;
          _formKey.currentState!.validate();
          //if(_formKey.currentState!.validate()){
            //lleva a la pagina de inicio
          //}
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
      String fieldName, TextEditingController controller, String valor) {
    return TextFormField(
      validator: (value) {

        if (value!.isEmpty) {
          return 'El campo no puede estar vacio';
        } else if (usuarioRegistrado.isEmpty){
          print("------------------------------------> VACIO --> $usuarioRegistrado");
          return 'Usuario no valido';
        }
        print('USUARIOS');
        bool exist = false;
        for(int i = 0; i<usuarioRegistrado.length; i++){
          print(usuarioRegistrado[i]);
          print(usuarioRegistrado[i]['username']);
          if(usuarioRegistrado[i]['username']==controladorUser.text && usuarioRegistrado[i]['password']==controladorPassw.text){
            exist = true;
          }
        }
        if(!exist){
          return 'Usuario no valido';
        }
        print("------------------------------------> NO VACIO --> $usuarioRegistrado");
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
    return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _widgets,
            ));
  }
}
/**
class FormWidget extends StatelessWidget {

  final FormatosDisenio formatosDisenio=FormatosDisenio();

  final ConexionDatos conexionDatos = ConexionDatos();

  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _textEditingControllers = [];
  final List<Widget> _widgets = [];
  ///Se convertira en comprobacion de si exsite en la base de datos el usuario dado
  final String usuario = "usuario";
  final String password = "1234";

  late bool existeUser;
  late List usuarioRegistrado;

  TextEditingController controladorUser = TextEditingController(text: "");
  TextEditingController controladorPassw = TextEditingController(text: "");

  FormWidget({Key? key}) : super(key: key) {

    _textEditingControllers.add(controladorUser);
    _widgets.add(Padding(
      padding: const EdgeInsets.all(0),
      child: _createTextFormField("Usuario", controladorUser, usuario),
    ));
    _widgets.add(const SizedBox(height: 7));

    _textEditingControllers.add(controladorPassw);
    _widgets.add(Padding(padding: const EdgeInsets.all(0),
      child: _createTextFormField("Contraseña", controladorPassw, password),
    ));
    _widgets.add(const SizedBox(height: 7));

    _widgets.add(ElevatedButton(
      style: formatosDisenio.btnBurdeos(),
      onPressed: () async{
        usuarioRegistrado = await conexionDatos.existeUsuario(controladorUser.text, controladorPassw.text);
        //existeUser=conexionDatos.existeUsu;
        _formKey.currentState!.validate();
        //if(_formKey.currentState!.validate()){
        //lleva a la pagina de inicio
        //}
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
      String fieldName, TextEditingController controller, String valor) {
    return TextFormField(
      validator: (value) {

        if (value!.isEmpty) {
          return 'El campo no puede estar vacio';
        } else if (usuarioRegistrado.isEmpty){
          print("------------------------------------> VACIO --> $usuarioRegistrado");
          return 'Los datos no son correctos';
        }
        print("------------------------------------> NO VACIO --> $usuarioRegistrado");
        return null;
      },
      decoration: InputDecoration(
          hintText: fieldName,
          labelText: fieldName),
      controller: controller,
      obscureText: oscurecerTexto(fieldName),
    );
  }

  late var usus;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: conexionDatos.existeUsuario(controladorUser.text, controladorPassw.text),
      builder: ((context, snapshot){
        usus=snapshot.data?[0]['username'];
        print("usuuuuuuuuuuuuuuuuuuuuuuuuuuus $usus");
        return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _widgets,
            ));
      }),
    );
  }
}**/