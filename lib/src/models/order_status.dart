
class OrderStatus {
  String? id;
  String? status;

  OrderStatus();


  OrderStatus.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      status = jsonMap['order_status'] ?? '';
    } catch (e) {
      id = '';
      status = '';
      print("Error OrderStatus modelo");
    }
  }
}
