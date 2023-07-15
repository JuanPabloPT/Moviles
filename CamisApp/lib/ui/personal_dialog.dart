import 'package:flutter/material.dart';
import 'package:camisapp/util/dbhelper.dart';
import 'package:camisapp/models/personal.dart';

class PersonalDialog{

  final txtName = TextEditingController();
  final txtPago = TextEditingController();

  Widget buildDialog(BuildContext context, Personal personal, bool isNew){
    DbHelper helper = DbHelper();
    if(!isNew){
      txtName.text = personal.name;
      txtPago.text = personal.pago.toString();
    }
    else{
      txtName.text = '';
      txtPago.text = '';
    }

    return AlertDialog(
      title: Text((isNew)? 'Nuevo Empleado' : 'Edición del empleado'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                  hintText: 'Nombre'
              ),
            ),
            TextField(
              controller: txtPago,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Pago Por Hora'
              ),
            ),
            ElevatedButton(
                child: Text('Grabar'),
                onPressed: (){
                  personal.name = txtName.text;
                  personal.pago = double.parse(txtPago.text);
                  helper.insertPersonal(personal);
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

}