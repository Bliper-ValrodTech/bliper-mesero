import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/food.dart';

class Menu_Item extends StatefulWidget {
  final Food foods;
  final int index;
  final ValueChanged<Food> food;
  const Menu_Item({super.key, required this.foods, required this.index, required this.food});
  _Menu_ItemState createState() => _Menu_ItemState();
}

class _Menu_ItemState extends State<Menu_Item> {
  int width = 135;
  int height = 250;
  int seleccionado = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 310,
        width: 161,
        decoration: BoxDecoration(
          color: seleccionado == 0 ? const Color.fromRGBO(0, 31, 36, 1.0) : Colors.lightBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        onEnd: (){
          setState(() {
            seleccionado = 0;
          });
          print(seleccionado);
        },
        child: SingleChildScrollView(
          primary: false,
          child: Column(
            children: [
              const SizedBox(height: 10,),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: widget.foods.imagen_url ?? "",
                  height: 135,
                  width: 140,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 35,
                      width: 200,
                      child: Text(
                        widget.foods.name.toString(),
                        style: const TextStyle(
                          fontFamily: 'alteHaasGrotesk',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        height: 85,
                        width: 200,
                        child: Text(
                          widget.foods.description.toString(),
                          style: const TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Precio",
                          style: TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          r'$'+widget.foods.price.toString(),
                          style: const TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        print(seleccionado);
        Food _food = widget.foods;
        widget.food(_food);
        Scaffold.of(context).openEndDrawer();
        setState(() {
          seleccionado = 1;
        });
        print(seleccionado);
      },
    );
  }

}
