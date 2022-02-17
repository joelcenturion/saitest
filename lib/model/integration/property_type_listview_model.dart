class PropertyTypeListviewModel {
  int? idTipoInmueble;
  late String nombre;
  String? prefijo;
  late bool alquiler;
  late bool venta;
  String? imagen;

  PropertyTypeListviewModel({required this.nombre, required this.alquiler, required this.venta});

  PropertyTypeListviewModel.fromJson(Map<String, dynamic> json) {
    idTipoInmueble = json['idTipoInmueble'];
    nombre = json['nombre'];
    prefijo = json['prefijo'];
    alquiler = json['alquiler'];
    venta = json['venta'];
    imagen = json['imagen']==null?'':json['imagen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idTipoInmueble'] = this.idTipoInmueble;
    data['nombre'] = this.nombre.toUpperCase();
    data['prefijo'] = this.prefijo;
    data['alquiler'] = this.alquiler;
    data['venta'] = this.venta;
    data['imagen']=this.imagen;
    return data;
  }
}
