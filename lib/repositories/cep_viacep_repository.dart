import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:via_cep_app/model/cep_viacep_model.dart';

class CepFromViaCepRepository {
  static var baseUrl = "https://viacep.com.br/ws/";

  static Future<CepFromViaCep> getCepFromApi(String cep) async {
    final consultaUrl = "$baseUrl$cep/json/";
    final uri = Uri.parse(consultaUrl);

    //Call to ViaCep API
    final response = await http.get(uri);

    //get json from response
    final jsonString = response.body;
    final responseMap = jsonDecode(jsonString);
    final cepFromApi = CepFromViaCep.fromJson(responseMap);

    return cepFromApi;
  }
}
