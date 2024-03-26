```dart
import 'dart:io';

import 'package:typesense/typesense.dart';


void main() async {
  final host = InternetAddress.loopbackIPv4.address, protocol = Protocol.http;
  final nodes = {
      Node(
        protocol,
        host,
        port: 7108,
      ),
      Node.withUri(
        Uri(
          scheme: 'http',
          host: host,
          port: 8108,
        ),
      ),
      Node(
        protocol,
        host,
        port: 9108,
      ),
    };

    final typesenseSearch = TypesenseSearch.withNodes(
        apiKey: "xyz",
        nodes: nodes,
        numRetries: 3,
        connectionTimeout: const Duration(seconds: 2),
    );
    
    final parameters = Parameters(
        query: 'marg',
        queryBy: 'name',
        sortBy: 'name:asc',
    );
  
  await typesenseSearch.search<String>("drinks", parameters, fromJson: (json) => json["name"]);
}
```