import "package:test/test.dart";
import 'package:gql/language.dart';

import 'package:normalize/normalize.dart';

void main() {
  group("Simple", () {
    final query = parseString("""
    query TestQuery {
      posts {
        id
        __typename
        author {
          id
          __typename
          name
        }
        title
        comments {
          id
          __typename
          commenter {
            id
            __typename
            name
          }
        }
      }
    }
  """);

    final data = {
      "posts": [
        {
          "id": "123",
          "__typename": "Post",
          "author": {"id": "1", "__typename": "Author", "name": "Paul"},
          "title": "My awesome blog post",
          "comments": [
            {
              "id": "324",
              "__typename": "Comment",
              "commenter": {"id": "2", "__typename": "Author", "name": "Nicole"}
            }
          ]
        }
      ]
    };

    final normalizedMap = {
      "Query": {
        "posts": [
          {"\$ref": "Post:123"}
        ]
      },
      "Post:123": {
        "id": "123",
        "__typename": "Post",
        "author": {"\$ref": "Author:1"},
        "title": "My awesome blog post",
        "comments": [
          {"\$ref": "Comment:324"}
        ]
      },
      "Author:1": {"id": "1", "__typename": "Author", "name": "Paul"},
      "Comment:324": {
        "id": "324",
        "__typename": "Comment",
        "commenter": {"\$ref": "Author:2"}
      },
      "Author:2": {"id": "2", "__typename": "Author", "name": "Nicole"}
    };

    test("Produces correct normalized object", () {
      expect(normalize(query: query, data: data), equals(normalizedMap));
    });

    test("Produces correct nested data object", () {
      expect(denormalize(query: query, normalizedMap: normalizedMap),
          equals(data));
    }, skip: true);
  });
}
