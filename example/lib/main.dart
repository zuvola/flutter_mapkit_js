import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:pointer_interceptor_web/pointer_interceptor_web.dart';
import 'package:web/web.dart' as web;

import 'package:flutter_mapkit_js/flutter_mapkit_js.dart' hide Padding;
import 'package:flutter_mapkit_js/flutter_mapkit_js.dart' as mapkit
    show Padding;

const tokenID = String.fromEnvironment('token');

void main() async {
  debugPrint(tokenID);
  await setupMapKitJS(
    () async => tokenID,
    initializationCallback: (type, status) {
      debugPrint('onInitialize: $type, $status');
    },
    libraries: ['map', 'annotations'],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MapKit JS Demo',
      home: MyHomePage(title: 'Flutter MapKit JS Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MapKitMapController? _controller;

  void _buttonPressed() {
    _controller?.map.setCenterAnimated(Coordinate(-33.852, 151.211), true);
    _controller?.addAnnotation(-33.852, 151.211,
        (Coordinate coordinate, AnnotationConstructorOptions? options) {
      return web.HTMLDivElement()..textContent = "Hello, MapKit!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: MapKitMap(
              onMapCreated: onMapCreated,
            ),
          ),
          Expanded(
            child: MapKitMap(
              options: MapConstructorOptions(
                center: Coordinate(37.415, -122.048333),
                mapType: 'satellite',
                padding: mapkit.Padding(0.toJS, 80, 0, 0),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: PointerInterceptorWeb().buildWidget(
        child: FloatingActionButton(
          onPressed: _buttonPressed,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void onMapCreated(MapKitMapController controller) {
    _controller = controller;
    controller.map.setCenterAnimated(Coordinate(37.415, -122.048333), true);
    final st = controller.observeDisplayEvent();
    st.listen((event) {
      debugPrint('${event.timing} - ${event.type}');
    });
  }
}
