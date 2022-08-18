// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:flinq/flinq.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart';

import 'utils.dart';
import '../core/utils.dart' as utils;
import '../core/google_map.dart' as gmap;
import '../core/map_items.dart' as items;

class GoogleMapState extends gmap.GoogleMapStateBase {
  final directionsService = DirectionsService();

  final _markers = <String, Marker>{};
  final _polygons = <String, Polygon>{};
  final _circles = <String, Circle>{};
  final _polylines = <String, Polyline>{};
  final _directionMarkerCoords = <GeoCoord, dynamic>{};

  final _waitUntilReadyCompleter = Completer<void>();

  late GoogleMapController? _controller;

  void _setState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    } else {
      fn();
    }
  }

  FutureOr<BitmapDescriptor> _getBmpDesc(String image) async {
    // if (image == null) return BitmapDescriptor.defaultMarker;

    if (utils.ByteString.isByteString(image)) {
      return BitmapDescriptor.fromBytes(utils.ByteString.fromString(image));
    }

    return await BitmapDescriptor.fromAssetImage(
      createLocalImageConfiguration(context),
      image,
    );
  }

  @override
  void moveCameraBounds(
    GeoCoordBounds newBounds, {
    double padding = 0,
    bool animated = true,
    bool waitUntilReady = true,
  }) async {
    assert(() {
      /* if (newBounds == null) {
        throw ArgumentError.notNull('newBounds');
      } */

      return true;
    }());

    if (waitUntilReady == true) {
      await _waitUntilReadyCompleter.future;
    }

    if (animated == true) {
      await _controller!.animateCamera(CameraUpdate.newLatLngBounds(
        newBounds.toLatLngBounds(),
        padding,
      ));
    } else {
      await _controller!.moveCamera(CameraUpdate.newLatLngBounds(
        newBounds.toLatLngBounds(),
        padding,
      ));
    }
  }

  @override
  void moveCamera(
    GeoCoord latLng, {
    bool animated = true,
    bool waitUntilReady = true,
    double? zoom,
  }) async {
    assert(() {
      /* if (latLng == null) {
        throw ArgumentError.notNull('latLng');
      } */

      return true;
    }());

    if (waitUntilReady == true) {
      await _waitUntilReadyCompleter.future;
    }

    if (animated == true) {
      await _controller!.animateCamera(CameraUpdate.newLatLngZoom(
        latLng.toLatLng(),
        zoom ?? await _controller!.getZoomLevel(),
      ));
    } else {
      await _controller!.moveCamera(CameraUpdate.newLatLngZoom(
        latLng.toLatLng(),
        zoom ?? await _controller!.getZoomLevel(),
      ));
    }
  }

  @override
  void zoomCamera(
    double zoom, {
    bool animated = true,
    bool waitUntilReady = true,
  }) async {
    assert(() {
      /* if (zoom == null) {
        throw ArgumentError.notNull('zoom');
      } */

      return true;
    }());

    if (waitUntilReady == true) {
      await _waitUntilReadyCompleter.future;
    }

    if (animated == true) {
      await _controller!.animateCamera(CameraUpdate.zoomTo(zoom));
    } else {
      await _controller!.moveCamera(CameraUpdate.zoomTo(zoom));
    }
  }

  @override
  FutureOr<GeoCoord> get center async =>
      (await _controller!.getVisibleRegion()).toGeoCoordBounds().center;

  @override
  void changeMapStyle(
    String mapStyle, {
    bool waitUntilReady = true,
  }) async {
    if (waitUntilReady == true) {
      await _waitUntilReadyCompleter.future;
    }
    try {
      await _controller!.setMapStyle(mapStyle);
    } on MapStyleException catch (e) {
      throw utils.MapStyleException(e.cause);
    }
  }

  @override
  void addMarkerRaw(
    GeoCoord position, {
    String? label,
    String? icon,
    String? info,
    String? infoSnippet,
    ValueChanged<String>? onTap,
    VoidCallback? onInfoWindowTap,
  }) async {
    assert(() {
      /* if (position == null) {
        throw ArgumentError.notNull('position');
      }

      if (position.longitude == null) {
        throw ArgumentError.notNull('position.latitude && position.longitude');
      } */

      return true;
    }());

    final key = position.toString();

    if (_markers.containsKey(key)) return;

    final markerId = MarkerId(key);
    final marker = Marker(
      markerId: markerId,
      onTap: onTap != null ? () => onTap(key) : null,
      consumeTapEvents: onTap != null,
      position: position.toLatLng(),
      icon: icon == null
          ? BitmapDescriptor.defaultMarker
          : await _getBmpDesc('${fixAssetPath(icon)}$icon'),
      infoWindow: InfoWindow(
        title: info ?? 'null',
        snippet: infoSnippet,
        onTap: onInfoWindowTap,
      ),
    );

    _setState(() => _markers[key] = marker);
  }

  @override
  void addMarker(items.Marker marker) => addMarkerRaw(
        marker.position,
        label: marker.label,
        icon: marker.icon,
        info: marker.info,
        infoSnippet: marker.infoSnippet,
        onTap: marker.onTap,
        onInfoWindowTap: marker.onInfoWindowTap,
      );

  @override
  void removeMarker(GeoCoord position) {
    assert(() {
      /* if (position == null) {
        throw ArgumentError.notNull('position');
      }

      if (position.longitude == null) {
        throw ArgumentError.notNull('position.latitude && position.longitude');
      } */

      return true;
    }());

    final key = position.toString();

    if (!_markers.containsKey(key)) return;

    _setState(() => _markers.remove(key));
  }

  @override
  void clearMarkers() => _setState(() => _markers.clear());

  @override
  void addDirection(
    dynamic origin,
    dynamic destination, {
    String? startLabel,
    String? startIcon,
    String? startInfo,
    String? endLabel,
    String? endIcon,
    String? endInfo,
  }) {
    assert(() {
      if (origin == null) {
        throw ArgumentError.notNull('origin');
      }

      if (destination == null) {
        throw ArgumentError.notNull('destination');
      }

      return true;
    }());

    final request = DirectionsRequest(
      origin: origin is GeoCoord ? LatLng(origin.latitude, origin.longitude) : origin,
      destination: destination is GeoCoord ? destination.toLatLng() : destination,
      travelMode: TravelMode.driving,
    );
    directionsService.route(
      request,
      (response, status) {
        if (status == DirectionsStatus.ok) {
          final key = '${origin}_$destination';

          if (_polylines.containsKey(key)) return;

          moveCameraBounds(
            response.routes?.firstOrNull?.bounds ??
                GeoCoordBounds(
                  southwest: const GeoCoord(0, 0),
                  northeast: const GeoCoord(0, 0),
                ),
            padding: 80,
          );

          final leg = response.routes?.firstOrNull?.legs?.firstOrNull;

          final startLatLng = leg?.startLocation;
          if (startLatLng != null) {
            _directionMarkerCoords[startLatLng] = origin;
            if (startIcon != null || startInfo != null || startLabel != null) {
              addMarkerRaw(
                startLatLng,
                icon: startIcon ?? 'assets/images/marker_a.png',
                info: startInfo ?? leg!.startAddress,
                label: startLabel,
              );
            } else {
              addMarkerRaw(
                startLatLng,
                icon: 'assets/images/marker_a.png',
                info: leg!.startAddress,
              );
            }
          }

          final endLatLng = leg?.endLocation;
          if (endLatLng != null) {
            _directionMarkerCoords[endLatLng] = destination;
            if (endIcon != null || endInfo != null || endLabel != null) {
              addMarkerRaw(
                endLatLng,
                icon: endIcon ?? 'assets/images/marker_b.png',
                info: endInfo ?? leg!.endAddress,
                label: endLabel,
              );
            } else {
              addMarkerRaw(
                endLatLng,
                icon: 'assets/images/marker_b.png',
                info: leg!.endAddress,
              );
            }
          }

          final polylineId = PolylineId(key);
          final polyline = Polyline(
            polylineId: polylineId,
            points: response.routes?.firstOrNull?.overviewPath?.mapList((_) => _.toLatLng()) ??
                [
                  startLatLng?.toLatLng() ?? const LatLng(0, 0),
                  endLatLng?.toLatLng() ?? const LatLng(0, 0),
                ],
            color: const Color(0xcc2196F3),
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            width: 8,
          );

          _setState(() => _polylines[key] = polyline);
        }
      },
    );
  }

  @override
  void removeDirection(dynamic origin, dynamic destination) {
    assert(() {
      if (origin == null) {
        throw ArgumentError.notNull('origin');
      }

      if (destination == null) {
        throw ArgumentError.notNull('destination');
      }

      return true;
    }());

    var value = _polylines.remove('${origin}_$destination');
    final start = value?.points.firstOrNull?.toGeoCoord();
    if (start != null) {
      removeMarker(start);
      _directionMarkerCoords.remove(start);
    }
    final end = value?.points.lastOrNull?.toGeoCoord();
    if (end != null) {
      removeMarker(end);
      _directionMarkerCoords.remove(end);
    }
    value = null;
  }

  @override
  void clearDirections() {
    for (var polyline in _polylines.values) {
      final start = polyline.points.firstOrNull?.toGeoCoord();
      if (start != null) {
        removeMarker(start);
        _directionMarkerCoords.remove(start);
      }
      final end = polyline.points.lastOrNull?.toGeoCoord();
      if (end != null) {
        removeMarker(end);
        _directionMarkerCoords.remove(end);
      }
      //   polyline = null;
    }
    _polylines.clear();
  }

  @override
  void addPolygon(
    String id,
    Iterable<GeoCoord> points, {
    ValueChanged<String>? onTap,
    Color strokeColor = const Color(0xFF000000),
    double strokeOpacity = 0.8,
    double strokeWidth = 1,
    Color fillColor = const Color(0xFF000000),
    double fillOpacity = 0.35,
  }) {
    assert(() {
      /* if (id == null) {
        throw ArgumentError.notNull('id');
      }

      if (points == null) {
        throw ArgumentError.notNull('position');
      } */

      if (points.isEmpty) {
        throw ArgumentError.value(<GeoCoord>[], 'points');
      }

      if (points.length < 3) {
        throw ArgumentError('Polygon must have at least 3 coordinates');
      }

      return true;
    }());

    _polygons.putIfAbsent(
      id,
      () => Polygon(
        polygonId: PolygonId(id),
        points: points.mapList((_) => _.toLatLng()),
        consumeTapEvents: onTap != null,
        onTap: onTap != null ? () => onTap(id) : null,
        strokeWidth: strokeWidth.toInt(),
        strokeColor: (strokeColor).withOpacity(strokeOpacity),
        fillColor: (fillColor).withOpacity(fillOpacity),
      ),
    );
  }

  @override
  void editPolygon(
    String id,
    Iterable<GeoCoord> points, {
    ValueChanged<String>? onTap,
    Color strokeColor = const Color(0xFF000000),
    double strokeOpacity = 0.8,
    double strokeWeight = 1,
    Color fillColor = const Color(0xFF000000),
    double fillOpacity = 0.35,
  }) {
    removePolygon(id);
    addPolygon(
      id,
      points,
      onTap: onTap,
      strokeColor: strokeColor,
      strokeOpacity: strokeOpacity,
      strokeWidth: strokeWeight,
      fillColor: fillColor,
      fillOpacity: fillOpacity,
    );
  }

  @override
  void removePolygon(String id) {
    assert(() {
      /* if (id == null) {
        throw ArgumentError.notNull('id');
      } */

      return true;
    }());

    if (!_polygons.containsKey(id)) return;

    _setState(() => _polygons.remove(id));
  }

  @override
  void clearPolygons() => _setState(() => _polygons.clear());

  @override
  void addCircle(
    String id,
    GeoCoord center,
    double radius, {
    ValueChanged<String>? onTap,
    Color strokeColor = const Color(0xFF000000),
    double strokeOpacity = 0.8,
    double strokeWidth = 1,
    Color fillColor = const Color(0xFF000000),
    double fillOpacity = 0.35,
  }) {
    assert(() {
      /* if (id == null) {
        throw ArgumentError.notNull('id');
      }

      if (center == null) {
        throw ArgumentError.notNull('center');
      }

      if (radius == null) {
        throw ArgumentError.notNull('radius');
      } */

      return true;
    }());

    setState(() {
      _circles.putIfAbsent(
        id,
        () => Circle(
          circleId: CircleId(id),
          center: center.toLatLng(),
          radius: radius,
          onTap: () => onTap!(id),
          strokeColor: strokeColor.withOpacity(strokeOpacity),
          strokeWidth: strokeWidth.toInt(),
          fillColor: fillColor.withOpacity(fillOpacity),
        ),
      );
    });
  }

  @override
  void clearCircles() => setState(() => _circles.clear());

  @override
  void editCircle(
    String id,
    GeoCoord center,
    double radius, {
    ValueChanged<String>? onTap,
    Color strokeColor = const Color(0xFF000000),
    double strokeOpacity = 0.8,
    double strokeWidth = 1,
    Color fillColor = const Color(0xFF000000),
    double fillOpacity = 0.35,
  }) {
    removeCircle(id);
    addCircle(
      id,
      center,
      radius,
      onTap: onTap,
      strokeColor: strokeColor,
      strokeOpacity: strokeOpacity,
      strokeWidth: strokeWidth,
      fillColor: fillColor,
      fillOpacity: fillOpacity,
    );
  }

  @override
  void removeCircle(String id) {
    assert(() {
      /* if (id == null) {
        throw ArgumentError.notNull('id');
      } */

      return true;
    }());

    if (!_circles.containsKey(id)) return;

    _setState(() => _circles.remove(id));
  }

  @override
  void initState() {
    super.initState();
    for (var marker in widget.markers) {
      addMarker(marker);
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => IgnorePointer(
          ignoring: !widget.interactive,
          child: Container(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight),
            child: GoogleMap(
              markers: Set<Marker>.of(_markers.values),
              polygons: Set<Polygon>.of(_polygons.values),
              polylines: Set<Polyline>.of(_polylines.values),
              circles: Set<Circle>.of(_circles.values),
              mapType: MapType.values[widget.mapType.index],
              minMaxZoomPreference: MinMaxZoomPreference(widget.minZoom, widget.minZoom),
              initialCameraPosition: CameraPosition(
                target: widget.initialPosition.toLatLng(),
                zoom: widget.initialZoom,
              ),
              onTap: (coords) => widget.onTap.call(coords.toGeoCoord()),
              onLongPress: (coords) => widget.onLongPress.call(coords.toGeoCoord()),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                _controller!.setMapStyle(widget.mapStyle);

                _waitUntilReadyCompleter.complete();
              },
              padding: widget.mobilePreferences.padding,
              compassEnabled: widget.mobilePreferences.compassEnabled,
              trafficEnabled: widget.mobilePreferences.trafficEnabled,
              buildingsEnabled: widget.mobilePreferences.buildingsEnabled,
              indoorViewEnabled: widget.mobilePreferences.indoorViewEnabled,
              mapToolbarEnabled: widget.mobilePreferences.mapToolbarEnabled,
              myLocationEnabled: widget.mobilePreferences.myLocationEnabled,
              myLocationButtonEnabled: widget.mobilePreferences.myLocationButtonEnabled,
              tiltGesturesEnabled: widget.mobilePreferences.tiltGesturesEnabled,
              zoomGesturesEnabled: widget.mobilePreferences.zoomGesturesEnabled,
              rotateGesturesEnabled: widget.mobilePreferences.rotateGesturesEnabled,
              zoomControlsEnabled: widget.mobilePreferences.zoomControlsEnabled,
              scrollGesturesEnabled: widget.mobilePreferences.scrollGesturesEnabled,
            ),
          ),
        ),
      );

  @override
  void dispose() {
    super.dispose();

    _markers.clear();
    _polygons.clear();
    _polylines.clear();
    _directionMarkerCoords.clear();

    _controller = null;
  }
}
