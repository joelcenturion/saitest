import 'dart:async';

import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/ui/apps/food_delivery/reusable_widget.dart';
import 'package:devkitflutter/ui/reusable/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart' as GPS;
//import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';


class MyLocation extends StatefulWidget {
  const MyLocation({Key? key, this.currentLocation}) : super(key: key);

  final LatLng? currentLocation;
  @override
  _MyLocationState createState() => _MyLocationState(currentLocation);
}


class _MyLocationState extends State<MyLocation> {

  _MyLocationState(this._currentLocation) : super();

  late String _address;
  LatLng? _currentLocation;
  GPS.Location location = GPS.Location();
  bool isLoading=true;
  final _shimmerLoading = ShimmerLoading();
  late GoogleMapController _controller;
  late LatLng _initialcameraposition;
  late Marker _marker1;
  final _reusableWidget = ReusableWidget();
  MapPickerController _mapPickerController = MapPickerController();
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    getLoc();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Navigator.pop(context, [_currentLocation, _address]);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                'Guardar',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.amberAccent),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
        backgroundColor: Color(0xff243972),
        centerTitle: true,
        title: Text('Seleccionar ubicaciÃ³n', style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          )
        ),
        bottom: _reusableWidget.bottomAppBar(),
      ),
      body: isLoading ? _shimmerLoading.buildShimmerBanner(double.infinity,MediaQuery.of(context).size.height/1.2):
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Container(
            color: Color(0xff243972).withOpacity(.8),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height:  MediaQuery.of(context).size.height/1.27,
                    width: MediaQuery.of(context).size.width,
                    child: MapPicker(
                      mapPickerController: _mapPickerController,
                      iconWidget: Icon(
                        Icons.location_pin,
                        size: 50,
                        color: Colors.red,
                      ),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(target: _initialcameraposition,
                            zoom: 15),
                        mapType: MapType.normal,
                        onMapCreated: _onMapCreated,
                        myLocationEnabled: true,
                        // markers: {_marker1},
                        mapToolbarEnabled: true,
                        zoomGesturesEnabled: true,
                        myLocationButtonEnabled: true,
                        scrollGesturesEnabled: true,
                        onCameraMove: (cameraPosition){
                          this._initialcameraposition = cameraPosition.target;
                          this._cameraPosition = cameraPosition;
                        },
                        onCameraMoveStarted: (){
                          _mapPickerController.mapMoving!();
                        },
                        onCameraIdle: () async{
                          _mapPickerController.mapFinishedMoving!();
                          _getAddress(_cameraPosition.target.latitude, _cameraPosition.target.longitude)
                              .then((value) {
                            setState(() {
                              _address = "${value.first.street}, ${value.first.locality}";
                              _currentLocation=_cameraPosition.target;
                            });
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child:SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "$_address",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child:SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "GPS: "+_currentLocation!.latitude.toString()+","+_currentLocation!.longitude.toString(),
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getLoc() async{
    bool _serviceEnabled;
    GPS.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == GPS.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != GPS.PermissionStatus.granted) {
        return;
      }
    }
    if(_currentLocation==null){
      var _currentPosition = await location.getLocation();
      _initialcameraposition = LatLng(_currentPosition.latitude??0.0,_currentPosition.longitude??0.0);
      _currentLocation=_initialcameraposition;
    }else{
      _initialcameraposition=_currentLocation!;
    }
    _marker1=Marker(
        markerId: MarkerId('1'),
        position: _initialcameraposition,
        draggable: true,
        consumeTapEvents: true,
        onDragEnd: (ltdlng){
          _getAddress(ltdlng.latitude, ltdlng.longitude)
              .then((value) {
            setState(() {
              _address = "${value.first.street}, ${value.first.locality}";
              _currentLocation=ltdlng;
            });
          });
        }
    );
    _getAddress(_currentLocation!.latitude, _currentLocation!.longitude)
        .then((value) {
      setState(() {
        _address = "${value.first.street}, ${value.first.locality}";
      });
    });
    if(isLoading)
      isLoading=false;
  }

  Future<List<Placemark>> _getAddress(double lat, double long) async {
    List<Placemark> add =
    await placemarkFromCoordinates(lat, long);

    return add;
  }

}