import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/style.dart';
import '../models/place.dart';
import '../models/latlng.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initLocation;
  final String runningType;
  final bool isFamily;

  const MapScreen({
    this.isFamily,
    this.initLocation = const PlaceLocation(
      latitude: -25.974509,
      longitude: 32.5732966,
    ),
    this.runningType,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  BitmapDescriptor _marker;
  GoogleMapController controller;
  List<Marker> corrdinates = [];

  @override
  void initState() {
    _createMarkerImageFromAsset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset();
    return Scaffold(
      backgroundColor: Colors.red,
      //key: _scaffoldKey,
      bottomSheet: Container(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          top: 20,
        ),
        decoration: BoxDecoration(
          //color: Color(0xFF960528),
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(13),
            topRight: Radius.circular(13),
          ),
        ),
        height: 200,
        width: double.infinity,
        child: Text(
          widget.isFamily
              ? 'A partida é dada na Avenida Samora Machel (Edificio Franco Moçambicano), Avenida 25 Setembro, Retorno na Rotunda do BCI, Avenida 25 de Setembro, Praça dos Trabalhadores (Estação dos Caminhos de Ferro), Avenida 25 de Setembro, Avenida Samora Machel até à Meta (Edificio Franco Moçambicano).'
              : 'A partida é dada na Avenida Samora Machel (Edifício Franco Moçambicano), Avenida 25 Setembro, Rotunda do BCI, Avenida da Marginal, Retorno na Rotunda depois do Mercado do Peixe (10 Km), Avenida M(Sentido Cidade), Rotunda do BCI, Avenida 25 de Setembro, Retorno na Avenida 25 de Setembro (Cruzamento de quem vem da estação dos caminhos de ferro), Avenida Samora Machel até à Meta (Edificio Franco Moçambicano).',
          textAlign: TextAlign.justify,
          style: AbsaStyle.descStyle.copyWith(
            color: Colors.black.withOpacity(.7),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(widget.runningType),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initLocation.latitude,
            widget.initLocation.longitude,
          ),
          zoom: 16,
        ),
        onMapCreated: _onMapCreated,
        markers: {
          ..._createMarker(),
        },
        //markers: _createMarker(),
      ),
    );
  }

  Future<void> _createMarkerImageFromAsset() async {
    /* if (_marker == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/marker.png',
      ).then(_updateBitmap);
    } */

    if (_marker == null) {
      final Uint8List markerIcon =
          await getBytesFromAsset('assets/marker.png', 24);
      _marker = BitmapDescriptor.fromBytes(markerIcon);
      print('está nullo');
    } else {
      print('não está nullo');
    }
  }

  void _updateBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _marker = bitmap;
      print('está a ser chamado?');
    });
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;
    });
  }

  Set<Marker> _createMarker() {
    latlng.asMap().forEach(
          (index, cordinate) => corrdinates.add(
            Marker(
              markerId: MarkerId('marker_${index.toString()}'),
              position: cordinate,
              icon: _marker,
            ),
          ),
        );

    print('ok');

    return corrdinates.toSet();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
