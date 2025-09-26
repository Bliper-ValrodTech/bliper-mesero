class CuponesChat{
  String? CouponID;
  String? Code;
  String? Descripcion;
  String? verificar;
  String? qr;
  // ignore: non_constant_identifier_names
  String? valid_day;
  CuponesChat();

  CuponesChat.fromJSON(Map<String, dynamic> jsonMap) {
    try{
      CouponID = jsonMap['id'];
      Code = jsonMap['code'];
      Descripcion = jsonMap['description'];
      verificar = jsonMap['verificar'];
      qr = jsonMap['qr'];
      valid_day = jsonMap['valid_day'];
    }catch(e)
    {
      CouponID = "";
      Code = "";
      Descripcion = "";
      verificar = "";
      qr = "";
      valid_day = "";
      print(e.toString());
    }
  }
  Map toMap()
  {
    var map = <String, dynamic>{};
    map['CouponID'] = CouponID;
    map['Code'] = Code;
    map['Descripcion'] = Descripcion;
    map['verificar'] = verificar;
    return map;
  }
}