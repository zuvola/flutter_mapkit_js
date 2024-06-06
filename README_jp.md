# flutter_mapkit_js

[![pub package](https://img.shields.io/pub/v/flutter_mapkit_js.svg)](https://pub.dartlang.org/packages/flutter_mapkit_js)

**[English](https://github.com/zuvola/flutter_mapkit_js/blob/master/README.md), [日本語](https://github.com/zuvola/flutter_mapkit_js/blob/master/README_jp.md)**

MapKit JSとの統合を提供するFlutterパッケージで、Flutterウェブアプリケーションにインタラクティブな地図を埋め込むことができます。

## Features

- MapKit JS の初期化と設定。
- マップアノテーションの追加と管理。
- 地域の変更、ズームの変更などのマップイベントを受け取れます。

## Installation

pubspec.yaml`ファイルに `flutter_mapkit_js` を追加してください。

## Usage

### Initialize MapKit JS
MapKit JS を初期化するには、コールバック関数を通してトークンを提供する必要があります。オプションで、ロードするライブラリのリストと初期化イベントのコールバックを指定することもできます。

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
MapKitMapウィジェットを使ってFlutterアプリケーションに地図を埋め込むことができます。

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
MapKitMapController を使用してマップにアノテーションを追加できます。

```dart
void _onMapCreated(MapKitMapController controller) {
  controller.addMarkerAnnotation(37.7749, -122.4194, 'San Francisco',
      subtitle: 'City by the Bay', color: Colors.blue);
}
```

カスタマイズアノテーションの追加もできます。

```dart
void _onMapCreated(MapKitMapController controller) {
  controller.addAnnotation(37.7749, -122.4194, (coordinate, options) {
    // Create and return a custom HTML element for the annotation
    return web.HTMLDivElement()..textContent = "Hello, San Francisco!";
  });
}
```

### The search service
MapKitMapController を使用してマップ上のポイントを検索できます。

```dart
void _onMapCreated(MapKitMapController controller) {
  controller.searchCurrentArea('restaurant').then((response) {
    // Process search results
  });
}
```

### Observing Map Events
MapKitMapController を使ってマップイベントを受け取ることができます。

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

`controller.map`から直接MapKitJSの機能を呼び出してください。

```dart
void _onMapCreated(MapKitMapController controller) {
  controller.map.setCenterAnimated(Coordinate(-33.852, 151.211), true);
}
```

## Contributing

コントリビュートを歓迎します！GitHubでissueを開くか、プルリクエストを提出してください。

