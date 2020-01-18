import 'package:gql_code_builder/src/built_request.dart' as _i1;
import 'package:gql_example_flutter/src/pokemon_detail/pokemon_detail.data.gql.dart'
    as _i2;
import 'package:gql_example_flutter/src/pokemon_detail/pokemon_detail.op.gql.dart'
    as _i3;

class PokemonDetail extends _i1.BuiltRequest<_i2.$PokemonDetail> {
  PokemonDetail()
      : super(operation: _i3.PokemonDetail, variables: <String, dynamic>{});

  set id(String value) => variables['id'] = value;
  set name(String value) => variables['name'] = value;
  _i2.$PokemonDetail parse(Map<String, dynamic> json) =>
      _i2.$PokemonDetail(json);
}
