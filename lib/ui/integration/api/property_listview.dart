// Don't forget to initialize all bloc provider at main.dart

import 'dart:convert';
import 'dart:async';
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:devkitflutter/bloc/property_listview/bloc.dart';
import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/model/integration/notifier_models.dart';
import 'package:devkitflutter/model/integration/property_model.dart';
import 'package:devkitflutter/model/integration/property_type_listview_model.dart';
import 'package:devkitflutter/network/api_provider.dart';
import 'package:devkitflutter/ui/integration/api/add_property.dart';
import 'package:devkitflutter/ui/integration/api/resumen.dart';
import 'package:devkitflutter/ui/reusable/global_function.dart';
import 'package:devkitflutter/ui/reusable/global_widget.dart';
import 'package:devkitflutter/ui/reusable/shimmer_loading.dart';
import 'package:devkitflutter/ui/screen/signin/signin2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:devkitflutter/ui/integration/api/edit_property_page.dart';
import 'package:provider/provider.dart';

class PropertyListviewPage extends StatefulWidget {
  @override
  _PropertyListviewPageState createState() => _PropertyListviewPageState();
}

class _PropertyListviewPageState extends State<PropertyListviewPage> {
  final _globalFunction = GlobalFunction();
  final _globalWidget = GlobalWidget();
  final _shimmerLoading = ShimmerLoading();
  String? _selectedTipoInmueble="Todos los inmuebles";
  TextEditingController _etSearch = TextEditingController();
  bool _showBottom=false;
  late FocusNode focusNode;
  NumberFormat nf = NumberFormat('#,###.##', 'es_PY');
  late PropertyImages _propertyImages = Provider.of<PropertyImages>(context, listen:  false);


  List<PropertyModel> propertyListViewData = [];
  List<PropertyTypeListviewModel> propertyTypeListViewData = [];
  List<String?> propertyTypeListViewDataSelected = [];

  late PropertyListviewBloc _propertyListviewBloc;
  int _apiPage = 0;
  ScrollController _scrollController = ScrollController();
  bool _lastData = false;
  bool _processApi = false;
  final int _apiLimit = 15;

  CancelToken apiToken = CancelToken(); // used to cancel fetch data from API

  @override
  void initState() {
    focusNode=FocusNode();
    // get data when initState
    _propertyListviewBloc = BlocProvider.of<PropertyListviewBloc>(context);
    _propertyListviewBloc.add(
        GetPropertyListview(
            first: _apiPage.toString(),
            show: _apiLimit.toString(),
            query: _buildQuery(),
            apiToken: apiToken));

    _getTiposInmueblesFromApi();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    apiToken.cancel("cancelled"); // cancel fetch data from API
    _scrollController.dispose();

    super.dispose();
  }

