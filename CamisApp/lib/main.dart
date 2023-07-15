import 'package:flutter/material.dart';
import 'package:camisapp/util/dbhelper.dart';
import 'package:camisapp/models/modelo.dart';
import 'package:camisapp/ui/modelo_dialog.dart';
import 'package:camisapp/ui/personal_screen.dart';
import 'package:camisapp/ui/operacion_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo
      ),
      home: ShowModelo(),
    );
  }
}

class ShowModelo extends StatefulWidget {
  const ShowModelo({super.key});

  @override
  State<ShowModelo> createState() => _ShowModeloState();
}

class _ShowModeloState extends State<ShowModelo> {


  DbHelper helper = DbHelper();
  List<Modelo> modelos = [];

  ModeloDialog dialog = ModeloDialog();

  @override
  void initState(){
    dialog = ModeloDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    showData();

    return Scaffold(
      appBar: AppBar(
        title: Text("MODELOS"),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                    MaterialPageRoute(builder: (context) => ShowPersonal(),)
                );
              },
              icon: Icon(Icons.account_circle_sharp))
        ],
      ),
      body: ListView.builder(
          itemCount: (modelos != null)? modelos.length : 0,
          itemBuilder: (BuildContext context, int index){
            
            double total = modelos[index].costo * modelos[index].cantidad; 

            return Column(
              children: [
                ListTile(

                  /*
                  leading: Container(
                    height: 200,
                    width: 50,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        modelos[index].orden,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.red
                        ),
                      ),
                    ),
                  ),

                   */




                  title: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          modelos[index].name,
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.teal
                          ), ),
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          modelos[index].orden,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.red
                          ), ),
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'Cantidad: ' + modelos[index].cantidad.toString(),
                            style: TextStyle(fontSize: 20)),
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'Costo Total: ' + total.toStringAsFixed(3),
                            style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),




                  trailing: Container(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => dialog!.buildDialog(
                                  context, modelos[index], false));
                        },
                    ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: (){
                          helper.deleteModelo(modelos[index]);
                        },
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ShowOperaciones(modelos[index])));
                },
              ),

                Divider(),
              ]
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context) => dialog!.buildDialog(
                      context, Modelo(0, '', '', 0, 0), true)
              );
        },
        child: Icon(Icons.plus_one),
        backgroundColor: Colors.cyan,
      ),
    );
  }

  Future showData() async{
    await helper.openDb();
    modelos = await helper.getModelos();

    setState(() {
      modelos = modelos;
    });
  }

}

