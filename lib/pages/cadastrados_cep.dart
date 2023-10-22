import 'package:consultacep/models/viacep_model.dart';
import 'package:consultacep/pages/cadastrados_cep.dart';
import 'package:consultacep/repositories/viacep_repository.dart';
import 'package:flutter/material.dart';

class CadastradosCEPs extends StatefulWidget {
  const CadastradosCEPs({super.key});

  @override
  State<CadastradosCEPs> createState() => _CadastradosCEPsState();
}

class _CadastradosCEPsState extends State<CadastradosCEPs> {
  TextEditingController controllerEditar = TextEditingController();
  ViaCEPHTTPRepository instanciaRepository = ViaCEPHTTPRepository();
  var _cepLista = ViaCEPModel([]);

  TextEditingController ruaController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController cepController = TextEditingController();

  var carregando = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    setState(() {
      carregando = true;
    });
    _cepLista = await instanciaRepository.obterCEP();
    setState(() {
      carregando = false;
    });
  }

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
                    "CEPs Cadastrados",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.list,
                    color: Colors.blue,
                    size: 30,
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: carregando == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: _cepLista.ceps.length,
                          itemBuilder: (_, int index) {
                            var cepCad = _cepLista.ceps[index];
                            return Dismissible(
                              onDismissed: (direcao) {},
                              key: GlobalKey(),
                              child: SizedBox(
                                height: 120,
                                child: Column(
                                  children: [
                                    ListTile(
                                        leading: const Icon(
                                          Icons.maps_home_work,
                                          size: 40,
                                          color:
                                              Color.fromARGB(255, 16, 171, 199),
                                        ),
                                        title: Center(
                                            child: Text(
                                          cepCad.cep,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )),
                                        trailing: Text(
                                          cepCad.bairro,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                ruaController.text =
                                                    cepCad.logradouro;
                                                estadoController.text =
                                                    cepCad.uf;
                                                cepController.text = cepCad.cep;
                                                bairroController.text =
                                                    cepCad.bairro;
                                                cidadeController.text =
                                                    cepCad.localidade;
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext bc) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            "Alterar CEP"),
                                                        content:
                                                            Wrap(children: [
                                                          Column(
                                                            children: [
                                                              TextField(
                                                                readOnly: true,
                                                                controller:
                                                                    cepController,
                                                              ),
                                                              TextField(
                                                                controller:
                                                                    ruaController,
                                                              ),
                                                              TextField(
                                                                controller:
                                                                    bairroController,
                                                              ),
                                                              TextField(
                                                                controller:
                                                                    cidadeController,
                                                              ),
                                                              TextField(
                                                                controller:
                                                                    estadoController,
                                                              ),
                                                            ],
                                                          ),
                                                        ]),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  "Cancelar")),
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                cepCad.logradouro =
                                                                    ruaController
                                                                        .text;

                                                                cepCad.uf =
                                                                    estadoController
                                                                        .text;

                                                                cepCad.bairro =
                                                                    bairroController
                                                                        .text;
                                                                cepCad.localidade =
                                                                    cidadeController
                                                                        .text;
                                                                await instanciaRepository
                                                                    .alterarCEP(
                                                                        cepCad);
                                                                Navigator.pop(
                                                                    context);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          "CEP Alterado com Sucesso")),
                                                                );
                                                                carregarDados();
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                  "Salvar"))
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: const Icon(Icons.edit)),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          ElevatedButton(
                                              onPressed: () async {
                                                await instanciaRepository
                                                    .deletarCEP(
                                                        cepCad.objectId);
                                                await carregarDados();
                                                setState(() {});
                                              },
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red)),
                                              child: const Icon(Icons.delete)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                ),
              ],
            )));
  }
}
