part of models;

class Parameters {
  final String query;
  final String queryBy;
  final String? filterBy;
  final String? sortBy;
  final String? groupBy;
  final int? groupLimit;
  final int? page;
  final int? limit;
  final int? offset;

  Parameters(
      {required this.query,
      required this.queryBy,
      this.filterBy,
      this.sortBy,
      this.groupBy,
      this.groupLimit,
      this.page,
      this.limit,
      this.offset});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> searchParameters = {
      'q': query,
      'query_by': queryBy
    };

    if (filterBy != null) {
      searchParameters['filter_by'] = filterBy;
    }

    if (sortBy != null) {
      searchParameters['sort_by'] = sortBy;
    }

    if (groupBy != null) {
      searchParameters['group_by'] = groupBy;
      if (groupLimit != null) {
        searchParameters['group_limit'] = groupLimit;
      }
    }

    if (page != null) {
      searchParameters['page'] = page;
    }

    if (limit != null) {
      searchParameters['limit'] = limit;
    }

    if (offset != null) {
      searchParameters['offset'] = offset;
    }

    return searchParameters;
  }
}
