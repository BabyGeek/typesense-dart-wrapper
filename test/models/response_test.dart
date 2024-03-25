import 'package:test/test.dart';
import 'package:typesense_search/typesense_search.dart';

void main() {
  group("Response", () {
    late ApiResponse response1, response2;

    setUp(() {
      response1 = ApiResponse<String>(
          hits: ["hit1", "hit2"], facetCounts: [], found: 2);

      response2 = ApiResponse<String>.fromJson({
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
          }
        ],
        "facet_counts": [],
        "found": 2
      }, (json) => json["name"]);
    });

    test("has hits field", () {
      expect(response1.hits, isNotEmpty);
      expect(response2.hits, isNotEmpty);
    });

    test("has facetCounts field", () {
      expect(response1.facetCounts, isNotNull);
      expect(response2.facetCounts, isNotNull);
    });

    test("has found field", () {
      expect(response1.found, 2);
      expect(response2.found, 2);
    });
  });

  group("Response.fromJson initialization", () {
    test("with no hits throws", () {
      expect(
          () => ApiResponse<String>.fromJson({"facet_counts": [], "found": 2},
                  (json) {
                return json["name"];
              }),
          throwsA(isA<TypeError>()));
    });

    test("identify type of the response", () {
      final result = ApiResponse<String>.fromJson(
        {
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
            }
          ],
          "facet_counts": [],
          "found": 2
        },
        (json) {
          return json["name"];
        },
      );

      expect(result, isA<ApiResponse<String>>());
    });
  });
}
