import 'package:test/test.dart';
import 'package:typesense_search/typesense_search.dart';

void main() {
  group("GroupedResponse", () {
    late ApiGroupedResponse group1, group2;

    setUp(() {
      group1 = ApiGroupedResponse<String>(groupedHits: [
        ApiGroup(found: 2, groupKeys: ["key1"], hits: ["hit1", "hit2"]),
        ApiGroup(found: 3, groupKeys: ["key2"], hits: ["hit3", "hit4", "hit5"]),
      ], facetCounts: [], foundDocs: 5, found: 2);

      group2 = ApiGroupedResponse<String>.fromJson({
        "grouped_hits": [
          {
            "found": 2,
            "group_key": ["key1"],
            "hits": [
              {
                "document": {
                  "name": "hit1",
                },
              },
              {
                "document": {
                  "name": "hit2",
                },
              },
            ]
          },
          {
            "found": 3,
            "group_key": ["key2"],
            "hits": [
              {
                "document": {
                  "name": "hit3",
                },
              },
              {
                "document": {
                  "name": "hit4",
                },
              },
              {
                "document": {
                  "name": "hit5",
                },
              },
            ]
          },
        ],
        "facet_counts": [],
        "found_docs": 5,
        "found": 2
      }, (json) => json["name"]);
    });

    test("has groupedHits field", () {
      expect(group1.groupedHits, isNotEmpty);
      expect(group2.groupedHits, isNotEmpty);
    });

    test("has facetCounts field", () {
      expect(group1.facetCounts, isNotNull);
      expect(group2.facetCounts, isNotNull);
    });

    test("has found field", () {
      expect(group1.found, 2);
      expect(group2.found, 2);
    });

    test("has foundDocs field", () {
      expect(group1.foundDocs, 5);
      expect(group2.foundDocs, 5);
    });
  });

  group("GroupedResponse.fromJson initialization", () {
    test("with no grouped hits throws", () {
      expect(
          () => ApiGroupedResponse<String>.fromJson(
              {"facet_counts": [], "found_docs": 5, "found": 2},
              (json) => json["name"]),
          throwsA(isA<TypeError>()));
    });

    test("identify type of the response", () {
      final result = ApiGroupedResponse<String>.fromJson({
        "grouped_hits": [
          {
            "found": 2,
            "group_key": ["key1"],
            "hits": [
              {
                "document": {
                  "name": "hit1",
                },
              },
              {
                "document": {
                  "name": "hit2",
                },
              },
            ]
          },
          {
            "found": 3,
            "group_key": ["key2"],
            "hits": [
              {
                "document": {
                  "name": "hit3",
                },
              },
              {
                "document": {
                  "name": "hit4",
                },
              },
              {
                "document": {
                  "name": "hit5",
                },
              },
            ]
          },
        ],
        "facet_counts": [],
        "found_docs": 5,
        "found": 2
      }, (json) => json["name"]);

      expect(result, isA<ApiGroupedResponse<String>>());
      expect(result.groupedHits, isA<List<ApiGroup<String>>>());
    });
  });
}
