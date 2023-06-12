enum DatosReceta {nombre, dificultad, ingredientes, elaboracion, foto,
npersonas,origen,tiempo,tipo}

String datosReceta(var dato){
  switch(dato){
    case DatosReceta.nombre:
      return 'nombre';
    case DatosReceta.dificultad:
      return 'dificultad';
    case DatosReceta.ingredientes:
      return 'ingredientes';
    case DatosReceta.elaboracion:
      return 'elaboracion';
    case DatosReceta.foto:
      return 'foto';
    case DatosReceta.npersonas:
      return 'npersonas';
    case DatosReceta.origen:
      return 'origen';
    case DatosReceta.tiempo:
      return 'tiempo';
    case DatosReceta.tipo:
      return 'tipo';
    default:
      return '';
  }
}