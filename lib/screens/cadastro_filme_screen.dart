

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/filme.dart';
import '../database/database_helper.dart';
import '../utils/constants.dart';

class CadastroFilmeScreen extends StatefulWidget {
  final Filme? filme;

  const CadastroFilmeScreen({super.key, this.filme});

  @override
  State<CadastroFilmeScreen> createState() => _CadastroFilmeScreenState();
}

class _CadastroFilmeScreenState extends State<CadastroFilmeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();


  late TextEditingController _urlImagemController;
  late TextEditingController _tituloController;
  late TextEditingController _generoController;
  late TextEditingController _duracaoController;
  late TextEditingController _anoController;
  late TextEditingController _descricaoController;
  String _faixaEtariaSelecionada = Constants.faixasEtarias.first;
  double _pontuacao = 3.0;

  @override
  void initState() {
    super.initState();

    _urlImagemController =
        TextEditingController(text: widget.filme?.urlImagem ?? '');
    _tituloController =
        TextEditingController(text: widget.filme?.titulo ?? '');
    _generoController =
        TextEditingController(text: widget.filme?.genero ?? '');
    _duracaoController =
        TextEditingController(text: widget.filme?.duracao ?? '');
    _anoController = TextEditingController(text: widget.filme?.ano ?? '');
    _descricaoController =
        TextEditingController(text: widget.filme?.descricao ?? '');

    if (widget.filme != null) {
      _faixaEtariaSelecionada = widget.filme!.faixaEtaria;
      _pontuacao = widget.filme!.pontuacao;
    }
  }

  @override
  void dispose() {
    _urlImagemController.dispose();
    _tituloController.dispose();
    _generoController.dispose();
    _duracaoController.dispose();
    _anoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _salvarFilme() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final filme = Filme(
        id: widget.filme?.id,
        urlImagem: _urlImagemController.text,
        titulo: _tituloController.text,
        genero: _generoController.text,
        faixaEtaria: _faixaEtariaSelecionada,
        duracao: _duracaoController.text,
        pontuacao: _pontuacao,
        descricao: _descricaoController.text,
        ano: _anoController.text,
      );

      if (filme.id == null) {

        await _dbHelper.insert(filme);
      } else {

        await _dbHelper.update(filme);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isUpdating = widget.filme != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdating ? 'Alterar Filme' : 'Cadastrar Filme'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTextFormField(
                controller: _urlImagemController,
                label: 'Url Imagem',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A URL da imagem é obrigatória.';
                  }
                  return null;
                },
              ),
              _buildTextFormField(
                controller: _tituloController,
                label: 'Título',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O título é obrigatório.';
                  }
                  return null;
                },
              ),
              _buildTextFormField(
                controller: _generoController,
                label: 'Gênero',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O gênero é obrigatório.';
                  }
                  return null;
                },
              ),
              _buildFaixaEtariaDropdown(),
              _buildTextFormField(
                controller: _duracaoController,
                label: 'Duração (ex: 1h 30min)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A duração é obrigatória.';
                  }
                  return null;
                },
              ),
              _buildPontuacaoRatingBar(),
              _buildTextFormField(
                controller: _anoController,
                label: 'Ano',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 4) {
                    return 'O ano deve ter 4 dígitos.';
                  }
                  return null;
                },
              ),
              _buildTextFormField(
                controller: _descricaoController,
                label: 'Descrição',
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A descrição é obrigatória.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarFilme,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  isUpdating ? 'ALTERAR FILME' : 'CADASTRAR FILME',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  Widget _buildFaixaEtariaDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Faixa Etária',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _faixaEtariaSelecionada,
            isDense: true,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _faixaEtariaSelecionada = newValue;
                });
              }
            },
            items: Constants.faixasEtarias
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildPontuacaoRatingBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nota', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 5),
          RatingBar.builder(
            initialRating: _pontuacao,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _pontuacao = rating;
              });
            },
          ),
        ],
      ),
    );
  }
}