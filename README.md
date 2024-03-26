
## Installation

## Getting Started

Instanciate the service

```dart
    final searchService = TypesenseSearch(
        apiKey: TYPESENSE_API_KEY, host: InternetAddress.loopbackIPv4);
```

## Filter

To use filtering you have to call the search method.

```dart
Future<dynamic> search<T>(String collectionName,
      {required Parameters parameters,
      required T Function(Map<String, dynamic>) fromJson}) async { } 
```

The object apiResponse can be used like so if it is not grouped by request:

```dart
print("total item found: ${apiResponse.found}");
print("Facet count: ${apiResponse.facetCount}");
print("items: ${apiResponse.hits}");
```

If it is a grouped by request:

```dart
print("total item found: ${apiResponse.foundDocs}");
print("total group found: ${apiResponse.found}");
print("Facet count: ${apiResponse.facetCount}");
print("items: ${apiResponse.groupedHits}");
```
