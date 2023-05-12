import 'package:flutter/material.dart';
import 'package:hambrout/enum/enum_usuario.dart';
import 'package:hambrout/firebase/conexion_firebase.dart';
import 'package:hambrout/paginas/app_principal_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'formatos_disenio.dart';

final FormatosDisenio formatosDisenio=FormatosDisenio();
final ConexionDatos conexionDatos = ConexionDatos();

class FormularioLogInWidget extends StatefulWidget{
  const FormularioLogInWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return FormularioLogIn();
  }
}

class FormularioLogIn extends  State<FormularioLogInWidget>{
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _textEditingControllers = [];
  final List<Widget> _widgets = [];
  late List usuarioRegistrado;

  late TextEditingController userContr;
  late TextEditingController passwContr;

  @override
  initState(){
    super.initState();

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
          return 'Usuario no valido';
        }
        bool exist = false;
        for(int i = 0; i<usuarioRegistrado.length; i++){
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
    return SizedBox(
      child:  Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _widgets,
          )),
    );
  }

}

class FormularioCrearCuentaWidget extends StatefulWidget{
  const FormularioCrearCuentaWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return FormularioCrearCuenta();
  }

}

class FormularioCrearCuenta extends State<FormularioCrearCuentaWidget>{
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _textEditingControllers = [];
  final List<Widget> _widgets = [];
  late List usuarioRegistrado;

  TextEditingController nombreContr = TextEditingController(text: "");
  TextEditingController apellidosContr = TextEditingController(text: "");
  TextEditingController correoContr = TextEditingController(text: "");
  TextEditingController passwContr = TextEditingController(text: "");
  TextEditingController repePasswContr = TextEditingController(text: "");

  @override
  initState() {
    super.initState();

    _textEditingControllers.add(nombreContr);
    _widgets.add(Padding(
      padding: const EdgeInsets.all(0),
      child: _createTextFormField("Nombre", nombreContr),
    ));
    _widgets.add(const SizedBox(height: 7));

    _textEditingControllers.add(apellidosContr);
    _widgets.add(Padding(
      padding: const EdgeInsets.all(0),
      child: _createTextFormField("Apellidos", apellidosContr),
    ));
    _widgets.add(const SizedBox(height: 7));

    _textEditingControllers.add(correoContr);
    _widgets.add(Padding(
      padding: const EdgeInsets.all(0),
      child: _createCorreoFormField("Correo electrónico", correoContr),
    ));
    _widgets.add(const SizedBox(height: 7));

    _textEditingControllers.add(passwContr);
    _widgets.add(Padding(padding: const EdgeInsets.all(0),
      child: _createPasswFormField("Contraseña", passwContr),
    ));
    _widgets.add(const SizedBox(height: 7));

    _textEditingControllers.add(repePasswContr);
    _widgets.add(Padding(
      padding: const EdgeInsets.all(0),
      child: _createPasswFormField("Repite la contraseña", repePasswContr),
    ));
    _widgets.add(const SizedBox(height: 7));

    _widgets.add(ElevatedButton(
      style: formatosDisenio.btnBurdeos(),
      onPressed: () async{
        usuarioRegistrado = await conexionDatos.existeUsuario(correoContr.text, passwContr.text);
        if(_formKey.currentState!.validate()){
          conexionDatos.crearUsuario(nombreContr.text, apellidosContr.text, correoContr.text, passwContr.text);
          Navigator.pushNamed(context!, '/');
        }
      },
      child: const Text('Crear cuenta'),
    ),
    );
  }

  TextFormField _createTextFormField(
      String fieldName, TextEditingController controller) {
    return TextFormField(
      validator: (value) {

        if (value!.isEmpty) {
          return 'El campo no puede estar vacio';
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: fieldName,
          labelText: fieldName),
      controller: controller,
    );
  }

  TextFormField _createCorreoFormField(
      String fieldName, TextEditingController controller) {
    return TextFormField(
      validator: (value) {

        if (value!.isEmpty) {
          return 'El campo no puede estar vacio';
        }

        //Comprueba que no haya un usuario con el mismo correo
        for(int i = 0; i<usuarioRegistrado.length; i++){
          if(usuarioRegistrado[i]['username']==correoContr.text){
            return 'Usuario no valido';
          }
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: fieldName,
          labelText: fieldName),
      controller: controller,
    );
  }

  TextFormField _createPasswFormField(
      String fieldName, TextEditingController controller) {
    return TextFormField(
      validator: (value) {

        if (value!.isEmpty) {
          return 'El campo no puede estar vacio';
        } else if (passwContr.text!=repePasswContr.text) {
          return 'Las contraseñas deben coincidir';
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: fieldName,
          labelText: fieldName),
      controller: controller,
      obscureText: true,
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