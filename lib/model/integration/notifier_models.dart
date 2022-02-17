
import 'package:devkitflutter/network/api_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:devkitflutter/model/integration/album_list_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'album_by_inmueble_model.dart';

class PageChanged extends ChangeNotifier{
  int _index = 0;
  int get index => _index;

  set onPageChange(int newIndex){
    _index = newIndex;
    notifyListeners();
  }
}

//////Images List///////
class PropertyImages extends ChangeNotifier{
  final CancelToken apiToken = CancelToken();
  ApiProvider _apiProvider = ApiProvider();

  List<dynamic> _albumToEdit = [];
  dynamic _coverImage;  //AlbumByInmuebleModel ó Asset
  int _coverImageIndex = 0;
  List<dynamic> _album = []; /*List<AlbumListModel ó Asset>*/
  List<Asset> _assets = [];
  late int _length;
  int? _idInmueble; //id de inmueble
  int _uploadedAssets = 0; //cantidad de imágenes ya subida
  int _totalAssets = 0;

  List<dynamic> get album => _album;
  dynamic get coverImage => _coverImage; //AlbumByInmuebleModel ó Asset
  int get coverImageIndex => _coverImageIndex;
  List<Asset> get assets => _assets;
  List<dynamic> get albumToEdit => _albumToEdit;
  int? get idInmueble => _idInmueble;
  int get uploadedAssets => _uploadedAssets;
  int get totalAssets => _totalAssets;

  set setTotalAssets (int n){
    _totalAssets = n;
  }

  set setUploadedAssets (int n){
    _uploadedAssets = n;
  }

  set setIdInmueble(int id){
    _idInmueble = id;
  }

  set addAssets(List<Asset> images){
    _assets = [];
    _assets.addAll(images);
  }

  set setCoverImageIndex (int index){
    _coverImageIndex = index;
  }

  set addImages (List<Asset> images){
    _album.removeRange(_length, _album.length);
    _album.addAll(images);
    notifyListeners();
  }

  set setCoverImage(dynamic image){
    _coverImage = image;
    notifyListeners();
  }

  void notify(){
    notifyListeners();
  }

  void getAlbum(int idinmueble) async{
    try{
      _album = []; _coverImageIndex=0; _coverImage = null; _assets= []; _albumToEdit = [];
      dynamic _tempAlbum = await _apiProvider.getAlbum(idinmueble, apiToken);
      _album.addAll(_tempAlbum);
      dynamic _principal;

      //find coverImage
      for (int i = 0; i < _album.length; i++) {
        if (_album[i].archivo.principal == true) {
          _coverImage =
              AlbumByInmuebleModel.createAndCopyValuesFrom(_album[i].archivo);
          _principal = _album[i];
        }
      }

      //place cover image at the beginning
      if(_principal!=null){
        int index = _album.indexOf(_principal);
        _album[index] = _album.first;
        _album.first = _principal;
      }

      _length = _album.length;
      notifyListeners();

    }catch (e){
      throw e.toString();
    }
  }

  void sortAlbumToEdit (){
    _albumToEdit = [];
    //coverImage was changed. coverImage is not one of the recently added images(assets)
    if(_coverImageIndex < _length && _coverImageIndex != 0) {
      _album[_coverImageIndex].archivo.principal = true;

      String _path = _album[_coverImageIndex].archivo.pathArchivo;
      int _end = _path.lastIndexOf('/');
      _album[_coverImageIndex].archivo.pathArchivo = _path.substring(0, _end);

      _albumToEdit.add(_album[_coverImageIndex].archivo);

    }else if(_coverImageIndex > _length){ //coverImage is one of the recently added images(assets)
      sortAssets();
    }
    _albumToEdit.addAll(_assets);

  }

  //place coverImage at the beginning
  void sortAssets(){
    if(_assets.isEmpty) return;
    Asset? tmp;
    tmp = _assets.first;
    _assets.first = _assets[_coverImageIndex] ;
    _assets[_coverImageIndex] = tmp;
  }

}


