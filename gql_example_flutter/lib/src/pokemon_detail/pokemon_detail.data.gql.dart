import 'package:gql_example_flutter/fragments.gql.dart' as _i1;

class $PokemonDetail {
  const $PokemonDetail(this.data);

  final Map<String, dynamic> data;

  $PokemonDetail$pokemon get pokemon =>
      $PokemonDetail$pokemon((data['pokemon'] as Map<String, dynamic>));
}

class $PokemonDetail$pokemon implements _i1.$PokemonCard {
  const $PokemonDetail$pokemon(this.data);

  final Map<String, dynamic> data;

  String get id => (data['id'] as String);
  String get name => (data['name'] as String);
  int get maxHP => (data['maxHP'] as int);
  String get image => (data['image'] as String);
  $PokemonDetail$pokemon$weight get weight =>
      $PokemonDetail$pokemon$weight((data['weight'] as Map<String, dynamic>));
  $PokemonDetail$pokemon$height get height =>
      $PokemonDetail$pokemon$height((data['height'] as Map<String, dynamic>));
}

class $PokemonDetail$pokemon$weight {
  const $PokemonDetail$pokemon$weight(this.data);

  final Map<String, dynamic> data;

  String get minimum => (data['minimum'] as String);
  String get maximum => (data['maximum'] as String);
}

class $PokemonDetail$pokemon$height {
  const $PokemonDetail$pokemon$height(this.data);

  final Map<String, dynamic> data;

  String get minimum => (data['minimum'] as String);
  String get maximum => (data['maximum'] as String);
}
