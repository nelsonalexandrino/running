import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:after_layout/after_layout.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initLocation;
  final String runningType;

  const MapScreen({
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
    with AfterLayoutMixin<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  VoidCallback _showBottomSheetCallback;

  @override
  void afterFirstLayout(BuildContext context) {
    //_showBottomSheetCallback();
  }

  _showModal() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
            height: 200,
            width: double.infinity,
          );
        });
  }

  @override
  void initState() {
    _showBottomSheetCallback = _showBottomSheet;
    super.initState();
  }

  void _showBottomSheet() {
    setState(() {
      // disable the button
      _showBottomSheetCallback = null;
    });
    _scaffoldKey.currentState
        .showBottomSheet<void>((
          BuildContext context, {
          backgroundColor: Colors.transparent,
        }) {
          return Container(
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Color(0xFF640032),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Text(
              'This is a Material persistent bottom sheet. Drag downwards to dismiss it.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontSize: 24.0,
              ),
            ),
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showBottomSheetCallback = _showBottomSheet;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      bottomSheet: Container(
        height: 200,
        color: Colors.amber,
        width: double.infinity,
      ),
      appBar: AppBar(
        title: Text(widget.runningType),
        actions: <Widget>[
          IconButton(
            disabledColor: Colors.white70,
            icon: Icon(Icons.info),
            onPressed: () {}, //_showBottomSheetCallback
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initLocation.latitude,
            widget.initLocation.longitude,
          ),
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: MarkerId('AB1'),
            position: LatLng(
              widget.initLocation.latitude,
              widget.initLocation.longitude,
            ),
          )
        },
      ),
    );
  }
}
