import "package:gql/language.dart";
import "package:normalize/normalize.dart";
import "package:test/test.dart";

void main() {
  group("Union Type Inline Fragments", () {
    final query = parseString("""
    query TestQuery {
      booksAndAuthors {
        id
        __typename
        ... on Book {
          title
        }
        ... on Author {
          name
        }
      }
    }
  """);

    final data = {
      "booksAndAuthors": [
        {"id": "123", "__typename": "Book", "title": "My awesome blog post"},
        {"id": "324", "__typename": "Author", "name": "Nicole"}
      ]
    };

    final normalizedMap = {
      "Query": {
        "booksAndAuthors": [
          {"\$ref": "Book:123"},
          {"\$ref": "Author:324"}
        ]
      },
      "Book:123": {
        "id": "123",
        "__typename": "Book",
        "title": "My awesome blog post"
      },
      "Author:324": {"id": "324", "__typename": "Author", "name": "Nicole"}
    };

    test("Produces correct normalized object", () {
      expect(normalize(query: query, data: data), equals(normalizedMap));
    });

    test("Produces correct nested data object", () {
      expect(denormalize(query: query, normalizedMap: normalizedMap),
          equals(data));
    });
  });
}
