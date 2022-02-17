
import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/model/integration/property_model.dart';
import 'package:devkitflutter/ui/integration/api/edit_property_page.dart';
import 'package:devkitflutter/ui/integration/api/tab/edit_tab_adicionales.dart';
import 'package:devkitflutter/ui/integration/api/tab/edit_tab_caracteristicas.dart';
import 'package:devkitflutter/ui/integration/api/tab/edit_tab_direccion.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class EditDetailsProperty extends StatefulWidget  {
  const EditDetailsProperty({Key? key}):super(key: key);

  @override
  _EditDetailsPropertyState createState() => _EditDetailsPropertyState();
}

class _EditDetailsPropertyState extends State<EditDetailsProperty> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _tabIndex = 0;
  late TabBar _tabBar;
  late TabController _tabController;
  final NumberFormat nf= NumberFormat("#,###", "es_PY");

  final CancelToken apiToken = CancelToken(); // used to cancel fetch data from API
  final List<bool> isSelected=[true, false];

  List<Tab> _tabBarList = [
    Tab( text: "CARACTERISTICAS"),
    Tab( text: "ADICIONALES"),
    Tab( text: "DIRECCION"),
  ];

  List<Widget> _tabContentList = <Widget>[
    EditCaracteristicasTabPage(),
    EditAdicionalesTabPage(),
    EditDireccionTabPage(),
  ];



  @override
  void initState() {

    _tabController = TabController(vsync: this, length: _tabBarList.length,
        initialIndex: _tabIndex);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: Column(
            children: [
              Material(
                elevation: 5,
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
      body: DefaultTabController(
        length: _tabBarList.length,
        child: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: _tabContentList.map((Widget content) {
            return content;
          }).toList(),
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
                  onPressed: () {

                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      'Guardar',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.greenAccent
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
    );
  }

}
