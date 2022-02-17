

import 'dart:convert';

import 'package:devkitflutter/config/apps/ecommerce/constant.dart';
import 'package:devkitflutter/model/integration/album_by_inmueble_model.dart';
import 'package:devkitflutter/model/integration/album_list_model.dart';
import 'package:devkitflutter/model/integration/album_to_save.dart';
import 'package:devkitflutter/model/integration/notifier_models.dart';
import 'package:devkitflutter/model/integration/property_listview_model.dart';
import 'package:devkitflutter/model/integration/property_model.dart';
import 'package:devkitflutter/network/api_provider.dart';
import 'package:devkitflutter/ui/apps/ecommerce/reusable_widget.dart';
import 'package:devkitflutter/ui/integration/api/add_details.dart';
import 'package:devkitflutter/ui/integration/api/edit_actividades.dart';
import 'package:devkitflutter/ui/integration/api/edit_details.dart';
import 'package:devkitflutter/ui/integration/api/edit_estados.dart';
import 'package:devkitflutter/ui/integration/api/edit_gallery_property.dart';
import 'package:devkitflutter/ui/integration/api/edit_property.dart';
import 'package:devkitflutter/ui/integration/api/property_listview.dart';
import 'package:devkitflutter/ui/integration/api/resumen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:devkitflutter/ui/reusable/global_function.dart';
import 'package:provider/provider.dart';

class EditPropertyPage extends StatefulWidget {
  const EditPropertyPage({Key? key, this.propertyData}) : super(key: key);
  final PropertyModel? propertyData;
  @override
  _EditPropertyPageState createState() => _EditPropertyPageState(propertyData!);
}

class _EditPropertyPageState extends State<EditPropertyPage> {
  _EditPropertyPageState(this._propertyData): super();
  PropertyModel _propertyData;
  Color blueColor = Color(0xff243972);
  int _selectedIndex=0;
  final _formKeyEditProperty = GlobalKey<FormState>();
  final _globalFunction = GlobalFunction();
  late PropertyImages propertyImages = Provider.of<PropertyImages>(context, listen: false);

  ApiProvider _apiProvider = ApiProvider();
  final CancelToken apiToken = CancelToken();
  late PageController _pageController;
  final _reusableWidget = ReusableWidget();

  @override
  void deactivate() {
    // Property.data.images64?.clear();
    // Property.data.coverImage64?.clear();
    Property.data.images.clear();
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    Property.data = _propertyData;
    getDataFromApi();
  }

