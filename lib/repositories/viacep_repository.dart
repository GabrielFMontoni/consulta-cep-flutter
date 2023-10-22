import 'package:consultacep/models/viacep_model.dart';
import 'package:consultacep/repositories/back4app_dio_custom_repository.dart';
import 'package:dio/dio.dart';

class ViaCEPHTTPRepository {
  final _customDio = Back4AppCustomDio();
  ViaCEPHTTPRepository();

  Future<CEPs> pegarCEPViaCEP(String cep) async {
    Dio dio = Dio();
    var response = await dio.get("https://viacep.com.br/ws/$cep/json/");
    var retornoData = response.data;
    if (retornoData["erro"] != null) {
      return CEPs.criarVazio();
    } else {
      if (response.statusCode == 200) {
        return CEPs.fromJsonViaCep(retornoData);
      } else {
        return CEPs.criarVazio();
      }
    }
  }

  Future<ViaCEPModel> obterCEP() async {
    var url = "/CEPs";
    var result = await _customDio.dio.get(url);
    return ViaCEPModel.fromJson(result.data);
  }

  Future<int> obterCEPEspecifico(String cep) async {
    var url = "/CEPs/?where={\"cep\":\"$cep\"} ";
    try {
      var result = await _customDio.dio.get(url);
      print(result.data["results"].length);
      if (result.data["results"].length == 0) {
        return 0;
      }
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<CEPs> obterCEPEspecificoAlterar(CEPs cepParam) async {
    var url = "/CEPs/?where={\"cep\":\"${cepParam.cep}\"} ";
    try {
      var result = await _customDio.dio.get(url);
      print(result.data["results"].length);
      return await CEPs.fromJson(result.data);
    } catch (e) {
      return CEPs.criarVazio();
    }
  }

  Future<void> salvarCEP(CEPs cep) async {
    try {
      var url = "/CEPs";
      await _customDio.dio.post(url, data: cep.salvarJson());
    } catch (e) {
      throw e;
    }
  }

  Future<void> deletarCEP(String id) async {
    try {
      var url = "/CEPs/${id}";
      await _customDio.dio.delete(url);
    } catch (e) {
      throw e;
    }
  }

  Future<void> alterarCEP(CEPs cep) async {
    try {
      var url = "/CEPs/${cep.objectId}";
      await _customDio.dio.put(url, data: cep.salvarJson());
    } catch (e) {
      throw e;
    }
  }

  // Future<void> cadastrarCEP(ViaCEPModel)
}
