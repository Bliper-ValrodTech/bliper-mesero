import 'media.dart';

class Restaurant {
  String? id;
  String? name;
  Media? image;
  String? rate;
  String? address;
  String? description;
  String? phone;
  String? mobile;
  String? information;
  double? deliveryFee;
  double? adminCommission;
  double? defaultTax;
  String? latitude;
  String? longitude;
  bool? closed;
  bool? availableForDelivery;
  double? deliveryRange;
  double? distance;
  String? banner_image_url;

  Restaurant();

  Restaurant.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).isNotEmpty ? Media.fromJSON(jsonMap['media'][0]) : Media();
      rate = jsonMap['rate'] ?? '0';
      deliveryFee = jsonMap['delivery_fee'] != null ? double.parse(jsonMap['delivery_fee'].toString()) : 0.0;
      adminCommission = jsonMap['admin_commission'] != null ? double.parse(jsonMap['admin_commission'].toString()) : 0.0;
      deliveryRange = 0.0;//jsonMap['delivery_range'] != null ? jsonMap['delivery_range'].toDouble() : 0.0;
      address = jsonMap['address'];
      description = jsonMap['description'];
      phone = jsonMap['phone'];
      mobile = jsonMap['mobile'];
      defaultTax = jsonMap['default_tax'] != null ? double.parse(jsonMap['default_tax']) : 0.0;
      information = jsonMap['information'];
      latitude = jsonMap['latitude'];
      longitude = jsonMap['longitude'];
      closed = jsonMap['closed'] ?? false;
      availableForDelivery = jsonMap['available_for_delivery'] ?? false;
      distance = jsonMap['distance'] != null ? double.parse(jsonMap['distance'].toString()) : 0.0;
      banner_image_url = jsonMap['banner_image_url'] ?? "";
    } catch (e) {
      id = '';
      name = '';
      image = Media();
      rate = '0';
      deliveryFee = 0.0;
      adminCommission = 0.0;
      deliveryRange = 0.0;
      address = '';
      description = '';
      phone = '';
      mobile = '';
      defaultTax = 0.0;
      information = '';
      latitude = '0';
      longitude = '0';
      closed = false;
      availableForDelivery = false;
      distance = 0.0;
      banner_image_url = "";
      print("Error restaurant: $e");
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'delivery_fee': deliveryFee,
      'distance': distance,
    };
  }
}