  getDataFromApi() async{
    //Get Estados from API
    Property.data.estados = await _apiProvider.getEstados((Property.data.idinmueble)!, apiToken);

    //Get Actividades from API
    Property.data.actividades = await _apiProvider.getActividades(Property.data.idinmueble!, apiToken);
  }


  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _onTapped(int index){
    setState(() {
      _selectedIndex=index;
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(index){
    setState(() {
      _selectedIndex=index;
    });
  }


  @override
  Widget build(BuildContext context) {
        return WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              actions: [
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        )
                    ),
                  ),
                  onPressed: () async {
                    _saveEditedProperty();
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      Property.data.titulo.toUpperCase(),
                      style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    )
                    ),
                  ),
                  Text(
                    'Ref: ${Property.data.ref.toUpperCase()}',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      )
                  )
                ],
              ),
              bottom: _reusableWidget.bottomAppBar(),
            ),
            body: PageView(
              children: [
                EditProperty(formKey: _formKeyEditProperty),
                EditGalleryProperty(),
                EditDetailsProperty(),
                EditEstados(),
                EditActividades()
              ],
              controller: _pageController,
              onPageChanged: _onPageChanged,
            ),
            bottomNavigationBar: BottomNavigationBar(
              // iconSize: 10.0,
              selectedFontSize: 11,
              unselectedFontSize: 9,
              type: BottomNavigationBarType.fixed,
              fixedColor: blueColor,
              currentIndex: _selectedIndex,
              onTap: _onTapped,
              items: <Map<String, dynamic>>[
                {'label': 'Propiedad', 'icon': Icon(Icons.home_work_rounded)},
                {'label': 'Galería', 'icon': Icon(Icons.image)},
                {'label': 'Detalles', 'icon': Icon(Icons.article)},
                {'label': 'Estados', 'icon': Icon(Icons.fact_check)},
                {'label': 'Actividades', 'icon': Icon(Icons.inventory_outlined)},
              ].map((navigator) {
                return BottomNavigationBarItem(
                  icon: navigator['icon'],
                  label: navigator['label'].toString().toUpperCase(),
                );
              }).toList(),
            ),
          ),
        );
  }

  Future<bool>_onBackPressed() async{
    late bool response;
    if(_selectedIndex == 0){
      await  _globalFunction.confirmationOnBackPressed(context).then((value){
        response = value;
        if(value){
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PropertyListviewPage()));
          Navigator.pop(context);
        }
      });
    }else {
      _selectedIndex = 0;
      _pageController.jumpToPage(_selectedIndex);
      response = false;
    }
    return response;
  }

  _saveEditedProperty(){
    if(_formKeyEditProperty.currentState?.validate()??true){
      // Property.data.images64 = propertyImages.images64;
      // Property.data.coverImage64 = propertyImages.coverImage;
      _globalFunction.showConfirmationPrompt(context).then((value){
        if(value){
          _globalFunction.showProgressDialog(context);
          int t1 = DateTime.now().millisecondsSinceEpoch;
          _apiProvider.saveEditedProperty(jsonEncode(Property.data.toJsonEdited())).then((response){
            int t2 = DateTime.now().millisecondsSinceEpoch;
            if(response.id != null){
              PropertyImages _propertyImages = Provider.of<PropertyImages>(context, listen: false);
              _propertyImages.sortAlbumToEdit();
              saveEditedAlbum(Property.data.idinmueble!, _propertyImages.albumToEdit, _propertyImages.coverImageIndex);
                // Future.delayed(Duration(milliseconds: 2000),() async {
                //   Navigator.pop(context);
                //   _globalFunction.showSnackBar(context, msg: 'GUARDADO CON EXITO', color: Colors.green);
                //   try{
                //     PropertyModel _propertyData = await _apiProvider.getProperty(Property.data.idinmueble, apiToken);
                //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PropertyListviewPage()));
                //     Navigator.push(context, MaterialPageRoute(builder: (context) => Resumen(propertyData: _propertyData,)));
                //   }catch(e){
                //     _globalFunction.flutterToast('${e.toString()}', Colors.red);
                //   }
                // });
                String msg = 'Tiempo guardado propiedad ${t2-t1}';
                logToFile(msg);
            }else{
              Navigator.pop(context);
              String msg = response.error??'No se pudo guardar los cambios';
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      content: Text('$msg'))
              );
            }
          });
        }
      });
    }

  }

  saveEditedAlbum(int idInmueble, List<dynamic> album, int coverIndex) async {
    ApiProvider _apiProvider = ApiProvider();
    Future<void> _pop () async{
      Navigator.pop(context);
      _globalFunction.showSnackBar(context, msg: 'GUARDADO CON EXITO', color: Colors.green);
      try{
        PropertyModel _propertyData = await _apiProvider.getProperty(Property.data.idinmueble, apiToken);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PropertyListviewPage()));
        Navigator.push(context, MaterialPageRoute(builder: (context) => Resumen(propertyData: _propertyData,)));
      }catch(e){
        _globalFunction.flutterToast('${e.toString()}', Colors.red);
      }
    }

    if(album.isEmpty) {
      _pop();
      return;
    }

    AlbumToSave _albumToSave = AlbumToSave();
    _albumToSave.idInmueble = idInmueble;
    int i = 0; int _uploadedAssets = 0;
    PropertyImages _propertyImages = Provider.of<PropertyImages>(context, listen: false);
    _propertyImages.setIdInmueble = idInmueble;
    _propertyImages.setUploadedAssets = _uploadedAssets;
    _propertyImages.setTotalAssets = album.length;

    Future<void> _save() async{
      String status  = await _apiProvider.saveAlbum(jsonEncode(_albumToSave.toJson()));
      print('status: $status'); //if it fails, try once more
      if (status == 'error') await _apiProvider.saveAlbum(jsonEncode(_albumToSave.toJson()));
      _uploadedAssets ++;
      _propertyImages.setUploadedAssets = _uploadedAssets;
    }

    if (album.first.runtimeType.toString() == 'AlbumByInmuebleModel'){
      _albumToSave.archivos = [];
      _albumToSave.archivos.add(album.first);
      await _save();
      await _pop();
      i++;
    }

    //Assets
    for (;i < album.length;i++){
      _albumToSave.archivos = [];
      String _data = await getBase64(album[i]);
      _albumToSave.archivos.add(
          AlbumByInmuebleModel(
            nombre: DateTime.now().millisecondsSinceEpoch.toString() + '.${(album[i].name?.split('.').last)??'jpg'}',
            imagen: true,
            pathArchivo: '/SAI/Documentos/$idInmueble',
            principal: (coverIndex != 0 && i == 0) ? true : false,
            mimeType: 'image/${(album[i].name?.split('.').last)??'jpg'}',
            data: _data,
          )
      );
      await _save();
      if(i==0) await _pop();
    }

  }


}




class Property{
  static late PropertyModel data;
}