  // this function used to fetch data from API if we scroll to the bottom of the page
  void _onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll) {
      if (_lastData == false && !_processApi) {
        _propertyListviewBloc.add(
            GetPropertyListview(
                first: _apiPage.toString(),
                show: _apiLimit.toString(),
                query: _buildQuery(),
                apiToken: apiToken
            )
        );
        _processApi = true;
      }
    }
  }


  Future _getTiposInmueblesFromApi() async {
    ApiProvider _apiProvider = ApiProvider();
    _apiProvider.getTiposInmueblesViewState("0","20","",apiToken).then((response) {
      setState(() {
        propertyTypeListViewData.clear();
        propertyTypeListViewData.addAll(response);
      });
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) => Colors.grey,
        ),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          )
        ),
      ),
      child: Text("Cancelar", style: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        )
      ),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) => Colors.blueGrey,
        ),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            )
        ),
      ),
      child: Text("Confirmar",style: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        )
      ),
      onPressed:  () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Signin2Page()
            ),
                (Route<dynamic> route) => false
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      content: Text("¿Desea cerrar la sesión actual?", style: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Color(0xff243972),
        )
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('width: ${MediaQuery.of(context).size.width*MediaQuery.of(context).devicePixelRatio}');
    return Scaffold(
      appBar: AppBar(
          primary: true,
          toolbarHeight: _showBottom?kToolbarHeight*2:kToolbarHeight+5,
          centerTitle: true,
          bottomOpacity: 0.7,
          leading: IconButton(
            color:Colors.white,
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Busqueda avanzada',
            iconSize: 26,
            padding: EdgeInsets.only(top: 10),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Avanzados..'))
              );
              _getUrl();
            },
          ),
          actions: <Widget>[
            IconButton(
              color:Colors.white,
              icon: !_showBottom? Icon(Icons.search_rounded):Icon(Icons.close_rounded),
              iconSize: 26,
              tooltip: 'Buscar',
              padding: EdgeInsets.only(top: 10, left: 10),
              onPressed: () {
                setState(() {
                  _showBottom=!_showBottom;
                  if(_showBottom){
                    focusNode.requestFocus();
                  }else{
                    focusNode.unfocus();
                  }
                });
              },
            ),
            IconButton(
              color:Colors.redAccent,
              icon: const Icon(Icons.logout_sharp),
              iconSize: 22,
              tooltip: 'Cerrar sesión',
              padding: EdgeInsets.only(top: 11),
              onPressed: () {
                showAlertDialog(context);
              },
            )
          ],
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          elevation: 0,
          title: Center(
            child: DropdownButton<String>(
              iconEnabledColor: Colors.white,
              isExpanded: true,
              value: _selectedTipoInmueble,
              dropdownColor: Color(0xff243972),
              underline: SizedBox(),
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
              focusColor: Colors.white,
              items: <String>["Todos los inmuebles", "Alquiler", "Venta", "Archivados"].map((String z) {
                return DropdownMenuItem<String>(
                  value: z,
                  child: Center(
                    child:Text(z,
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (_v) {
                setState(() {
                  _selectedTipoInmueble = _v;
                });
                refreshData();
              },
            ),
          ),
          backgroundColor: Color(0xff243972),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          bottom: (_showBottom?PreferredSize(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(46, 6, 46, 6),
                  height: kToolbarHeight,
                  child: TextField(
                    controller: _etSearch,
                    focusNode: focusNode,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (textValue){
                      if(textValue != ''){
                        refreshData();
                      }
                    },
                    maxLines: 1,
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    decoration: InputDecoration(
                      prefixIcon:
                      Icon(Icons.search, color: Colors.grey[500], size: 20),
                      suffixIcon: (_etSearch.text == '')
                          ? null
                          : GestureDetector(
                          onTap: () {
                            setState(() {
                              _etSearch = TextEditingController(text: '');
                              refreshData();
                            });
                          },
                          child: Icon(Icons.close, color: Colors.grey[500], size: 20)
                      ),
                      contentPadding: EdgeInsets.all(0),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: 'Buscar por titulo, zona o ref',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ),
                ),
                Container(
                  child: MultiSelectChipField<String?>(
                    height:50,
                    decoration:BoxDecoration(
                      border: null,
                    ),
                    textStyle: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                    ),
                    selectedTextStyle: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                    ),
                    showHeader: false,
                    searchable:false,
                    items: propertyTypeListViewData.map((e) =>
                        MultiSelectItem<String?>(e.nombre, e.nombre)
                    ).toList(),
                    onTap: (values) {
                      propertyTypeListViewDataSelected = values;
                      refreshData();
                    },
                  ),
                ),
              ],
            ),
            preferredSize: Size.fromHeight(kToolbarHeight),
          ): null)
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: BlocListener<PropertyListviewBloc, PropertyListviewState>(
          listener: (context, state) {
            if(state is PropertyListviewError) {
              Fluttertoast.showToast(
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 13.0,
                  msg: state.errorMessage,
                  toastLength: Toast.LENGTH_LONG
              );
            }
            if(state is GetPropertyListviewSuccess) {
              _scrollController.addListener(_onScroll);
              if(state.propertyListviewData.length==0){
                _lastData = true;
              } else {
                _apiPage += _apiLimit;
                propertyListViewData.addAll(state.propertyListviewData);
              }
              _processApi = false;
            }
          },
          child: BlocBuilder<PropertyListviewBloc, PropertyListviewState>(
            builder: (context, state) {
              if(state is PropertyListviewError) {
                return Container(
                    child: Center(
                        child: Text('Error occured, please try again later', style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff777777)
                        )
                        )
                    )
                );
              } else {
                if(_lastData && _apiPage==0){
                  return Container(
                      child: Center(
                          child: Text('No hay datos', style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff777777)
                          ))
                      )
                  );
                } else {
                  if(propertyListViewData.length==0){
                    return _shimmerLoading.buildShimmerContent();
                  } else {
                    double _width = MediaQuery.of(context).size.width*MediaQuery.of(context).devicePixelRatio;
                    return ScrollConfiguration(
                      behavior: MyCustomScrollBehavior(),
                      // child: ListView.builder(
                      //   itemCount: (state is PropertyListviewWaiting) ? propertyListViewData.length + 1 : propertyListViewData.length,
                      //   // Add one more item for progress indicator
                      //   padding: EdgeInsets.symmetric(vertical: 5),
                      //   physics: AlwaysScrollableScrollPhysics(),
                      //   itemBuilder: (BuildContext context, int index) {
                      //     if (index == propertyListViewData.length) {
                      //       return _globalWidget.buildProgressIndicator(_lastData);
                      //     } else {
                      //       return _buildItem(index);
                      //     }
                      //   },
                      //   controller: _scrollController,
                      // ),
                      child: GridView.builder(
                        itemCount: (state is PropertyListviewWaiting) ? propertyListViewData.length + 1 : propertyListViewData.length,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == propertyListViewData.length) {
                            return _globalWidget.buildProgressIndicator(_lastData);
                          } else {
                            return _buildItem(index);
                          }
                        },
                        controller: _scrollController,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _width >=  MIN_WIDTH ?2:1,
                          childAspectRatio: _width >= MIN_WIDTH? 1: 10/9,
                        ),
                      ),
                    );
                  }
                }
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        //mini: true,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPropertyPage()));
        },
        backgroundColor: Color(0xff243972),
        icon: Center(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Icon(Icons.add, size: 20,),
                Icon(Icons.home_work_sharp, size:16),
              ]
          ),
        ),
        label: Text("Añadir propiedad", style: GoogleFonts.nunito(
          fontSize: 11,
          fontWeight: FontWeight.normal,
        ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  ImageProvider _getImage(String? pathPrincipal, String tipoInmueble){
      if(pathPrincipal==null || pathPrincipal.isEmpty){
        return AssetImage('assets/images/casa.png');
      }
      print(IMG_SERVER_URL+pathPrincipal);
      return NetworkImage(IMG_SERVER_URL+pathPrincipal);
  }


  Widget _buildItem(index){
    return Container(
      margin: EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color:
              (propertyListViewData[index].estado.compareTo('DISPONIBLE')==0? Color(0xFF49d707) :
              (propertyListViewData[index].estado.compareTo('RESERVADO')==0? Color(0xFF0EC7F0):
              (propertyListViewData[index].estado.compareTo('SEÑADO')==0? Color(0xFFFFC700):
              Color(0xFF94AFB6)
              )
              )
            ),
            width:10,
          ),
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        color: Colors.white,
        child:GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Resumen(propertyData: propertyListViewData[index],)));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image:
                DecorationImage(
                  image: _getImage(propertyListViewData[index].pathPrincipal, 'propertyListViewData[index].tipoInmueble.imagen!'),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
                ),
                color: Color(0xFFF1F3F6),
              ),
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.fromLTRB(8,5,8,5),
              height: 300,
              child: Column(
                mainAxisSize: MainAxisSize.max ,
                children: <Widget>[
                  Container(
                    height: 175,
                    margin: EdgeInsets.fromLTRB(0, 4, 4, 4),
                    child:
                    Row(
                      children: <Widget>[
                        Badge(
                          alignment: Alignment.topLeft,
                          badgeColor:
                          ((propertyListViewData[index].estado.compareTo('ALQUILADO')==0||propertyListViewData[index].estado.compareTo('VENDIDO')==0)?
                          Color(0xFF94AFB6):
                          (propertyListViewData[index].publicado?Color(0xFFeb1f39):
                          Color(0xFF49d707))
                          ),
                          elevation: 1.0,
                          position: BadgePosition.topStart(start: 0,top: 0),
                          padding: EdgeInsets.all(7),
                          child: Container(
                            width: 20.0,
                            margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                            padding: EdgeInsets.all(20),
                          ),
                        ),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.clip,
                                    text: TextSpan(
                                        style: GoogleFonts.nunito(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          color: (propertyListViewData[index].estado.compareTo('ALQUILADO')==0||propertyListViewData[index].estado.compareTo('VENDIDO')==0)? Color(0xFFB2B5BE):Color(0xFFFFFFFF),
                                        ),
                                        text: (propertyListViewData[index].titulo.isEmpty?"SIN TITULO": propertyListViewData[index].titulo.toUpperCase()
                                        + ((_propertyImages.idInmueble == propertyListViewData[index].idinmueble)? '\nImágenes subidas: ${_propertyImages.uploadedAssets}/${_propertyImages.totalAssets}' :''))
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            propertyListViewData[index].tipoInmueble.venta? Align(
                              alignment: Alignment.centerRight,
                              child: Text('  V: '+propertyListViewData[index].monedaVenta! + ' ' + nf.format(propertyListViewData[index].precioVenta),
                                  style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: propertyListViewData[index].estado.compareTo('DISPONIBLE')==0? Color(0xFF49d707):Color(
                                          0xFFB2B5BE)
                                  )
                              ),
                            ):SizedBox(),
                            propertyListViewData[index].tipoInmueble.alquiler? Align(
                              alignment: Alignment.centerRight,
                              child: Text('  A: '+propertyListViewData[index].monedaAlquiler!+ ' ' + nf.format(propertyListViewData[index].precioAlquiler!),
                                  style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: propertyListViewData[index].estado.compareTo('DISPONIBLE')==0? Color(0xFF49d707):Color(0xFFB2B5BE)
                                  )
                              ),
                            ):SizedBox(),
                          ],
                        )
                      ]
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 107,
                    child:Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(propertyListViewData[index].tipoInmueble.nombre.toUpperCase()+' EN '+(propertyListViewData[index].tipoInmueble.alquiler?'ALQUILER':'VENTA'),
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFFFFFFF)
                            )
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: RichText(
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.end,
                                  text: TextSpan(
                                    style: GoogleFonts.nunito(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFFFFFFFF)
                                    ),
                                    text: (propertyListViewData[index].zonas?.ciudades.nombre.toUpperCase()??'')+ (propertyListViewData[index].zonas?.ciudades.nombre!=null?' - ': '') +(propertyListViewData[index].zonas?.nombre.toUpperCase() ?? '')
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ]
              )
            ),
        )
      )
    );

  }

  String _buildQuery(){
    var mapQuery=Map();
    if(_selectedTipoInmueble?.compareTo("Todos los inmuebles")!=0){
      mapQuery["operacion"]=_selectedTipoInmueble!.toUpperCase();
    }
    if(_etSearch.text != ''){
      mapQuery["query"]=_etSearch.value.text;
    }
    if(propertyTypeListViewDataSelected.isNotEmpty){
      mapQuery["tipoInmueble"]=propertyTypeListViewDataSelected;
    }
    print(json.encode(mapQuery));
    return json.encode(mapQuery);
  }

  Future refreshData() async {
    setState(() {
      _apiPage = 0;
      _lastData = false;

      propertyListViewData.clear();
      _propertyListviewBloc.add(GetPropertyListview(
          first: _apiPage.toString(),
          show: _apiLimit.toString(),
          query:_buildQuery(),
          apiToken: apiToken));
    });
  }

  _getUrl() async{
    // String url = 'https://goo.gl/maps/V6ifnc9bsTb216en6';
    String url = 'https://maps.google.com/?q=Solano+Ubrique,+Enrique+Solano+L%C3%B3pez,+Asunci%C3%B3n&ftid=0x945da7cdcd32e4e7:0x8066d0328b96ff37&hl=en-US&gl=us&entry=gps&lucs=s2se&shorturl=1';
    Dio dio = Dio();
    final Response response;

    response = await dio.get(url);
    print('response: ${response.realUri}');

  }
}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    // etc.
  };
}