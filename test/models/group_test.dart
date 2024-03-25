import 'package:test/test.dart';
import 'package:typesense_search/typesense_search.dart';

void main() {
  group("Group", () {
    late ApiGroup group1, group2;

    setUp(() {
      group1 = ApiGroup<String>(
          found: 2, groupKeys: ["key1"], hits: ["hit1", "hit2"]);
      group2 = ApiGroup<String>.fromJson({
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
      }, (json) => json["name"]);
    });

    test("has hits field", () {
      expect(group1.hits.first, "hit1");
      expect(group2.hits.first, "hit1");
    });

    test("has groupKeys field", () {
      expect(group1.groupKeys.first, "key1");
      expect(group2.groupKeys.first, "key1");
    });

    test("has found field", () {
      expect(group1.found, 2);
      expect(group2.found, 2);
    });
  });

  group("Group.fromJson initialization", () {
    test("with no hits throws", () {
      expect(
          () => ApiGroup<String>.fromJson({
                "found": 2,
                "group_key": ["key1"]
              }, (json) => json["name"]),
          throwsA(isA<TypeError>()));
    });

    test("identify type of the response", () {
      final result = ApiGroup<String>.fromJson({
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
      }, (json) => json["name"]);

      expect(result, isA<ApiGroup<String>>());
      expect(result.hits, isA<List<String>>());
    });
  });
}
