/*import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controller/page_manager.dart';
import '../models/user_login.dart' as user;
import '../controller/global.dart' as global;

import '../controller/chatnuevo_controller.dart';
import '../elements/record_button.dart';
import '../models/chat_audio.dart';
class ChatNuevo extends StatefulWidget{
  final ValueChanged<int> enviarMQTT;
  final String mesa;
  final String codigo;
  final String restaurante;
  const ChatNuevo({required this.codigo, required this.enviarMQTT, required this.mesa, required this.restaurante});

  @override
  _ChatNuevoState createState() => _ChatNuevoState();
}
class _ChatNuevoState extends StateMVC<ChatNuevo>{

  chat_nuevoController? _con;

  _ChatNuevoState() : super(chat_nuevoController()) {
    _con = controller as chat_nuevoController;
  }
  Stream<QuerySnapshot>? queryChat;
  TextEditingController mensajes = TextEditingController();
  int numeroMensaje = 0;
  double size = 70;
  double grabando = 0;
  int grabando_seg = 300;
  bool esNull = false;
  List<ChatAudio> chatAudioList = <ChatAudio>[];
  var subscription;
  @override
  void dispose() {
    global.pantalla = "";
    subscription.cancel();
    for(int i = 0; i < chatAudioList.length; i++)
      {
        chatAudioList[i].audio?.dispose();
      }
    super.dispose();
  }

  Future<void> conection()async{
    var isDeviceConnected = false;
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    print("hay internet: "+isDeviceConnected.toString());
  }

  Future<void> inicio() async{
    await Firebase.initializeApp();
    conection();
    var isDeviceConnected = false;
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if(result != ConnectivityResult.none) {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        print("hay internet: "+isDeviceConnected.toString());
      }
    });


    _con?.ScrollMensaje = ScrollController();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    queryChat =  firestore.collection('Chat').doc(widget.restaurante).collection(widget.codigo).orderBy("id",descending: false).snapshots();
    a();
    queryChat?.forEach((element) {
      element.docs.forEach((element) {
        print(element.reference.path);
      });
    });
  }
  @override
  void initState() {
    global.pantalla = "chat";
    global.codigo = widget.codigo;
    inicio();
    super.initState();
  }
  int cont = 0;
  ValueNotifier<bool> llegoAudio = ValueNotifier(true);
  void a() {

    llegoAudio.addListener(() {
      print("=================================");
      print("Hubo cambio");
      Future.delayed(const Duration(seconds: 1),(){
        newData.value = !newData.value;
      });
    });
    //
  }
  PageManager? player;
  ValueNotifier<bool> newData = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "¡Super Chat!",
          style: TextStyle(
            fontFamily: 'alteHaasGrotesk',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(CupertinoIcons.tickets),
              onPressed: (){
                //showCupones();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Prueba()));
              }
            ),
          )
        ],
      ),
      backgroundColor: const Color.fromRGBO(0, 31, 36, 1.0),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          const SizedBox(height: 10,),
          //listMensajes(),

         Expanded(
            child: Container(
              decoration: const BoxDecoration(
               /* gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(0,71,187,1.0),
                    Color.fromRGBO(45,204,211,1.0),
                  ]
                ),*/
              ),
              child: Stack(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: queryChat,
                    builder: (context, snapshotChat) {
                      if (snapshotChat.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      if (snapshotChat.hasError) {
                        return Center(child: Text(
                            snapshotChat.error.toString()));
                      }
                      QuerySnapshot<Object?>? querySnapshotChat = snapshotChat.data;
                      numeroMensaje = querySnapshotChat!.size;
                      print(querySnapshotChat.size);
                      conection();
                      return ValueListenableBuilder<bool>(
                        valueListenable: newData,
                        builder: (context, value, child) {
                          return  SingleChildScrollView(
                            controller: con.ScrollMensaje,
                            child: Column(
                              children: List.generate(querySnapshotChat.size, (index) {
                                if(index == (querySnapshotChat.size-1))
                                  {
                                    con.scrollEnd();
                                  }
                                bool audio = false;
                                if(querySnapshotChat.docs[index].get("tipo") == "audio" ) {
                                  audio = true;
                                }
                                else {
                                  audio = false;
                                }
                                if(querySnapshotChat.docs[index].get("tipo") == "llamadoMesero") {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                width: MediaQuery.of(context).size.width*0.5,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: Colors.yellow,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "¡Llamado a la mesa ${querySnapshotChat.docs[index].get("mesa")}!",
                                                      style: const TextStyle(
                                                        fontFamily: 'alteHaasGrotesk',
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color.fromRGBO(0, 31, 36, 1.0),
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    Expanded(
                                                      child: Image.asset("assets/img/mesero.png",width: 100,color: const Color.fromRGBO(0, 31, 36, 1.0)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: (){
                                               // mesaAtendida();
                                              },
                                            ),

                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                      ],
                                    );
                                  }
                                else if(querySnapshotChat.docs[index].get("tipo") == "Cupon") {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            width: MediaQuery.of(context).size.width*0.5,
                                            height: 180,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Theme.of(context).cardColor,
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                FittedBox(
                                                  child: Text(
                                                    "¡Enviaste un cupon ala mesa ${querySnapshotChat.docs[index].get("mesa")}!",
                                                    style: const TextStyle(
                                                      fontFamily: 'alteHaasGrotesk',
                                                      // fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      //color: Color.fromRGBO(0, 31, 36, 1.0),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                    "Cupon: "+querySnapshotChat.docs[index].get("cupon"),
                                                    style: const TextStyle(
                                                      fontFamily: 'alteHaasGrotesk',
                                                      // fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      //color: Color.fromRGBO(0, 31, 36, 1.0),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Expanded(
                                                  child: Text(
                                                    querySnapshotChat.docs[index].get("descripcion"),
                                                    style: const TextStyle(
                                                      fontFamily: 'alteHaasGrotesk',
                                                      //fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      //color: Color.fromRGBO(0, 31, 36, 1.0),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 80,
                                                  height: 80,
                                                  child: Image.asset("assets/images/mesero.png",width: 100,height: 100,/*color: const Color.fromRGBO(0, 31, 36, 1.0)*/),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  );
                                }
                                else {
                                  if(("${user.id}") == querySnapshotChat.docs[index].get("id_enviado").toString()) {
                                    return Container(
                                      alignment: Alignment.centerRight,
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width*0.5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                              margin: const EdgeInsets.only(right: 5),
                                              decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(0,71,187,1.0),
                                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15),topLeft: Radius.circular(15))
                                              ),
                                              child: Column(
                                                children: [
                                                  audio == true ?
                                                  FutureBuilder(
                                                    key: UniqueKey(),
                                                   // future: obtenerUrl(ordenId: querySnapshotChat.docs[index].get("id"),mensaje: querySnapshotChat.docs[index].get("mensaje")),
                                                    builder:(context, snapshot) {
                                                      ChatAudio? este;
                                                      bool encontrado = false;
                                                      int cont = 0;
                                                      for(int i = 0; i < chatAudioList.length; i++)
                                                      {
                                                        if(chatAudioList[i].id.toString() == querySnapshotChat.docs[index].get("id").toString())
                                                        {
                                                          encontrado = true;
                                                          cont = i;
                                                        }
                                                      }
                                                      if(chatAudioList.isNotEmpty)
                                                        {
                                                          este = chatAudioList[cont];
                                                        }
                                                      if(encontrado == false)
                                                      {
                                                        if(querySnapshotChat.docs[index].get("rutaAudio") == "")
                                                        {
                                                          return CircularProgressIndicator(key: UniqueKey(),);
                                                        }
                                                        else if(querySnapshotChat.docs[index].get("rutaAudio") != ""){
                                                          ChatAudio nuevo = ChatAudio();
                                                          nuevo.id = querySnapshotChat.docs[index].get("id").toString();
                                                          nuevo.audio = PageManager(querySnapshotChat.docs[index].get("rutaAudio"));
                                                          chatAudioList.add(nuevo);
                                                          este = chatAudioList.last;
                                                        }
                                                      }
                                                      esNull = false;
                                                      return SingleChildScrollView(
                                                        scrollDirection: Axis.horizontal,
                                                        child: SizedBox(
                                                          //width: 250,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: <Widget>[
                                                              ValueListenableBuilder<ButtonState>(
                                                                key: UniqueKey(),
                                                                valueListenable: este!.audio!.buttonNotifier,
                                                                builder: (_, value, __) {
                                                                  switch (value) {
                                                                    case ButtonState.loading:
                                                                      return Container(
                                                                        margin: const EdgeInsets.all(8.0),
                                                                        width: 32.0,
                                                                        height: 32.0,
                                                                        child: const CircularProgressIndicator(),
                                                                      );
                                                                    case ButtonState.paused:
                                                                      return IconButton(
                                                                        icon: const Icon(Icons.play_arrow,color: Colors.white,),
                                                                        iconSize: 32.0,
                                                                        onPressed: este!.audio!.play,
                                                                      );
                                                                    case ButtonState.playing:
                                                                      return IconButton(
                                                                        icon: const Icon(Icons.pause,color: Colors.white,),
                                                                        iconSize: 32.0,
                                                                        onPressed: este!.audio!.pause,
                                                                      );
                                                                  }
                                                                },
                                                              ),
                                                              const SizedBox(width: 5,),
                                                              SizedBox(
                                                                width: 98,
                                                                child: ValueListenableBuilder<ProgressBarState>(
                                                                  valueListenable: este.audio!.progressNotifier,
                                                                  builder: (_, value, __) {
                                                                    return ProgressBar(
                                                                      progress: value.current,
                                                                      buffered: value.buffered,
                                                                      total: value.total,
                                                                      onSeek: este!.audio!.seek,
                                                                      progressBarColor: Colors.white,
                                                                      timeLabelTextStyle: const TextStyle(color: Colors.white),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ) :
                                                  Text(
                                                    querySnapshotChat.docs[index].get("mensaje"),
                                                    style: const TextStyle(
                                                      fontFamily: 'alteHaasGrotesk',
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    maxLines: 100,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: true,
                                                  ),
                                                  const SizedBox(height: 5),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width*0.5,
                                              padding: const EdgeInsets.only(right: 20),
                                              child: Text(
                                                querySnapshotChat.docs[index].get("hora"),
                                                softWrap: true,
                                                textAlign: TextAlign.right,
                                                style: const TextStyle(
                                                  fontFamily: 'alteHaasGrotesk',
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  else {
                                    return Container(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width*0.5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15),topRight: Radius.circular(15),bottomRight: Radius.circular(15)),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                                margin: const EdgeInsets.only(left:  5),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).buttonColor.withValues(alpha:0.7),
                                                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15),topRight: Radius.circular(15))
                                                ),
                                                child: Column(
                                                  children: [
                                                    audio == true ?
                                                    FutureBuilder(
                                                      key: UniqueKey(),
                                                      // future: obtenerUrl(ordenId: querySnapshotChat.docs[index].get("id"),mensaje: querySnapshotChat.docs[index].get("mensaje")),
                                                      builder:(context, snapshot) {
                                                        ChatAudio? este;
                                                        bool encontrado = false;
                                                        int cont = 0;
                                                        for(int i = 0; i < chatAudioList.length; i++)
                                                        {
                                                          if(chatAudioList[i].id.toString() == querySnapshotChat.docs[index].get("id").toString())
                                                          {
                                                            encontrado = true;
                                                            cont = i;
                                                          }
                                                        }
                                                        if(chatAudioList.isNotEmpty)
                                                        {
                                                          este = chatAudioList[cont];
                                                        }
                                                        if(encontrado == false)
                                                        {
                                                          if(querySnapshotChat.docs[index].get("rutaAudio") == "")
                                                          {
                                                            /*if(querySnapshotChat.size-1 == index)
                                                            {
                                                              llegoAudio.notifyListeners();
                                                            }*/
                                                            return CircularProgressIndicator(key: UniqueKey(),);
                                                          }
                                                          else if(querySnapshotChat.docs[index].get("rutaAudio") != ""){
                                                            ChatAudio nuevo = ChatAudio();
                                                            nuevo.id = querySnapshotChat.docs[index].get("id").toString();
                                                            nuevo.audio = PageManager(querySnapshotChat.docs[index].get("rutaAudio"));
                                                            chatAudioList.add(nuevo);
                                                            este = chatAudioList.last;
                                                          }
                                                        }
                                                        esNull = false;
                                                        return SingleChildScrollView(
                                                          scrollDirection: Axis.horizontal,
                                                          child: SizedBox(
                                                            //width: 250,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: <Widget>[
                                                                ValueListenableBuilder<ButtonState>(
                                                                  key: UniqueKey(),
                                                                  valueListenable: este!.audio!.buttonNotifier,
                                                                  builder: (_, value, __) {
                                                                    switch (value) {
                                                                      case ButtonState.loading:
                                                                        return Container(
                                                                          margin: const EdgeInsets.all(8.0),
                                                                          width: 32.0,
                                                                          height: 32.0,
                                                                          child: const CircularProgressIndicator(),
                                                                        );
                                                                      case ButtonState.paused:
                                                                        return IconButton(
                                                                          icon: const Icon(Icons.play_arrow,color: Colors.white,),
                                                                          iconSize: 32.0,
                                                                          onPressed: este!.audio!.play,
                                                                        );
                                                                      case ButtonState.playing:
                                                                        return IconButton(
                                                                          icon: const Icon(Icons.pause,color: Colors.white,),
                                                                          iconSize: 32.0,
                                                                          onPressed: este!.audio!.pause,
                                                                        );
                                                                    }
                                                                  },
                                                                ),
                                                                const SizedBox(width: 5,),
                                                                SizedBox(
                                                                  width: 98,
                                                                  child: ValueListenableBuilder<ProgressBarState>(
                                                                    valueListenable: este.audio!.progressNotifier,
                                                                    builder: (_, value, __) {
                                                                      return ProgressBar(
                                                                        progress: value.current,
                                                                        buffered: value.buffered,
                                                                        total: value.total,
                                                                        onSeek: este!.audio!.seek,
                                                                        progressBarColor: Colors.white,
                                                                        timeLabelTextStyle: const TextStyle(color: Colors.white),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ) :
                                                    Text(
                                                      querySnapshotChat.docs[index].get("mensaje"),
                                                      style: const TextStyle(
                                                        fontFamily: 'alteHaasGrotesk',
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      maxLines: 100,
                                                      overflow: TextOverflow.fade,
                                                      softWrap: true,
                                                    ),
                                                    const SizedBox(height: 5),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width*0.5,
                                              padding: const EdgeInsets.only(left: 20),
                                              child: Text(
                                                querySnapshotChat.docs[index].get("hora"),
                                                softWrap: true,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  fontFamily: 'alteHaasGrotesk',
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],),
            ),
          ),
          bottones(
            enviarMQTT: (value){
              widget.enviarMQTT(1);
            },
            restaurante: widget.restaurante,
            mesa: widget.mesa,
            codigo: widget.codigo,
          ),
        ],
      ),
    );
  }
 FirebaseStorage firebaseStorage = FirebaseStorage.instance;
 Future<String> obtenerUrl({required ordenId,required mensaje}) async {
   String url = "null";
   try{
     url = await firebaseStorage.ref(mensaje).getDownloadURL();
   }catch(e)
   {
     print(e);
     Future.delayed(const Duration(seconds: 1),(){
       obtenerUrl(mensaje: mensaje, ordenId: ordenId);
     });
   }
   if(url == "null")
     {
       Future.delayed(const Duration(seconds: 1),(){
         obtenerUrl(mensaje: mensaje, ordenId: ordenId);
       });
     }
   else if(url == "")
     {
       Future.delayed(const Duration(seconds: 1),(){
         obtenerUrl(mensaje: mensaje, ordenId: ordenId);
       });
     }
   return url;
 }
 Future showCupones() {
   return showDialog(context: context, builder: (context){
     return Scaffold(
       backgroundColor: Colors.transparent,
       body: Container(
         color: Colors.black45,
         width: MediaQuery.of(context).size.width,
         height: MediaQuery.of(context).size.height,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 GestureDetector(
                   onTap: (){
                     Navigator.pop(context);
                   },
                   child: Container(
                     margin: const EdgeInsets.only(right: 20),
                     height: 30,
                     width: 30,
                     decoration: const BoxDecoration(
                         color: Colors.red,
                         borderRadius: BorderRadius.all(Radius.circular(15))
                     ),
                     child: const Icon(Icons.clear),
                   ),
                 ),
               ],
             ),
             const SizedBox(height: 10),
             Container(
               width: MediaQuery.of(context).size.width*0.8,
               height: MediaQuery.of(context).size.height*0.7,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(15),
                 color: Theme.of(context).cardColor,
               ),
               child: Column(
                 children: [
                   const SizedBox(height: 20),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Container(
                           width: 200,
                           height: 70,
                           decoration: const BoxDecoration(
                             borderRadius: BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15)),
                             color: Color.fromRGBO(45,204,211,1.0),
                           ),
                           child: Center(
                             child: Text(
                               "Cupones",
                               style: TextStyle(
                                 fontFamily: 'alteHaasGrotesk',
                                 fontWeight: FontWeight.bold,
                                 fontSize: 20,
                                 color: Theme.of(context).bottomAppBarColor,
                               ),
                             ),
                           )
                       ),
                     ],
                   ),
                   const SizedBox(height: 20),
                   //ChatCupones(codigo: widget.codigo,numeroMensaje:numeroMensaje,mesa: widget.mesa),
                 ],
               ),
             ),
           ],
         ),
       ),
     );
   });
 }
 Future<void> mesaAtendida() {
    return showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black45,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black45,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: const Icon(Icons.clear),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                  ],
                ),
                const SizedBox(height: 10,),
                Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  width: MediaQuery.of(context).size.width*0.8,
                  color: Theme.of(context).bottomAppBarColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "¿Mesa atendida?",
                        style: TextStyle(
                          fontFamily: 'alteHaasGrotesk',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.red,
                              ),
                              child: const Text(
                                "No",
                                style: TextStyle(
                                  fontFamily: 'alteHaasGrotesk',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              widget.enviarMQTT(10);

                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blue,
                              ),
                              child: const Text(
                                "Si",
                                style: TextStyle(
                                  fontFamily: 'alteHaasGrotesk',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
class respuestasRapidas extends StatefulWidget{
  final int numeroMensaje;
  final String mesa;
  final String codigo;
  final String restaurante;
  respuestasRapidas({required this.codigo,required this.numeroMensaje, required this.mesa,required this.restaurante});
  @override
  _respuestasRapidasState createState() => _respuestasRapidasState();
}
class _respuestasRapidasState extends StateMVC<respuestasRapidas> with SingleTickerProviderStateMixin {

  chat_nuevoController? _con;

  _respuestasRapidasState() : super(chat_nuevoController()) {
    _con = controller as chat_nuevoController;
  }
  void rellenarRespuestas()
  {
    for(int i = 0; i < 4; i++)
    {
      respuestas.add(Colors.black);
    }
  }
  Color Precionado = Colors.black;
  List<Color> respuestas = <Color>[];
  @override
  void initState() {
    rellenarRespuestas();
    super.initState();
  }
  int segundos = 500;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      primary: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 10,),
          GestureDetector(
            onTap: (){
              setState(() {
                respuestas[0] = Colors.blueAccent;
              });
              con.enviarMensajes(codigoChat: widget.codigo,mensajes: "Voy en camino",tipo: "Texto",mesa: widget.mesa, hora: (value){}, restaurante: widget.restaurante);
            },
            child: AnimatedContainer(
              //key: UniqueKey(),
              duration: Duration(milliseconds: segundos),
              padding: const EdgeInsets.all(10),
              child: const Center(child: Text("Voy en camino"),),
              onEnd: (){
                setState(() {
                  respuestas[0] = Colors.black;
                });
              },
              decoration: BoxDecoration(
                color: respuestas[0],
                borderRadius: BorderRadius.circular(15),
              ),
              curve: Curves.fastOutSlowIn,
            ),
          ),
          const SizedBox(width: 10,),
          GestureDetector(
            onTap: (){
              setState(() {
                respuestas[1] = Colors.blueAccent;
              });
              con.enviarMensajes(codigoChat: widget.codigo,mensajes: "Un momento porfavor",tipo: "Texto",mesa: widget.mesa,hora: (value){},restaurante: widget.restaurante);
            },
            child: AnimatedContainer(
              //key: UniqueKey(),
              duration: Duration(milliseconds: segundos),
              padding: const EdgeInsets.all(10),
              child: const Center(child: Text("Un momento porfavor"),),
              onEnd: (){
                setState(() {
                  respuestas[1] = Colors.black;
                });
              },
              decoration: BoxDecoration(
                color: respuestas[1],
                borderRadius: BorderRadius.circular(15),
              ),
              curve: Curves.fastOutSlowIn,
            ),
          ),
          const SizedBox(width: 10,),
          GestureDetector(
            onTap: (){
              setState(() {
                respuestas[2] = Colors.blueAccent;
              });
              con.enviarMensajes(codigoChat: widget.codigo,mensajes:"En seguida lo atiendo",tipo: "Texto",mesa: widget.mesa,hora: (value){},restaurante: widget.restaurante);
            },
            child: AnimatedContainer(
              //key: UniqueKey(),
              duration: Duration(milliseconds: segundos),
              padding: const EdgeInsets.all(10),
              child: const Center(child: Text("En seguida lo atiendo"),),
              onEnd: (){
                setState(() {
                  respuestas[2] = Colors.black;
                });
              },
              decoration: BoxDecoration(
                color: respuestas[2],
                borderRadius: BorderRadius.circular(15),
              ),
              curve: Curves.fastOutSlowIn,
            ),
          ),
          const SizedBox(width: 10,),
        ],
      ),
    );
  }
}
class bottones extends StatefulWidget{
  final ValueChanged<int> enviarMQTT;
  final String mesa;
  final String codigo;
  final String restaurante;
  bottones({required this.codigo,required this.enviarMQTT, required this.mesa,required this.restaurante});
  @override
  _bottonesState createState() => _bottonesState();
}
class _bottonesState extends StateMVC<bottones> with SingleTickerProviderStateMixin{

  chat_nuevoController? _con;

  _bottonesState() : super(chat_nuevoController()) {
    _con = controller as chat_nuevoController;
  }
  Stream<QuerySnapshot>? queryChat;
  TextEditingController mensajes = TextEditingController();
  int numeroMensaje = 0;
  double size = 70;
  double grabando = 0;
  int grabando_seg = 300;


  late AnimationController controllerAni;

  @override
  void initState() {
    queryChat = FirebaseFirestore.instance.collection('Chat').doc("Sushiko").collection(widget.codigo).orderBy("id",descending: false).snapshots();
    super.initState();
    controllerAni = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {

    controllerAni.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: queryChat,
          builder: (context, snapshotChat) {
            if (snapshotChat.connectionState == ConnectionState.waiting) {
              return Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator()
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                           SizedBox(
                              width: 90,
                              height: 90,
                              child: Icon(CupertinoIcons.bolt_horizontal_circle_fill,color: Colors.blueAccent),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              );
            }
            if (snapshotChat.hasError) {
              return Center(child: Text(
                  snapshotChat.error.toString()));
            }
            QuerySnapshot<Object?>? querySnapshotChat = snapshotChat.data;
            numeroMensaje = querySnapshotChat!.size;
            return Column(
              children: [
                respuestasRapidas(codigo: widget.codigo,numeroMensaje: numeroMensaje, mesa: widget.mesa, restaurante: widget.restaurante,),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: size,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.only(left: 20,right: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey.withValues(alpha:0.3),
                              ),
                              child: Center(
                                child: TextFormField(
                                  controller: mensajes,
                                  onChanged: (mensaje){

                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                      onPressed: ()  {
                                        mensajes.text.trim();
                                        if(mensajes.text != "")
                                        {
                                          con.enviarMensajes(codigoChat: widget.codigo ,mensajes: mensajes.text,tipo: "Texto",mesa: widget.mesa, hora: (value){},restaurante: widget.restaurante);
                                          widget.enviarMQTT(1);
                                        }
                                        mensajes.text = "";
                                      },
                                      icon: const Icon(Icons.send),
                                    ),
                                  ),
                                  autocorrect: true,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          RecordButton(
                            mesa: widget.mesa,
                            controller: controllerAni,
                            mensajeID: numeroMensaje,
                            ordenID: "1",
                            restaurante: widget.restaurante,
                            codigoChat: widget.codigo,
                            enviarMQTT: (int value) {  },
                            cargando: (String value) {  },
                              //key: UniqueKey()
                          ),
                          const SizedBox(width: 10,),
                        ],
                      ),
                      const SizedBox(height: 5,)
                    ],
                  ),
                )
              ],
            );
          },
        )
      ],
    );
  }
}
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import '../controllers/global.dart' as global;
import '../controllers/chat_controller.dart';
import '../elements/record_button.dart';
import '../models/user_login.dart' as user;
import 'audio_chat.dart';
class ChatNuevo extends StatefulWidget{
  final String codigo;
  final String id_restaurante;
  final String mesa;
  final ordenes;
  final ValueChanged<int> refresh;
  ChatNuevo({required this.codigo, required this.id_restaurante, required this.mesa, this.ordenes, required this.refresh});

  @override
  _ChatNuevoState createState() => _ChatNuevoState();
}

class _ChatNuevoState extends StateX<ChatNuevo> with SingleTickerProviderStateMixin{
  late ChatController con;

  _ChatNuevoState() : super(controller: ChatController()) {
    con = controller as ChatController;
  }

  @override
  void initState() {
    con.init(mesa: widget.mesa,codigo: widget.codigo);
    con.controllerAni = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    super.initState();
  }
  @override
  void dispose() {
    global.codigo = "";
    global.pantalla = "";
    global.sesion = "";
    widget.refresh(1);
    global.obtener_mesas();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      appBar: widget.ordenes == true ?
      AppBar(
        title: Text(
          "Super Chat".toUpperCase(),
          style: const TextStyle(
            fontFamily: 'alteHaasGrotesk',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ) :
      const PreferredSize(preferredSize: Size.zero,child: SizedBox(),),
      body: con.cargando_mensajes ?
      Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            children: [
              Center(
                child: Icon(CupertinoIcons.bolt_horizontal_circle_fill,size: 60,color: global.buttonColor),
              ),
              const Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          )
        ),) :
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: con.ScrollMensaje,

              child: Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child:  Wrap(
                  spacing: 10,
                  direction: Axis.vertical,
                  children: List.generate(con.mensajes.length, (index){
                    if(con.mensajes[index].id_enviado.toString() == global.user.id.toString()){
                      if(con.mensajes[index].tipo == "Texto"){
                        if(con.mensajes[index].hora == "enviando"){
                          return Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withValues(alpha: 0.4),
                                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15),topLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
                                      ),

                                      child: Text(
                                        con.mensajes[index].mensaje.toString(),
                                        style: TextStyle(
                                          fontFamily: 'alteHaasGrotesk',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white.withValues(alpha:0.7),
                                        ),
                                        textAlign: TextAlign.start,
                                        maxLines: 100,
                                        overflow: TextOverflow.fade,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width-20,
                                child: Text(
                                  con.mensajes[index].hora.toString(),
                                  style: Theme.of(context).textTheme.labelSmall,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          );
                        }else{
                          return Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10,left: 50),
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),topLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
                                      ),
                                      child: Text(
                                        con.mensajes[index].mensaje.toString(),
                                        style: const TextStyle(
                                          fontFamily: 'alteHaasGrotesk',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.start,
                                        maxLines: 100,
                                        overflow: TextOverflow.fade,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width-20,
                                child: Text(
                                  con.mensajes[index].hora.toString(),
                                  style: Theme.of(context).textTheme.labelSmall,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          );
                        }
                      }
                      else if(con.mensajes[index].tipo == "Audio"){
                        if(con.mensajes[index].hora == "enviando"){
                          return Container(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              // width: MediaQuery.of(context).size.width * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                                    decoration: BoxDecoration(
                                        color: Colors.blue.withValues(alpha:0.4),
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                            topLeft: Radius.circular(15))),
                                    child: Column(
                                      children: const [
                                        SizedBox(
                                          child: CircularProgressIndicator(),
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width-10,
                                    child: Text(
                                      con.mensajes[index].hora.toString(),
                                      style: Theme.of(context).textTheme.labelSmall,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        else{
                          return Container(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                                    decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                            topLeft: Radius.circular(15))),
                                    child: Column(
                                      children: [
                                        FutureBuilder(
                                          builder: (context,snapshot){
                                            return SingleChildScrollView(
                                              child: Container(
                                                padding: EdgeInsets.zero,
                                                width: 300,
                                                child:AudioChatWidget(audio_url: con.mensajes[index].rutaAudio.toString()),
                                              ),
                                            );
                                          }, future: null,
                                        ),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width-10,
                                    child: Text(
                                      con.mensajes[index].hora.toString(),
                                      style: Theme.of(context).textTheme.labelSmall,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                      else if(con.mensajes[index].tipo == "llamadoMesero"){
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.yellow,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: ElevatedButton(
                                    onPressed: (){
                                      print("se preciono ");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "¡Llamado a la mesa ${con.mensajes[index].mesa}!",
                                          style: const TextStyle(
                                            fontFamily: 'alteHaasGrotesk',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(0, 31, 36, 1.0),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Expanded(
                                          child: Image.asset(
                                              "assets/images/mesero.png",
                                              width: 100,
                                              color: const Color.fromRGBO(0, 31, 36, 1.0)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }else{
                        return const SizedBox();
                        /*return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.yellow,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "¡Llamaste al mesero a la mesa ${con.mensajes[index].mesa}!",
                                        style: const TextStyle(
                                          fontFamily: 'alteHaasGrotesk',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(0, 31, 36, 1.0),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Expanded(
                                        child: Image.asset(
                                            "assets/img/mesero.png",
                                            width: 100,
                                            color: const Color.fromRGBO(0, 31, 36, 1.0)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                          ],
                        );*/
                      }
                    }
                    else{
                      if(con.mensajes[index].tipo == "Texto"){
                        return Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),topRight: Radius.circular(15),bottomRight: Radius.circular(15)),
                                    ),
                                    child: Text(
                                      con.mensajes[index].mensaje.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'alteHaasGrotesk',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  con.mensajes[index].hora.toString(),
                                  style: Theme.of(context).textTheme.labelSmall,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),

                          ],
                        );
                      }
                      else if(con.mensajes[index].tipo == "Audio"){
                        return Container(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            // width: MediaQuery.of(context).size.width * 0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15)
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      FutureBuilder(
                                        builder: (context,snapshot){
                                          print("============================");
                                          print(con.mensajes[index].rutaAudio.toString());
                                          print(con.mensajes[index].tipo_usuario);
                                          if(con.mensajes[index].id_enviado.toString() != global.user.id){
                                            if(con.mensajes[index].visto.toString() == "0"){
                                              con.visto_llamnado(nombre: con.mensajes[index].nombre.toString(),id:con.mensajes[index].id.toString(),codigo: con.mensajes[index].codigo_chat.toString());
                                            }
                                          }
                                          return Container(
                                            padding: EdgeInsets.zero,
                                            width: 300,
                                            child:AudioChatWidget(audio_url: con.mensajes[index].rutaAudio.toString()),
                                          );/*VoiceMessage(
                                            audioSrc: con.mensajes[index].rutaAudio.toString(),
                                            played: false, // To show played badge or not.
                                            me: true, // Set message side.
                                            onPlay: () {
                                              if(con.mensajes[index].tipo_usuario=="centro mesa"){
                                                print("=================");
                                                print("onplay");
                                                print("=================");
                                                con.visto_llamnado(nombre: con.mensajes[index].nombre.toString(),id:con.mensajes[index].id.toString(),codigo: con.mensajes[index].codigo_chat.toString());
                                              }
                                            }, // Do something when voice played.
                                            meBgColor: Colors.blue,
                                          );*/
                                        }, future: null,
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width-10,
                                  child: Text(
                                    con.mensajes[index].hora.toString(),
                                    style: Theme.of(context).textTheme.labelSmall,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      else if(con.mensajes[index].tipo == "llamadoMesero"){
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                //padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: con.mensajes[index].visto == "1" ? Colors.greenAccent : Colors.yellow,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: ElevatedButton(
                                    onPressed: (){
                                      print("se preciono aaaa");
                                      if(con.mensajes[index].visto != "1" ){
                                        cargando();
                                        con.visto_llamnado(nombre: con.mensajes[index].nombre.toString(),id:con.mensajes[index].id.toString(),codigo: con.mensajes[index].codigo_chat.toString()).whenComplete((){
                                          setState(() {
                                            print("TERMINO  --------------------------");
                                            con.obtener_mensaje(chat_code: widget.codigo,id_restaurante: widget.id_restaurante,mesa: widget.mesa.toString());
                                          });
                                          Navigator.pop(context);
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      padding: EdgeInsets.zero,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "¡Llamado a la mesa ${con.mensajes[index].mesa}!",
                                          style: const TextStyle(
                                            fontFamily: 'alteHaasGrotesk',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(0, 31, 36, 1.0),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Expanded(
                                          child: Image.asset(
                                              "assets/images/mesero.png",
                                              width: 100,
                                              color: const Color.fromRGBO(0, 31, 36, 1.0)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else{
                        return const SizedBox();
                      }
                    }
                  }),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 10,right: 5),
                              width: MediaQuery.of(context).size.width*0.8,
                              height: 50,
                              decoration: BoxDecoration(
                                color: global.buttonColor.withValues(alpha:0.3),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: TextField(
                                  controller: con.tec,
                                  onChanged: (_mensaje){
                                    print(con.tec.text);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Mensaje",
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        if(con.tec.text != ""){
                                          con.guardar_mensaje(
                                            Mensaje: con.tec.text,
                                            tipo: "Texto",
                                            id_restaurante: widget.id_restaurante,
                                            mesa: widget.mesa,
                                            codigo_chat: widget.codigo,
                                            rutaAudio: "",
                                          );
                                          con.tec.text = "";
                                        }
                                      },
                                      icon: const Icon(Icons.send),
                                    ),
                                  ),
                                  autocorrect: true,
                                  style: const TextStyle(
                                    fontFamily: 'alteHaasGrotesk',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: RecordButton(
                                codigoChat: widget.codigo,
                                mesa: widget.mesa,
                                controller: con.controllerAni,
                                mensajeID: con.mensajes.length,
                                ordenID: "",
                                key: con.record,
                                id_restaurante: widget.id_restaurante,
                                enviar_mensaje: (List<String> respuesta){
                                  if(respuesta[0] == "true"){
                                    con.guardar_mensaje(
                                      Mensaje: respuesta[1],
                                      tipo: "Audio",
                                      mesa: widget.mesa.toString(),
                                      rutaAudio: respuesta[1],
                                      codigo_chat: widget.codigo,
                                      id_restaurante: widget.id_restaurante,
                                    );
                                  }
                                },
                                cargando: (String value){
                                  //con.agregarCargando(hora: value);
                                },
                                enviarMQTT: (value) {
                                  if (value == 1) {
                                    //widget.enviarMQTT(1);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> cargando() async{
    return showDialog(
      context: context,
      builder: (context){
        return WillPopScope(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onWillPop: ()async{
            return false;
          },
        );
      },
    );
  }
}