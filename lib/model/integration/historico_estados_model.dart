
class HistoricoEstadosModel {
  int? idestadoinmueble;
  late String estado;
  String? fechaHora;
  String? comentario;

  HistoricoEstadosModel({
    required this.estado,
    required this.fechaHora,
  });

  HistoricoEstadosModel.fromJson(Map<String, dynamic> json){
    idestadoinmueble = json['idestadoinmueble'];
    estado = json['estado'] == null? '' : json['estado'];
    fechaHora = json['fechaHora'].toString();
    comentario = json['comentario'] == null ? '' : json['comentario'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['idestadoinmueble'] = idestadoinmueble;
    data['estado'] = estado;
    data['fechaHora'] = fechaHora;
    data['comentario'] = comentario??'';
    return data;
  }
}