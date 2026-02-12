
import 'package:bliper_mesero/src2/features/navigation/widgets/navigation_widget/screens/navigation_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

import '../../../config/theme/theme.dart';
import '../controllers/controllers.dart';

class NavigationScreen extends StatefulWidget {
  final String? deviceToken;
  const NavigationScreen({super.key,this.deviceToken,});
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}
class _NavigationScreenState extends StateX<NavigationScreen> {
  late NavigationController con;

  _NavigationScreenState() : super(controller: NavigationController()) {
    con = controller as NavigationController;
  }


  @override
  Widget build(BuildContext context){
    return PopScope(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: NavigationWidget(page: 1,currentPage: (value) {
            con.change_page(page: value);
          },
        ),
        body: con.currentScreen,
      ),
    );
  }
}
