import 'dart:convert';
import 'dart:typed_data';

import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/model/integration/album_list_model.dart';
import 'package:devkitflutter/model/integration/notifier_models.dart';
import 'package:devkitflutter/model/integration/property_model.dart';
import 'package:devkitflutter/ui/reusable/global_function.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:devkitflutter/ui/reusable/icons.dart';
import 'package:devkitflutter/network/api_provider.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'edit_property_page.dart';
import 'package:devkitflutter/ui/reusable/shimmer_loading.dart';

class Resumen extends StatefulWidget {
  final PropertyModel propertyData;
  const Resumen({Key? key, required this.propertyData}) : super(key: key);

  @override
  _ResumenState createState() => _ResumenState(propertyData);
}

class _ResumenState extends State<Resumen> {
  _ResumenState(this._propertyData):super();

  late final PropertyModel _propertyData;
  final _globalFunction = GlobalFunction();
  ApiProvider _apiProvider = ApiProvider();
  final CancelToken apiToken = CancelToken();
  final _shimmerLoading = ShimmerLoading();
  late PropertyImages _propertyImages = Provider.of<PropertyImages>(context, listen: false);

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    _getAlbum();
  }

   _getAlbum() {
    if(_propertyData.idinmueble!=null){
      _propertyImages.getAlbum((_propertyData.idinmueble)!);
    }
  }
  Future _refresh() async{
    _propertyImages.notify();
    _getAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff243972),
        title: Center(
          child: Text(
            'RESUMEN',
            style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
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
              // Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditPropertyPage(propertyData: _propertyData)));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                'Editar',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.greenAccent),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      body:  Container(
        margin: EdgeInsets.all(15),
        child: ListView(
          children: _items(),
        ),
      )
    );
}

  Widget buildGridImages(){
    double _width = MediaQuery.of(context).size.width*MediaQuery.of(context).devicePixelRatio;
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Consumer<PropertyImages>(
        builder: (context, images, child){
          if(images.album.length > 0)
          return Container(
            height: _width >= MIN_WIDTH ?400:280,
            child: ListView(
              children: [
                StaggeredGrid.count(
                  crossAxisCount: 3,
                  children: List.generate(images.album.length, (index) {
                    Uint8List _image = base64Decode(images.album[index].data);
                    return StaggeredGridTile.count(
                      crossAxisCellCount: index==0?3:1,
                      mainAxisCellCount: index==0?1.6:0.7,
                      child: GestureDetector(
                        onTap: () => _openGallery(index, images.album),
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 1.5,horizontal: 2),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: _getImage(_image),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
          else
            return Container(
                height: 279,
                child: _shimmerLoading.buildShimmerImagesResumen()
            );
        }
      ),
    );
  }

  _openGallery(int index, List<dynamic> imagesList) =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryWidget(imagesList: imagesList, index: index,)));

  ImageProvider _getImage(Uint8List? image){
    if(image==null || image.isEmpty){
      return AssetImage('assets/images/casa.png');
    }
    return MemoryImage(image);
  }

  List<Widget> _items(){
    return [
      Container(
          child: Text(
              'GALERIA',
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: SOFT_GREY,
              )
          )
      ),
      Divider(color: SOFT_GREY, height: 5, thickness: 1, indent: 5, endIndent: 5),
      buildGridImages(),
      SizedBox(height: 25),
      Container(
          child: Text(
              '${_propertyData.titulo.toUpperCase()}',
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: SOFT_GREY,
              )
          )
      ),
      SizedBox(height: 10),
      _buildIcons3(),
      SizedBox(height: 10),
      Container(
          margin: EdgeInsets.symmetric(vertical: 0),
          child: Text(
              'DESCRIPCIÓN',
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )
          )
      ),
      Divider(color: SOFT_GREY, height: 5, thickness: 0),
      SizedBox(height: 7),
      Container(
          margin: EdgeInsets.symmetric(vertical: 0),
          child: SelectableText(
              '${_propertyData.descripcion}',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.blueGrey,
              )
          )
      ),
      ElevatedButton(
        onPressed: (){},
        child: Text(
          'COMPARTIR',
          style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.normal
          )
        ),
      )
    ];
  }

  Widget _buildIcons(){
    Size screen = MediaQuery.of(context).size;
    Color _textColor = Colors.black;
    Color _iconColor = Colors.blueGrey;
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: screen.width*0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(CustomIcons.house_dollar, color: _iconColor, size: 30,),
                    _propertyData.tipoInmueble.alquiler?Text(
                      'Alq.: ${_globalFunction.formatNumber(_propertyData.precioAlquiler)} ${_propertyData.monedaAlquiler}',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: _textColor
                      )
                    ):SizedBox(),
                    _propertyData.tipoInmueble.venta?Text(
                      'Vent.: ${_globalFunction.formatNumber(_propertyData.precioVenta)} ${_propertyData.monedaVenta}',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: _textColor
                      )
                    ):SizedBox()
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              (_propertyData.dormitoriosSuite!=0 || _propertyData.dormitoriosNormales!=0 ||  _propertyData.dormitoriosPlantaBaja!=0)?
              Container(
                width: screen.width*0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.hotel, size: 30, color: _iconColor),
                    _propertyData.dormitoriosSuite!=0?Text(
                      '${_propertyData.dormitoriosSuite} Suite',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: _textColor
                        )
                    ):SizedBox(),
                    _propertyData.dormitoriosNormales!=0?Text(
                        '${_propertyData.dormitoriosNormales} Normal',
                        style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: _textColor
                        )
                    ):SizedBox(),
                    _propertyData.dormitoriosPlantaBaja!=0?Text(
                        '${_propertyData.dormitoriosPlantaBaja} Planta Baja',
                        style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: _textColor
                        )
                    ):SizedBox()
                  ],
                ),
              ):SizedBox(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    CustomIcons.house_size,
                    size: 32,
                    color: _iconColor
                  ),
                  Text(
                      '${_globalFunction.formatNumber(_propertyData.supTotal)} m2',
                      style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: _textColor
                      )
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _propertyData.piscina?Container(
                width: screen.width*0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.pool, size: 30, color: _iconColor,),
                    Text(
                        'Piscina: Sí',
                        style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: _textColor
                        )
                    ),
                  ],
                ),
              ):SizedBox(),
              _propertyData.parrilla?Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    CustomIcons.grill,
                    size: 32,
                    color: _iconColor,
                  ),
                  Text(
                      'Parrilla: Sí',
                      style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: _textColor
                      )
                  )
                ],
              ):SizedBox()
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              _propertyData.cochera?Container(
                width: screen.width*0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(CustomIcons.garage, size: 40, color: _iconColor),
                    Text(
                        '${_propertyData.cocheras} ' + (_propertyData.cocheras>1?'Cocheras':'Cochera'),
                        style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: _textColor
                        )
                    ),
                  ],
                ),
              ):SizedBox(),
              _propertyData.jardin?Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    CustomIcons.garden,
                    size: 32,
                    color: _iconColor,
                  ),
                  Text(
                      'Jardín: Sí',
                      style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: _textColor
                      )
                  )
                ],
              ):SizedBox()
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIcons2(){
    Color _textColor = Colors.black;
    Color _iconColor = Colors.blueGrey;
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1.9/1,
      shrinkWrap: true,
      crossAxisCount: 2,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(CustomIcons.house_dollar, color: _iconColor, size: 30,),
              _propertyData.tipoInmueble.alquiler?Text(
                  'Alq.: ${_globalFunction.formatNumber(_propertyData.precioAlquiler)} ${_propertyData.monedaAlquiler}',
                  style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: _textColor
                  )
              ):SizedBox(),
              _propertyData.tipoInmueble.venta?Text(
                  'Vent.: ${_globalFunction.formatNumber(_propertyData.precioVenta)} ${_propertyData.monedaVenta}',
                  style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: _textColor
                  )
              ):SizedBox()
            ],
          ),
        ),
        if((_propertyData.dormitoriosSuite!=0 || _propertyData.dormitoriosNormales!=0 ||  _propertyData.dormitoriosPlantaBaja!=0))
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.hotel, size: 30, color: _iconColor),
            _propertyData.dormitoriosSuite!=0?Text(
                '${_propertyData.dormitoriosSuite} Suite',
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: _textColor
                )
            ):SizedBox(),
            _propertyData.dormitoriosNormales!=0?Text(
                '${_propertyData.dormitoriosNormales} Normal',
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: _textColor
                )
            ):SizedBox(),
            _propertyData.dormitoriosPlantaBaja!=0?Text(
                '${_propertyData.dormitoriosPlantaBaja} Planta Baja',
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: _textColor
                )
            ):SizedBox()
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
                CustomIcons.house_size,
                size: 32,
                color: _iconColor
            ),
            Text(
                '${_globalFunction.formatNumber(_propertyData.supTotal)} m2',
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: _textColor
                )
            )
          ],
        ),
        if(_propertyData.piscina) Container(
          // width: screen.width*0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.pool, size: 30, color: _iconColor,),
              Text(
                  'Piscina: Sí',
                  style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: _textColor
                  )
              ),
            ],
          ),
        ),
        if(_propertyData.parrilla) Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              CustomIcons.grill,
              size: 32,
              color: _iconColor,
            ),
            Text(
                'Parrilla: Sí',
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: _textColor
                )
            )
          ],
        ),
        if(_propertyData.cochera)Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(CustomIcons.garage, size: 40, color: _iconColor),
              Text(
                  '${_propertyData.cocheras} ' + (_propertyData.cocheras>1?'Cocheras':'Cochera'),
                  style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: _textColor
                  )
              ),
            ],
          ),
        ),
        if(_propertyData.jardin)Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              CustomIcons.garden,
              size: 32,
              color: _iconColor,
            ),
            Text(
                'Jardín: Sí',
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: _textColor
                )
            )
          ],
        ),
      ],
    );
  }

  Widget _buildIcons3(){
    Size screen = MediaQuery.of(context).size;
    Color _textColor = Colors.black;
    Color _iconColor = Colors.blueGrey;
    return Wrap(
      runSpacing: 10,
      children: [
        Container(
          width: screen.width*0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(CustomIcons.house_dollar, color: _iconColor, size: 30,),
              _propertyData.tipoInmueble.alquiler?Text(
                  'Alq.: ${_globalFunction.formatNumber(_propertyData.precioAlquiler)} ${_propertyData.monedaAlquiler}',
                  style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: _textColor
                  )
              ):SizedBox(),
              _propertyData.tipoInmueble.venta?Text(
                  'Vent.: ${_globalFunction.formatNumber(_propertyData.precioVenta)} ${_propertyData.monedaVenta}',
                  style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: _textColor
                  )
              ):SizedBox()
            ],
          ),
        ),
        if((_propertyData.dormitoriosSuite!=0 || _propertyData.dormitoriosNormales!=0 ||  _propertyData.dormitoriosPlantaBaja!=0))
          Container(
            width: screen.width*0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.hotel, size: 30, color: _iconColor),
                _propertyData.dormitoriosSuite!=0?Text(
                    '${_propertyData.dormitoriosSuite} Suite',
                    style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: _textColor
                    )
                ):SizedBox(),
                _propertyData.dormitoriosNormales!=0?Text(
                    '${_propertyData.dormitoriosNormales} Normal',
                    style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: _textColor
                    )
                ):SizedBox(),
                _propertyData.dormitoriosPlantaBaja!=0?Text(
                    '${_propertyData.dormitoriosPlantaBaja} Planta Baja',
                    style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: _textColor
                    )
                ):SizedBox()
              ],
            ),
          ),
        Container(
          width: screen.width*0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                  CustomIcons.house_size,
                  size: 32,
                  color: _iconColor
              ),
              Text(
                  '${_globalFunction.formatNumber(_propertyData.supTotal)} m2',
                  style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: _textColor
                  )
              )
            ],
          ),
        ),
        if(_propertyData.piscina) Container(
          width: screen.width*0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.pool, size: 30, color: _iconColor,),
              Text(
                  'Piscina: Sí',
                  style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: _textColor
                  )
              ),
            ],
          ),
        ),
        if(_propertyData.parrilla) Container(
          width: screen.width*0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                CustomIcons.grill,
                size: 32,
                color: _iconColor,
              ),
              Text(
                  'Parrilla: Sí',
                  style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: _textColor
                  )
              )
            ],
          ),
        ),
        if(_propertyData.cochera)Container(
          width: screen.width*0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(CustomIcons.garage, size: 40, color: _iconColor),
              Text(
                  '${_propertyData.cocheras} ' + (_propertyData.cocheras>1?'Cocheras':'Cochera'),
                  style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: _textColor
                  )
              ),
            ],
          ),
        ),
        if(_propertyData.jardin)Container(
          width: screen.width*0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height:8),
              Icon(
                CustomIcons.garden,
                size: 32,
                color: _iconColor,
              ),
              Text(
                  'Jardín: Sí',
                  style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: _textColor
                  )
              )
            ],
          ),
        ),
      ],
    );
  }

}


