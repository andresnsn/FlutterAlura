import 'package:flutter/material.dart';

void main() => runApp(const ByteBankApp());

class ByteBankApp extends StatelessWidget {
  const ByteBankApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListaTransferencias(),
      ),
    );
  }
}

class FormularioTransferencia extends StatefulWidget{
  FormularioTransferencia({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormularioTransferenciaState();
  }
}

class FormularioTransferenciaState extends State<FormularioTransferencia>{

  final TextEditingController controladorCampoNumeroConta =
  TextEditingController();
  final TextEditingController controladorCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criando transferência"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Editor(
              controlador: controladorCampoNumeroConta,
              rotulo: "Número da conta",
              dica: "0000",
            ),
            Editor(
              controlador: controladorCampoValor,
              rotulo: "Valor",
              dica: "0.00",
              icone: Icons.monetization_on,
            ),
            ElevatedButton(
              onPressed: () => _criaTransferencia(context),
              child: const Text("Confirmar"),
            ),
          ],
        ),
      ),
    );
  }

  void _criaTransferencia(BuildContext context) {
    final int? numeroConta =
    int.tryParse(controladorCampoNumeroConta.text);
    final double? valor = double.tryParse(controladorCampoValor.text);
    if (numeroConta != null && valor != null) {
      final transferenciaCriada = Transferencia(valor, numeroConta);
      debugPrint("Criando transferência");
      debugPrint("$transferenciaCriada");
      Navigator.pop(context, transferenciaCriada);
    }
  }
}

class Editor extends StatelessWidget {
  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;

  Editor({this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        style: const TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          icon: icone != null? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}



class ListaTransferencias extends StatefulWidget {

  ListaTransferencias({Key? key}) : super(key: key);
  final List<Transferencia?> _transferencias = [];

  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciasState();
  }

}

class ListaTransferenciasState extends State<ListaTransferencias> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transferências"),
      ),
      body: ListView.builder(
          itemCount: widget._transferencias.length,
          itemBuilder: (context, index) {
            final Transferencia? transferencia = widget._transferencias[index];
            return ItemTransferencia(transferencia);
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future<Transferencia?> future = Navigator.push(context, MaterialPageRoute(builder: (context){
            return FormularioTransferencia();
          }));
          future.then((transferenciaRecebida) {
            Future.delayed(Duration(seconds: 1), (){
              debugPrint("Chegou no then do future");
              debugPrint("$transferenciaRecebida");
              setState(() {
                widget._transferencias.add(transferenciaRecebida);
              });
            });
            });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

}

class ItemTransferencia extends StatelessWidget {
  final Transferencia? _transferencia;

  const ItemTransferencia(this._transferencia, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: Text(_transferencia!.valor.toString()),
        subtitle: Text(_transferencia!.numeroConta.toString()),
      ),
    );
  }
}

class Transferencia {
  Transferencia(this.valor, this.numeroConta);

  final double? valor;
  final int? numeroConta;

  @override
  String toString() {
    return 'Transferencia{valor: $valor, numeroConta: $numeroConta}';
  }
}
