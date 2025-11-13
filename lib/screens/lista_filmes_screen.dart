
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/filme.dart';
import '../database/database_helper.dart';
import 'cadastro_filme_screen.dart';
import 'detalhes_filme_screen.dart';

class ListaFilmesScreen extends StatefulWidget {
  const ListaFilmesScreen({super.key});

  @override
  State<ListaFilmesScreen> createState() => _ListaFilmesScreenState();
}

class _ListaFilmesScreenState extends State<ListaFilmesScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<Filme>> _filmesFuture;

  @override
  void initState() {
    super.initState();
    _recarregarFilmes();
  }

  void _recarregarFilmes() {
    setState(() {
      _filmesFuture = _dbHelper.getFilmes();
    });
  }

  void _mostrarInfoGrupo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informação do Grupo/Aluno'),
          content: const Text(
            'Projeto Final de Programação para Dispositivos Móveis.\n\nAlunos: [ Rafael de Oliveira, Rhuan Ramalho e Ruann Carneiro ]',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('FECHAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarOpcoes(Filme filme) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Exibir Dados'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalhesFilmeScreen(filme: filme),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Alterar'),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroFilmeScreen(filme: filme),
                    ),
                  );
                  if (result == true) {
                    _recarregarFilmes();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _mostrarInfoGrupo,
          ),
        ],
      ),
      body: FutureBuilder<List<Filme>>(
        future: _filmesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum filme cadastrado.\nClique no "+" para adicionar!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            final filmes = snapshot.data!;
            return ListView.builder(
              itemCount: filmes.length,
              itemBuilder: (context, index) {
                final filme = filmes[index];
                return Dismissible(
                  key: Key(filme.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirma Exclusão?"),
                          content: Text(
                              "Tem certeza que deseja deletar o filme \"${filme.titulo}\"?"),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("NÃO")),
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text("SIM")),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) async {
                    await _dbHelper.delete(filme.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${filme.titulo} removido!')),
                    );
                    _recarregarFilmes();
                  },
                  child: _buildFilmeListItem(context, filme),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CadastroFilmeScreen(),
            ),
          );
          if (result == true) {
            _recarregarFilmes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilmeListItem(BuildContext context, Filme filme) {
    return InkWell(
      onTap: () => _mostrarOpcoes(filme),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[

              Container(
                width: 70,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  image: DecorationImage(
                    image: NetworkImage(filme.urlImagem),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      filme.titulo,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gênero: ${filme.genero} | ${filme.faixaEtaria}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),

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
              const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}