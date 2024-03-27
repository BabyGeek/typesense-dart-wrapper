part of models;

class Parameters {
  /// The query text to search for in the collection.
  final String query;

  /// TOne or more field names that should be queried against.
  /// Separate multiple fields with a comma: company_name, country
  final String queryBy;

  /// Filter conditions for refining your search results.
  final String? filterBy;

  /// A list of fields and their corresponding sort orders that will be used for ordering your results.
  /// Separate multiple fields with a comma.
  final String? sortBy;

  /// You can aggregate search results into groups or buckets by specify one or more group_by fields.
  /// Separate multiple fields with a comma.
  /// NOTE: To group on a particular field, it must be a faceted field.
  /// E.g. group_by=country,company_name
  final String? groupBy;

  /// Maximum number of hits to be returned for every group.
  /// If the group_limit is set as K then only the top K hits in each group are returned in the response.
  /// Default: 3
  final int? groupLimit;

  /// Results from this specific page number would be fetched.
  /// Page numbers start at 1 for the first page.
  /// Default: 1.
  final int? page;

  /// Number of hits to fetch.
  /// Default: 10.
  /// NOTE: Only upto 250 hits (or groups of hits when using group_by) can be fetched per page.
  final int? limit;

  /// Identifies the starting point to return hits from a result set.
  /// Can be used as an alternative to the page parameter.
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
      this.offset}) {
    if (queryBy.isEmpty) {
      throw ArgumentError('Ensure Parameters.queryBy is not empty');
    }

    if (page != null && page! < 0) {
      throw ArgumentError('Ensure Parameters.page is not a negative number');
    }

    if (groupLimit != null && groupLimit! < 0) {
      throw ArgumentError(
          'Ensure Parameters.groupLimit is not a negative number');
    }

    if (limit != null && limit! < 0) {
      throw ArgumentError('Ensure Parameters.limit is not a negative number');
    }

    if (offset != null && offset! < 0) {
      throw ArgumentError('Ensure Parameters.offset is not a negative number');
    }

    if (groupLimit != null && groupBy == null) {
      throw ArgumentError(
          'Ensure Parameters.groupBy is not a null if Parameters.groupLimit is not null');
    }
  }

  Map<String, dynamic /*String?|Iterable<String>*/ > toMap() {
    final Map<String, dynamic /*String?|Iterable<String>*/ > searchParameters =
        {'q': query, 'query_by': queryBy};

    if (filterBy != null) {
      searchParameters['filter_by'] = filterBy;
    }

    if (sortBy != null) {
      searchParameters['sort_by'] = sortBy;
    }

    if (groupBy != null) {
      searchParameters['group_by'] = groupBy;
      if (groupLimit != null) {
        searchParameters['group_limit'] = groupLimit.toString();
      }
    }

    if (page != null) {
      searchParameters['page'] = page.toString();
    }

    if (limit != null) {
      searchParameters['limit'] = limit.toString();
    }

    if (offset != null) {
      searchParameters['offset'] = offset.toString();
    }

    return searchParameters;
  }
}
