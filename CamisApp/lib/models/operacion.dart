class Operacion {
  int id;
  int modeloId;
  String name;
  int alCien;
  double total;

  Operacion(this.id, this.modeloId, this.name, this.alCien, this.total);

  Map<String, dynamic> toMap(){
    return{
      'id' : (id==0)? null : id,
      'modeloId' : modeloId,
      'name' : name,
      'alCien' : alCien,
      'total' : total
    };
  }

}