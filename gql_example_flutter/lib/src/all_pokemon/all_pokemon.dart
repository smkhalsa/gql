import 'package:flutter/material.dart';
import 'package:gql_exec/gql_exec.dart';

import './all_pokemon.req.gql.dart';
import '../config.dart';
import '../pokemon_card/pokemon_card.dart';

class AllPokemonScreen extends StatelessWidget {
  final request = AllPokemon()..first = 500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Pokemon'),
      ),
      body: StreamBuilder(
        stream: link.request(request),
        builder: (BuildContext build, AsyncSnapshot<Response> snapshot) {
          if (snapshot.data?.data == null)
            return Center(child: CircularProgressIndicator());

          final data = request.parse(snapshot.data.data);

          return ListView.builder(
            itemCount: data.pokemons.length,
            itemBuilder: (context, index) => PokemonCard(
              pokemon: data.pokemons[index],
            ),
          );
        },
      ),
    );
  }
}
