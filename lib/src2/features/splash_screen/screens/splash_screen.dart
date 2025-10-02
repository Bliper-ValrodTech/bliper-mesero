import 'package:bliper_mesero/src/controllers/splashscreen_controller.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import '../../../config/global/widgets/widgets.dart';
import '../../../config/global/global.dart' as global;
class SpashScreenWidget extends StatefulWidget {
  SpashScreenWidget({Key? key}) : super(key: key);
  @override
  _SpashScreenWidgetState createState() => _SpashScreenWidgetState();
}
class _SpashScreenWidgetState extends StateX<SpashScreenWidget> {
  late SplashScreenController con;
  _SpashScreenWidgetState() : super(controller: SplashScreenController()) {
    con = controller as SplashScreenController;
  }

  @override
  void initState() {
    super.initState();
    con.init(context: context);
    //Future.delayed(Duration(seconds: 2),() => global.routs.loginRoute(devicetoken: "", context: context),);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "assets/app/fondo_dark.jpg",
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Loading(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}