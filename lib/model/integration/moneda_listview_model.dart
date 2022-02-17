class MoneyListviewModel {
  late int idMoneda;
  late String nombre;
  late double valorCambio;
  late String simbolo;

  MoneyListviewModel({required this.idMoneda, required this.nombre, required this.simbolo});

  MoneyListviewModel.fromJson(Map<String, dynamic> json) {
    idMoneda = json['idMoneda'];
    nombre = json['nombre'];
    valorCambio = json['valorCambio'].toDouble();
    simbolo = json['simbolo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idMoneda'] = this.idMoneda;
    data['nombre'] = this.nombre;
    data['valorCambio'] = this.valorCambio;
    data['simbolo'] = this.simbolo;
    return data;
  }
}
