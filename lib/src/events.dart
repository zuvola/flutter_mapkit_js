import 'dart:async';
import 'dart:js_interop';

import '../flutter_mapkit_js.dart';

/// List of map event names that the mixin listens to.
const _eventNames = [
  'region-change-start',
  'region-change-end',
  'rotation-start',
  'rotation-end',
  'scroll-start',
  'scroll-end',
  'zoom-start',
  'zoom-end',
  'map-type-change'
];

/// Extension type representing a map event with a type property.
extension type _MapEvent._(JSObject _) implements JSObject {
  external String type;
}

/// Enum representing different types of map display events.
enum MapDisplayEventType {
  regionChange,
  rotation,
  scroll,
  zoom,
  typeChange;

  /// Factory constructor to create a [MapDisplayEventType] from a string.
  /// Throws an error if the string does not match any known event type.
  factory MapDisplayEventType.fromString(String string) {
    if (string.startsWith('region')) {
      return MapDisplayEventType.regionChange;
    }
    if (string.startsWith('rotation')) {
      return MapDisplayEventType.rotation;
    }
    if (string.startsWith('scroll')) {
      return MapDisplayEventType.scroll;
    }
    if (string.startsWith('zoom')) {
      return MapDisplayEventType.zoom;
    }
    if (string == 'map-type-change') {
      return MapDisplayEventType.typeChange;
    }
    throw 'unknown MapDisplayEventType: $string';
  }
}

/// Enum representing the timing of a map event.
enum MapEventTiming {
  none,
  start,
  end;

  /// Factory constructor to create a [MapEventTiming] from a string.
  /// Defaults to [MapEventTiming.none] if the string does not match 'start' or 'end'.
  factory MapEventTiming.fromString(String string) {
    if (string.endsWith('start')) {
      return MapEventTiming.start;
    } else if (string.endsWith('end')) {
      return MapEventTiming.end;
    }
    return MapEventTiming.none;
  }
}

/// Class representing a map display event, including its type and timing.
class MapDisplayEvent {
  final MapDisplayEventType type;
  final MapEventTiming timing;

  /// Constructs a [MapDisplayEvent] from a string by parsing its type and timing.
  MapDisplayEvent.fromString(String string)
      : type = MapDisplayEventType.fromString(string),
        timing = MapEventTiming.fromString(string);
}

/// Mixin providing functionality to observe map display events on a [MapKitMapControllerBase].
mixin MapDisplayEventMixin on MapKitMapControllerBase {
  final _eventStream = StreamController<MapDisplayEvent>();

  JSFunction? _displayEventListener;

  /// Starts observing map display events and returns a stream of [MapDisplayEvent].
  ///
  /// Listens for various map events and adds them to the event stream. When the stream is closed,
  /// removes the event listeners.
  Stream<MapDisplayEvent> observeDisplayEvent() {
    if (_displayEventListener != null) {
      return _eventStream.stream;
    }
    final listener = _displayEventListener = (_MapEvent e) {
      _eventStream.add(MapDisplayEvent.fromString(e.type));
    }.toJS;
    for (var name in _eventNames) {
      map.addEventListener(name, listener, null);
    }
    _eventStream.done.then((value) {
      for (var name in _eventNames) {
        map.removeEventListener(name, listener, null);
      }
    });
    return _eventStream.stream;
  }

  /// Stops observing map display events and closes the event stream.
  ///
  /// Closes the stream controller, which in turn removes the event listeners.
  void stopObserveDisplayEvent() {
    if (_displayEventListener == null) {
      return;
    }
    _eventStream.close();
  }
}
