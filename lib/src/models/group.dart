part of models;

class ApiGroup<T> {
  /// Number of hits found.
  final int found;

  /// Keys that represent the group.
  final List<dynamic> groupKeys;

  /// List of hits found.
  final List<T> hits;

  ApiGroup({required this.found, required this.groupKeys, required this.hits});

  /// Convert json data to [ApiGroup] object, using [fromJson] to convert the hits.
  factory ApiGroup.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    try {
      return ApiGroup<T>(
        hits: (json['hits'] as List<dynamic>)
            .map((hit) => fromJson(hit['document'] as Map<String, dynamic>))
            .toList(),
        groupKeys: json['group_key'] as List<dynamic>,
        found: json['found'] as int,
      );
    } catch (e) {
      rethrow;
    }
  }
}
