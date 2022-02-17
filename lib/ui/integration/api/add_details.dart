
import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/model/integration/album_by_inmueble_model.dart';
import 'package:devkitflutter/model/integration/album_to_save.dart';
import 'package:devkitflutter/model/integration/notifier_models.dart';
import 'package:devkitflutter/model/integration/property_model.dart';
import 'package:devkitflutter/network/api_provider.dart';
import 'package:devkitflutter/ui/integration/api/property_listview.dart';
import 'package:devkitflutter/ui/integration/api/tab/tab_caracteristicas.dart';
import 'package:devkitflutter/ui/integration/api/tab/tab_direccion.dart';
import 'package:devkitflutter/ui/integration/api/tab/tab_adicionales.dart';
import 'package:devkitflutter/ui/reusable/global_function.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';


class AddDetailsPage extends StatefulWidget  {
  const AddDetailsPage({Key? key, this.propertyModel}):super(key: key);

  final PropertyModel? propertyModel;

  @override
  _AddDetailsPageState createState() => _AddDetailsPageState(propertyModel!);
}

class _AddDetailsPageState extends State<AddDetailsPage> with SingleTickerProviderStateMixin {
  _AddDetailsPageState(this._propertyModel):super();
  int _tabIndex = 0;
  late TabBar _tabBar;
  late TabController _tabController;
  final NumberFormat nf= NumberFormat("#,###", "es_PY");
  late PropertyModel _propertyModel;
  final CancelToken apiToken = CancelToken(); // used to cancel fetch data from API
  final List<bool> isSelected=[true, false];
  final _formKeyCaracteristicas = GlobalKey<FormState>();
  final _formKeyAdicionales= GlobalKey<FormState>();
  final _formKeyDireccion = GlobalKey<FormState>();
  bool saved = false;
  bool progressIndicator = false;
  final _globalFunction = GlobalFunction();
  late PropertyImages _propertyImages = Provider.of<PropertyImages>(context, listen: false);
  final navigatorKey = GlobalKey<NavigatorState>();

  List<Tab> _tabBarList = [
    Tab( text: "CARACTERISTICAS"),
    Tab( text: "ADICIONALES"),
    Tab( text: "DIRECCION"),
  ];


