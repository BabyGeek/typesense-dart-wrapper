part of services;

class TypesenseSearch {
  final Client client;

  /// Used to the current collections Schema of the server
  List<Schema> collections = [];

  TypesenseSearch(this.client);

  factory TypesenseSearch.withNodes({
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
    try {
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

      return TypesenseSearch(Client(configuration));
    } catch (e) {
      rethrow;
    }
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
    return TypesenseSearch.withNodes(
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
    return TypesenseSearch.withNodes(
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

  /// Perform a search on the collection [collectionName] using the defined parameters.
  /// [fromJson] is used to convert the hits into the given object of type [T]
  /// Returns [ApiResponse] or [ApiGroupedResponse] depending on the given parameters.
  Future<dynamic> search<T>(String collectionName,
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
