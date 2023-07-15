class OperacionPersonal {
  int id;
  int personalId;
  int operacionId;
  int produce;
  int porcentaje;
  String personalName;
  double personalPago;

  OperacionPersonal(this.id, this.personalId, this.operacionId, this.produce,
      this.porcentaje, this.personalName, this.personalPago);

  Map<String, dynamic> toMap(){
    return{
      'id' : (id==0)? null : id,
      'personalId' : personalId,
      'operacionId' : operacionId,
      'produce' : produce,
      'porcentaje' : porcentaje,
    };
  }


}