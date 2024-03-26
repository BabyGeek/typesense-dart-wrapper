import 'package:test/test.dart';
import 'package:typesense_search/typesense_search.dart';

void main() {
  group("Parameters", () {
    late Parameters parameters;

    setUp(() {
      parameters = Parameters(
          query: "query",
          queryBy: "queryBy",
          filterBy: "filterBy",
          groupBy: "groupBy",
          sortBy: "sortBy",
          groupLimit: 1,
          page: 1,
          limit: 20,
          offset: 0);
    });

    test("has query field", () {
      expect(parameters.query, "query");
    });

    test("has queryBy field", () {
      expect(parameters.queryBy, "queryBy");
    });

    test("has filterBy field", () {
      expect(parameters.filterBy, "filterBy");
    });
    test("has sortBy field", () {
      expect(parameters.sortBy, "sortBy");
    });
    test("has groupBy field", () {
      expect(parameters.groupBy, "groupBy");
    });
    test("has groupLimit field", () {
      expect(parameters.groupLimit, 1);
    });
    test("has page field", () {
      expect(parameters.page, 1);
    });
    test("has filterBy field", () {
      expect(parameters.limit, 20);
    });
    test("has sortBy field", () {
      expect(parameters.offset, 0);
    });
  });

  group("Parameters initialization", () {
    test("with empty query is ok", () {
      expect(Parameters(query: "", queryBy: "query"), isA<Parameters>());
    });
    test("with empty queryBy throws", () {
      expect(() => Parameters(query: "q", queryBy: ""),
          throwsA(isA<ArgumentError>()));
    });
    test("with negative page throws", () {
      expect(() => Parameters(query: "q", queryBy: "name", page: -1),
          throwsA(isA<ArgumentError>()));
    });
    test("with negative limit throws", () {
      expect(() => Parameters(query: "q", queryBy: "name", limit: -1),
          throwsA(isA<ArgumentError>()));
    });
    test("with negative groupLimit throws", () {
      expect(() => Parameters(query: "q", queryBy: "name", groupLimit: -1),
          throwsA(isA<ArgumentError>()));
    });
    test("with negative offset throws", () {
      expect(() => Parameters(query: "q", queryBy: "name", offset: -1),
          throwsA(isA<ArgumentError>()));
    });
    test("with groupLimit but no groupBy offset throws", () {
      expect(() => Parameters(query: "q", queryBy: "name", groupLimit: 1),
          throwsA(isA<ArgumentError>()));
    });
  });

  group("Parameters.toMap", () {
    late Map<String, dynamic> parameters1, parameters2;

    setUp(() {
      parameters1 = Parameters(
              query: "ali",
              queryBy: "name",
              sortBy: "name:asc",
              page: 1,
              limit: 20,
              offset: 0)
          .toMap();

      parameters2 = Parameters(
              query: "ali",
              queryBy: "name",
              sortBy: "name:asc",
              groupBy: "related_id",
              groupLimit: 1,
              page: 1,
              limit: 20,
              offset: 0)
          .toMap();
    });
    test("has query field", () {
      expect(parameters1["q"], "ali");
      expect(parameters2["q"], "ali");
    });
    test("has queryBy field", () {
      expect(parameters1["query_by"], "name");
      expect(parameters2["query_by"], "name");
    });
    test("has sortBy field", () {
      expect(parameters1["sort_by"], "name:asc");
      expect(parameters2["sort_by"], "name:asc");
    });
    test("has groupBy field", () {
      expect(parameters1["group_by"], isNull);
      expect(parameters2["group_by"], "related_id");
    });
    test("has groupLimit field", () {
      expect(parameters1["group_limit"], isNull);
      expect(parameters2["group_limit"], 1);
    });
    test("has page field", () {
      expect(parameters1["page"], 1);
      expect(parameters2["page"], 1);
    });
    test("has limit field", () {
      expect(parameters1["limit"], 20);
      expect(parameters2["limit"], 20);
    });
    test("has offset field", () {
      expect(parameters1["offset"], 0);
      expect(parameters2["offset"], 0);
    });
  });
}
