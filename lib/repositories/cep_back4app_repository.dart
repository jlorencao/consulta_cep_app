import 'package:dio/dio.dart';
import 'package:via_cep_app/model/cep_back4app_model.dart';

class CepBack4AppRepository {
  static var baseUrl = "https://parseapi.back4app.com/classes";
  var _dio = Dio();

  CepBack4AppRepository() {
    _dio = Dio();
    _dio.options.headers["X-Parse-Application-Id"] =
        "XEeuSkjAEKBwdwOXl1vgGAwvqHwyNKDwodKkRDCg";
    _dio.options.headers["X-Parse-REST-API-Key"] =
        "0qCVuUtvMFNItVxfmdlrPhTxPhXKblUd3XWu3fWK";
    _dio.options.headers["content-type"] = "application/json";
    _dio.options.baseUrl = baseUrl;
  }

  Future<CepBack4AppModel> getCepList() async {
    var url = "/Cep";

    //Call to Back4App API
    var response = await _dio.get(url);

    //get json from response
    final jsonString = response.data;

    final cepFromBack4AppApi = CepBack4AppModel.fromJson(jsonString);

    return cepFromBack4AppApi;
  }

  Future<bool> getSingleCep(String cep) async {
    var url = "/Cep";

    var urlComplete = "$url?where={\"cep\":\"$cep\"}";

    //Call to Back4App API
    var response = await _dio.get(urlComplete);

    //get json from response
    final jsonString = response.data;

    final cepFromBack4AppApi = CepBack4AppModel.fromJson(jsonString);

    if (cepFromBack4AppApi.results.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> createCep(CEP cep) async {
    //Call to Back4App API
    try {
      await _dio.post("/Cep", data: cep.toJson());
    } catch (e) {
      throw e;
    }
  }
}
