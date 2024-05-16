import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/widgets.dart';
import 'package:mapkit_js/mapkit_js.dart' as mapkit;
import 'package:web/web.dart' as web;

import 'controller.dart';

/// Callback type for when the MapKit map is created.
typedef MapCreatedCallback = void Function(MapKitMapController controller);

/// A Flutter widget that embeds a MapKit JS map.
class MapKitMap extends StatefulWidget {
  const MapKitMap({
    super.key,
    this.onMapCreated,
    this.options,
  });

  /// Callback invoked when the map is created and ready to use.
  final MapCreatedCallback? onMapCreated;

  /// Options for configuring the MapKit map.
  final mapkit.MapConstructorOptions? options;

  @override
  State<MapKitMap> createState() => _MapKitMapState();
}

class _MapKitMapState extends State<MapKitMap> {
  static int _mapId = 0;
  final _tagId = 'map_${_mapId++}';
  MapKitMapController? _controller;

  /// Observes the DOM for the element with the given selectors and returns it once found.
  Future<web.Element> _observeElement(String selectors) async {
    web.Element? tag;
    while (tag == null) {
      tag = web.document.querySelector(selectors);
      await Future.delayed(Duration.zero);
    }
    return tag;
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.stopObserveDisplayEvent();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView.fromTagName(
      tagName: 'div',
      onElementCreated: (element) async {
        (element as web.HTMLDivElement)
          ..id = _tagId
          ..style.width = '100%'
          ..style.height = '100%';
        await _observeElement('#$_tagId');
        final map = mapkit.Map(_tagId.toJS, widget.options);
        _controller = MapKitMapController(map: map);
        widget.onMapCreated?.call(_controller!);
      },
    );
  }
}
