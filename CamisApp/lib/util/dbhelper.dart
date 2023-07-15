import 'package:camisapp/models/modelo.dart';
import 'package:camisapp/models/operacion.dart';
import 'package:camisapp/models/operacion_personal.dart';
import 'package:camisapp/models/personal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DbHelper{
  final int version = 1;
  Database? db;

  //para que solo se cree una instancia de la BD
  static final DbHelper dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper(){
    return dbHelper;
  }

  Future<Database> openDb() async{
    if (db == null){
      db = await openDatabase(join(await getDatabasesPath(),
          'camisapp13.db'),
          onCreate: (database, version){
            database.execute(
                'CREATE TABLE modelos(id INTEGER PRIMARY KEY, name TEXT, orden TEXT, cantidad INTEGER, costo REAL)');
            database.execute(
                'CREATE TABLE operaciones(id INTEGER PRIMARY KEY, modeloId INTEGER, name TEXT, alCien INTEGER, total REAL,'
                    'FOREIGN KEY(modeloId) REFERENCES modelos(id))');
            database.execute(
                'CREATE TABLE personal(id INTEGER PRIMARY KEY, name TEXT, pago REAL)');
            database.execute(
                'CREATE TABLE operacionpersonal(id INTEGER PRIMARY KEY, operacionId INTEGER, personalId INTEGER, produce INTEGER , porcentaje INTEGER,'
                    'FOREIGN KEY(operacionId) REFERENCES operaciones(id),'
                    'FOREIGN KEY(personalId) REFERENCES personal(id))');
          }, version: version);
    }
    return db!;
  }

  //Vamos a probar la BD
  Future testDB() async{
    db = await openDb();

    await db!.execute('INSERT INTO modelos VALUES(0,"Hola","Hola2",12)');
    await db!.execute('INSERT INTO operaciones VALUES(0,0,"Hola",900)');
    await db!.execute('INSERT INTO personal VALUES(0,"Ben",12.9)');
    await db!.execute('INSERT INTO operacionpersonal VALUES(0,0,0,400)');

    List operaciones = await db!.rawQuery('SELECT * FROM operaciones');
    List modelos = await db!.rawQuery('SELECT * FROM modelos');
    List personal = await db!.rawQuery('SELECT * FROM personal');
    List operacionpersonal = await db!.rawQuery('SELECT * FROM operacionpersonal');

    print(modelos[0]);
    print(operaciones[0]);
    print(personal[0]);
    print(operacionpersonal[0]);
  }

  // CRUD ------------------------------------------------------------------------------------


  // MODELOS     -----------------------------------------------------------------------------

  Future<List<Modelo>> getModelos() async{
    final List<Map<String, dynamic>> maps = await db!.query('modelos');
    return List.generate(maps.length, (i){
      return Modelo(
          maps[i]['id'],
          maps[i]['name'],
          maps[i]['orden'],
          maps[i]['cantidad'],
          maps[i]['costo']
      );
    });
  }

  Future<int> insertModelo(Modelo modelo) async{
    int id = await this.db!.insert('modelos', modelo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    List<Map<String,dynamic>> result = await this.db!.rawQuery('SELECT last_insert_rowid()');

    int ultimoId = result.first['last_insert_rowid()'];

    insertOperacion(Operacion(0, ultimoId,"Cerrado", 200, 0));

    print(ultimoId);

    return id;
  }

  Future<void> updateModelo(Modelo modelo, double nuevoCosto) async {
    modelo.costo = nuevoCosto; // Actualiza el costo en el objeto Modelo

    await this.db!.update(
      'modelos',
      modelo.toMap(),
      where: 'id = ?',
      whereArgs: [modelo.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteModelo(Modelo modelo) async {
    int result = await db!.delete("operacionpersonal", where: "operacionId IN (SELECT id FROM operaciones WHERE modeloId = ?)", whereArgs: [modelo.id]);
    result = await db!.delete("operaciones", where: "modeloId = ?", whereArgs: [modelo.id]);
    result = await db!.delete("modelos", where: "id = ?", whereArgs: [modelo.id]);
    return result;
  }


  // OPERACIONES -----------------------------------------------------------------------------

  Future<List<Operacion>> getOperaciones(int modeloId) async{
    final List<Map<String, dynamic>> maps = await db!.query('operaciones', where: 'modeloId = ?', whereArgs: [modeloId]);
    return List.generate(maps.length, (i){
      return Operacion(
        maps[i]['id'],
        maps[i]['modeloId'],
        maps[i]['name'],
        maps[i]['alCien'],
        maps[i]['total']
      );
    });
  }

  Future<int> insertOperacion(Operacion operacion) async{
    int id = await this.db!.insert('operaciones', operacion.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<int> deleteOperacion(Operacion operacion) async {
    int result = await db!.delete("operacionpersonal", where: "operacionId = ?", whereArgs: [operacion.id]);
    result = await db!.delete("operaciones", where: "id = ?", whereArgs: [operacion.id]);
    return result;
  }

  // PERSONAL    -----------------------------------------------------------------------------

  Future<List<Personal>> getPersonal() async{
    final List<Map<String, dynamic>> maps = await db!.query('personal');
    return List.generate(maps.length, (i){
      return Personal(
          maps[i]['id'],
          maps[i]['name'],
          maps[i]['pago'],
      );
    });
  }

  Future<int> insertPersonal(Personal personal) async{
    int id = await this.db!.insert('personal', personal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<Personal> getPersonalById(int personalId) async {
    final result = await db!.rawQuery(
      'SELECT * FROM personal WHERE id = ?',
      [personalId],
    );

    final personalMap = result.first;
    final personal = Personal(
      personalMap['id'] as int,
      personalMap['name'] as String,
      personalMap['pago'] as double,
    );
    return personal;

  }

  Future<int> deletePersonal(Personal personal) async {
    int result = await db!.delete("operacionpersonal", where: "personalId = ?", whereArgs: [personal.id]);
    result = await db!.delete("personal", where: "id = ?", whereArgs: [personal.id]);
    return result;
  }


  // OPERACION PERSONAL  ---------------------------------------------------------------------

  /*
  Future<List<OperacionPersonal>> getPersonalByOperacion(int operacionId) async{
    final List<Map<String, dynamic>> maps = await db!.query('operacionpersonal', where: 'operacionId = ?', whereArgs: [operacionId]);
    return List.generate(maps.length, (i){
      return OperacionPersonal(
          maps[i]['id'],
          maps[i]['personalId'],
          maps[i]['operacionId'],
          maps[i]['produce'],
          maps[i]['porcentaje'],
      );
    });
  }
   */

  Future<List<OperacionPersonal>> getPersonalByOperacion(int operacionId) async{
    final List<Map<String, dynamic>> maps = await db!.rawQuery('''
    SELECT operacionpersonal.*, personal.name AS personalName, personal.pago AS personalPago
    FROM operacionpersonal
    INNER JOIN personal ON operacionpersonal.personalId = personal.id
    WHERE operacionpersonal.operacionId = ?
    ''', [operacionId]);

    return List.generate(maps.length, (i){
      return OperacionPersonal(
        maps[i]['id'],
        maps[i]['personalId'],
        maps[i]['operacionId'],
        maps[i]['produce'],
        maps[i]['porcentaje'],
        maps[i]['personalName'],
        maps[i]['personalPago']
      );
    });
  }

  Future<int> insertOperacionPersonal(OperacionPersonal operacionpersonal) async{
    int id = await this.db!.insert('operacionpersonal', operacionpersonal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<Personal> getOnePersonal(int personalId) async {
    final List<Map<String, dynamic>> maps = await db!.query(
      'personal', where: 'id = ?', whereArgs: [personalId], limit: 1,);

    return Personal(
      maps.first['id'],
      maps.first['name'],
      maps.first['pago'],
    );
  }

  Future<int> deleteOperacionPersonal(OperacionPersonal operacionPersonal) async {
    int result = await db!.delete("operacionpersonal", where: "id = ?", whereArgs: [operacionPersonal.id]);
    return result;
  }

}