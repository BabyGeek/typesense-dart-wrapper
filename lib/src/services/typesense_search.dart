import 'dart:io';

import 'package:typesense/typesense.dart';
import 'package:typesense_search/src/models/models.dart';

class TypesenseSearch {
  final Client client;
  List<Schema> collections = [];

  TypesenseSearch._(this.client);

  factory TypesenseSearch({
    required String apiKey,
    Set<Node>? nodes,
    Node? nearestNode,
    int? numRetries,
    Duration retryInterval = const Duration(milliseconds: 100),
    Duration connectionTimeout = const Duration(seconds: 10),
    Duration healthcheckInterval = const Duration(seconds: 15),
    Duration cachedSearchResultsTTL = Duration.zero,
    bool sendApiKeyAsQueryParam = false,
  }) {
    final configuration = Configuration(
      apiKey,
      nodes: nodes,
      nearestNode: nearestNode,
      numRetries: numRetries,
      connectionTimeout: connectionTimeout,
      retryInterval: retryInterval,
      healthcheckInterval: healthcheckInterval,
      cachedSearchResultsTTL: cachedSearchResultsTTL,
      sendApiKeyAsQueryParam: sendApiKeyAsQueryParam,
    );

    return TypesenseSearch._(Client(configuration));
  }

  factory TypesenseSearch.withHostAddress({
    required String apiKey,
    required String hostAdress,
    InternetAddressType hostAdressType = InternetAddressType.unix,
    String scheme = 'http',
    int? port = 8108,
    Node? nearestNode,
    int? numRetries,
    Duration retryInterval = const Duration(milliseconds: 100),
    Duration connectionTimeout = const Duration(seconds: 10),
    Duration healthcheckInterval = const Duration(seconds: 15),
    Duration cachedSearchResultsTTL = Duration.zero,
    bool sendApiKeyAsQueryParam = false,
  }) {
    return TypesenseSearch(
      apiKey: apiKey,
      nodes: {
        Node.withUri(Uri(
            scheme: scheme,
            host: InternetAddress(hostAdress, type: hostAdressType).address,
            port: port)),
      },
      nearestNode: nearestNode,
      numRetries: numRetries,
      connectionTimeout: connectionTimeout,
      retryInterval: retryInterval,
      healthcheckInterval: healthcheckInterval,
      cachedSearchResultsTTL: cachedSearchResultsTTL,
      sendApiKeyAsQueryParam: sendApiKeyAsQueryParam,
    );
  }

  factory TypesenseSearch.localhost({
    required String apiKey,
    int? numRetries,
    Duration retryInterval = const Duration(milliseconds: 100),
    Duration connectionTimeout = const Duration(seconds: 10),
    Duration healthcheckInterval = const Duration(seconds: 15),
    Duration cachedSearchResultsTTL = Duration.zero,
    bool sendApiKeyAsQueryParam = false,
  }) {
    return TypesenseSearch(
      apiKey: apiKey,
      nodes: {
        Node.withUri(Uri(
            scheme: "http",
            host: InternetAddress.loopbackIPv4.address,
            port: 8108))
      },
      numRetries: numRetries,
      connectionTimeout: connectionTimeout,
      retryInterval: retryInterval,
      healthcheckInterval: healthcheckInterval,
      cachedSearchResultsTTL: cachedSearchResultsTTL,
      sendApiKeyAsQueryParam: sendApiKeyAsQueryParam,
    );
  }

  Future<dynamic> search<T>(String search, String collectionName,
      {required Parameters parameters,
      required T Function(Map<String, dynamic>) fromJson}) async {
    try {
      final Map<String, dynamic> result = await client
          .collection(collectionName)
          .documents
          .search(parameters.toMap());

      if (parameters.groupBy == null) {
        return ApiResponse.fromJson(result, fromJson);
      } else {
        return ApiGroupedResponse.fromJson(result, fromJson);
      }
    } catch (e) {
      rethrow;
    }
  }
}
