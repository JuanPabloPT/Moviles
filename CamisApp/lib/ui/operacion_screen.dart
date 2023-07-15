import 'package:flutter/material.dart';
import 'package:camisapp/util/dbhelper.dart';
import 'package:camisapp/models/operacion.dart';
import 'package:camisapp/models/modelo.dart';
import 'package:camisapp/ui/operacion_personal_screen.dart';

class ShowOperaciones extends StatefulWidget {
  final Modelo modelo;
  ShowOperaciones(this.modelo);

  @override
  State<ShowOperaciones> createState() => _ShowOperacionesState(this.modelo);
}

class _ShowOperacionesState extends State<ShowOperaciones> {
  final Modelo modelo;
  _ShowOperacionesState(this.modelo);

  DbHelper helper = DbHelper();
  List<Operacion> operaciones = [];

  @override
  Widget build(BuildContext context) {

    double totalCosto = operaciones.fold(0, (double previousValue, operacion) {
      double costo = operacion.total;
      return previousValue + costo;
    });

    showData(this.modelo.id);

    helper.updateModelo(modelo, totalCosto);

    return Scaffold(
      appBar: AppBar(
        title: Text("OPERACIONES"),
      ),
      body: Column(
        children: [

          Container(

              height: 95,
              width: 360,
              margin: EdgeInsets.only(top: 20, bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  )
              ),

              child: Column(
                  children: [
                    Text('Costo Total:',
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.white
                      ),),
                    Text(totalCosto.toStringAsFixed(3),
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white
                      ),)
                  ]
              )
          ),

          Expanded(
            child: ListView.builder(
              itemCount: (operaciones != null)? operaciones.length : 0,
              itemBuilder: (BuildContext context, int index){
                return Column(
                  children: [
                    ListTile(

                      leading: Container(
                        height: 200,
                        width: 40,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            operaciones[index].alCien.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.red
                            ),
                          ),
                        ),
                      ),

                      title: Column(
                        children: [

                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              operaciones[index].name,
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.teal
                              ), ),
                          ),

                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Costo: ' + operaciones[index].total.toStringAsFixed(3),
                              style: TextStyle(
                                  fontSize: 20,
                              ), ),
                          ),
                        ]
                      ),



                      trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: (){
                        helper.deleteOperacion(operaciones[index]);
                        },
                      ),
                      onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ShowOperacionPersonal(operaciones[index])));
                      },
                    ),

                    Divider(),
                  ]
                );
              }),
          ),
        ]
      ),
    );
  }


  Future showData(int modeloId) async{
    await helper.openDb();
    operaciones = await helper.getOperaciones(modeloId);
    setState(() {
      operaciones = operaciones;
    });
  }

}


