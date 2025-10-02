import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import '../../../config/theme/theme.dart';
import '../controllers/controllers.dart';
import '../widgets/circle/screens/screens.dart';

class LoginScreenWidget extends StatefulWidget {
  final String? deviceToken;
  const LoginScreenWidget({super.key,this.deviceToken,});
  @override
  _LoginScreenWidgetState createState() => _LoginScreenWidgetState();
}
class _LoginScreenWidgetState extends StateX<LoginScreenWidget> {
  late LoginController con;

  _LoginScreenWidgetState() : super(controller: LoginController()) {
    con = controller as LoginController;
  }
  @override
  Widget build(BuildContext context){
    Size sizes = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colorBackground,
        appBar: AppBar(
          title: Text(
            "Login",
            style: titleStyle,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: colorBackground,
        ),
        body: SafeArea(
          child: SizedBox(
            height: sizes.height,
            width: sizes.width,
            child: Stack(
              children: [
                BouncingCircles(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: sizes.width,
                  height: sizes.height,
                  child: Form(
                    key: con.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ],
                            image: DecorationImage(
                              image: AssetImage('assets/app/logo.png'),
                              fit: BoxFit.cover,),
                          ),
                        ),
                        const SizedBox(height: 25,),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: cardBackground,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: con.userController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'Usuario',
                                  hintText: 'Ususario',
                                  prefixIcon: const Icon(Icons.person),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Ingresa tu usuario';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20,),
                              TextFormField(
                                controller: con.passController,
                                obscureText: con.obscurePassword,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      con.obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    ),
                                    onPressed: () => setState(() => con.obscurePassword = !con.obscurePassword),
                                  ),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
                                  if (v.length < 5) return 'La contraseña debe tener al menos 5 caracteres';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20,),
                              SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: (){
                                    con.trySubmit(widget,context);

                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorBtnGuardar,
                                    foregroundColor: colorBackground,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Iniciar sesion",
                                      style: labelBoldStyle?.copyWith(
                                        color: colorBackground,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  /*
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
  }*/
}
