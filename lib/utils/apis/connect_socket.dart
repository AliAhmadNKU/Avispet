

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../shared_pref.dart';
import 'api_strings.dart';

late IO.Socket socket;

void connectSocket() {
  socket = IO.io(ApiStrings.socket, <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false,
  });
  socket.connect();
  socket.onConnect((_) {
    debugPrint('Socket connected.');
    connectUser();
    connectListener();
  });

  socket.onDisconnect((_) => debugPrint('Connection Disconnected'));
  socket.onReconnect((_) => debugPrint('Connection Reconnected'));
  socket.onConnectError((err) => debugPrint("Connection Error: $err"));
  socket.onError((err) => debugPrint("Error: $err"));
}


connectUser() {
  Map mapping = {'userId': sharedPref.getString(SharedKey.userId).toString()};
  socket.emit("connect_user", mapping);
}

connectListener() {
  socket.on('connect_listener', (newMessage) {
    debugPrint("CONNECTED_USER ==> $newMessage");
  });
}

socketOff(String listener){
  socket.off(listener);
}


disconnectSocket(){
  Map mapping = {"userId": sharedPref.getString(SharedKey.userId)};
  socket.emit("disconnect_user", mapping);
}



checkSocketConnect(){
  debugPrint('check socket connect ${socket.connect().connected}');
  if(!socket.connect().connected){
    debugPrint('SOCKET CALL AGAIN !...');
    connectSocket();
  }
}