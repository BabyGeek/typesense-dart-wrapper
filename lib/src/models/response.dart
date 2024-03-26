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
    try {
      return ApiResponse<T>(
        hits: (json['hits'] as List<dynamic>)
            .map((hit) => fromJson(hit['document'] as Map<String, dynamic>))
            .toList(),
        facetCounts: json['facet_counts'] as List<dynamic>,
        found: json['found'] as int,
      );
    } catch (e) {
      rethrow;
    }
  }
}
