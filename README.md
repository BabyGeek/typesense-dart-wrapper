
## Installation

## Getting Started

Instanciate the service

```dart
    final searchService = TypesenseSearch(
        apiKey: TYPESENSE_API_KEY, host: InternetAddress.loopbackIPv4);
```

## Filter

To use filtering you have to call the search method, you can use it with pagination also.

```dart
Future<ApiResponse<T>> search<T>(String search, String collectionName,
      {String? queryBy,
      String? filterBy,
      String? sortBy,
      int? page,
      int? limit,
      int? offset,
      required T Function(Map<String, dynamic>) fromJson}) async { } 
```

The filters follow the format from the Typesense documentation

The object apiResponse can be used like so:

```dart
print("total item found: ${apiResponse.found}");
print("Facet count: ${apiResponse.facetCount}");
print("items: ${apiResponse.hits}");

```