class LoginModel {
  late String nombre;
  late String apellido;
  late String nombreUsuario;

  LoginModel({required this.nombre, required this.apellido, required this.nombreUsuario});

  LoginModel.fromJson(Map<String, dynamic> json) {
    nombre = json['nombre'];
    apellido = json['apellido'];
    nombreUsuario = json['nombreUsuario'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombre'] = this.nombre;
    data['apellido'] = this.apellido;
    data['nombreUsuario'] = this.nombreUsuario;
    return data;
  }
}