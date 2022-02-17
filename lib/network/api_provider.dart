/*
This is api provider
This page is used to get data from API
 */

import 'dart:convert';

import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/model/integration/album_by_inmueble_model.dart';
import 'package:devkitflutter/model/integration/album_list_model.dart';
import 'package:devkitflutter/model/integration/historico_actividades_model.dart';
import 'package:devkitflutter/model/integration/historico_estados_model.dart';
import 'package:devkitflutter/model/integration/login_model.dart';
import 'package:devkitflutter/model/integration/product_grid_model.dart';
import 'package:devkitflutter/model/integration/product_listview_model.dart';
import 'package:devkitflutter/model/integration/property_listview_model.dart';
import 'package:devkitflutter/model/integration/property_model.dart';
import 'package:devkitflutter/model/integration/property_saved_model.dart';
import 'package:devkitflutter/model/integration/property_type_listview_model.dart';
import 'package:devkitflutter/model/integration/student_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  Dio dio = Dio();
  late Response response;
  String connErr = 'No se puede conectar con el servidor. Verifique su conexión a Internet.';

  Future<Response> getConnect(url, apiToken) async{
    print('url : '+url.toString());
    try{
      dio.options.headers['content-Type'] = 'application/x-www-form-urlencoded';
      dio.options.connectTimeout = 30000; //5s
      dio.options.receiveTimeout = 25000;
      return await dio.post(url, cancelToken: apiToken);
    } on DioError catch (e){
      //print(e.toString()+' | '+url.toString());
      if(e.type == DioErrorType.response){
        int? statusCode = e.response!.statusCode;
        if(statusCode == STATUS_NOT_FOUND){
          throw "Api not found";
        } else if(statusCode == STATUS_INTERNAL_ERROR){
          throw "Internal Server Error";
        } else {
          throw e.error.message.toString();
        }
      } else if(e.type == DioErrorType.connectTimeout){
        throw e.message.toString();
      } else if(e.type == DioErrorType.cancel){
        throw 'cancel';
      }
      throw connErr;
    } finally{
      dio.close();
    }
  }


  Future<Response> getConnectJson(url, queryParam, apiToken) async{
    Dio dio = Dio();
    print('url : '+url.toString());
    try{
      dio.options.headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJTQUkiLCJpYXQiOjE2MjMxMDY1OTMsInN1YiI6ImFkbWluIiwiZXhwIjoxNjIzMTI4MTkzfQ.-ghkzCHUghscyn9TQPv3-OqIJIhVx8fqXUaj6wI1o-4';
      dio.options.setRequestContentTypeWhenNoPayload = true;
      dio.options.connectTimeout = 30000; //5s
      dio.options.receiveTimeout = 90000;

      return await dio.get(url, queryParameters: queryParam, cancelToken: apiToken);
    } on DioError catch (e){
      print('error en getConnectJson');
      // print(e.toString()+' | '+url.toString());
      if(e.type == DioErrorType.response){
        int? statusCode = e.response!.statusCode;
        if(statusCode == STATUS_NOT_FOUND){
          throw "Api not found";
        } else if(statusCode == STATUS_INTERNAL_ERROR){
          throw "Internal Server Error";
        } else {
          throw e.error.message.toString();
        }
      } else if(e.type == DioErrorType.connectTimeout){
        throw e.message.toString();
      } else if(e.type == DioErrorType.cancel){
        throw 'cancel';
      }else if(e.type == DioErrorType.receiveTimeout){
        throw 'Se agotó tiempo de espera de recepción';
      }else{
      throw connErr;
      }
    }
    finally{
      dio.close();
    }
  }

  Future<Response> putConnect(url, data) async{
    print('url: $url');
    // print('data: $data');
    try{
      dio.options.headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJTQUkiLCJpYXQiOjE2MjI2MzU5MzQsInN1YiI6ImFkbWluIiwiaXNzIjoiMzUzMjcwMDY1MzEyNjAiLCJleHAiOjE2MjI2NTc1MzR9.TGGAVEWBWwuVD3NgRux3zb9jOn4Iq2Aa5fuP2OllIbk';
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.connectTimeout = 30000; //5s
      dio.options.receiveTimeout = 25000;
      return await dio.put(url, data: data);

    } on DioError catch(e){
      print('put exception: $e');
      if(e.type == DioErrorType.response){
        int? statusCode = e.response!.statusCode;
        if(statusCode == STATUS_NOT_FOUND){
          throw "Api not found";
        } else if(statusCode == STATUS_INTERNAL_ERROR){
          throw "Internal Server Error";
        } else {
          throw e.error.message.toString();
        }
      } else if(e.type == DioErrorType.connectTimeout){
        // throw e.message.toString();
        throw connErr;
      } else if(e.type == DioErrorType.cancel){
        throw 'cancel';
      }
      throw connErr;
    }
  }


  Future<Response> postConnect(url, data, apiToken) async{
    print('url : '+url.toString());
    // print('postData : '+data.toString());
    try{
      dio.options.headers['content-Type'] = 'application/x-www-form-urlencoded';
      dio.options.connectTimeout = 30000; //5s
      dio.options.receiveTimeout = 25000;

      return await dio.post(url, data: data, cancelToken: apiToken);
    } on DioError catch (e){
      //print(e.toString()+' | '+url.toString());
      if(e.type == DioErrorType.response){
        int? statusCode = e.response!.statusCode;
        if(statusCode == STATUS_NOT_FOUND){
          throw "Api not found";
        } else if(statusCode == STATUS_INTERNAL_ERROR){
          throw "Internal Server Error";
        } else {
          throw e.error.message.toString();
        }
      } else if(e.type == DioErrorType.connectTimeout){
        throw 'Se agotó tiempo de espera de conección';
      } else if(e.type == DioErrorType.cancel){
        throw 'cancel';
      }
      throw connErr;
    } finally{
      dio.close();
    }
  }


  Future<Response> postConnect2(url, data) async{
    Dio dio = Dio();
    print('url : '+url.toString());
    // print('postData : '+data.toString());
    try{
      dio.options.headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJTQUkiLCJpYXQiOjE2MjI2MzU5MzQsInN1YiI6ImFkbWluIiwiaXNzIjoiMzUzMjcwMDY1MzEyNjAiLCJleHAiOjE2MjI2NTc1MzR9.TGGAVEWBWwuVD3NgRux3zb9jOn4Iq2Aa5fuP2OllIbk';
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.connectTimeout = 30000; //5s
      dio.options.receiveTimeout = 25000;

      return await dio.post(url, data: data);
    } on DioError catch (e){
      //print(e.toString()+' | '+url.toString());
      if(e.type == DioErrorType.response){
        int? statusCode = e.response!.statusCode;
        if(statusCode == STATUS_NOT_FOUND){
          throw "Api not found";
        } else if(statusCode == STATUS_INTERNAL_ERROR){
          throw "Internal Server Error";
        } else {
          throw e.error.message.toString();
        }
      } else if(e.type == DioErrorType.connectTimeout){
        throw e.message.toString();
      } else if(e.type == DioErrorType.cancel){
        throw 'cancel';
      }else{
        throw connErr;
      }
    } finally{
      dio.close();
    }
  }

  Future<String> getExample(apiToken) async {
    response = await getConnect(SERVER_URL+'/example/getData', apiToken);
    print('res : '+response.toString());
    return response.data.toString();
  }

  Future<String> postExample(String id, apiToken) async {
    var postData = {
      'id': id
    };
    response = await postConnect(SERVER_URL+'/example/postData', postData, apiToken);
    print('res : '+response.toString());
    return response.data.toString();
  }

  Future<List<StudentModel>> getStudent(String sessionId, apiToken) async {
    var postData = {
      'session_id': sessionId
    };
    response = await postConnect(SERVER_URL+'/student/getStudent', postData, apiToken);
    if(response.data['status'] == STATUS_OK){
      List responseList = response.data['data'];
      List<StudentModel> listData = responseList.map((f) => StudentModel.fromJson(f)).toList();
      return listData;
    } else {
      throw response.data['msg'];
    }
  }

  Future<List<dynamic>> addStudent(String sessionId, String studentName, String studentPhoneNumber, String studentGender, String studentAddress, apiToken) async {
    var postData = {
      'session_id': sessionId,
      'student_name': studentName,
      'student_phone_number': studentPhoneNumber,
      'student_gender': studentGender,
      'student_address': studentAddress,
    };
    response = await postConnect(SERVER_URL+'/student/addStudent', postData, apiToken);
    if(response.data['status'] == STATUS_OK){
      List<dynamic> respList = [];
      respList.add(response.data['msg']);
      respList.add(response.data['data']['id']);
      return respList;
    } else {
      throw response.data['msg'];
    }
  }

  Future<String> editStudent(String sessionId, int studentId, String studentName, String studentPhoneNumber, String studentGender, String studentAddress, apiToken) async {
    var postData = {
      'session_id': sessionId,
      'student_id': studentId,
      'student_name': studentName,
      'student_phone_number': studentPhoneNumber,
      'student_gender': studentGender,
      'student_address': studentAddress,
    };
    response = await postConnect(SERVER_URL+'/student/editStudent', postData, apiToken);
    if(response.data['status'] == STATUS_OK){
      return response.data['msg'];
    } else {
      throw response.data['msg'];
    }
  }

  Future<String> deleteStudent(String sessionId, int studentId, apiToken) async {
    var postData = {
      'session_id': sessionId,
      'student_id': studentId,
    };
    response = await postConnect(SERVER_URL+'/student/deleteStudent', postData, apiToken);
    if(response.data['status'] == STATUS_OK){
      return response.data['msg'];
    } else {
      throw response.data['msg'];
    }
  }

  Future<List<LoginModel>> login(String email, String password, apiToken) async {
    var postData = {
      'email': email,
      'password': password,
    };
    response = await postConnect(LOGIN_API, postData, apiToken);
    if(response.data['status'] == STATUS_OK){
      List responseList = response.data['data'];
      List<LoginModel> listData = responseList.map((f) => LoginModel.fromJson(f)).toList();
      return listData;
    } else {
      throw response.data['msg'];
    }
  }

  Future<LoginModel> loginImei(String username, String password, imei) async {
    var postData = {
      'userName': username,
      'password': password,
      'imei': imei,
    };
    response = await postConnect2(LOGIN_API, postData);
    if(response.statusCode == STATUS_OK){
      if(response.data['msg']!=null){
        throw  response.data['msg'];
      }

      LoginModel loginData=LoginModel.fromJson(response.data);
      return loginData;
    } else {
      throw response.data['msg'];
    }
  }

  Future<List<ProductGridModel>> getProductGrid(String sessionId, String skip, String limit, apiToken) async {
    var postData = {
      'session_id': sessionId,
      'skip': skip,
      'limit': limit
    };
    response = await postConnect(PRODUCT_API, postData, apiToken);
    if(response.data['status'] == STATUS_OK){
      List responseList = response.data['data'];
      //print('data : '+responseList.toString());
      List<ProductGridModel> listData = responseList.map((f) => ProductGridModel.fromJson(f)).toList();
      return listData;
    } else {
      throw response.data['msg'];
    }
  }

  Future<List<ProductListviewModel>> getProductListview(String sessionId, String skip, String limit, apiToken) async {
    var postData = {
      'session_id': sessionId,
      'skip': skip,
      'limit': limit
    };
    response = await postConnect(PRODUCT_API, postData, apiToken);
    if(response.data['status'] == STATUS_OK){
      List responseList = response.data['data'];
      //print('data : '+responseList.toString());
      List<ProductListviewModel> listData = responseList.map((f) => ProductListviewModel.fromJson(f)).toList();
      return listData;
    } else {
      throw response.data['msg'];
    }
  }


  Future<List<PropertyModel>> getPropertyListview(String first, String show, String query, apiToken) async {
    print('query: $query');
    var queryParam = {
      'first': first,
      'show': show,
      'query': query
    };
    print('queryparam: $queryParam');
    response = await getConnectJson(PROPERTY_API, queryParam, apiToken);
    if(response.statusCode == STATUS_OK){
      List responseList = response.data;
      List<PropertyModel> listData = responseList.map((f) => PropertyModel.fromJson(f)).toList();
      return listData;
    } else {
      throw response.data;
    }
  }

  Future<List<PropertyTypeListviewModel>> getTiposInmueblesViewState(
      String first,
      String show,
      String query,
      apiToken) async {
    var queryParam = {
      'first': first,
      'show': show,
      'query': query
    };
    response = await getConnectJson(PROPERTY_TYPE_API, queryParam, apiToken);
    if(response.statusCode == STATUS_OK){
      List responseList = response.data;
      // print(responseList);
      List<PropertyTypeListviewModel> listData = responseList.map((f) => PropertyTypeListviewModel.fromJson(f)).toList();
      return listData;
    } else {
      throw response.data;
    }
  }

  Future<List<PropertyTypeListviewModel>> getCamposInmueblesState(
      String first,
      String show,
      String query,
      apiToken) async {
    var queryParam = {
      'first': first,
      'show': show,
      'query': query
    };
    response = await getConnectJson(PROPERTY_TYPE_API, queryParam, apiToken);
    if(response.statusCode == STATUS_OK){
      List responseList = response.data;
      print(responseList);
      List<PropertyTypeListviewModel> listData = responseList.map((f) => PropertyTypeListviewModel.fromJson(f)).toList();
      return listData;
    } else {
      throw response.data;
    }
  }

  Future<List<String>> getDestinosState(apiToken) async {
    response = await getConnectJson(DESTINOS_TYPE_API, null, apiToken);
    if(response.statusCode == STATUS_OK){
      List responseList = response.data;
      List<String> listData = responseList.map((f) => f.toString()).toList();
      return listData;
    } else {
      throw response.data;
    }
  }

  Future<List<String>> getDepartamentosState(apiToken) async {
    response = await getConnectJson(GEO_DEPARTAMENTOS_API, null, apiToken);
    if(response.statusCode == STATUS_OK){
      List responseList = response.data;
      List<String> listData = responseList.map((f) => f.toString()).toList();
      return listData;
    } else {
      throw response.data;
    }
  }

  Future<List<String>> getCiudadesState(departamentos, apiToken) async {
    var queryParam = {
      'departamento':departamentos,
    };
    response = await getConnectJson(GEO_CIUDADES_API, queryParam, apiToken);
    if(response.statusCode == STATUS_OK){
      List responseList = response.data;
      List<String> listData = responseList.map((f) => f.toString()).toList();
      return listData;
    } else {
      throw response.data;
    }
  }

  Future<List<String>> getBarriosState(ciudad, apiToken) async {
    var queryParam = {
      'ciudad':ciudad,
    };
    response = await getConnectJson(GEO_BARRIOS_API, queryParam, apiToken);
    if(response.statusCode == STATUS_OK){
      List responseList = response.data;
      List<String> listData = responseList.map((f) => f.toString()).toList();
      return listData;
    } else {
      throw response.data;
    }
  }

  Future<List<String>> getZonasState(ciudad, apiToken) async {
    var queryParam = {
      'ciudad':ciudad,
    };
    response = await getConnectJson(GEO_ZONAS_API, queryParam, apiToken);
    if(response.statusCode == STATUS_OK){
      List responseList = response.data;
      List<String> listData = responseList.map((f) => f.toString()).toList();
      return listData;
    } else {
      throw response.data;
    }
  }

  Future <List<AlbumListModel>> getAlbum(idinmueble, apiToken) async{
    late Response _response;
    final String urlAlbum = ALBUM_API + '/' + idinmueble.toString();
    try {
      _response = await getConnectJson(urlAlbum, null, apiToken);
      print('statuscode album: ${_response.statusCode}');
      // print('response: ${response.data}');
      if(_response.statusCode == STATUS_OK){
        List responseList = _response.data;
        List<AlbumListModel> albumList = [];
        responseList.forEach((element) {
          if (element['data'] != null && element['archivo'] != null){
            albumList.add(AlbumListModel.fromJson(element));
          }
        });
        return albumList;
      }else{
        throw _response.statusCode.toString();
      }
    }catch (e){
      throw e.toString();
    }
  }

  Future<PropertyModel> getProperty(idinmueble, apiToken) async{
    final String urlProperty = GET_INMUEBLE + '/' + idinmueble.toString();
    try{
      response = await getConnectJson(urlProperty, null, apiToken);
      if (response.statusCode == STATUS_OK){
        Map<String, dynamic> data = response.data;
        PropertyModel inmueble = PropertyModel.fromJson(data.values.first);
        return inmueble;
      }else{
        throw response.data;
      }
    }catch (e){
      throw e;
    }
  }



  Future<PropertySavedModel> saveProperty(data) async{
    final String url = SAVE_INMUEBLE;
    late PropertySavedModel res;
    try{
      response = await putConnect(url, data);
      print('Saved: ${response.data}');
      if (response.statusCode == STATUS_OK){
        res = PropertySavedModel.fromJson(response.data);
        return res;
      }else{
        throw response.data;
      }
    }catch (ex){
      res = PropertySavedModel(id: null, error: ex.toString());
      return res;
    }
  }

  Future<PropertySavedModel> saveEditedProperty(data) async{
    final String url = SAVE_EDITED;
    late PropertySavedModel res;
    try{
      response = await postConnect2(url, data);
      print('Saved: ${response.data}');
      if (response.statusCode == STATUS_OK){
        res = PropertySavedModel.fromJson(response.data);
        return res;
      }else{
        throw response.data;
      }
    }catch(ex){
      res = PropertySavedModel(id: null, error: ex.toString());
      return res;
    }
  }


  Future<List<HistoricoActividadesModel>> getActividades(int idInmueble, apiToken) async{
    // idInmueble = 480;
    String urlActividades = GET_ACTIVIDADES + '/$idInmueble/list';
    try{
      response = await getConnectJson(urlActividades, null, apiToken);
      if(response.statusCode == STATUS_OK){
        print('actividades API: ${response.data}');
        List actividades = response.data;
        List<HistoricoActividadesModel> listActividades = actividades.map((e) => HistoricoActividadesModel.fromJson(e)).toList();
        return listActividades;
      }else{
        throw response.data;
      }

    }catch (ex){
      print('Exception getActividades: ${ex.toString()}');
      throw response.data;
    }
  }


  Future<List<HistoricoEstadosModel>> getEstados(int idInmueble, apiToken) async{
    // idInmueble = 16; //to test
    String urlEstados = GET_ESTADOS + '/$idInmueble/list';
    response = await getConnectJson(urlEstados, null, apiToken);
    if(response.statusCode == STATUS_OK){
      List estados = response.data;
      print('estadosAPI: ${response.data}');
      List<HistoricoEstadosModel> listEstados = estados.map((e) => HistoricoEstadosModel.fromJson(e)).toList();
      return listEstados;
    }else{
      throw response.data;
    }
  }

  Future<String> saveAlbum(data) async{
    String url = SAVE_ALBUM;
    // print('data: $data');
    Map<String, dynamic> res = Map<String, dynamic>();
    try{
      response = await putConnect(url, data);
      print('saveAlbum: ${response.data}');
      res = response.data;
      String status = res['status']??'error';
      return status;
    }catch(e){
      throw e.toString();
    }
  }

  Future<String> getBigImage(int idArchivo) async{
    final CancelToken apiToken = CancelToken();
    String url = ALBUM_ID + '/$idArchivo';
    try{
      response = await getConnectJson(url, null, apiToken);
      print('img: ${response.data}');
      String image = '';
      if(response.data['data'] != null) {
        AlbumListModel res = AlbumListModel.fromJson(response.data);
        image = res.data;
      }
      return image;
    }catch(e){
      throw '${e.toString()}';
    }
  }

}
