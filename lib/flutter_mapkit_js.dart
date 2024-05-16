library flutter_mapkit_js;

import 'dart:async';
import 'dart:js_interop';

import 'package:mapkit_js/mapkit_js.dart' as mapkit;

export 'package:mapkit_js/mapkit_js.dart';
export 'src/controller.dart';
export 'src/mapkit_map.dart';
export 'src/events.dart'
    show MapDisplayEventType, MapEventTiming, MapDisplayEvent;

/// Callback signature for obtaining a MapKit token.
typedef GetTokenCallback = Future<String> Function();

/// Callback signature for handling map initialization events.
typedef MapInitializationCallback = void Function(String type, String status);

/// Sets up MapKit JS with the provided token callback and optional initialization callback and libraries.
///
/// This function initializes the MapKit JS environment, loading the required libraries and setting up
/// authorization with the provided token callback. It also sets up event listeners for configuration changes
/// and errors during the initialization process.
///
/// [getToken] is a callback function that returns a Future resolving to the MapKit token.
/// [initializationCallback] is an optional callback function for handling initialization events, such as
/// configuration changes or errors. It takes the event type and status as parameters.
/// [libraries] is an optional list of libraries to be loaded by MapKit. If not provided, the default library
/// 'map' will be loaded.
///
/// Returns a Future that completes once the MapKit libraries are loaded and initialization is complete.
///
/// Example usage:
/// ```dart
/// setupMapKitJS(() async => 'your_token_here', initializationCallback: (type, status) {
///   print('Initialization event: $type, status: $status');
/// });
/// ```
Future<void> setupMapKitJS(GetTokenCallback getToken,
    {MapInitializationCallback? initializationCallback,
    List<String>? libraries}) async {
  final completer = Completer<void>();
  final initalToken = await getToken();

  // Load MapKit JS with the initial token
  await mapkit.loadMapKitJS(initalToken);

  // Set default libraries to load if not provided
  libraries ??= ['map'];

  // Initialize MapKit with options
  mapkit.init(
    mapkit.MapKitInitOptions(
      authorizationCallback: (JSFunction done) {
        // Obtain token and pass it to the authorization callback
        getToken().then((String tokenID) {
          done.callAsFunction(null, tokenID.toJS);
        });
        // Wait until library loading is complete
        Future.doWhile(() async {
          if (mapkit.loadedLibraries.toDart.isEmpty) {
            await Future.delayed(const Duration(milliseconds: 10));
            return true;
          }
          return false;
        }).whenComplete(() {
          if (!completer.isCompleted) {
            completer.complete();
          }
        });
      }.toJS,
      libraries: libraries.map((e) => e.toJS).toList().toJS,
    ),
  );

  // Add event listeners for configuration changes and errors
  mapkit.addEventListener(
    "configuration-change",
    ((mapkit.InitializationEvent event) =>
        initializationCallback?.call(event.type, event.status)).toJS,
    null,
  );
  mapkit.addEventListener(
    "error",
    ((mapkit.InitializationEvent event) =>
        initializationCallback?.call(event.type, event.status)).toJS,
    null,
  );

  return completer.future;
}
