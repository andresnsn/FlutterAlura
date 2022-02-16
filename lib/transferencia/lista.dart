import 'package:bytebank/models/transferencia.dart';
import 'package:bytebank/transferencia/formulario.dart';
import 'package:flutter/material.dart';


const _tituloAppBar = 'Transferências';

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
        title: const Text(_tituloAppBar),
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