/*
this is constant pages
 */

import 'package:flutter/material.dart';

const String APP_NAME = 'SAIMobile';

// color for apps
const Color PRIMARY_COLOR = Color(0xff243972);
const Color ASSENT_COLOR = Color(0xFFe75f3f);

const Color BLACK21 = Color(0xFF212121);
const Color BLACK55 = Color(0xFF555555);
const Color BLACK77 = Color(0xFF777777);
const Color SOFT_GREY = Color(0xFFaaaaaa);
const Color SOFT_BLUE = Color(0xff01aed6);

const int STATUS_OK = 200;
const int STATUS_BAD_REQUEST = 400;
const int STATUS_NOT_AUTHORIZED = 403;
const int STATUS_NOT_FOUND = 404;
const int STATUS_INTERNAL_ERROR = 500;
const int STATUS_TIMEOUT = 408;


const int LIMIT_PAGE = 8;

const String GLOBAL_URL = 'https://devkit.ijteknologi.com';
//const String GLOBAL_URL = 'http://192.168.0.4/devkit';

//const String SERVER_URL = 'http://10.0.2.2:8080/SAI/seam/resource/rest';
// const String SERVER_URL = 'http://192.168.100.59:8080/SAI/seam/resource/rest';
// const String HOST = 'propiver.bypar.com.py';
const String HOST='sai.propiver.com';
const String BASE_PATH='/SAI/seam/resource/rest';
const String SERVER_URL = 'https://'+HOST+BASE_PATH;
// const String IMG_SERVER_URL = 'https://documentos.bypar.com.py/';
const String IMG_SERVER_URL = 'https://documentos.propiver.com/';

const String LOGIN_API = SERVER_URL + "/auth/login";
const String PRODUCT_API = SERVER_URL + "/example/getProduct";
const String PROPERTY_API = SERVER_URL + "/inmuebles/list";
const String PROPERTY_TYPE_API = SERVER_URL + "/tipos-inmuebles/list";
const String DESTINOS_TYPE_API = SERVER_URL + "/inmuebles/destinos";
const String GEO_DEPARTAMENTOS_API = SERVER_URL + "/geo/departamentos";
const String GEO_BARRIOS_API = SERVER_URL + "/geo/barrios";
const String GEO_CIUDADES_API = SERVER_URL + "/geo/ciudades";
const String GEO_ZONAS_API = SERVER_URL + "/geo/zonas";
const String FIELDS_TYPE_API = SERVER_URL + "/campos/list";
const String ALBUM_API = SERVER_URL + "/album/show";
const String GET_INMUEBLE = SERVER_URL + "/inmuebles/get";
const String SAVE_INMUEBLE = SERVER_URL + "/inmuebles/save";
const String SAVE_EDITED = SERVER_URL + "/inmuebles/edit";
const String GET_ACTIVIDADES = SERVER_URL + "/actividades";
const String GET_ESTADOS = SERVER_URL + "/estados";
const String SAVE_ALBUM = SERVER_URL + "/album/save";
const String ALBUM_ID = SERVER_URL + "/album";
const int MIN_WIDTH = 1536;