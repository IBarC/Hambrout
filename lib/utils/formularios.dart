import 'package:flutter/material.dart';
import 'formatos_disenio.dart';

class FormWidget extends StatelessWidget {

  final FormatosDisenio formatosDisenio=FormatosDisenio();

  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _textEditingControllers = [];
  final List<Widget> _widgets = [];
  ///Se convertira en comprobacion de si exsite en la base de datos el usuario dado
  final String usuario = "usuario";
  final String password = "1234";

  FormWidget({Key? key}) : super(key: key) {

    TextEditingController textEditingController =
    TextEditingController(text: "");
    _textEditingControllers.add(textEditingController);
    _widgets.add(Padding(
      padding: const EdgeInsets.all(0),
      child: _createTextFormField("Usuario", textEditingController, usuario),
    ));
    _widgets.add(const SizedBox(height: 7));
    TextEditingController textEditingController2 = TextEditingController(text: "");
    _textEditingControllers.add(textEditingController2);
    _widgets.add(Padding(padding: const EdgeInsets.all(0),
      child: _createTextFormField("Contraseña", textEditingController2, password),
    ));
    _widgets.add(const SizedBox(height: 7));

    _widgets.add(ElevatedButton(
        style: formatosDisenio.btnBurdeos(),
        onPressed: () {
          _formKey.currentState?.validate();
        },
        child: const Text('Guardar'),
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
          return 'Por favor, introduzca $fieldName.';
        } else if (value != valor){
          return "El valor no es correcto";
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
    return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _widgets,
            ));
  }
}