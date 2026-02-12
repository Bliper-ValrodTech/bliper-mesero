import 'package:flutter/cupertino.dart';

import '../../features/home/screens/screens.dart';
import '../../features/login/screens/screens.dart';
import '../../features/navigation/screens/screens.dart';

class Routs{

  void navigate({required paginaRout, required BuildContext context}) {
    final pagina = animacion(paginaRout: paginaRout, context: context);
    Navigator.push(context, pagina);
  }
  PageRouteBuilder animacion({required paginaRout, required BuildContext context}){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => paginaRout,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  void loginRoute({required String devicetoken,required BuildContext context}){
    navigate(paginaRout: LoginScreenWidget(deviceToken: devicetoken,), context: context);
  }
  void homeRoute({required BuildContext context}){
    navigate(paginaRout: HomeScreenWidget(), context: context);
  }
  void chatRoute({required BuildContext context}){
    //navigate();
  }
  void navigationRoute({required BuildContext context}){
    navigate(paginaRout: NavigationScreen(), context: context);
  }
}