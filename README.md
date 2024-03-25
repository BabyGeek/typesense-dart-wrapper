
## Getting Started

Instanciate the service

```dart
    final searchService = SearchService(
        apiKey: TYPESENSE_ITGRATE_API_KEY, host: InternetAddress.loopbackIPv4);
```

If you are running in local and need to setup the collection for testing purpose, you need to set them up by yourself, here is an example based on Cocktail project

```dart
  void setUpCollections() async {
    // More likely server side

    // Delete collections if you need to update them, if first set up you can skip this lines
    await client.collection(COCKTAIL_COLLECTION_NAME).delete();
    await client.collection(USER_COLLECTION_NAME).delete();

    // Retreive existing collections
    collections.addAll(await client.collections.retrieve());

    // Add the new collections if they do not exists on the server
    // Here we use name as the default string field for sorting results
    if (!collectionAlreadyExists(COCKTAIL_COLLECTION_NAME)) {
      final cocktailSchema = await createCollection(
          COCKTAIL_COLLECTION_NAME,
          {
            Field("name", type: Type.string, sort: true),
            Field("ingredients.ingredient_id",
                type: Type.string, isMultivalued: true, isFacetable: true),
            Field("serving_style_id", type: Type.string, isFacetable: true),
            autoSchemaDetectionField
          },
          enableNestedFields: true);

      collections.add(cocktailSchema);
    } else {
      print("Collection $COCKTAIL_COLLECTION_NAME already exists");
    }

    if (!collectionAlreadyExists(USER_COLLECTION_NAME)) {
      final userSchema = await createCollection(
          USER_COLLECTION_NAME,
          {
            Field("name", type: Type.string, sort: true),
            autoSchemaDetectionField
          },
          enableNestedFields: true);
      collections.add(userSchema);
    } else {
      print("Collection $USER_COLLECTION_NAME already exists");
    }

    if (!collectionAlreadyExists(INGREDIENT_COLLECTION_NAME)) {
      final ingredientSchema = await createCollection(
          INGREDIENT_COLLECTION_NAME,
          {
            autoSchemaDetectionField
          });

      collections.add(ingredientSchema);
    } else {
      print("Collection $INGREDIENT_COLLECTION_NAME already exists");
    }

    if (!collectionAlreadyExists(SERVING_STYLE_COLLECTION_NAME)) {
      final servingStyleSchema = await createCollection(
          SERVING_STYLE_COLLECTION_NAME, {autoSchemaDetectionField});

      collections.add(servingStyleSchema);
    } else {
      print("Collection $SERVING_STYLE_COLLECTION_NAME already exists");
    }

    // Populate the collections using firebase

    final cocktailsSnapshot =
        await GetIt.I.get<FirebaseFirestore>().collection("cocktails").get();
    final cocktails = cocktailsSnapshot.docs.map((e) => e.data());

    client
        .collection(COCKTAIL_COLLECTION_NAME)
        .documents
        .importDocuments(cocktails.toList());

    final usersSnapshot =
        await GetIt.I.get<FirebaseFirestore>().collection("users").get();
    final users = usersSnapshot.docs.map((e) => e.data());
    client
        .collection(USER_COLLECTION_NAME)
        .documents
        .importDocuments(users.toList());

    final ingredientsSnapshot =
        await GetIt.I.get<FirebaseFirestore>().collection("ingredients").get();
    final ingredients = ingredientsSnapshot.docs.map((e) => e.data());

    client
        .collection(INGREDIENT_COLLECTION_NAME)
        .documents
        .importDocuments(ingredients.toList());

    final servingStylesSnapshot = await GetIt.I
        .get<FirebaseFirestore>()
        .collection("serving_styles")
        .get();
    final servingStyles = servingStylesSnapshot.docs.map((e) => e.data());

    client
        .collection(SERVING_STYLE_COLLECTION_NAME)
        .documents
        .importDocuments(servingStyles.toList());
  }

  bool collectionAlreadyExists(String name) {
    return collections.any((collection) => collection.name == name);
  }

  Future<Schema> createCollection(String name, Set<Field> fields,
      {Field? defaultSortingField,
      int? documentCount,
      bool? enableNestedFields}) async {
    return await client.collections.create(Schema(name, fields,
        defaultSortingField: defaultSortingField,
        documentCount: documentCount,
        enableNestedFields: enableNestedFields));
  }
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

Here are some examples based on Cocktail project:

- Filter by name
```dart

    final apiResponse = await searchService.search<Cocktail>(
        searchTerm, COCKTAIL_COLLECTION_NAME,
        queryBy: COCKTAIL_COLLECTION_QUERY_BY_NAME,
        limit: 20,
        fromJson: Cocktail.fromJson);
