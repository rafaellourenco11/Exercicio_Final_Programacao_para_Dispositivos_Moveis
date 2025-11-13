
const String tableFilmes = 'filmes';
const String columnId = '_id';
const String columnUrlImagem = 'urlImagem';
const String columnTitulo = 'titulo';
const String columnGenero = 'genero';
const String columnFaixaEtaria = 'faixaEtaria';
const String columnDuracao = 'duracao';
const String columnPontuacao = 'pontuacao';
const String columnDescricao = 'descricao';
const String columnAno = 'ano';

class Filme {
  int? id;
  String urlImagem;
  String titulo;
  String genero;
  String faixaEtaria;
  String duracao;
  double pontuacao;
  String descricao;
  String ano;

  Filme({
    this.id,
    required this.urlImagem,
    required this.titulo,
    required this.genero,
    required this.faixaEtaria,
    required this.duracao,
    required this.pontuacao,
    required this.descricao,
    required this.ano,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnUrlImagem: urlImagem,
      columnTitulo: titulo,
      columnGenero: genero,
      columnFaixaEtaria: faixaEtaria,
      columnDuracao: duracao,
      columnPontuacao: pontuacao,
      columnDescricao: descricao,
      columnAno: ano,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Filme.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        urlImagem = map[columnUrlImagem],
        titulo = map[columnTitulo],
        genero = map[columnGenero],
        faixaEtaria = map[columnFaixaEtaria],
        duracao = map[columnDuracao],
        pontuacao = map[columnPontuacao] is int
            ? (map[columnPontuacao] as int).toDouble()
            : map[columnPontuacao] as double,
        descricao = map[columnDescricao],
        ano = map[columnAno];
}