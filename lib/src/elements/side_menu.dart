import 'package:bliper_mesero/src/pages/login.dart';
import 'package:bliper_mesero/src/pages/pages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import '../controllers/global.dart' as global;
import '../pages/mesas_configuracion.dart';
import '../pages/qr_centro_mesa.dart';
import '../repository/login_repository.dart';


class NavDrawer extends StatefulWidget {
  final ValueChanged<int> onTapcCancelar;
  NavDrawer({required this.onTapcCancelar});
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends StateX<NavDrawer> {

  _NavDrawerState();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Stack(
            children: [
              DrawerHeader(
                decoration:  BoxDecoration(
                    color: Colors.black12,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(global.user.banner))), child: null,
              ),
              Positioned(
                bottom: 10,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    global.user.restaurant_name.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'alteHaasGrotesk',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(global.user.name),
          ),
          /*ListTile(
            leading: const Icon(CupertinoIcons.sidebar_left),
            title: const Text("centros de mesa"),
            onTap: () => {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => const QrCentroMesaWidget()),
              )
            },
          ),*/
          ListTile(
            leading: const Icon(CupertinoIcons.sidebar_left),
            title: const Text("Mesa"),
            onTap: () => {
             global.paginas.mesasConfigRoute(context: context)
            },
          ),

          /*ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Ordenes'),
            onTap: () => {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PagesWidget(page: 1,)),
              )
            },
          ),*/
          /*ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuraciones'),
            onTap: () => {Navigator.of(context).pop()},
          ),*/
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async {
              global.cerrarSesion(context: context);
            },
          ),
        ],
      ),
    );
  }
}