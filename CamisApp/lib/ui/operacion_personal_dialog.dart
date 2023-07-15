import 'package:camisapp/models/personal.dart';
import 'package:flutter/material.dart';
import 'package:camisapp/util/dbhelper.dart';
import 'package:camisapp/models/operacion_personal.dart';
import 'package:camisapp/models/operacion.dart';

class OperacionPersonalDialogg extends StatefulWidget {
  List<Personal> empleados = [];
  Operacion? operacion;

  OperacionPersonalDialogg(this.empleados, this.operacion);

  @override
  State<OperacionPersonalDialogg> createState() => _OperacionPersonalDialoggState();
}

class _OperacionPersonalDialoggState extends State<OperacionPersonalDialogg> {

  final txtPersonal = TextEditingController();
  final txtOperacion = TextEditingController();
  final txtProduce = TextEditingController();
  final txtPorcentaje = TextEditingController();
  Personal? personalSeleccionado;

  DbHelper helper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nueva Asignación'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            DropdownButton(
                value: personalSeleccionado,
                hint: Text('Selecciona un empleado'),
                items: widget.empleados.map<DropdownMenuItem<Personal>>((Personal personal){
                  return DropdownMenuItem(
                      value: personal,
                      child: Text(personal.name)
                  );
                }).toList(),
                onChanged: (Personal? newValue) {
                  setState((){
                    personalSeleccionado = newValue;
                  });
                }),

            TextField(
              controller: txtProduce,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Produceeeee'
              ),
            ),
            TextField(
              controller: txtPorcentaje,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Porcentaje'
              ),
            ),
            ElevatedButton(
                child: Text('Grabar'),
                onPressed: (){
                  OperacionPersonal operacionPersonal = OperacionPersonal(
                      0,
                      personalSeleccionado!.id,
                      widget.operacion!.id,
                      int.parse(txtProduce.text),
                      int.parse(txtPorcentaje.text),
                      personalSeleccionado!.name,
                      personalSeleccionado!.pago);

                  helper.insertOperacionPersonal(operacionPersonal);
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}



























class OperacionPersonalDialog{

  final txtPersonal = TextEditingController();
  final txtOperacion = TextEditingController();
  final txtProduce = TextEditingController();
  final txtPorcentaje = TextEditingController();
  Personal? personalSeleccionado;

  Widget buildDialog(BuildContext context, OperacionPersonal operacionPersonal, bool isNew){
    DbHelper helper = DbHelper();
    if(!isNew){
      txtPersonal.text = operacionPersonal.personalId.toString();
      txtOperacion.text = operacionPersonal.operacionId.toString();
      txtProduce.text = operacionPersonal.produce.toString();
      txtPorcentaje.text = operacionPersonal.porcentaje.toString();
    }
    else{
      txtPersonal.text = '';
      txtOperacion.text = '';
      txtProduce.text = '';
      txtPorcentaje.text = '';
    }

    return AlertDialog(
      title: Text((isNew)? 'Nueva Asignación' : 'Edición de la Asignación'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            /*
            DropdownButton(
              value: personalSeleccionado,
                hint: Text('Selecciona un empleado'),
                items: items,
                onChanged: (Personal? newValue) {
                setState((){
                  personalSeleccionado = newValue;
                });
                }),*/
            
            TextField(
              controller: txtProduce,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Produce'
              ),
            ),
            TextField(
              controller: txtPorcentaje,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Porcentaje'
              ),
            ),
            ElevatedButton(
                child: Text('Grabar'),
                onPressed: (){
                  operacionPersonal.produce = int.parse(txtProduce.text);
                  operacionPersonal.porcentaje = int.parse(txtPorcentaje.text);
                  helper.insertOperacionPersonal(operacionPersonal);
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

}