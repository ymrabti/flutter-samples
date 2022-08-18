// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart' show GeoCoord, GeoCoordBounds;

extension MobileLatLngExtensions on LatLng {
  GeoCoord toGeoCoord() => GeoCoord(latitude, longitude);
}

extension MobileGeoCoordExtensions on GeoCoord {
  LatLng toLatLng() => LatLng(latitude, longitude);
}

extension MobileGeoCoordBoundsExtensions on GeoCoordBounds {
  LatLngBounds toLatLngBounds() => LatLngBounds(
        northeast: northeast.toLatLng(),
        southwest: southwest.toLatLng(),
      );

  GeoCoord get center => GeoCoord(
        (northeast.latitude + southwest.latitude) / 2,
        (northeast.longitude + southwest.longitude) / 2,
      );
}

extension MobileLatLngBoundsExtensions on LatLngBounds {
  GeoCoordBounds toGeoCoordBounds() => GeoCoordBounds(
        northeast: northeast.toGeoCoord(),
        southwest: southwest.toGeoCoord(),
      );
}
