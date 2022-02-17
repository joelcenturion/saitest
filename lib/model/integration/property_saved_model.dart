class PropertySavedModel{
  int? id;
  String? files;
  String? error;

  PropertySavedModel({this.error, this.id});

  PropertySavedModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    files = json['files'];
  }
}