import "package:gql_exec/gql_exec.dart";

abstract class BuiltRequest<T> extends Request {
  const BuiltRequest({Operation operation, Map<String, dynamic> variables})
      : super(operation: operation, variables: variables);

  /// Parses a JSON map into the response type.
  T parse(Map<String, dynamic> json);
}
