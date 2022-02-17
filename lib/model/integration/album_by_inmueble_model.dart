
class AlbumByInmuebleModel {
  int? idarchivos;
  late String nombre;
  late bool imagen;
  late bool principal;
  String? pathArchivo;
  String? data; //para album_to_save
  late String mimeType;

  AlbumByInmuebleModel({
    required this.nombre,
    required this.imagen,
    required this.principal,
    required this.mimeType,
    required this.pathArchivo,
    required this.data,
  });

  AlbumByInmuebleModel.fromJson(Map<String, dynamic> json) {
    idarchivos= json['idarchivos']==null?null:json['idarchivos'];
    nombre = json['nombre']==null?"":json['nombre'];
    imagen = json['imagen'];
    principal = json['principal']==null?false:json['principal'];
    pathArchivo = json['pathArchivo']==null?"":json['pathArchivo'];
    mimeType = json['mimeType']??'image/jpg';
    // extension = json['mimeType'].toString().split('/').last;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idarchivos'] = idarchivos;
    data['nombre'] = this.nombre;
    data['imagen'] = this.imagen;
    data['principal'] = this.principal;
    data['pathArchivo'] = this.pathArchivo;
    data['mimeType'] = this.mimeType;
    data['data'] = this.data;
    return data;
  }

  AlbumByInmuebleModel.createAndCopyValuesFrom(AlbumByInmuebleModel from){
      idarchivos = from.idarchivos;
      nombre = from.nombre;
      imagen = from.imagen;
      principal = from.principal;
      mimeType = from.mimeType;
      pathArchivo = from.pathArchivo;
      data = from.data;
  }

  copyFromAtoB(AlbumByInmuebleModel A, AlbumByInmuebleModel B){
    B.idarchivos = A.idarchivos;
    B.nombre = A.nombre;
    B.imagen = A.imagen;
    B.principal = A.principal;
    B.mimeType = B.mimeType;
    B.pathArchivo = B.pathArchivo;
    B.data = B.data;
  }

}
