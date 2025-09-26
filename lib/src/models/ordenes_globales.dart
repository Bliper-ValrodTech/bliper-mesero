import 'package:flutter/foundation.dart';

import 'order.dart';

List<Order>? ordenes;
List<Order>? ordenesEntregadas;
List<Order>? ordenesCanceladas;
ordenesNotifier a = ordenesNotifier(0);
class ordenesNotifier extends ValueNotifier{
  ordenesNotifier(value) : super(value);

  void setstate(){
    value++;
  }
}