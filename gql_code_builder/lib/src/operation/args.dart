import "package:built_collection/built_collection.dart";
import "package:code_builder/code_builder.dart";
import "package:gql/ast.dart";
import "package:gql_code_builder/src/common.dart";

List<Class> buildOperationArgsClasses(
  DocumentNode doc,
  DocumentNode schema,
  String opDocUrl,
  String dataDocUrl,
  String schemaUrl,
) =>
    doc.definitions
        .whereType<OperationDefinitionNode>()
        .map(
          (op) => _buildOperationArgsClass(
            op,
            schema,
            opDocUrl,
            dataDocUrl,
            schemaUrl,
          ),
        )
        .toList();

Class _buildOperationArgsClass(
  OperationDefinitionNode node,
  DocumentNode schema,
  String opDocUrl,
  String dataDocUrl,
  String schemaUrl,
) =>
    Class(
      (b) => b
        ..name = node.name.value
        ..extend = TypeReference((b) => b
          ..symbol = "BuiltRequest"
          ..url = "package:gql_code_builder/src/built_request.dart"
          ..types.add(refer("\$${node.name.value}", dataDocUrl)))
        ..constructors = ListBuilder<Constructor>(<Constructor>[
          Constructor(
            (b) => b
              ..initializers = ListBuilder<Code>(<Code>[
                refer(
                  "super",
                ).call(
                  [],
                  {
                    "operation": refer(
                      node.name.value,
                      opDocUrl,
                    ),
                    "variables": literalMap(
                      {},
                      refer("String"),
                      refer("dynamic"),
                    )
                  },
                ).code,
              ]),
          ),
        ])
        ..methods = _buildMethods(
          node,
          schema,
          opDocUrl,
          dataDocUrl,
          schemaUrl,
        ),
    );

ListBuilder<Method> _buildMethods(
  OperationDefinitionNode node,
  DocumentNode schema,
  String opDocUrl,
  String dataDocUrl,
  String schemaUrl,
) =>
    ListBuilder(<Method>[
      ...node.variableDefinitions.map<Method>(
        (VariableDefinitionNode node) => _buildSetter(
          node,
          schema,
          opDocUrl,
          schemaUrl,
        ),
      ),
      _buildParse(node, dataDocUrl)
    ]);

Method _buildParse(OperationDefinitionNode node, String dataDocUrl) =>
    Method((b) => b
      ..returns = refer("\$${node.name.value}", dataDocUrl)
      ..name = "parse"
      ..requiredParameters = ListBuilder<Parameter>(<Parameter>[
        Parameter((b) => b
          ..type = refer("Map<String, dynamic>")
          ..name = "json")
      ])
      ..lambda = true
      ..body =
          refer("\$${node.name.value}", dataDocUrl).call([refer("json")]).code);

Method _buildSetter(
  VariableDefinitionNode node,
  DocumentNode schema,
  String opDocUrl,
  String schemaUrl,
) {
  final unwrappedTypeNode = _unwrapTypeNode(node.type);
  final typeName = unwrappedTypeNode.name.value;
  final argTypeDef = _getTypeDefinitionNode(
    schema,
    typeName,
  );

  final typeMap = {
    ...defaultTypeMap,
    if (argTypeDef != null) typeName: refer(typeName, schemaUrl),
  };

  final argType = typeRef(
    node.type,
    typeMap,
  );
  final unwrappedArgType = typeRef(
    unwrappedTypeNode,
    typeMap,
  );

  return Method(
    (b) => b
      ..name = node.variable.name.value
      ..type = MethodType.setter
      ..requiredParameters = ListBuilder<Parameter>(
        <Parameter>[
          Parameter(
            (b) => b
              ..type = argType
              ..name = "value",
          ),
        ],
      )
      ..lambda = true
      ..body = refer("variables")
          .index(
            literalString(node.variable.name.value),
          )
          .assign(
            (node.type is ListTypeNode &&
                    (argTypeDef is InputObjectTypeDefinitionNode ||
                        argTypeDef is ScalarTypeDefinitionNode ||
                        argTypeDef is EnumTypeDefinitionNode))
                ? refer("value")
                    .property("map")
                    .call(
                      [
                        Method(
                          (b) => b
                            ..requiredParameters = ListBuilder<Parameter>(
                              <Parameter>[
                                Parameter(
                                  (b) => b
                                    ..type = unwrappedArgType
                                    ..name = "e",
                                ),
                              ],
                            )
                            ..lambda = true
                            ..body = (argTypeDef
                                        is InputObjectTypeDefinitionNode
                                    ? refer("e").property("input")
                                    : argTypeDef is ScalarTypeDefinitionNode ||
                                            argTypeDef is EnumTypeDefinitionNode
                                        ? refer("e").property("value")
                                        : refer("e"))
                                .code,
                        ).closure,
                      ],
                    )
                    .property("toList")
                    .call([])
                : argTypeDef is InputObjectTypeDefinitionNode
                    ? refer("value").property("input")
                    : argTypeDef is ScalarTypeDefinitionNode ||
                            argTypeDef is EnumTypeDefinitionNode
                        ? refer("value").property("value")
                        : refer("value"),
          )
          .code,
  );
}

TypeDefinitionNode _getTypeDefinitionNode(
  DocumentNode schema,
  String name,
) =>
    schema.definitions.whereType<TypeDefinitionNode>().firstWhere(
          (node) => node.name.value == name,
          orElse: () => null,
        );

NamedTypeNode _unwrapTypeNode(
  TypeNode node,
) {
  if (node is NamedTypeNode) {
    return node;
  }

  if (node is ListTypeNode) {
    return _unwrapTypeNode(node.type);
  }

  return null;
}
