import 'package:bliper_mesero/src2/features/home/screens/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:state_extended/state_extended.dart';

class NavigationController extends StateXController{
  Widget currentScreen = const HomeScreenWidget();

  void change_page({required int page}){

    switch (page) {
      case 1:
        currentScreen = const HomeScreenWidget();
        break;
    }

    setState(() {
      currentScreen;
    });
  }
}