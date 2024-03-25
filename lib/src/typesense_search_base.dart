import 'dart:io';

import 'package:typesense/typesense.dart';
import 'package:typesense_search/src/models/models.dart';

class TypesenseSearch {
  final Client client;
  List<Schema> collections = [];

  TypesenseSearch._(this.client);

  factory TypesenseSearch(
      {required String apiKey,
      required InternetAddress host,
      String scheme = 'http',
      int? port = 8108,
      Protocol protocol = Protocol.http,
      int retries = 3,
      int timeout = 3}) {
    final configuration = Configuration(apiKey,
        nodes: {
          Node.withUri(Uri(scheme: scheme, host: host.address, port: port))
        },
        numRetries: retries,
        connectionTimeout: Duration(seconds: timeout));

    return TypesenseSearch._(Client(configuration));
  }

  factory TypesenseSearch.withHostAddress(
      {required String apiKey,
      required String hostAdress,
      InternetAddressType hostAdressType = InternetAddressType.unix,
      String scheme = 'http',
      int? port = 8108,
      Protocol protocol = Protocol.http,
      int retries = 3,
      int timeout = 3}) {
    return TypesenseSearch(
        apiKey: apiKey,
        host: InternetAddress(hostAdress, type: hostAdressType),
        scheme: scheme,
        port: port,
        protocol: protocol,
        retries: retries,
        timeout: timeout);
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
