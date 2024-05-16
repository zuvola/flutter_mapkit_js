import 'package:mapkit_js/mapkit_js.dart' as mapkit;

import 'annotation.dart';
import 'events.dart';

/// Abstract base class for a MapKit map controller.
///
/// This class holds a reference to a [mapkit.Map] object, which is the main interface
/// for interacting with the MapKit JS library. Subclasses can extend this base class
/// to implement specific functionalities.
abstract class MapKitMapControllerBase {
  final mapkit.Map map;
  MapKitMapControllerBase({required this.map});
}

// Concrete implementation of a MapKit map controller.
///
/// This class extends [MapKitMapControllerBase] and mixes in [MapDisplayEventMixin] and [AnnotationMixin]
/// to provide additional functionalities such as observing map display events and adding annotations to the map.
class MapKitMapController extends MapKitMapControllerBase
    with MapDisplayEventMixin, AnnotationMixin {
  MapKitMapController({required super.map});
}
