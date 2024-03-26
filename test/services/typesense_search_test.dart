import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:typesense/typesense.dart';
import 'package:typesense_search/typesense_search.dart';
import "package:typesense/src/documents.dart";

@GenerateMocks([Client, Collection, Documents])
import "typesense_search_test.mocks.dart";

void main() {
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
