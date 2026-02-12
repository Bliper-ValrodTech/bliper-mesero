import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import '../../../config/theme/theme.dart';

class HomeScreenWidget extends StatefulWidget {
  final String? deviceToken;
  const HomeScreenWidget({super.key,this.deviceToken,});
  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}
class _HomeScreenWidgetState extends StateX<HomeScreenWidget> {
  // late LoginController con;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      //backgroundColor: ,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Home",
        ),
        centerTitle: true,
      ),
    );
  }
}

