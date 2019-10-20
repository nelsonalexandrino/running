import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_view/photo_view.dart';

import '../models/place.dart';

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

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  BitmapDescriptor image;
  TabController tabController;

  Future<BitmapDescriptor> _getAssetIcon(BuildContext context) async {
    final Completer<BitmapDescriptor> bitmapIcon =
        Completer<BitmapDescriptor>();
    final ImageConfiguration config =
        createLocalImageConfiguration(context, size: Size(48, 48));

    const AssetImage('assets/marker.png').resolve(config).addListener(
      ImageStreamListener(
        (ImageInfo image, bool sync) async {
          final ByteData bytes =
              await image.image.toByteData(format: ImageByteFormat.png);
          final BitmapDescriptor bitmap =
              BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
          bitmapIcon.complete(bitmap);
        },
      ),
    );

    return await bitmapIcon.future;
  }

  int _selectedIndex = 0;

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: CupertinoSegmentedControl(
          //padding: EdgeInsets.all(3),
          children: {
            0: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'Meia maratona',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            1: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'Corrida familia',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          },
          onValueChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          groupValue: _selectedIndex,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return IndexedStack(
            sizing: StackFit.expand,
            index: _selectedIndex,
            children: <Widget>[
              Container(
                constraints: constraints,
                //color: Colors.amber,
                child: PhotoView(
                  imageProvider: AssetImage('assets/percurso/meia2.jpg'),
                ),
              ),
              Container(
                constraints: constraints,
                //color: Colors.pink,
                child: PhotoView(
                  imageProvider: AssetImage('assets/percurso/familia2.jpg'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(widget.runningType),
        flexibleSpace: SafeArea(
          child: TabBar(
            //labelPadding: EdgeInsets.only(top: 5),
            controller: tabController,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.track_changes),
                text: 'Meia maratona',
              ),
              Tab(
                icon: Icon(Icons.favorite),
                text: 'Corrida familia',
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraints) => Container(
              constraints: constraints,
              //color: Colors.amber,
              child: PhotoView(
                minScale: PhotoViewComputedScale.covered,
                imageProvider: AssetImage('assets/percurso/meia2.jpg'),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) => Container(
                constraints: constraints,
                //color: Colors.pink,
                child: PhotoView(
                  minScale: PhotoViewComputedScale.covered * 0.4,
                  imageProvider: AssetImage(
                    'assets/percurso/meia2.jpg',
                  ),
                )),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  WidgetBuilder androidBuilder;
  WidgetBuilder iosBuilder;

  @override
  Widget build(BuildContext context) {
    _getAssetIcon(context).then((onValue) {
      setState(() {
        image = onValue;
      });
    });

    androidBuilder = _buildAndroid;
    iosBuilder = _buildIos;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidBuilder(context);
      case TargetPlatform.iOS:
        return iosBuilder(context);
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return null;
    }
  }
}

//key: _scaffoldKey,
/*  bottomSheet: Container(
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
              : 'A partida é dada na Avenida Samora Machel (Edifício Franco Moçambicano), Avenida 25 Setembro, Rotunda do BCI, Avenida da Marginal, Retorno na Rotunda depois do Mercado do Peixe (10 Km), Avenida Marginal (Sentido Cidade), Rotunda do BCI, Avenida 25 de Setembro, Retorno na Avenida 25 de Setembro (Cruzamento de quem vem da estação dos caminhos de ferro), Avenida Samora Machel até à Meta (Edificio Franco Moçambicano).',
          textAlign: TextAlign.justify,
          style: AbsaStyle.descStyle.copyWith(
            color: Colors.black.withOpacity(.7),
          ),
        ),
      ), */

/* GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.initLocation.latitude,
                widget.initLocation.longitude,
              ),
              zoom: 16,
            ),
            markers: latlng.map((position) {
              return Marker(
                  markerId:
                      MarkerId('${position.latitude}${position.longitude}'),
                  position: position,
                  icon: image);
            }).toSet(),
          ),
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.initLocation.latitude,
                widget.initLocation.longitude,
              ),
              zoom: 16,
            ),
            markers: latlng.map((position) {
              return Marker(
                  markerId:
                      MarkerId('${position.latitude}${position.longitude}'),
                  position: position,
                  icon: image);
            }).toSet(),
          ), */
