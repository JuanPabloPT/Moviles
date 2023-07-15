class Modelo {
  int id;
  String name;
  String orden;
  int cantidad;
  double costo;

  Modelo(this.id, this.name, this.orden, this.cantidad, this.costo);

  Map<String, dynamic> toMap(){
    return{
      'id' : (id==0)? null : id,
      'name' : name,
      'orden' : orden,
      'cantidad' : cantidad,
      'costo': costo

    };
  }

}