import 'package:consultacep/models/viacep_model.dart';
import 'package:consultacep/pages/cadastrados_cep.dart';
import 'package:consultacep/repositories/viacep_repository.dart';
import 'package:flutter/material.dart';

class ConsultaCEP extends StatefulWidget {
  const ConsultaCEP({super.key});

  @override
  State<ConsultaCEP> createState() => _ConsultaCEPState();
}

class _ConsultaCEPState extends State<ConsultaCEP> {
  TextEditingController textoCEP = TextEditingController();
  var statusCode = 0;
  ViaCEPHTTPRepository instanciaRepository = ViaCEPHTTPRepository();
  var carregando = false;
  CEPs cepInstancia = CEPs.criarVazio();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 192, 177, 41),
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Consultar CEP",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
            body: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        const Text(
                          "Digite seu CEP",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          controller: textoCEP,
                          onChanged: (String value) async {
                            var CepInformado =
                                value.replaceAll(RegExp(r'[^0-9]'), '');

                            if (CepInformado.trim().length == 8) {
                              setState(() {
                                carregando = true;
                              });
                              cepInstancia = await instanciaRepository
                                  .pegarCEPViaCEP(CepInformado);
                              FocusManager.instance.primaryFocus?.unfocus();
                              print(cepInstancia.logradouro);
                              statusCode = await instanciaRepository
                                  .obterCEPEspecifico(cepInstancia.cep);
                              print(statusCode);
                              setState(() {
                                carregando = false;
                              });
                            } else {
                              cepInstancia.cep = "";
                              cepInstancia.localidade = "";
                              cepInstancia.logradouro = "";
                              cepInstancia.uf = "";
                              carregando = false;
                            }
                            setState(() {});
                          },
                        ),
                        carregando == true
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : cepInstancia.localidade == ""
                                ? textoCEP.text.length == 8
                                    ? const Text("CEP Inválido",
                                        style: TextStyle(fontSize: 22))
                                    : const Text(
                                        "Indique um CEP Válido",
                                        style: TextStyle(fontSize: 22),
                                      )
                                : Expanded(
                                    child: Column(children: [
                                    const Icon(
                                      Icons.home,
                                      size: 50,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      cepInstancia.cep,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      cepInstancia.logradouro,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      "${cepInstancia.localidade} - ${cepInstancia.uf}",
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 200,
                                      child: statusCode == 1
                                          ? Text(
                                              "Cep Já Cadastrado",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            )
                                          : ElevatedButton(
                                              onPressed: () async {
                                                try {
                                                  await instanciaRepository
                                                      .salvarCEP(cepInstancia);
                                                } catch (e) {
                                                  throw e;
                                                }
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "CEP Cadastrado!")));
                                                textoCEP.text = "";
                                                cepInstancia =
                                                    CEPs.criarVazio();
                                                setState(() {});
                                              },
                                              child: Text(
                                                "Cadastrar CEP",
                                                style: TextStyle(fontSize: 20),
                                              )),
                                    ),
                                  ])),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
