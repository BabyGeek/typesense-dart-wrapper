part of models;

class ApiGroupedResponse<T> {
  final List<ApiGroup<T>> groupedHits;
  final List<dynamic> facetCounts;
  final int foundDocs;
  final int found;

  ApiGroupedResponse(
      {required this.groupedHits,
      required this.facetCounts,
      required this.foundDocs,
      required this.found});

  factory ApiGroupedResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    try {
      final List<dynamic> groupedHitsJson =
          json['grouped_hits'] as List<dynamic>;

      return ApiGroupedResponse<T>(
        groupedHits: groupedHitsJson
            .map((hitJson) => ApiGroup<T>.fromJson(hitJson, fromJson))
            .toList(),
        facetCounts: json['facet_counts'] as List<dynamic>,
        foundDocs: json['found_docs'] as int,
        found: json['found'] as int,
      );
    } catch (e) {
      rethrow;
    }
  }
}
