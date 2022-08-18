import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmagest/EspaceClient/components/ma_pharmacie/page_01/flutter_googlemaps/lite_mode.dart';
import 'flutter_googlemaps/animate_camera.dart';
import 'flutter_googlemaps/lite_mode.dart';
import 'flutter_googlemaps/map_click.dart';
import 'flutter_googlemaps/map_coordinates.dart';
import 'flutter_googlemaps/map_ui.dart';
import 'flutter_googlemaps/marker_icons.dart';
import 'flutter_googlemaps/move_camera.dart';
import 'flutter_googlemaps/padding.dart';
import 'page.dart';
import 'flutter_googlemaps/place_circle.dart';
import 'flutter_googlemaps/place_marker.dart';
import 'flutter_googlemaps/place_polygon.dart';
import 'flutter_googlemaps/place_polyline.dart';
import 'flutter_googlemaps/scrolling_map.dart';
import 'flutter_googlemaps/snapshot.dart';
import 'flutter_googlemaps/tile_overlay.dart';

final List<GoogleMapExampleAppPage> allPages = <GoogleMapExampleAppPage>[
  const MapUiPage(),
  const MapCoordinatesPage(),
  const MapClickPage(),
  const AnimateCameraPage(),
  const MoveCameraPage(),
  const PlaceMarkerPage(),
  const MarkerIconsPage(),
  const ScrollingMapPage(),
  const PlacePolylinePage(),
  const PlacePolygonPage(),
  const PlaceCirclePage(),
  const PaddingPage(),
  const SnapshotPage(),
  const LiteModePage(),
  const TileOverlayPage(),
];

/// MapsDemo is the Main Application.
class MapsDemo extends StatelessWidget {
  /// Default Constructor
  const MapsDemo({Key? key}) : super(key: key);

  void _pushPage(BuildContext context, GoogleMapExampleAppPage page) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GoogleMaps examples')),
      body: ListView.builder(
        itemCount: allPages.length,
        itemBuilder: (_, int index) => ListTile(
          leading: allPages[index].leading,
          title: Text(allPages[index].title),
          onTap: () => _pushPage(context, allPages[index]),
        ),
      ),
    );
  }
}

class GoogleMapsFlutter extends StatefulWidget {
  const GoogleMapsFlutter({Key? key}) : super(key: key);

  @override
  State<GoogleMapsFlutter> createState() => GoogleMapsFlutterState();
}

class GoogleMapsFlutterState extends State<GoogleMapsFlutter> {
  final Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _kLake = const CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    CameraPosition _kGooglePlex = const CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962),
      zoom: 14.4746,
    );

    return GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  Future<void> goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
