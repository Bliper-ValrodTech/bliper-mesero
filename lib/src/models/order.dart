import 'package:bliper_mesero/src/models/payment.dart';
import 'package:bliper_mesero/src/models/user.dart';
import 'food_order.dart';
import 'order_status.dart';
import '../controllers/global.dart' as global;

class Order {
  String? id;
  List<FoodOrder>? foodOrders;
  OrderStatus? orderStatus;
  String? status;
  String? order_status_id;
  double? tax;
  double? deliveryFee;
  String? hint;
  bool? active;
  DateTime? dateTime;
  User? user;
  Payment? payment;
  //Address deliveryAddress;
  int? restaurant_id;
  int? driver_id;
  String? created_at;
  // ignore: non_constant_identifier_names
  String? updated_at;
  String? accepted_order_status;
  int? id_city;
  String? city;
  String? ID_RESTAURANT;
  int? En_Restaurante;
  int? idRestaurante;
  int? Mesa;
  int? points_restaurant;
  String? error;
  int? puntos_gastados;
  String? payment_method;

  String? subtotal;
  String? extra_precio;
  String? iva;
  String total = "0.00";

  Order();

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : "0";
      restaurant_id= jsonMap['restaurant_id'] != null ? int.parse(jsonMap['restaurant_id'].toString()) : 0;
      tax = jsonMap['tax'] != null ? double.parse(jsonMap['tax'].toString()) : 0.0;
      id_city = jsonMap['id_city'] != null ? int.parse(jsonMap['id_city'].toString()) : 0;
      city = jsonMap['id_city'] != null ? jsonMap['id_city'].toString() : "";
      foodOrders = jsonMap['foods'] != null ? List.from(jsonMap['foods']).map((element) => FoodOrder.fromJSON(element)).toList() : [];
      hint = jsonMap['hint'] != null ? jsonMap['hint'].toString() : '';
      //active = jsonMap['active'] ?? false;
      orderStatus = jsonMap['order_status'] != null ? OrderStatus.fromJSON(jsonMap['order_status']) : OrderStatus.fromJSON({});
      // user = jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : User.fromJSON({});
      payment = jsonMap['payment'] != null ? Payment.fromJSON(jsonMap['payment']) : Payment.fromJSON({});
      accepted_order_status =jsonMap["accepted_order_status"] != null ? jsonMap["accepted_order_status"].toString() : "";
      puntos_gastados = jsonMap["puntos_gastados"] != null ? int.parse(jsonMap["puntos_gastados"].toString()) : 0;
      payment_method = jsonMap["payment_method"] != null ? jsonMap["payment_method"].toString() : "";
      En_Restaurante = jsonMap["En_Restaurante"] != null ? int.parse(jsonMap["En_Restaurante"].toString()) : 0;
      Mesa = jsonMap["Mesa"] != null ? int.parse(jsonMap["Mesa"].toString()) : 0;
      status = jsonMap["status"] != null ? jsonMap["status"].toString() : "";
      order_status_id = jsonMap["order_status_id"] != null ? jsonMap["order_status_id"].toString() : "0";
      created_at = jsonMap['created_at'] ?? "";
      subtotal = jsonMap['subtotal'] ?? "0.00";
      iva = jsonMap['iva'] ?? "0.00";
      total = jsonMap['total'] ?? "0.00";
      extra_precio = jsonMap['extras'] ?? "0.00";
    } catch (e) {
      id = '';
      order_status_id = '';
      tax = 0.0;
      id_city = 0;
      city = '';
      restaurant_id = 0;
      deliveryFee = 0.0;
      hint = '';
      created_at = '';
      updated_at = '';
      accepted_order_status = '';
      driver_id = 0;
      active = false;
      orderStatus = OrderStatus.fromJSON({});
      dateTime = DateTime(0);
      //user = User.fromJSON({});
      payment = Payment.fromJSON({});
      //deliveryAddress = Address.fromJSON({});
      foodOrders = [];
      puntos_gastados = 0;
      //print(CustomTrace(StackTrace.current, message: e));
      print("Orden error: ");
      print(e);
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id ?? "" ;
    map["restaurant_id"] = restaurant_id ?? "" ;
    map["user_id"] = user?.id ?? "" ;
    map["id_city"] = id_city ?? "" ;
    map["city"] = city ?? "" ;
    map["order_status_id"] = orderStatus?.id ?? "" ;
    map["tax"] = tax ?? 0.0;
    map['hint'] = hint ?? "" ;
    map["delivery_fee"] = deliveryFee ?? 0.0;
    map["foods"] = foodOrders?.map((element) => element.toMap()).toList();
    map["payment"] = payment?.toMap();
    map["driver_id"] =driver_id ?? "0" ;
    map["created_at"] =created_at ?? "" ;
    map["updated_at"] =updated_at ?? "" ;
    map["En_Restaurante"] = En_Restaurante ?? "0";
    map["Mesa"] = Mesa ?? "0";
    map["accepted_order_status"] = accepted_order_status ?? "";
    map["device_token"] = global.token;
    /*if (!deliveryAddress.isUnknown()) {
      map["delivery_address_id"] = deliveryAddress?.id;
    }*/
    return map;
  }


  Map rejectMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["order_status_id"] = 7;
    map["accepted_order_status"] = "No Aceptada";
    return map;
  }

  Map acceptMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["order_status_id"] = 2;
    map["accepted_order_status"] = "Aceptada";
    return map;
  }

  Map preparingMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["order_status_id"] = 3;
    return map;
  }

  Map readyMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["order_status_id"] = 4;
    return map;
  }

  Map inWayMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["order_status_id"] = 5;
    return map;
  }

  Map deliveredMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["order_status_id"] = 6;
    return map;
  }
}