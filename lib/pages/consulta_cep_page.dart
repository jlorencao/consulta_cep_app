import 'package:flutter/material.dart';
import 'package:via_cep_app/model/cep_viacep_model.dart';
import 'package:via_cep_app/repositories/cep_viacep_repository.dart';

class ConsultaCepPage extends StatefulWidget {
  const ConsultaCepPage({super.key});

  @override
  State<ConsultaCepPage> createState() => _ConsultaCepPageState();
}

class _ConsultaCepPageState extends State<ConsultaCepPage> {
  final cepRepository = CepFromViaCepRepository();
  var cepModel = CepFromViaCep();
  bool loading = false;
  var cepController = TextEditingController(text: " ");

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
        child: Column(
          children: [
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
                  var cep = value;
                  if (cep.length == 8) {
                    setState(() {
                      loading = true;
                    });
                    cepModel = await CepFromViaCepRepository.getCepFromApi(cep);
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
            if (loading) const CircularProgressIndicator(),
            SizedBox(
              height: 100,
              width: double.infinity,
              child: Card(
                shape: const OutlineInputBorder(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(cepModel.cep ?? "",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(cepModel.logradouro ?? "",
                        style: const TextStyle(fontSize: 16)),
                    Text("${cepModel.localidade ?? ""} - ${cepModel.uf ?? ""}",
                        style: const TextStyle(fontSize: 16))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