```

- Filter by Serving Style ID (here ID `QDgzZ1r6WDPWEAny5pxZ`)
```dart
    final apiResponse = await searchService.search<Cocktail>(
        "QDgzZ1r6WDPWEAny5pxZ", COCKTAIL_COLLECTION_NAME,
        queryBy: COCKTAIL_COLLECTION_QUERY_BY_SERVING_STYLE, limit: 20, fromJson: Cocktail.fromJson);
```

or 

```dart
    final apiResponse = await searchService.search<Cocktail>(
        "", COCKTAIL_COLLECTION_NAME,
        queryBy: COCKTAIL_COLLECTION_QUERY_BY_NAME,
        filterBy:
            "${COCKTAIL_COLLECTION_FILTER_BY_SERVING_STYLE}QDgzZ1r6WDPWEAny5pxZ",
        limit: 20,
        fromJson: Cocktail.fromJson);
```

- Filter by name and Serving Style

```dart
    final apiResponse = await searchService.search<Cocktail>(
        searchTerm, COCKTAIL_COLLECTION_NAME,
        queryBy: COCKTAIL_COLLECTION_QUERY_BY_NAME,
        filterBy:
            "${COCKTAIL_COLLECTION_FILTER_BY_SERVING_STYLE}QDgzZ1r6WDPWEAny5pxZ",
        limit: 20,
        fromJson: Cocktail.fromJson);
```

- Filter by multiple ingredient IDs
```dart
     final apiResponse = await this.search<Cocktail>(
         "", COCKTAIL_COLLECTION_NAME,
         queryBy: COCKTAIL_COLLECTION_QUERY_BY_NAME,
         filterBy:
             "${COCKTAIL_COLLECTION_FILTER_BY_INGREDIENT}[4q4UCQAVmrlP9FxpfSL2, EMnTL6wSV5xIqHbYLCdM]",
         limit: 20,
         fromJson: Cocktail.fromJson);
```

- Filter by multiple ingredient IDs, name and serving style
```dart
     final apiResponse = await this.search<Cocktail>(
         search, COCKTAIL_COLLECTION_NAME,
         queryBy: COCKTAIL_COLLECTION_QUERY_BY_NAME,
         filterBy:
             "${COCKTAIL_COLLECTION_FILTER_BY_SERVING_STYLE}QDgzZ1r6WDPWEAny5pxZ && ${COCKTAIL_COLLECTION_FILTER_BY_INGREDIENT}[4q4UCQAVmrlP9FxpfSL2, EMnTL6wSV5xIqHbYLCdM]",
         limit: 20,
         fromJson: Cocktail.fromJson);
```

The object apiResponse can be used like so:

```dart
print("total item found: ${apiResponse.found}");
print("Facet count: ${apiResponse.facetCount}");
print("items: ${apiResponse.hits}");

```

### References to used constants
```dart
final autoSchemaDetectionField = Field(".*", type: Type.auto);

const COCKTAIL_COLLECTION_NAME = "cocktails";
const COCKTAIL_COLLECTION_QUERY_BY_NAME = "name";
const COCKTAIL_COLLECTION_QUERY_BY_SERVING_STYLE = "serving_style_id";
const COCKTAIL_COLLECTION_FILTER_BY_SERVING_STYLE = "serving_style_id:=";
const COCKTAIL_COLLECTION_FILTER_BY_INGREDIENT = "ingredients.ingredient_id:";
const COCKTAIL_COLLECTION_FILTER_BY_TASTE = "tastes.id:";
```