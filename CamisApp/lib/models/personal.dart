class Personal {
  int id;
  String name;
  double pago;

  Personal(this.id, this.name, this.pago);

  Map<String, dynamic> toMap(){
    return{
      'id' : (id==0)? null : id,
      'name' : name,
      'pago' : pago,
    };
  }

}