import 'dart:js_interop';
import 'dart:ui';

import 'package:mapkit_js/mapkit_js.dart' as mapkit;
import 'package:web/web.dart' as web;

import '../flutter_mapkit_js.dart';

/// Signature for a function that creates an HTML element for a map annotation.
///
/// The [coordinate] parameter specifies the location of the annotation.
/// The [options] parameter provides additional options for the annotation.
typedef AnnotationFactory = web.HTMLElement Function(
    mapkit.Coordinate coordinate, mapkit.AnnotationConstructorOptions? options);

/// Mixin providing annotation functionality for a MapKit map controller.
///
/// This mixin allows for the addition of annotations to the map. An annotation is a marker that can be
/// customized with an HTML element created by the provided [AnnotationFactory].
mixin AnnotationMixin on MapKitMapControllerBase {
  /// Adds an annotation to the map at the specified latitude and longitude.
  ///
  /// The [latitude] and [longitude] parameters specify the location for the annotation.
  /// The [factory] parameter is a function that creates an HTML element for the annotation.
  ///
  /// Returns the created [mapkit.Annotation] object.
  ///
  /// Example usage:
  /// ```dart
  /// controller.addAnnotation(37.7749, -122.4194, (coordinate, options) {
  ///   final element = web.HTMLDivElement();
  ///   element.textContent = 'Hello, MapKit!';
  ///   return element;
  /// });
  /// ```
  mapkit.Annotation addAnnotation(
      double latitude, double longitude, AnnotationFactory factory) {
    final coordinate = mapkit.Coordinate(latitude, longitude);
    final annotation = mapkit.Annotation(
        coordinate,
        (mapkit.Coordinate coordinate,
            mapkit.AnnotationConstructorOptions? options) {
          return factory(coordinate, options);
        }.toJS,
        null);
    map.addAnnotation(annotation);
    return annotation;
  }

  /// Adds a marker annotation to the map at the specified latitude and longitude.
  ///
  /// The [latitude] and [longitude] parameters specify the location for the annotation.
  /// The [title] parameter specifies the title of the annotation.
  /// The [subtitle] parameter specifies an optional subtitle for the annotation.
  /// The [color] parameter specifies an optional color for the annotation.
  ///
  /// Returns the created [mapkit.MarkerAnnotation] object.
  ///
  /// Example usage:
  /// ```dart
  /// controller.addMarkerAnnotation(37.7749, -122.4194, 'San Francisco',
  ///     subtitle: 'City by the Bay', color: Colors.blue);
  /// ```
  mapkit.Annotation addMarkerAnnotation(
      double latitude, double longitude, String title,
      {String? subtitle, Color? color}) {
    final coordinate = mapkit.Coordinate(latitude, longitude);
    final annotation = mapkit.MarkerAnnotation(coordinate, null);
    annotation.title = title;
    if (subtitle != null) annotation.subtitle = subtitle;
    if (color != null) {
      annotation.color = '#${color.value.toRadixString(16).substring(2, 8)}';
    }
    map.addAnnotation(annotation);
    return annotation;
  }
}
