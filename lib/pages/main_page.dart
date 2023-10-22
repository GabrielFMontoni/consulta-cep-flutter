import 'package:consultacep/pages/cadastrados_cep.dart';
import 'package:consultacep/pages/consultaCep.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController controllerPaginas = PageController(initialPage: 0);
  int posicaoPagina = 0;
  TextEditingController textoCEP = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
                child: PageView(
                    controller: controllerPaginas,
                    onPageChanged: (value) {
                      setState(() {
                        posicaoPagina = value;
                      });
                    },
                    children: const [
                  ConsultaCEP(),
                  CadastradosCEPs(),
                ])),
            BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: posicaoPagina,
                onTap: (value) {
                  controllerPaginas.jumpToPage(value);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.streetview),
                    label: "Consulta CEP",
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check), label: "CEPs Cadastrados")
                ])
          ],
        ),
      ),
    );
  }
}
