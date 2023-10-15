import 'package:flutter/material.dart';
import 'package:via_cep_app/model/cep_back4app_model.dart';
import 'package:via_cep_app/model/cep_viacep_model.dart';
import 'package:via_cep_app/repositories/cep_back4app_repository.dart';
import 'package:via_cep_app/repositories/cep_viacep_repository.dart';

class ConsultaCepPage extends StatefulWidget {
  const ConsultaCepPage({super.key});

  @override
  State<ConsultaCepPage> createState() => _ConsultaCepPageState();
}

class _ConsultaCepPageState extends State<ConsultaCepPage> {
  final cepRepository = CepFromViaCepRepository();
  CepFromViaCep? cepModel;
  bool loading = false;
  bool loadingListView = true;
  var cepBack4AppModel = CepBack4AppModel([]);
  var cepBack4AppRepository = CepBack4AppRepository();
  bool cepExistsInBackforApp = false;
  bool listLoaded = false;

  @override
  void initState() {
    obterCepFromBack4AppApi();
    cepModel = null;
    super.initState();
  }

  void obterCepFromBack4AppApi() async {
    setState(() {
      loadingListView = true;
    });
    cepBack4AppModel = await cepBack4AppRepository.getCepList();
    setState(() {
      listLoaded = true;
      loadingListView = false;
    });
  }

  Future<void> obterUmCepFromBack4AppApi(String cep) async {
    cepExistsInBackforApp = await cepBack4AppRepository.getSingleCep(cep);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Consulta Cep"),
          backgroundColor: Colors.greenAccent.shade100,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
                decoration: const InputDecoration(
                  label: Text("Digite o Cep"),
                  contentPadding: EdgeInsets.zero,
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                ),
                onChanged: (value) async {
                  cepExistsInBackforApp = false;
                  var cep = value.replaceAll(RegExp(r'[^0-9]'), '');
                  var cepToConsult =
                      "${cep.substring(0, 5)}-${cep.substring(5, cep.length)}";
                  if (cep.length == 8) {
                    //search cep on ViaCepAPI and set loading true
                    setState(() {
                      loading = true;
                    });
                    obterUmCepFromBack4AppApi(cepToConsult);
                    cepModel = await CepFromViaCepRepository.getCepFromApi(cep);
                    //if cepModel.cep != null verify if cep exists on back4App API
                    setState(() {
                      loading = false;
                    });
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            (loading)
                ? const CircularProgressIndicator()
                : (cepModel != null)
                    ? SizedBox(
                        width: double.infinity,
                        child: Card(
                          shape: const OutlineInputBorder(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(cepModel?.cep ?? "",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(cepModel?.logradouro ?? "",
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  "${cepModel?.localidade ?? ""} - ${cepModel?.uf ?? ""}",
                                  style: const TextStyle(fontSize: 16)),
                              //if cep exist in back4app show a text "Cep ja salvo"
                              (cepExistsInBackforApp)
                                  ? Text("Cep Ja Salvo")
                                  :
                                  //else TextButton to create cep
                                  TextButton(
                                      onPressed: () {
                                        //create a new cep
                                        if (cepModel?.cep != null) {
                                          cepBack4AppRepository.createCep(
                                              CEP.create(
                                                  "${cepModel!.cep}",
                                                  "${cepModel!.logradouro}",
                                                  "${cepModel!.localidade}",
                                                  "${cepModel!.uf}"));
                                          obterCepFromBack4AppApi();
                                          obterUmCepFromBack4AppApi(
                                              "${cepModel?.cep}");
                                          setState(() {});
                                        }
                                      },
                                      child: const Text("Salvar CEP")),
                            ],
                          ),
                        ),
                      )
                    : const Text("Digite para ver os dados do CEP"),
            const SizedBox(
              height: 20,
            ),
            if (loadingListView) const CircularProgressIndicator(),
            (cepBack4AppModel.results.isNotEmpty)
                ? Expanded(
                    child: ListView.builder(
                      itemCount: cepBack4AppModel.results.length,
                      itemBuilder: (BuildContext bc, int index) {
                        var cep = cepBack4AppModel.results[index];
                        return Text("${cep.cep} - ${cep.localidade}");
                      },
                    ),
                  )
                : (listLoaded)
                    ? const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                            "Adicione um CEP a sua lista para ve-lo aqui!"),
                      )
                    : Container()
          ]),
        ),
      ),
    );
  }
}
