part of models;

class ApiGroup<T> {
  final int found;
  final List<dynamic> groupKeys;
  final List<T> hits;

  ApiGroup({required this.found, required this.groupKeys, required this.hits});

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
