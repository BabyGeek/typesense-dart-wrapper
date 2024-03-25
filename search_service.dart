import 'dart:io';

import 'package:typesense/typesense.dart';
import 'response.dart';

class SearchService {
  final Client client;
  List<Schema> collections = [];

  SearchService._(this.client);

  factory SearchService(
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

    return SearchService._(Client(configuration));
  }

  factory SearchService.withHostAddress(
      {required String apiKey,
      required String hostAdress,
      InternetAddressType hostAdressType = InternetAddressType.unix,
      String scheme = 'http',
      int? port = 8108,
      Protocol protocol = Protocol.http,
      int retries = 3,
      int timeout = 3}) {
    return SearchService(
        apiKey: apiKey,
        host: InternetAddress(hostAdress, type: hostAdressType),
        scheme: scheme,
        port: port,
        protocol: protocol,
        retries: retries,
        timeout: timeout);
  }

  Future<dynamic> search<T>(String search, String collectionName,
      {required String queryBy,
      String? filterBy,
      String? sortBy,
      String? groupBy,
      int? groupLimit,
      int? page,
      int? limit,
      int? offset,
      required T Function(Map<String, dynamic>) fromJson}) async {
    final searchParameters = {'q': '$search', 'query_by': '$queryBy'};

    if (filterBy != null) {
      searchParameters['filter_by'] = '$filterBy';
    }

    if (sortBy != null) {
      searchParameters['sort_by'] = '$sortBy';
    }

    if (groupBy != null) {
      searchParameters['group_by'] = '$groupBy';
      if (groupLimit != null) {
        searchParameters['group_limit'] = '$groupLimit';
      }
    }

    if (page != null) {
      searchParameters['page'] = '$page';
    }

    if (limit != null) {
      searchParameters['limit'] = '$limit';
    }

    if (offset != null) {
      searchParameters['offset'] = '$offset';
    }

    print(
        "search on collection $collectionName with parameters $searchParameters");

    try {
      final Map<String, dynamic> result = await client
          .collection(collectionName)
          .documents
          .search(searchParameters);

      if (groupBy == null) {
        return ApiResponse.fromJson(result, fromJson);
      } else {
        return ApiGroupedResponse.fromJson(result, fromJson);
      }
    } catch (e) {
      throw e;
    }
  }
}
