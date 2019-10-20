import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:running/models/place.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../pages/map_screen.dart';
import '../pages/registration_page.dart';
import '../utils/style.dart';

import '../providers/location_provider.dart';

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final PlaceLocation initLocation = const PlaceLocation(
    latitude: -25.969598,
    longitude: 32.572989,
  );

  double zoom = 16;

  _zoomout() {
    print('ok');
    setState(() {
      zoom = zoom - 1;
      print('sei');
    });
    print('aahham');
  }

  final latlng = LatLng(-25.96964, 32.57309);
  BitmapDescriptor image;
  Future<BitmapDescriptor> _getAssetIcon(BuildContext context) async {
    final Completer<BitmapDescriptor> bitmapIcon =
        Completer<BitmapDescriptor>();
    final ImageConfiguration config =
        createLocalImageConfiguration(context, size: Size(48, 48));

    const AssetImage('assets/marker.png').resolve(config).addListener(
      ImageStreamListener(
        (ImageInfo image, bool sync) async {
          final ByteData bytes =
              await image.image.toByteData(format: ui.ImageByteFormat.png);
          final BitmapDescriptor bitmap =
              BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
          bitmapIcon.complete(bitmap);
        },
      ),
    );

    return await bitmapIcon.future;
  }

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _statusBarHeight = MediaQuery.of(context).padding.top;
    const double _kToolbarHeight = 56.0;
    final double _chartAnimationDuration = 0.0;
    final staticMapImageUrl =
        LocationHelper.generateLocationPreviewImage(-25.974509, 32.5732966);

    _getAssetIcon(context).then((onValue) {
      setState(() {
        image = onValue;
      });
    });

    LinearGradient _buildBackgroundGradient(BuildContext context) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        //stops: [0.2, 0.7],
        colors: [
          Colors.transparent,
          Colors.black.withOpacity(.5), //0xFF2E071B
        ],
        tileMode: TileMode.clamp,
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildTheFirstImage(_deviceHeight, _statusBarHeight,
              _buildBackgroundGradient, context),
          SizedBox(
            height: 15,
          ),
          Container(
            //color: Colors.amber,
            width: double.infinity,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Uma corrida sem igual',
                  style: AbsaStyle.headingStyle2.copyWith(
                      color: Color(
                        0xFF2d2323,
                      ),
                      fontSize: 26),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Dia 07 de Setembro de 2019 vem a Moçambique participar numa grande meia maratona pelas belas estradas de Maputo, uma prova que não vais esquecer seja a correr ou a caminhar!',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.track_changes,
                          color: Color(0xFFf52d28),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Meia Maratona - 21.0975 Km',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          color: Color(0xFFf05a78),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Corrida da Familia - 5 Km',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.people,
                          color: Color(0xFF870a3c),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Cerca de 3000 atletas',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
          Container(
            //height: 100,
            width: double.infinity,
            //color: Colors.amber,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Partida',
                  style: AbsaStyle.headingStyle2.copyWith(
                    color: Color(
                      0xFF2d2323,
                    ),
                    fontSize: 26,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'A partida dar-se-á as 08h00',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 7,
          ),
          Container(
            width: double.infinity,
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                GoogleMap(
                  //myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      initLocation.latitude,
                      initLocation.longitude,
                    ),
                    zoom: zoom,
                  ),
                  markers: {
                    Marker(
                      infoWindow: InfoWindow(title: 'Local da partida'),
                      markerId: MarkerId(
                          '${initLocation.latitude}${initLocation.longitude}'),
                      position:
                          LatLng(initLocation.latitude, initLocation.longitude),
                      //icon: image,
                    )
                  },
                ),
                /* Positioned(
                  bottom: 2,
                  right: 2,
                  child: FlatButton(
                    color: Colors.amber,
                    child: Icon(Icons.maximize),
                    onPressed: _zoomout,
                  ),
                ), */
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            //height: 100,
            width: double.infinity,
            //color: Colors.amber,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Levantamento de dorsal',
                  style: AbsaStyle.headingStyle2.copyWith(
                    color: Color(
                      0xFF2d2323,
                    ),
                    fontSize: 26,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  '20 de Outubro das 09h00 às 17h00',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  '21 de Outubro das 09h00 às 17h00',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 7,
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            child: GoogleMap(
              //myLocationEnabled: false,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  initLocation.latitude,
                  initLocation.longitude,
                ),
                zoom: zoom,
              ),
              markers: {
                Marker(
                  infoWindow:
                      InfoWindow(title: 'Local de levantamento da dorsal'),
                  markerId: MarkerId(
                      '${initLocation.latitude}${initLocation.longitude}'),
                  position:
                      LatLng(initLocation.latitude, initLocation.longitude),
                  //icon: image,
                )
              },
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Escalões',
                  style: AbsaStyle.headingStyle2.copyWith(
                    color: Color(
                      0xFF2d2323,
                    ),
                    fontSize: 26,
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/icons/man.png'),
                          color: Color(0xFF870a3c),
                          //size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Seniores (20 aos 39 anos inclusive)',
                          style: TextStyle(
                            fontSize:
                                16 * MediaQuery.of(context).textScaleFactor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Row(
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/icons/man.png'),
                          color: Color(0xFF870a3c),
                          //size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Veteranos M40 (40 aos 49 anos inclusive)',
                          style: TextStyle(
                              fontSize: 16 *
                                  MediaQuery.of(context).textScaleFactor *
                                  .9),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Row(
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/icons/man.png'),
                          color: Color(0xFF870a3c),
                          //size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Veteranos M50 (50 aos 59 anos inclusive)',
                          style: TextStyle(
                              fontSize: 16 *
                                  MediaQuery.of(context).textScaleFactor *
                                  .9),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Row(
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/icons/man.png'),
                          color: Color(0xFF870a3c),
                          //size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Veteranos M60 (60 em diante)',
                          style: TextStyle(
                              fontSize: 16 *
                                  MediaQuery.of(context).textScaleFactor *
                                  .9),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/icons/woman.png'),
                          color: Color(0xFFf05a78),
                          //size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Seniores (20 aos 39 anos inclusive)',
                          style: TextStyle(
                              fontSize: 16 *
                                  MediaQuery.of(context).textScaleFactor *
                                  .9),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Row(
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/icons/woman.png'),
                          color: Color(0xFFf05a78),
                          //size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Veteranas F40 (40 em diante)',
                          style: TextStyle(
                              fontSize: 16 *
                                  MediaQuery.of(context).textScaleFactor *
                                  .9),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Patrocinadores',
                  style: AbsaStyle.headingStyle2.copyWith(
                    color: Color(
                      0xFF2d2323,
                    ),
                    fontSize: 26,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: Text('Estão a caminho'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildTheFirstImage(
      double _deviceHeight,
      double _statusBarHeight,
      LinearGradient _buildBackgroundGradient(BuildContext context),
      BuildContext context) {
    return SizedBox(
      height: (_deviceHeight - _statusBarHeight) * .5,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/runner.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Hero(
            tag: 'nelson',
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: _buildBackgroundGradient(context),
              ),
            ),
          ),
          Positioned(
            top: 30,
            height: 60,
            width: 60,
            child: Builder(
              builder: (context) => Padding(
                padding: EdgeInsets.all(12),
                child: Image.asset('assets/absa.png'),
              ),
            ),
          ),
          Positioned(
            top: _deviceHeight * .2,
            child: Column(
              children: <Widget>[
                Text(
                  '2ª Meia Maratona',
                  textAlign: TextAlign.center,
                  style: AbsaStyle.headingStyle.copyWith(fontSize: 30),
                ),
                Text(
                  'Internacional de Maputo',
                  textAlign: TextAlign.center,
                  style: AbsaStyle.headingStyle.copyWith(fontSize: 30),
                )
              ],
            ),
          ),
          /* Positioned(
            bottom: 10,
            child: SizedBox(
              height: 40,
              width: 200,
              child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RegistrationPage.routeName);
                },
                color: Theme.of(context).primaryColor,
                child: Text(
                  'Registar-se',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ), */
        ],
      ),
    );
  }
}
