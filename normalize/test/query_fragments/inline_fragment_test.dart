import "package:gql/language.dart";
import "package:normalize/normalize.dart";
import "package:test/test.dart";

import "../shared_data.dart";

void main() {
  group("Inline Fragment", () {
    final query = parseString("""
    query TestQuery {
      posts {
        id
        __typename
        ... on Post {
          author {
            ... on Author {
              id
              __typename
              name
            }
          }
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

    test("Produces correct normalized object", () {
      expect(normalize(query: query, data: sharedResponse),
          equals(sharedNormalizedMap));
    });

    test("Produces correct nested data object", () {
      expect(denormalize(query: query, normalizedMap: sharedNormalizedMap),
          equals(sharedResponse));
    });
  });
}
