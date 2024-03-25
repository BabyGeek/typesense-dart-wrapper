part of models;

class ApiResponse<T> {
  final List<T> hits;
  final List<dynamic> facetCounts;
  final int found;

  ApiResponse({
    required this.hits,
    required this.facetCounts,
    required this.found,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return ApiResponse<T>(
      hits: (json['hits'] as List<dynamic>)
          .map((hit) => fromJson(hit['document'] as Map<String, dynamic>))
          .toList(),
      facetCounts: json['facet_counts'] as List<dynamic>,
      found: json['found'] as int,
    );
  }
}

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
    final List<dynamic> groupedHitsJson = json['grouped_hits'] as List<dynamic>;

    return ApiGroupedResponse<T>(
      groupedHits: groupedHitsJson
          .map((hitJson) => ApiGroup.fromJson(hitJson, fromJson))
          .toList(),
      facetCounts: json['facet_counts'] as List<dynamic>,
      foundDocs: json['found_docs'] as int,
      found: json['found'] as int,
    );
  }
}

class ApiGroup<T> {
  final int found;
  final List<dynamic> groupKeys;
  final List<T> hits;

  ApiGroup({required this.found, required this.groupKeys, required this.hits});

  factory ApiGroup.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return ApiGroup<T>(
      hits: (json['hits'] as List<dynamic>)
          .map((hit) => fromJson(hit['document'] as Map<String, dynamic>))
          .toList(),
      groupKeys: json['group_key'] as List<dynamic>,
      found: json['found'] as int,
    );
  }
}
