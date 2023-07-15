import 'package:flutter/material.dart';
import 'package:camisapp/util/dbhelper.dart';
import 'package:camisapp/models/modelo.dart';

class ModeloDialog{

  final txtName = TextEditingController();
  final txtOrden = TextEditingController();
  final txtCantidad = TextEditingController();

  Widget buildDialog(BuildContext context, Modelo modelo, bool isNew){
    DbHelper helper = DbHelper();
    if(!isNew){
      txtName.text = modelo.name;
      txtOrden.text = modelo.orden;
      txtCantidad.text = modelo.cantidad.toString();
    }
    else{
      txtName.text = '';
      txtOrden.text = '';
      txtCantidad.text = '';
    }

    return AlertDialog(
      title: Text((isNew)? 'Nuevo modelo' : 'Edición del modelo'),
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
              controller: txtOrden,
              decoration: InputDecoration(
                  hintText: 'Orden'
              ),
            ),
            TextField(
              controller: txtCantidad,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Cantidad'
              ),
            ),
            ElevatedButton(
                child: Text('Grabar'),
                onPressed: (){
                  modelo.name = txtName.text;
                  modelo.orden = txtOrden.text;
                  modelo.cantidad = int.parse(txtCantidad.text);
                  helper.insertModelo(modelo);
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

}