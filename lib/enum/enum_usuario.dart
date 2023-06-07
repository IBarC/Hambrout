enum DatosUsuario {nombre, apellidos, password, username, sesionIniciada, telefono}

String dU(var dato){
  switch(dato){
    case DatosUsuario.nombre:
      return 'nombre';
    case DatosUsuario.apellidos:
      return 'apellidos';
    case DatosUsuario.password:
      return 'password';
    case DatosUsuario.username:
      return 'username';
    case DatosUsuario.sesionIniciada:
      return 'sesionIniciada';
    case DatosUsuario.telefono:
      return 'telefono';
    default:
      return '';
  }
}