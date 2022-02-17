import 'dart:typed_data';

import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/model/integration/notifier_models.dart';
import 'package:devkitflutter/model/integration/property_model.dart';
import 'package:devkitflutter/ui/apps/ecommerce/reusable_widget.dart';
import 'package:devkitflutter/ui/integration/api/add_details.dart';
import 'package:devkitflutter/ui/integration/api/edit_property_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:convert' as convert;

import 'package:provider/provider.dart';

class AddGalleryWidget extends StatefulWidget {
  const AddGalleryWidget({Key? key, this.propertyModel}):super(key: key);
  final PropertyModel? propertyModel;
  @override
  _AddGalleryWidgetState createState() => _AddGalleryWidgetState(propertyModel!);
}

class _AddGalleryWidgetState extends State<AddGalleryWidget> {
  _AddGalleryWidgetState(this._propertyModel):super();
  late PropertyModel _propertyModel;
  late List<Asset> images;
  Asset? coverImage;
  int coverImageIndex=0;
  final NumberFormat nf= NumberFormat("#,###", "es_PY");
  final _reusableWidget = ReusableWidget();
  late PropertyImages _propertyImages = Provider.of<PropertyImages>(context, listen: false);

  @override
  void initState() {
    images=_propertyModel.images;
    coverImageIndex=_propertyModel.coverImageIndex;
    coverImage=_propertyModel.coverImage;
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
          borderOnForeground: true,
          elevation: 3,
          child: GestureDetector(
            onDoubleTap: () {
              setState((){
                coverImage=images[index];
                coverImageIndex=index;
                _propertyImages.setCoverImageIndex = index;
              });
            },
            child: Stack(
              children: [
                AssetThumb(
                  asset: asset,
                  width: 600,
                  height: 600,
                ),
                index==_propertyImages.coverImageIndex? Container(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.star, color: Colors.amber,),
                ):SizedBox(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 100,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#243972",
          actionBarTitle: "Seleccionados",
          allViewTitle: "Todas las imagenes",
          useDetailsView: false,
          selectCircleStrokeColor: "#aaaaaa",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
    });
    _propertyImages.addAssets = images;
  }

  bool coverImg = false;
  getCoverImg(){
    Timer(Duration(milliseconds: 500),(){
      setState((){
        coverImage = _propertyModel.coverImage;
      });
      coverImg = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(!coverImg){
      getCoverImg();
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading:  new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              _onBackPressed();
            },
          ),
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
              onPressed: _navigateToDetails,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'Siguiente',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.amberAccent
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          backgroundColor: Color(0xff243972),
          centerTitle: true,
          title: Column(children:[
            Text(
            (_propertyModel.tipoInmueble.venta&&_propertyModel.tipoInmueble.alquiler)?
              "VENTA/ALQUILER DE ":
              (_propertyModel.tipoInmueble.venta?
                "VENTA DE ":
                  "ALQUILER DE "
              )+
              _propertyModel.tipoInmueble.nombre,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                )
            ),
            Text('Agregar Imagenes',
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              )
            ),
          ]),
          bottom: _reusableWidget.bottomAppBar(),
        ),
        body:Container(
          width: double.infinity,//MediaQuery.of(context).size.width,
          child:Column(
            mainAxisAlignment:MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              coverImage!=null?
                Container(
                  width: 200,
                  height: 200,
                  key: UniqueKey(),
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber),
                    borderRadius: BorderRadius.all(Radius.circular(3))
                  ),
                  child: AssetThumb(
                    key: UniqueKey(),
                    asset: coverImage!,
                    width: 300,
                    height: 300,
                  )
                )
              :Padding(
                padding: new EdgeInsets.all(75.0),
                child:Center(
                  child:Align(
                    alignment: Alignment.center,
                    child:Text(
                      images.isNotEmpty?"Doble tap en una imagen para seleccionar como portada..":"", textAlign: TextAlign.center,
                    )
                  )
                )
              ),
              Divider(
                color: Colors.amber
              ),
              images.isNotEmpty?
              Expanded(
                child: buildGridView(),
              ):Padding(
                  padding: new EdgeInsets.all(75.0),
                  child:Center(
                      child:Align(
                          alignment: Alignment.center,
                          child:Text(
                            "Debe seleccionar imagenes..", textAlign: TextAlign.center,
                          )
                      )
                  )
              ),

            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          //mini: true,
          onPressed: loadAssets,
          backgroundColor: Color(0xff243972),
          icon: Center(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Icon(Icons.add, size: 20,),
                  Icon(Icons.image, size:16),
                ]
            ),
          ),
          label: Text("Seleccionar imagenes", style: GoogleFonts.nunito(
            fontSize: 11,
            fontWeight: FontWeight.normal,
          ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                              "Precio del Alquiler: "+(_propertyModel.monedaAlquiler??"")+" "+
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
                  Expanded(
                    flex: 0,
                    child:TextButton(
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
                      onPressed: _navigateToDetails,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          'Siguiente',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.amberAccent
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      );
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(
        context,{images, coverImage,coverImageIndex});
    return true;
  }

  _navigateToDetails() async {
      if(coverImage!=null && images.isNotEmpty){
        _propertyModel.images=images;
        // _propertyModel.images64 = await getBase64List(images);
        _propertyModel.coverImageIndex = coverImageIndex;
        _propertyModel.coverImage=coverImage;
        // _propertyModel.coverImage64= await getBase64(coverImage!);
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => AddDetailsPage(propertyModel: _propertyModel, )
            )
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            width: 300,
            content: Text("Debe seleccionar una imagen de portada",
              style: TextStyle(
                  color: Colors.white
              ),
            )
        )
        );
      }
    }

}

Future<List<List<dynamic>>> getBase64List(List<Asset> images) async{
  final  images64 = List.generate(images.length, (i) => [null,'','']);
  ByteData imageByte;
  int i=0;
  for(Asset image in images) {
    imageByte = await image.getByteData(quality: 30);
    images64[i][1] = images[i].name!.split('.').last;
    images64[i][2] = convert.base64Encode(imageByte.buffer.asUint8List());
    // print('images: ${images64}');
    i++;
  }
  // print('compare: ${images64[0][2]!.compareTo((images64[1][2])!)}');
  return images64;
}

Future<List<String>> getBase64(Asset coverImage) async{
  List<String> coverImage64 = ['',''];
  ByteData imageByte;
  imageByte = await coverImage.getByteData(quality: 30);
  coverImage64[0]= coverImage.name!.split('.').last;
  coverImage64[1] = convert.base64Encode(imageByte.buffer.asUint8List());
  return coverImage64;
}