class GalleryWidget extends StatefulWidget {
  final List<dynamic> imagesList;
  final int index;
  const GalleryWidget({Key? key, required this.imagesList, required this.index}) : super(key: key);

  @override
  _GalleryWidgetState createState() => _GalleryWidgetState(imagesList, index);
}

class _GalleryWidgetState extends State<GalleryWidget> {
  _GalleryWidgetState(this._imagesList, this._index):super();
  late int _index;
  late List<dynamic> _imagesList;
  late List<String?> _album;
  late PageController _pageController;
  int initialIndex=0;
  late PageChanged _pageChanged = Provider.of<PageChanged>(context, listen: false);
  int _updates = 0; //number of album updates. to update just once
  @override
  void initState() {
    super.initState();
    _pageController=PageController(initialPage: _index);
    _album = List.generate(_imagesList.length, (index) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PhotoViewGallery.builder(
          pageController: _pageController,
          itemCount: _imagesList.length,
          builder: (context, index){
            Uint8List _image = base64Decode(_imagesList[index].data);

            return PhotoViewGalleryPageOptions(
              imageProvider: (_album[index] != null && _album[index]!.isNotEmpty)?MemoryImage(base64Decode(_album[index]!)):MemoryImage(_image),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained*2,
            );
          },
          loadingBuilder: (a,b){
            return Center(child: CircularProgressIndicator());
          },
          onPageChanged: (index){
            initialIndex=1;
            _pageChanged.onPageChange = index;
            _updateAlbum(index);
          },
        ),
        Consumer<PageChanged>(
          builder: (context, page, child){
            return Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.all(16),
              child: Text(
                'Imagen ${initialIndex==0?_index+1:(page.index +1)}/${_imagesList.length}',
                style: GoogleFonts.nunito(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none
                ),
              ),
            );
          }
        ),
        SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            alignment: Alignment.topRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white12,
                shape: CircleBorder()
              ),
              onPressed: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.close, size: 30, color: Colors.white,),
            ),
          ),
        ),
      ],
    );

  }

  _updateAlbum(int index) async{
    if(_album[index] == null) {
      _updates++;
      ApiProvider _apiProvider = ApiProvider();
      String _image = await _apiProvider.getBigImage(
          _imagesList[index].archivo.idarchivos);
      if (_image.isNotEmpty) {
          if(_updates == 1){
            setState(() {
              _album[index] = _image;
              _updates = 0;
            });
          }else {
            _album[index] = _image;
            _updates--;
          }
      }else _album[index] = _image;
    }
  }

}
