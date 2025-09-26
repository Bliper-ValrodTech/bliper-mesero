import 'package:bliper_mesero/src/pages/login.dart';
import 'package:flutter/cupertino.dart';
import '../models/food.dart';
import '../pages/asignacion_manual.dart';
import '../pages/menu.dart';
import '../pages/mesas_configuracion.dart';
import '../pages/pages.dart';

class RoutsController{

  void navigate({required PageRouteBuilder pagina,required BuildContext context}){
    Navigator.push(context, pagina);
  }
  void pagesRoute({required int page,required BuildContext context, required String deviceToken}) {
   final pagina = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PagesWidget(page: page,deviceToken: deviceToken,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
   navigate(pagina: pagina, context: context);
  }
  void asiganacionManualRoute({required List<Food> food,required BuildContext context}) {
    final pagina = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AsiganacionManualWidget(food: food,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
    navigate(pagina: pagina, context: context);
  }
  void menuRoute({required String mesa,required String deviceToken,required BuildContext context}) {
    final pagina = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MenuWidget(deviceToken: deviceToken, mesa: mesa),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
    navigate(pagina: pagina, context: context);
  }
  void loginRoute({required String devicetoken,required BuildContext context}){
    final pagina = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginWidget(deviceToken: devicetoken,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
    navigate(pagina: pagina, context: context);
  }
  void mesasConfigRoute({required BuildContext context}){
    final pagina = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MesasConfiguracion(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
    navigate(pagina: pagina, context: context);
  }
}