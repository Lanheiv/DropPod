import 'dart:convert';
import 'dart:io';

import 'package:sendrop/model/app_data.dart';

class UdpService { // vēlāk jāpārtaisa koda struktūra
  static final UdpService _instance = UdpService._internal();
  factory UdpService() => _instance;
  UdpService._internal();

  String requestMassage = "DEVICE_REQUEST";
  String responseMassage = "DEVICE_RESPONSE";

  String myusername = AppData().myusername; // šitos visus mainīgos pārtaisīšu savādāk (shared_preferences izmantojot iespējams)
  String myUid = AppData().myUid;
  int port = AppData().port;

  RawDatagramSocket? socket;
  Map<String, Device> devices = {};
  
  Future<void> start() async {
    if (socket != null) return;

    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    socket!.broadcastEnabled = true;

    socket!.listen((event) {
      if (event == RawSocketEvent.read) {
        Datagram? datagram = socket!.receive();

        if (datagram == null) return;

        String message = utf8.decode(datagram.data);
        String senderIp = datagram.address.address;

        try {
          var json = jsonDecode(message);

          if (json['type'] == requestMassage) {
            sendResponse(datagram.address);
          } 

          //if (json['uid'] == myUid) return;
          if (json['type'] == responseMassage) {
            if(!devices.containsKey(json['uid'])) {
              devices[json['uid']] = Device(
                uid: json['uid'],
                username: json['username'],
                ip: senderIp,
                tcpPort: json['chat_port'],
              );
            }
          }
        } catch (e) {}
      }
    });
  }

  void sendResponse(InternetAddress adr) {
    Map json = {
      "type": responseMassage,
      "username": myusername,
      "uid": myUid,
      "chat_port": port
    };

    List<int> data = utf8.encode(jsonEncode(json));

    socket!.send(
      data,
      adr,
      port,
    );
  }
  void sendRequest() {
    Map json = {
      "type": requestMassage,
      "uid": myUid,
    };

    List<int> data = utf8.encode(jsonEncode(json));

    socket!.send(
      data,
      InternetAddress("255.255.255.255"),
      port,
    );
  }
}