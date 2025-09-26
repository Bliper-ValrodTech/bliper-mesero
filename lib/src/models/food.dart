import 'package:bliper_mesero/src/models/category.dart';
import 'package:bliper_mesero/src/models/restaurant.dart';
import 'extras.dart';
import 'media.dart';

class Food {
  String? id;
  String? name;
  double? price;
  double? discountPrice;
  Media? image;
  String? description;
  String? ingredients;
  String? weight;
  String? unit;
  String? packageItemsCount;
  bool? featured;
  bool? deliverable;
  Restaurant? restaurant;
  Category category = Category();
  String? imagen_url;
  String? abreviatura;
  String? nota;
  String? cantidad;
  List<Extras>? extras;
  String category_id = "";
  bool mostrar = true;

  Food();

  Food.fromJSON(Map<String, dynamic> jsonMap) {
    try {

      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      price = jsonMap['price'] != null ? double.parse(jsonMap['price'].toString()) : 0.0;
      discountPrice = jsonMap['discount_price'] != null ? double.parse(jsonMap['discount_price'].toString()) : 0.0;
      price = discountPrice != 0 ? discountPrice : price;
      discountPrice = discountPrice == 0 ? discountPrice : jsonMap['price'] != null ? double.parse(jsonMap['price'].toString()) : 0.0;
      description = jsonMap['description'];
      ingredients = jsonMap['ingredients'];
      weight = jsonMap['weight'] != null ? jsonMap['weight'].toString() : '';
      unit = jsonMap['unit'].toString();
      packageItemsCount = jsonMap['package_items_count'].toString();
      if(jsonMap['featured'] == "1"){
        featured = true;
      }else{
        featured = false;
      }
      if(jsonMap['deliverable'] == "1"){
        deliverable = true;
      }else{
        deliverable = false;
      }
      restaurant = jsonMap['restaurant'] != null ? Restaurant.fromJSON(jsonMap['restaurant']) : Restaurant();
      image = jsonMap['media'] != null && (jsonMap['media'] as List).isNotEmpty ? Media.fromJSON(jsonMap['media'][0]) : Media();
      imagen_url = jsonMap['imagen_url'] ?? "";
      abreviatura = jsonMap['abreviatura'] ?? "";
      nota = jsonMap["nota"] ?? "";
      extras = jsonMap['extras'] != null && (jsonMap['extras'] as List).length > 0
          ? List.from(jsonMap['extras']).map((element) => Extras.fromJSON(element)).toSet().toList()
          : [];
      category_id = jsonMap["category_id"];
    } catch (e) {
      id = '';
      name = '';
      price = 0.0;
      discountPrice = 0.0;
      description = '';
      weight = '';
      ingredients = '';
      unit = '';
      packageItemsCount = '';
      featured = false;
      deliverable = false;
      restaurant = Restaurant();
      category = Category();
      image = Media();
      imagen_url = "";
      abreviatura = "";
      print("Error food modelos $e");
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["discountPrice"] = discountPrice;
    map["description"] = description;
    map["ingredients"] = ingredients;
    map["weight"] = weight;
    map["nota"] = nota;
    map["extras"] = extras?.map((extra) => extra.toMap()).toList();
    return map;
  }
  Map<String, dynamic> toJson(){
    return {
    '"id"' : '"$id"',
    '"name"': '"$name"',
    '"price"': price,
    '"discountPrice"': discountPrice,
    '"description"': '"$description"',
    '"ingredients"': '"$ingredients"',
    '"weight"': '"$weight"',
    '"extras"': extras?.map((extra) => extra.toJson()).toList(),
    };
  }

  @override
  // ignore: non_nullable_equals_parameter
  bool operator ==(dynamic other) {
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

