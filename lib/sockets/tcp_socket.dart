import 'dart:io';

import 'package:sendrop/model/app_data.dart';

class TcpService {
  List<Socket> peers = [];
  ServerSocket? socket;

  int port = AppData().port;

  Future<void> start() async {
    socket = await ServerSocket.bind(InternetAddress.anyIPv4, port);

  }
} 