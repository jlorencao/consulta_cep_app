class CepBack4AppModel {
  List<CEP> results = [];

  CepBack4AppModel(this.results);

  CepBack4AppModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <CEP>[];
      json['results'].forEach((v) {
        results.add(CEP.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

class CEP {
  String objectId = "";
  String cep = "";
  String logradouro = "";
  String localidade = "";
  String uf = "";
  String createdAt = "";
  String updatedAt = "";

  CEP(this.objectId, this.cep, this.logradouro, this.localidade, this.uf,
      this.createdAt, this.updatedAt);

  CEP.create(this.cep, this.logradouro, this.localidade, this.uf);

  CEP.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    cep = json['cep'];
    logradouro = json['logradouro'];
    localidade = json['localidade'];
    uf = json['uf'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cep'] = cep;
    data['logradouro'] = logradouro;
    data['localidade'] = localidade;
    data['uf'] = uf;

    return data;
  }
}
