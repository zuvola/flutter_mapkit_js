# flutter_mapkit_js

[![pub package](https://img.shields.io/pub/v/flutter_mapkit_js.svg)](https://pub.dartlang.org/packages/flutter_mapkit_js)

**[English](https://github.com/zuvola/flutter_mapkit_js/blob/master/README.md), [日本語](https://github.com/zuvola/flutter_mapkit_js/blob/master/README_jp.md)**

A Flutter package that provides integration with MapKit JS, allowing you to embed interactive maps in your Flutter web applications.

## Features

- Initialize and configure MapKit JS.
- Add and manage map annotations.
- Listen to map events such as region changes, zoom changes, and more.

## Installation

Add `flutter_mapkit_js` to your `pubspec.yaml` file:

## Usage

### Initialize MapKit JS
To initialize MapKit JS, you need to provide a token through a callback function. Optionally, you can provide a list of libraries to load and a callback for initialization events.

```dart
import 'package:flutter_mapkit_js/flutter_mapkit_js.dart';

Future<String> getToken() async {
  // Replace with your token fetching logic
  return 'YOUR_MAPKIT_TOKEN';
}

void main() {
  setupMapKitJS(getToken, libraries: ['map'], initializationCallback: (type, status) {
    print('MapKit JS initialization: $type - $status');
  }).then((_) {
    runApp(MyApp());
  });
}
```

### Embed a Map in Your Widget
You can use the MapKitMap widget to embed a map in your Flutter application.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_mapkit_js/flutter_mapkit_js.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('MapKit JS Example')),
        body: MapKitMap(
          onMapCreated: (MapKitMapController controller) {
            // Perform actions with the map controller
          },
          options: MapConstructorOptions(
            center: Coordinate(37.7749, -122.4194), // San Francisco
            zoom: 10,
          ),
        ),
      ),
    );
  }
}
```

### Adding Annotations
You can add annotations to the map using the MapKitMapController.

```dart
void _onMapCreated(MapKitMapController controller) {
  _ontroller.addMarkerAnnotation(37.7749, -122.4194, 'San Francisco',
      subtitle: 'City by the Bay', color: Colors.blue);
}
```

You can also add customized annotations.

```dart
void _onMapCreated(MapKitMapController controller) {
  controller.addAnnotation(37.7749, -122.4194, (coordinate, options) {
    // Create and return a custom HTML element for the annotation
    return web.HTMLDivElement()..textContent = "Hello, San Francisco!";
  });
}
```

### The search service
You can search for points of interest on the map using MapKitMapController.

```dart
void _onMapCreated(MapKitMapController controller) {
  controller.searchCurrentArea('restaurant').then((response) {
    // Process search results
  });
}
```

### Observing Map Events
You can listen for map events using the MapKitMapController.

```dart
void _onMapCreated(MapKitMapController controller) {
  final st = controller.observeDisplayEvent();
  st.listen((event) {
    debugPrint('${event.timing} - ${event.type}');
  });
  // stop
  controller.stopObserveDisplayEvent();
}
```

### Others
Call MapKitJS functions directly from `controller.map`.

```dart
void _onMapCreated(MapKitMapController controller) {
  controller.map.setCenterAnimated(Coordinate(-33.852, 151.211), true);
}
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request on GitHub.

