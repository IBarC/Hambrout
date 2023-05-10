enum Colecciones {userdata, recetas, recetasFavs}

String c(var dato){
  switch(dato){
    case Colecciones.userdata:
      return 'userdata';
    case Colecciones.recetas:
      return 'recetas';
    case Colecciones.recetasFavs:
      return 'recetasFavs';
    default:
      return '';
  }
}