import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subChat;
StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subMensajes;
StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subfChats;
bool iniciado = false;
bool checarOrdenes = false;