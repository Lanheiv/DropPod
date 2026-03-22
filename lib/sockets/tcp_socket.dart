import 'dart:io';
import 'dart:convert';

import 'package:sendrop/model/app_data.dart';

class TcpService {
  Function(String message)? onMessageReceived;

  List<Socket> peers = [];
  ServerSocket? socket;

  int port = AppData().port;

  Future<void> start() async {
    socket = await ServerSocket.bind(InternetAddress.anyIPv4, port);

    socket!.listen((client) {
      peers.add(client);

      listenToSocket(client);
    });
  }
  Future<void> connectToDevice(Device device) async {
    final socket = await Socket.connect(device.ip, device.tcpPort);

    peers.add(socket);

    listenToSocket(socket);
  } 

  void listenToSocket(Socket socket) {
    socket.listen((data) {
      String message = utf8.decode(data);
      print("Received: $message");
    });
  }
  void sendMessage(String text) {
    for (var peer in peers) {
      peer.write(text);
    }
  }
} 