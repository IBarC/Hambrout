import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      child: _createTextFormField("Correo electrónico", userContr),
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
          usuarioRegistrado = await conexionDatos.buscarUsuarios(userContr.text, passwContr.text);

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
  late bool existeUser;

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
        usuarioRegistrado = await conexionDatos.buscarUsuarios(correoContr.text, passwContr.text);
        existeUser = await conexionDatos.existeUsuario(correoContr.text);
        if(_formKey.currentState!.validate()){
          conexionDatos.crearUsuario(nombreContr.text, apellidosContr.text, correoContr.text, passwContr.text);
          Navigator.popAndPushNamed(context!, '/login').then((value) => setState((){}));
        }
      },
      child: const Text('Crear cuenta'),
    ),
    );
  }

  String hintText(String fieldName){
    if(fieldName=='Nombre'){
      return 'Ej: Maria del Carmen';
    }
    return 'Ej: López del Castillo';
  }

  TextFormField _createTextFormField(
      String fieldName, TextEditingController controller) {
    return TextFormField(
      validator: (value) {

        if (value!.isEmpty) {
          return 'El campo no puede estar vacio';
        } else if(!RegExp(r"^(?=.{3,15})[A-ZÁÉÍÓÚ][a-zñáéíóú]+(?: [A-ZÁÉÍÓÚ][a-zñáéíóú]+)?").hasMatch(controller.text)){
          if(fieldName=='Nombre'){
            return 'El formato de nombre no es válido';
          } else {
            return 'El formato de apellidos no es válido';
          }
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: hintText(fieldName),
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
        } else if(existeUser){
          return 'El correo ya está en uso';
        } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
          return 'El formato de correo no es válido';
        }

        return null;
      },
      decoration: InputDecoration(
          hintText: 'Ej: maria@ejemplo.com',
          labelText: fieldName),
      controller: controller,
    );
  }

  String hintPass(String fieldName){
    if(fieldName=='Contraseña'){
      return 'Debe contener mayuscula, minusculas y caracteres especiales';
    }
    return '';
  }

  TextFormField _createPasswFormField(
      String fieldName, TextEditingController controller) {
    return TextFormField(
      validator: (value) {

        if (value!.isEmpty) {
          return 'El campo no puede estar vacio';
        } else if(passwContr.text.length<6){
          return 'La contraseña debe tener 6 o más caracteres';
        } else if(!RegExp(r"[A-Za-z]+").hasMatch(passwContr.text)){
          return 'La contraseña debe contener mayuscula y minusculas';
        } else if(!RegExp(r"[0-9]+").hasMatch(passwContr.text)){
          return 'La contraseña debe contener numeros';
        } else if(!RegExp(r"[!.?_,;:]+").hasMatch(passwContr.text)){
          return 'La contraseña debe contener caracteres especiales';
        } else if (passwContr.text!=repePasswContr.text) {
          return 'Las contraseñas deben coincidir';
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: hintPass(fieldName),
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