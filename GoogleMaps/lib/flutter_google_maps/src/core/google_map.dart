// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'package:google_directions_api/google_directions_api.dart' show GeoCoord, DirectionsService;

import 'map_items.dart';
import 'map_operations.dart';
import 'map_preferences.dart';

import 'google_map.state.dart'
    if (dart.library.html) '../web/google_map.state.dart'
    if (dart.library.io) '../mobile/google_map.state.dart';

/// This widget will try to occupy all available space
class GoogleMap extends StatefulWidget {
  /// Creates an instance of [GoogleMap].
  const GoogleMap({
    Key? key,
    required this.minZoom,
    required this.maxZoom,
    required this.mapStyle,
    this.markers = const <Marker>{},
    required this.onTap,
    required this.onLongPress,
    this.interactive = true,
    this.initialZoom = _zoom,
    this.mapType = MapType.roadmap,
    this.initialPosition = const GeoCoord(_defaultLat, _defaultLng),
    this.mobilePreferences = const MobileMapPreferences(),
    this.webPreferences = const WebMapPreferences(),
  }) : super(key: key);

  /// The initial position of the map's camera.
  final GeoCoord initialPosition;

  /// The initial zoom of the map's camera.
  final double initialZoom;

  /// Type of map tiles to be rendered.
  final MapType mapType;

  /// The preferred minimum zoom level or null, if unbounded from below.
  final double minZoom;

  /// The preferred maximum zoom level or null, if unbounded from above.
  final double maxZoom;

  final String mapStyle;

  /// Defines whether map is interactive or not.
  final bool interactive;

  /// Called every time a [GoogleMap] is tapped.
  final ValueChanged<GeoCoord> onTap;

  /// Markers to be placed on the map.
  final Set<Marker> markers;

  /// Called every time a [GoogleMap] is long pressed.
  ///
  /// For `web` this will be called when `right mouse clicked`.
  final ValueChanged<GeoCoord> onLongPress;

  /// Set of mobile map preferences.
  final MobileMapPreferences mobilePreferences;

  /// Set of web map preferences.
  final WebMapPreferences webPreferences;

  static const _zoom = 12.0;
  static const _defaultLat = 34.0469058;
  static const _defaultLng = -118.3503948;

  /// Gets [MapOperations] interface via provided `key` of
  /// [GoogleMapStateBase] state.
  static GoogleMapStateBase? of(GlobalKey<GoogleMapStateBase> key) {
    return key.currentState;
  }

  /// Initializer of [GoogleMap].
  ///
  /// `Required` if `Directions API` will be needed.
  /// For other cases, could be ignored.
  static void init(String apiKey) => DirectionsService.init(apiKey);

  @override
  GoogleMapState createState() => GoogleMapState();
}

abstract class GoogleMapStateBase extends State<GoogleMap> implements MapOperations {
  @protected
  String fixAssetPath(String icon) =>
      icon.endsWith('/marker_a.png') || icon.endsWith('/marker_b.png')
          ? 'packages/flutter_google_maps/'
          : '';
}
