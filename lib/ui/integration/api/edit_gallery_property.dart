import 'dart:typed_data';


import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/model/integration/album_by_inmueble_model.dart';
import 'package:devkitflutter/model/integration/notifier_models.dart';
import 'package:devkitflutter/network/api_provider.dart';
import 'package:devkitflutter/ui/integration/api/edit_property_page.dart';
import 'package:devkitflutter/ui/reusable/shimmer_loading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:convert';
import 'package:devkitflutter/ui/integration/api/add_gallery_property.dart';
import 'package:provider/provider.dart';

class EditGalleryProperty extends StatefulWidget {
  const EditGalleryProperty({Key? key, }):super(key: key);

  @override
  _EditGalleryPropertyState createState() => _EditGalleryPropertyState();
}

class _EditGalleryPropertyState extends State<EditGalleryProperty> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  late List<Asset> images;
  final NumberFormat nf= NumberFormat("#,###", "es_PY");
  Uint8List? coverImg;
  final CancelToken apiToken = CancelToken();
  late PropertyImages _propertyImages = Provider.of<PropertyImages>(context);
  final _shimmerLoading = ShimmerLoading();

  @override
  void initState() {
    super.initState();
    images= List.empty();
  }

  // Widget buildGridView() {
  //   return GridView.count(
  //     crossAxisCount: 3,
  //     children: List.generate(images.length, (index) {
  //       Asset asset = images[index];
  //       return Card(
  //         margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
  //         borderOnForeground: true,
  //         elevation: 3,
  //         child: GestureDetector(
  //           onDoubleTap: () async {
  //             ByteData imageByte = await images[index].getByteData();
  //             setState((){
  //               coverImg = imageByte.buffer.asUint8List();
  //               indexCover=index;
  //             });
  //
  //             //Property.newCoverImage64 = await getBase64(coverImage!);
  //             //TODO: newCoverImage64
  //           },
  //           child: AssetThumb(
  //             asset: asset,
  //             width: 600,
  //             height: 600,
  //           ),
  //         ),
  //       );
  //     }),
  //   );
  // }


  // Widget buildGridImages (){
  //   return Selector<PropertyImages, List<List<dynamic>>>(
  //     selector: (context, provider) => provider.images64,
  //     builder: (_, images64, __){
  //       return GridView.count(
  //         crossAxisCount: 3,
  //         children: List.generate(images64.length, (index) {
  //           Uint8List image = base64Decode(images64[index].last);
  //           return Card(
  //             margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
  //             borderOnForeground: true,
  //             elevation: 3,
  //             child: GestureDetector(
  //               onDoubleTap: (){
  //                 indexCover=index;
  //                 propertyImages.setCoverImage = [images64[index][1], images64[index].last];
  //               },
  //               child: Image.memory(
  //                 image,
  //                 width: 600,
  //                 height: 600,
  //                 errorBuilder: (context, exception, stackTrace){
  //                   return SizedBox();
  //                 },
  //                 fit: BoxFit.fill,
  //               ),
  //             ) ,
  //           );
  //         }),
  //       );
  //     }
  //   );
  // }

  Widget buildGridImages2 (){
    return Selector<PropertyImages, List<dynamic>>(
        selector: (context, provider) => provider.album,
        builder: (_, album, __){
          return GridView.count(
            crossAxisCount: 3,
            children: List.generate(album.length, (index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                borderOnForeground: true,
                elevation: 3,
                child: GestureDetector(
                  onDoubleTap: (){
                    _propertyImages.setCoverImageIndex = index;
                    _propertyImages.setCoverImage = album[index].runtimeType.toString()=='AlbumListModel'?album[index].archivo:album[index];
                  },
                  child: Stack(
                    children: [
                      album[index].runtimeType.toString() == 'Asset'?
                      AssetThumb(asset: album[index], width: 600, height: 600)
                      :Image.memory(
                        base64Decode(album[index].data),
                        width: 600,
                        height: 600,
                        errorBuilder: (context, exception, stackTrace){
                          return SizedBox();
                        },
                        fit: BoxFit.fill,
                      ),
                      index==_propertyImages.coverImageIndex? Container(
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.star, color: Colors.amber,),
                      ):SizedBox(),
                    ],
                  ),
                ) ,
              );
            }),
          );
        }
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
    _propertyImages.addImages = images;
    _propertyImages.addAssets = images;
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width*MediaQuery.of(context).devicePixelRatio;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body:Container(
            width: double.infinity,//MediaQuery.of(context).size.width,
            child:Column(
              mainAxisAlignment:MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                    width: _width >= MIN_WIDTH ?300:200,
                    height: _width >= MIN_WIDTH ?300:200,
                    key: UniqueKey(),
                    // margin: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.amber),
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    ),
                    child: Selector<PropertyImages, dynamic>(
                      selector: (context, provider) => provider.coverImage,
                      builder: (_, coverImage, __){
                        return coverImage!=null? (coverImage.runtimeType.toString()=='Asset'?
                        AssetThumb(asset: coverImage, width: 600, height: 600):
                        Image.memory(
                          base64Decode(coverImage.data!) , width: 150, height: 150,
                          errorBuilder: (context, exception, stackTrace){
                            return SizedBox();
                          },
                          fit: BoxFit.cover,
                        ))
                          :_shimmerLoading.buildShimmerCoverImage();
                      },
                    )
                ),
                // Padding(
                //     padding: new EdgeInsets.all(75.0),
                //     child:Center(
                //         child:Align(
                //             alignment: Alignment.center,
                //             child:Text(
                //               images.isNotEmpty || propertyImages.list.isNotEmpty?"Doble tap para seleccionar la portada..":"", textAlign: TextAlign.center,
                //             )
                //         )
                //     )
                // ),
                Divider(
                    color: Colors.amber
                ),
                (images.isNotEmpty || _propertyImages.album.isNotEmpty)?
                Flexible(child: buildGridImages2())
                : _shimmerLoading.buildShimmerEditGallery(),
                // Padding(
                //     padding: new EdgeInsets.all(75.0),
                //     child:Center(
                //         child:Align(
                //             alignment: Alignment.center,
                //             child:Text(
                //               "Debe seleccionar imagenes..", textAlign: TextAlign.center,
                //             )
                //         )
                //     )
                // ),
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
                              SingleChildScrollView (
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                    Property.data.titulo.toUpperCase(),
                                    style: GoogleFonts.nunito(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    )
                                ),
                              ),
                              Property.data.tipoInmueble.alquiler?
                              Text(
                                  "Precio del Alquiler: "+(Property.data.monedaAlquiler!)+" "+
                                      nf.format(Property.data.precioAlquiler),
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  )
                              ): Center(),
                              Property.data.tipoInmueble.venta?
                              Text(
                                  "Precio de Venta: "+(Property.data.monedaVenta!)+" "+
                                      nf.format(Property.data.precioVenta),
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
                ],
              ),
            ),
          ),
        )
    );

  }

  Future<bool> _onBackPressed() async {
    // Navigator.pop(
    //     context,{images, coverImage,indexCover, });
    return true;
  }

  buildProgressDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
