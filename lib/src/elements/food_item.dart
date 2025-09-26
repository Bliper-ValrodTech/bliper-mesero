import 'package:bliper_mesero/src/models/order.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Food_Item extends StatefulWidget {
  final Order orden;

  Food_Item(this.orden);
  _Food_ItemState createState() => _Food_ItemState();
}
class _Food_ItemState extends State<Food_Item> {
  @override
  Widget build(BuildContext context) {

    calcularSubTotal();
    return Container(
      // height: double.tryParse(height.toString()),
      width: 161,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        primary: false,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                         child: Container(
                            padding:const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.blueGrey,
                            ),
                            child: Text("Orden #${widget.orden.id}",),
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Container(
                        padding:const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.blueGrey,
                        ),
                        child: Text(widget.orden.status.toString(),),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15,top: 5),
                  child: Text(
                    "${widget.orden.created_at}",
                    style: Theme.of(context).textTheme.labelSmall,
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15,top: 5),
                  child: Text(
                    "Mesa: ${widget.orden.Mesa}",
                    style: Theme.of(context).textTheme.labelSmall,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 135,
              width: 140,
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: widget.orden.foodOrders?[index].imagen_url ?? "",
                        height: 135,
                        width: 140,
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width:10,);
                  },
                  itemCount: widget.orden.foodOrders!.length
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 3,
                  ),
                  SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      primary: false,
                      child: ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:[
                                Text(
                                 widget.orden.foodOrders?[index].name ?? "",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "${widget.orden.foodOrders?[index].quantity} x "r'$ '"${widget.orden.foodOrders?[index].price}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 5,);
                        },
                        itemCount: widget.orden.foodOrders?.length ?? 0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "SubTotal",
                        style: TextStyle(
                          color: Color(0xffd17842),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        r'$ '"$subTotal",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Impuesto %${widget.orden.tax}",
                        style: const TextStyle(
                          color: Color(0xffd17842),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        r'$ '"$tax",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          color: Color(0xffd17842),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        r'$ '"$Total",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.only(right: 15,bottom: 10),
                    height: 35,
                    width: 35,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        //color: Colors.blueAccent
                    ),
                    child: const Center(
                      child: Icon(Icons.chat,color: Colors.white,),
                    ),
                  ),
                  onTap: (){
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatWidget(Order_ID: widget.orden.id.toString(),Restaurant_ID: widget.orden.restaurant_id.toString(), mesa: widget.orden.Mesa.toString(),)),
                    );*/
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  double subTotal = 0.0;
  double Total = 0.0;
  double Tax = 0.0;
  double tax = 0.0;

  void calcularSubTotal(){
     subTotal = 0.0;
     Total = 0.0;
     Tax = 0.0;
     tax = 0.0;
    for(int i = 0; i < widget.orden.foodOrders!.length; i++){
      subTotal += widget.orden.foodOrders![i].price!;
    }
    setState(() {});
    calcularTotal();
  }

  void calcularTotal()
  {
    Tax = widget.orden.tax!;
    double total = subTotal;
    // total += order.deliveryFee;
    /*print("$Tax * $subTotal / 100");
    print(Tax * subTotal / 100);*/
    setState(() {
      tax = Tax * subTotal / 100;
      total += Tax * total / 100;
      Total = total;
    });
  }
}