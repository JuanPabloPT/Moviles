import 'package:camisapp/models/personal.dart';
import 'package:camisapp/ui/personal_screen.dart';
import 'package:flutter/material.dart';
import 'package:camisapp/util/dbhelper.dart';
import 'package:camisapp/models/operacion.dart';
import 'package:camisapp/models/operacion_personal.dart';
import 'package:camisapp/ui/operacion_personal_dialog.dart';

class ShowOperacionPersonal extends StatefulWidget {
  final Operacion operacion;
  ShowOperacionPersonal(this.operacion);

  @override
  State<ShowOperacionPersonal> createState() => _ShowOperacionPersonalState(this.operacion);
}

class _ShowOperacionPersonalState extends State<ShowOperacionPersonal> {
  final Operacion operacion;
  _ShowOperacionPersonalState(this.operacion);

  DbHelper helper = DbHelper();
  List<OperacionPersonal> asignaciones = [];
  List<Personal> empleados = [];

  OperacionPersonalDialog dialog = OperacionPersonalDialog();

  @override
  void initState(){
    dialog = OperacionPersonalDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double totalCosto = asignaciones.fold(0, (double previousValue, asignacion) {
      double costo = (asignacion.personalPago/asignacion.produce) * (asignacion.porcentaje/100);
      return previousValue + costo;
    });

    operacion.total = totalCosto;

    showData(this.operacion.id);
    helper.insertOperacion(operacion);

    return Scaffold(
      appBar: AppBar(
        title: Text("ASIGNACIONES"),
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
              itemCount: (asignaciones != null)? asignaciones.length : 0,
              itemBuilder: (BuildContext context, int index){

                double costo = asignaciones[index].personalPago / asignaciones[index].produce;

                return Column(
                  children: [
                    ListTile(

                    leading: Container(
                      height: 200,
                      width: 40,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          asignaciones[index].porcentaje.toString() + '%',
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
                              asignaciones[index].personalName,
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.teal
                              ), ),
                        ),

                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              'Cantidad: ' + asignaciones[index].produce.toString(),
                              style: TextStyle(fontSize: 20)),
                        ),

                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              'Costo: ' +costo.toStringAsFixed(3),
                              style: TextStyle(fontSize: 20)),
                        ),
                        ],
                      ),


                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: (){
                        helper.deleteOperacionPersonal(asignaciones[index]);
                      },
                    ),
                    onTap: (){

                    },
                  ),

                    Divider(),
                  ]
                );
              }),

          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          showDialog(
              context: context,
              builder: (BuildContext context){
                return OperacionPersonalDialogg(empleados, operacion);
              }
              /*builder: (BuildContext context) => dialog!.buildDialog(
                  context, OperacionPersonal(0, 0, 0, 0, 0), true)*/
          );

        },
        child: Icon(Icons.plus_one),
        backgroundColor: Colors.cyan,
      ),
    );
  }

  Future showData(int operacionId) async{
    await helper.openDb();
    asignaciones = await helper.getPersonalByOperacion(operacionId);
    empleados = await helper.getPersonal();
    setState(() {
      asignaciones = asignaciones;
    });
  }

}
