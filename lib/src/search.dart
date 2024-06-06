import 'dart:async';
import 'dart:js_interop';

import '../flutter_mapkit_js.dart';

/// Mixin providing search functionality for a MapKit map controller.
///
/// This mixin allows for performing searches within a specified area or the current map area using a query string.
mixin SearchMixin on MapKitMapControllerBase {
  /// Searches using the specified query and options.
  ///
  /// The [query] parameter specifies the search query.
  /// The [options] parameter specifies optional search constructor options.
  ///
  /// Returns a [Future] that completes with a [SearchResponse] containing the search results.
  ///
  /// Example usage:
  /// ```dart
  /// controller.search('restaurant').then((response) {
  ///   // Process search results
  /// });
  /// ```
  Future<SearchResponse> search(String query,
      {SearchConstructorOptions? options}) {
    final completer = Completer<SearchResponse>();
    final search = Search(options);

    search.search(
        query.toJS,
        (JSAny? error, SearchResponse? data) {
          if (error != null) {
            completer.completeError(error);
          } else {
            completer.complete(data);
          }
        }.toJS,
        null);

    return completer.future;
  }

  /// Searches the current map area using the specified query.
  ///
  /// The [query] parameter specifies the search query.
  ///
  /// Returns a [Future] that completes with a [SearchResponse] containing the search results.
  ///
  /// Example usage:
  /// ```dart
  /// controller.searchCurrentArea('restaurant').then((response) {
  ///   // Process search results
  /// });
  /// ```
  Future<SearchResponse> searchCurrentArea(String query) {
    return search(query, options: SearchConstructorOptions(region: map.region));
  }
}
