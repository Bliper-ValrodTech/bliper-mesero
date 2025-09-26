import 'package:bliper_mesero/src/controllers/login_controller.dart';
import 'package:bliper_mesero/src/repository/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import '../controllers/global.dart' as global;

class LoginWidget extends StatefulWidget {
  final String? deviceToken;
  const LoginWidget({Key? key,this.deviceToken,}) : super(key: key);
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}
class _LoginWidgetState extends StateX<LoginWidget> {
  late LoginController con;

  _LoginWidgetState() : super(controller: LoginController()) {
    con = controller as LoginController;
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Theme.of(context).brightness != Brightness.dark
                    ? 'assets/app/login.png'
                    : 'assets/app/login_dark.jpg'),
                fit: BoxFit.cover),
          ),
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Iniciar session".toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'alteHaasGrotesk',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              automaticallyImplyLeading: false,
            ),
            backgroundColor: Colors.transparent,
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.89,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: const Text(
                          "Bienvenido",
                          style: TextStyle(
                            fontFamily: 'alteHaasGrotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 35, right: 35),
                            child: Column(
                              children: [
                                AnimatedOpacity(
                                  opacity: con.opacidad,
                                  duration: const Duration(milliseconds: 500),
                                  child: Text(
                                    con.error,
                                    style: Theme.of(context).textTheme.labelMedium!.merge(const TextStyle(fontSize: 18,color: Colors.red)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  onChanged: (_usuario) {
                                    setState(() {
                                      con.usuario = _usuario;
                                    });
                                  },
                                  style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                          Brightness.dark
                                          ? Colors.white
                                          : Colors.black),
                                  decoration: InputDecoration(
                                      fillColor: Theme.of(context).brightness ==
                                          Brightness.dark
                                          ? Colors.black26
                                          : Colors.grey.shade100,
                                      filled: true,
                                      hintText: "Usuario",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextField(
                                  onChanged: (_password) {
                                    setState(() {
                                      con.password = _password;
                                    });
                                  },
                                  style: const TextStyle(),
                                  obscureText: con.visible,
                                  decoration: InputDecoration(
                                      fillColor: Theme.of(context).brightness ==
                                          Brightness.dark
                                          ? Colors.black26
                                          : Colors.grey.shade100,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          con.visible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if(con.visible == true)
                                            {
                                              con.visible = false;
                                            }
                                            else
                                            {
                                              con.visible = true;
                                            }
                                          });
                                        },
                                      ),
                                      filled: true,
                                      hintText: "Contraseña",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Iniciar Sesion',
                                      style: TextStyle(
                                          fontSize: 27, fontWeight: FontWeight.w700),
                                    ),
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: const Color(0xff4c505b),
                                      child: IconButton(
                                        color: Colors.white,
                                        onPressed: () async {
                                          con.login(context: context);
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        },
    );
  }
  Future<void> Cargando() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
