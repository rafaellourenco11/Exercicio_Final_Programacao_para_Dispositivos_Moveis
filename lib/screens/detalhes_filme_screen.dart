
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/filme.dart';

class DetalhesFilmeScreen extends StatelessWidget {
  final Filme filme;

  const DetalhesFilmeScreen({super.key, required this.filme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(
                  image: NetworkImage(filme.urlImagem),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          filme.titulo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(blurRadius: 5.0, color: Colors.black)
                            ],
                          ),
                        ),
                        RatingBarIndicator(
                          rating: filme.pontuacao,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Ano: ${filme.ano}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Duração: ${filme.duracao}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Gênero: ${filme.genero}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Faixa Etária: ${filme.faixaEtaria}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Divider(height: 30),
                  const Text(
                    'Descrição:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    filme.descricao,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}