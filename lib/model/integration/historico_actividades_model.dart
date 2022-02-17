
class HistoricoActividadesModel {
  int? idactividadInmueble;
  late String fecha;
  late String tipoActividad;
  late String obs;

  HistoricoActividadesModel();

  HistoricoActividadesModel.fromJson(Map<String, dynamic> json){
    idactividadInmueble = json['idactividadInmueble'];
    fecha = (json['fecha']);
    tipoActividad = json['tipoActividad'];
    obs = json['obs'];

  }

  Map<String, dynamic> toJson(){
    final data = Map<String, dynamic>();
    data['idactividadInmueble'] = idactividadInmueble;
    data['fecha'] = fecha;
    data['tipoActividad'] = tipoActividad;
    data['obs'] = obs;
    return data;
  }

}