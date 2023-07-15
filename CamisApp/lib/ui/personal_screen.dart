import 'package:flutter/material.dart';
import 'package:camisapp/util/dbhelper.dart';
import 'package:camisapp/models/personal.dart';
import 'package:camisapp/ui/personal_dialog.dart';

class ShowPersonal extends StatefulWidget {
  const ShowPersonal({super.key});

  @override
  State<ShowPersonal> createState() => _ShowPersonalState();
}

class _ShowPersonalState extends State<ShowPersonal> {

  DbHelper helper = DbHelper();
  List<Personal> empleados = [];

  PersonalDialog dialog = PersonalDialog();

  @override
  void initState(){
    dialog = PersonalDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    showData();

    return Scaffold(
      appBar: AppBar(
        title: Text("EMPLEADOS"),
      ),


      body: ListView.builder(
          itemCount: (empleados != null)? empleados.length : 0,
          itemBuilder: (BuildContext context, int index){
            return Column(
              children: [
                ListTile(

                  title: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          empleados[index].name,
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.teal
                          ), ),
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'S/.' + empleados[index].pago.toString(),
                          style: TextStyle(
                              fontSize: 20,
                          ), ),
                      ),
                    ]
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
                                  context, empleados[index], false));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: (){
                          helper.deletePersonal(empleados[index]);
                        },
                      ),
                    ],
                  ),
                ),
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
                  context, Personal(0, '', 0), true));
        },
        child: Icon(Icons.plus_one),
        backgroundColor: Colors.cyan,
      ),
    );
  }

  Future showData() async{
    await helper.openDb();
    empleados = await helper.getPersonal();

    setState(() {
      empleados = empleados;
    });
  }

}
