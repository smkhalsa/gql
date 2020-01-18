import 'package:gql_code_builder/src/built_request.dart' as _i1;
import 'package:gql_example_flutter/src/all_pokemon/all_pokemon.data.gql.dart'
    as _i2;
import 'package:gql_example_flutter/src/all_pokemon/all_pokemon.op.gql.dart'
    as _i3;

class AllPokemon extends _i1.BuiltRequest<_i2.$AllPokemon> {
  AllPokemon()
      : super(operation: _i3.AllPokemon, variables: <String, dynamic>{});

  set first(int value) => variables['first'] = value;
  _i2.$AllPokemon parse(Map<String, dynamic> json) => _i2.$AllPokemon(json);
}
