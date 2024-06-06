import 'package:flutter_mapkit_js/src/search.dart';
import 'package:mapkit_js/mapkit_js.dart' as mapkit;

import 'annotation.dart';
import 'events.dart';

/// Abstract base class for MapKit map controllers.
///
/// This class provides a basic structure for map controllers, holding a reference to a [mapkit.Map] object.
abstract class MapKitMapControllerBase {
  /// The MapKit map instance managed by this controller.
  final mapkit.Map map;

  /// Constructs a [MapKitMapControllerBase] with the given [mapkit.Map] instance.
  MapKitMapControllerBase({required this.map});
}

/// Concrete implementation of a MapKit map controller.
///
/// This class extends [MapKitMapControllerBase] and mixes in [MapDisplayEventMixin], [AnnotationMixin], and [SearchMixin]
/// to provide additional functionality for handling map display events, annotations, and search operations.
class MapKitMapController extends MapKitMapControllerBase
    with MapDisplayEventMixin, AnnotationMixin, SearchMixin {
  /// Constructs a [MapKitMapController] with the given [mapkit.Map] instance.
  MapKitMapController({required super.map});
}
