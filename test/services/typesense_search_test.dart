import 'dart:io';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:typesense/typesense.dart';
import 'package:typesense_search/typesense_search.dart';
import "package:typesense/src/documents.dart";

@GenerateMocks([Client, Collection, Documents])
import "typesense_search_test.mocks.dart";

void main() {
  group("TypesenseSearch initializers", () {
    test("TypesenseSearch.withNodes throws when no nodes", () {
      try {
        TypesenseSearch.withNodes(apiKey: "api_key");
        // If no error is thrown, fail the test
        fail("Expected MissingConfiguration error but got none");
      } catch (e) {
        expect(e, isA<MissingConfiguration>());
      }
    });
    test("TypesenseSearch.withNodes initializes correctly with nearest nodes",
        () {
      final typesenseSearch = TypesenseSearch.withNodes(
        apiKey: "api_key",
        nodes: {
          Node.withUri(Uri(host: "example.com")),
        },
        nearestNode: Node.withUri(Uri(host: "nearest.example.com")),
      );

      expect(typesenseSearch.client.config.apiKey, "api_key");
      expect(typesenseSearch.client.config.nodes,
          {Node.withUri(Uri(host: "example.com"))});
      expect(typesenseSearch.client.config.nearestNode,
          Node.withUri(Uri(host: "nearest.example.com")));
      expect(typesenseSearch.client.config.numRetries, 2);
      expect(typesenseSearch.client.config.retryInterval,
          Duration(milliseconds: 100));
      expect(typesenseSearch.client.config.connectionTimeout,
          Duration(seconds: 10));
      expect(typesenseSearch.client.config.healthcheckInterval,
          Duration(seconds: 15));
      expect(
          typesenseSearch.client.config.cachedSearchResultsTTL, Duration.zero);
      expect(typesenseSearch.client.config.sendApiKeyAsQueryParam, false);
    });
    test(
        "TypesenseSearch.withNodes initializes correctly without nearest nodes",
        () {
      final typesenseSearch = TypesenseSearch.withNodes(
        apiKey: "api_key",
        nodes: {
          Node.withUri(Uri(host: "example.com")),
        },
      );

      expect(typesenseSearch.client.config.apiKey, "api_key");
      expect(typesenseSearch.client.config.nodes,
          {Node.withUri(Uri(host: "example.com"))});
      expect(typesenseSearch.client.config.nearestNode, isNull);
      expect(typesenseSearch.client.config.numRetries, 1);
      expect(typesenseSearch.client.config.retryInterval,
          Duration(milliseconds: 100));
      expect(typesenseSearch.client.config.connectionTimeout,
          Duration(seconds: 10));
      expect(typesenseSearch.client.config.healthcheckInterval,
          Duration(seconds: 15));
      expect(
          typesenseSearch.client.config.cachedSearchResultsTTL, Duration.zero);
      expect(typesenseSearch.client.config.sendApiKeyAsQueryParam, false);
    });

    test("TypesenseSearch.withHostAddress initializes correctly", () {
      final typesenseSearch = TypesenseSearch.withHostAddress(
        apiKey: "api_key",
        hostAdress: "localhost",
      );

      expect(typesenseSearch.client.config.apiKey, "api_key");
      expect(typesenseSearch.client.config.nodes, {
        Node.withUri(
          Uri(
            scheme: "http",
            host: "localhost",
            port: 8108,
          ),
        ),
      });
      expect(typesenseSearch.client.config.nearestNode, isNull);
      expect(typesenseSearch.client.config.numRetries, 1);
      expect(typesenseSearch.client.config.retryInterval,
          Duration(milliseconds: 100));
      expect(typesenseSearch.client.config.connectionTimeout,
          Duration(seconds: 10));
      expect(typesenseSearch.client.config.healthcheckInterval,
          Duration(seconds: 15));
      expect(
          typesenseSearch.client.config.cachedSearchResultsTTL, Duration.zero);
      expect(typesenseSearch.client.config.sendApiKeyAsQueryParam, false);
    });

    test("TypesenseSearch.localhost initializes correctly", () {
      final typesenseSearch = TypesenseSearch.localhost(apiKey: "api_key");

      expect(typesenseSearch.client.config.apiKey, "api_key");
      expect(typesenseSearch.client.config.nodes, {
        Node.withUri(
          Uri(
            scheme: "http",
            host: InternetAddress.loopbackIPv4.address,
            port: 8108,
          ),
        ),
      });
      expect(typesenseSearch.client.config.nearestNode, isNull);
      expect(typesenseSearch.client.config.numRetries, 1);
      expect(typesenseSearch.client.config.retryInterval,
          Duration(milliseconds: 100));
      expect(typesenseSearch.client.config.connectionTimeout,
          Duration(seconds: 10));
      expect(typesenseSearch.client.config.healthcheckInterval,
          Duration(seconds: 15));
      expect(
          typesenseSearch.client.config.cachedSearchResultsTTL, Duration.zero);
      expect(typesenseSearch.client.config.sendApiKeyAsQueryParam, false);
    });
  });

  group('TypesenseSearch', () {
    late TypesenseSearch typesenseSearch;
    final MockClient mockClient = MockClient();
    final MockCollection mockCollection = MockCollection();
    final MockDocuments mockDocuments = MockDocuments();

    setUp(() {
      typesenseSearch = TypesenseSearch(mockClient);
    });

    group('search', () {
      setUp(() {
        when(mockClient.collection("collectionName"))
            .thenReturn(mockCollection);
        when(mockCollection.documents).thenReturn(mockDocuments);
      });

      test('performs search with correct parameters and returns ApiResponse',
          () async {
        final parameters = Parameters(
          query: 'query',
          queryBy: 'queryBy',
        );

        when(mockDocuments.search(parameters.toMap())).thenAnswer((_) async {
          return {'hits': [], 'facet_counts': [], 'found': 0};
        });

        final result = await typesenseSearch.search<String>('collectionName',
            parameters: parameters, fromJson: (json) => '');

        expect(result, isA<ApiResponse<String>>());
        expect(result.hits, isEmpty);
        expect(result.facetCounts, isEmpty);
        expect(result.found, 0);

        verify(mockClient.collection("collectionName")).called(1);
      });
      test(
          'performs search with correct parameters and returns ApiResponseGrouped',
          () async {
        final parameters =
            Parameters(query: 'query', queryBy: 'queryBy', groupBy: "groupBy");

        when(mockDocuments.search(parameters.toMap())).thenAnswer((_) async => {
              "grouped_hits": [],
              "facet_counts": [],
              "found_docs": 0,
              "found": 0
            });

        final result = await typesenseSearch.search<String>('collectionName',
            parameters: parameters, fromJson: (json) => '');

        expect(result, isA<ApiGroupedResponse<String>>());
        expect(result.groupedHits, isEmpty);
        expect(result.facetCounts, isEmpty);
        expect(result.foundDocs, 0);
        expect(result.found, 0);

        verify(mockClient.collection("collectionName")).called(1);
      });

      test('throws an error if search fails', () async {
        final parameters = Parameters(
          query: 'query',
          queryBy: 'queryBy',
        );

        when(mockDocuments.search(parameters.toMap()))
            .thenThrow(Exception('Search failed'));

        expect(
            typesenseSearch.search<String>('collectionName',
                parameters: parameters, fromJson: (json) => ''),
            throwsA(isA<Exception>()));
      });

      // Add more test cases for different scenarios, such as testing grouped responses
    });
  });
}