  @override
  void initState() {
    _tabController = TabController(vsync: this, length: _tabBarList.length,
        initialIndex: _tabIndex);
    Inmueble.data = _propertyModel;
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) => PRIMARY_COLOR,
                ),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    )
                ),
              ),
              onPressed: () {
                _saveProperty(navigatorKey);
                // buildProgressIndicator(context);
                // saveAlbum(_propertyImages.assets , _propertyImages.coverImageIndex, 573, navigatorKey);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'Guardar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.greenAccent),
                    textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          backgroundColor: Color(0xff243972),
          centerTitle: true,
          title: Column(
            children: [
              Text(
                (_propertyModel.tipoInmueble.venta&&_propertyModel.tipoInmueble.alquiler)?"VENTA/ALQUILER DE ":(_propertyModel.tipoInmueble.venta?"VENTA DE ":"ALQUILER DE ")+
                _propertyModel.tipoInmueble.nombre, style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                )
              ),
            ],
          ),
          bottom: PreferredSize(
            child: Column(
              children: [
                new Material(
                  color: Colors.white,
                  child: _tabBar = TabBar(
                    controller: _tabController,
                    onTap: (position){
                      setState(() {
                        _tabIndex = position;
                      });
                    },
                    isScrollable: true,
                    labelColor: Color(0xff243972),
                    labelStyle: TextStyle(fontSize: 14),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 4,
                    indicatorColor: Color(0xff243972),
                    unselectedLabelColor: Colors.grey,
                    automaticIndicatorColorAdjustment: true,
                    labelPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    tabs: _tabBarList,
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  height: 0.5,
                )
              ],
            ),
            preferredSize: Size.fromHeight(
              _tabBar.preferredSize.height+1
            )
          ),
        ),
        body: DefaultTabController(
          length: _tabBarList.length,
          child: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            // children: _tabContentList.map((Widget content) {
            //   return content;
            // }).toList(),
            children: [
              CaracteristicasTabPage(formKey: _formKeyCaracteristicas,),
              AdicionalesTabPage(formKey: _formKeyAdicionales,),
              DireccionTabPage(formKey: _formKeyDireccion,),
            ],
          ),
        ),//_buildForm(),
        bottomNavigationBar:
          BottomAppBar(
            color: Color(0xff243972),
            elevation: 2,
            child: Container(
              height: 75.0,
              width: double.maxFinite,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:15,
                              vertical: 3
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                    _propertyModel.titulo.toUpperCase(),
                                    style: GoogleFonts.nunito(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    )
                                ),
                              ),
                              _propertyModel.tipoInmueble.alquiler?
                              Text(
                                  "Precio del Alquiler: "+(_propertyModel.monedaAlquiler?? "")+" "+
                                      nf.format(_propertyModel.precioAlquiler),
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  )
                              ): Center(),
                              _propertyModel.tipoInmueble.venta?
                              Text(
                                  "Precio de Venta: "+(_propertyModel.monedaVenta??"")+" "+
                                      nf.format(_propertyModel.precioVenta),
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  )
                              ): Center(),
                            ],
                          )
                      )
                  ),
                  // Expanded(
                  //   flex: 0,
                  //   child:TextButton(
                  //     style: ButtonStyle(
                  //       backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  //             (Set<MaterialState> states) => PRIMARY_COLOR,
                  //       ),
                  //       overlayColor: MaterialStateProperty.all(Colors.transparent),
                  //       shape: MaterialStateProperty.all(
                  //           RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(3.0),
                  //           )
                  //       ),
                  //     ),
                  //     onPressed: () {
                  //
                  //       _saveProperty();
                  //     },
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(vertical: 5.0),
                  //       child: Text(
                  //         'Guardar',
                  //         style: TextStyle(
                  //             fontSize: 16,
                  //             color: Colors.greenAccent
                  //         ),
                  //         textAlign: TextAlign.center,
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
      ),
    );
  }

  _saveProperty(GlobalKey<NavigatorState> navigatorKey){
    ApiProvider _apiProvider = ApiProvider();
    String? incompletePage = !(_formKeyCaracteristicas.currentState?.validate()??true)?'CARACTERISTICAS':
    !(_formKeyAdicionales.currentState?.validate()??true)? 'ADICIONALES':'DIRECCION';

    if ((_formKeyCaracteristicas.currentState?.validate()??true) &&
        (_formKeyAdicionales.currentState?.validate()??true) &&
        (_formKeyDireccion.currentState?.validate()??true)
    ){
      buildProgressIndicator(context);
      int t1 = DateTime.now().millisecondsSinceEpoch;
      _apiProvider.saveProperty(jsonEncode(Inmueble.data.toJson())).then((response) {
        int t2 = DateTime.now().millisecondsSinceEpoch;
        String msg = '\nrespuesta de inmueble guardado: ${t2-t1}';
        logToFile(msg);
        if(response.id != null){
          _propertyImages.sortAssets();
          saveAlbum(_propertyImages.assets, _propertyImages.coverImageIndex, response.id!, navigatorKey);
          // Future.delayed(Duration(milliseconds: 2000),(){
          //   Navigator.pop(context);
          //   _globalFunction.showSnackBar(context, msg: 'GUARDADO CON EXITO', color: Colors.green);
          //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>PropertyListviewPage()), (route) => false);
          // });
        }else{
          Navigator.pop(context);
          String msg = response.error??'No se pudo guardar el Inmueble';
          ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  content: Text('$msg'))
          );
        }
      });

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              content: Text('Datos Incompletos en la Pestaña: $incompletePage.'))
      );
    }
  }

  buildProgressIndicator(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  saveAlbum(List<Asset> images, int coverImageIndex, int idInmueble, GlobalKey<NavigatorState> navigatorKey) async{
    ApiProvider _apiProvider = ApiProvider();
    AlbumToSave _albumToSave = AlbumToSave();
    GlobalFunction _globalFunction = GlobalFunction();
    _albumToSave.idInmueble = idInmueble;
    int index = 0; int _cantList = 1; int _uploadedAssets = 0;
    PropertyImages _propertyImages = Provider.of<PropertyImages>(context, listen: false);
    _propertyImages.setIdInmueble = idInmueble;
    _propertyImages.setUploadedAssets = _uploadedAssets;
    _propertyImages.setTotalAssets = images.length;

    void _pop(){
      _globalFunction.showSnackBar(context, msg: 'GUARDADO CON EXITO', color: Colors.green);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>PropertyListviewPage()), (route) => false);
    }

    Future<void> _save() async{
      String status  = await _apiProvider.saveAlbum(jsonEncode(_albumToSave.toJson()));
      print('status: $status'); //if it fails, try once more
      if (status == 'error') await _apiProvider.saveAlbum(jsonEncode(_albumToSave.toJson()));
      _uploadedAssets ++;
      _propertyImages.setUploadedAssets = _uploadedAssets;
    }

    while(index < images.length) {
      _albumToSave.archivos = [];
      for (int i = 0; i < _cantList; i++) {
        int _imageIndex = i + index;
        String _data = await getBase64(images[_imageIndex]);
        _albumToSave.archivos.add(AlbumByInmuebleModel(
          nombre: DateTime.now().millisecondsSinceEpoch.toString() + '.${(images[_imageIndex].name?.split('.').last)??'jpg'}',
          imagen: true,
          pathArchivo: '/SAI/Documentos/$idInmueble',
          principal: _imageIndex == 0 ? true : false,
          mimeType: 'image/${(images[_imageIndex].name?.split('.').last)??'jpg'}',
          data: _data,
        ));
      }
      await _save();
      if (index == 0){
        _pop();
      }
      index=index+_cantList;
    }

  }

}

class Inmueble{
  static late PropertyModel data;
}

