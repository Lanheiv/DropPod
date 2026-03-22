import 'dart:io';
import 'dart:convert';

import 'package:sendrop/model/app_data.dart';

class TcpService {
  Function(String message)? onMessageReceived;

  List<Socket> peers = [];
  ServerSocket? socket;

  int port = AppData().tcpPort;

  Future<void> start() async {
    socket = await ServerSocket.bind(InternetAddress.anyIPv4, port);

    socket!.listen((client) {
      listenToSocket(client);
    });
  }
  Future<void> connectToDevice(Device device) async {
    final socket = await Socket.connect(device.ip, device.tcpPort);

    listenToSocket(socket);
  } 

  void listenToSocket(Socket socket) {
    peers.add(socket);

    socket.listen((data) {
      String message = utf8.decode(data);
      print("Received: $message");
      
      if (onMessageReceived != null) {
        onMessageReceived!(message);
      }
    },
    onDone: () {
      peers.remove(socket);
    });
  }
  void sendMessage(String text) {
    for (var peer in peers) {
      peer.write(text);
    }
  }
} 