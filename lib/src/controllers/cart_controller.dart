import 'package:bliper_mesero/src/models/cart.dart';
import 'package:bliper_mesero/src/models/food_order.dart';
import 'package:bliper_mesero/src/models/order.dart';
import 'package:bliper_mesero/src/models/order_status.dart';
import 'package:bliper_mesero/src/models/payment.dart';
import 'package:bliper_mesero/src/models/user.dart';
import 'package:bliper_mesero/src/repository/orden_repository.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import '../controllers/global.dart' as global;

class CartController extends StateXController {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CartController(){
    scaffoldKey = GlobalKey<ScaffoldState>();
  }
  List<FoodOrder> foodOrders = <FoodOrder>[];
  Order? orden;
  String subtotal ="0.00";
  String impuesto = "% 0.00";
  String total = "0.00";
  String extras = "0.00";
  Future<int> ordenar(List<Cart> carrito,{required int mesa}) async {
    Payment payment = Payment("Cash on Delivery");
    payment.id = "1";
    payment.status = "Order not paid yet";
    payment.method = "Cash on Delivery";

    Order _order = Order();
    User User2 = User();
    User2.name = global.user.name;
    User2.id = global.user.id;
    User2.deviceToken = global.token;
    User2.apiToken = global.token;
    _order.user = User2;
    _order.idRestaurante = int.parse(global.user.restaurante_id);
    _order.restaurant_id = int.parse(global.user.restaurante_id);
    _order.En_Restaurante = 1;
    _order.Mesa = mesa;

    _order.foodOrders = foodOrders;
    _order.tax = carrito[0].food!.restaurant!.defaultTax;

    _order.deliveryFee = 0;

    OrderStatus _orderStatus = OrderStatus();
    _orderStatus.id = '1'; // TODO default order status Id
    _order.orderStatus = _orderStatus;

    carrito.forEach((_cart) {
      FoodOrder _foodOrder = FoodOrder();
      _foodOrder.quantity = _cart.quantity;
      _foodOrder.price = _cart.food!.price;
      _foodOrder.food = _cart.food;
      _foodOrder.nota = _cart.nota != null && _cart.nota != "" ? _cart.nota :" ";
      _foodOrder.Fecha = _cart.Fecha != null && _cart.Fecha != "" ? _cart.Fecha: " ";
      _foodOrder.Hora = _cart.Hora != null && _cart.Hora != "" ? _cart.Hora : DateTime.now();
      _order.foodOrders!.add(_foodOrder);
    });
    // orderRepo.addOrder
    int respuesta = 0;
    respuesta = await agregarOrden(_order, payment);
    return respuesta;
  }
  void precios(List<Cart> carrito){
    if(carrito.isNotEmpty){
      double subtotalD = 0.00;
      for (var _cart in carrito) {
        subtotalD += _cart.quantity! * double.parse(_cart.food!.price.toString());
      }
      impuesto = (double.parse(global.user.porcentaje_iva) * double.parse(subtotalD.toString()) /100).toStringAsFixed(2);
      subtotal = subtotalD.toStringAsFixed(2);
      total = (double.parse(impuesto)+double.parse(subtotal)).toStringAsFixed(2);
      setState(() {
        impuesto;
        subtotal;
        total;
      });
    }
  }
}