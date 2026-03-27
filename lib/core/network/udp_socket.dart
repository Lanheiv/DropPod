import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sendrop/core/data/app_data.dart';

class UdpService {
  static final UdpService _instance = UdpService._internal();
  factory UdpService() => _instance;
  UdpService._internal();

  String requestMassage = "DEVICE_REQUEST";
  String responseMassage = "DEVICE_RESPONSE";

  String myusername = AppData().myusername; // šitos visus mainīgos pārtaisīšu savādāk (shared_preferences izmantojot iespējams)
  String myUid = AppData().myUid;
  int port = AppData().udpPort;
  
  RawDatagramSocket? socket;
  final appData = AppData();
  
  Function(Device device)? onDeviceFound;

  Future<void> start() async { // automātiski paliž šo funkciju lai varētu klausīties noteiktā portā 
    if (socket != null) return;

    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port); // definē ka vajag meklēt gan wifi, gan ethernet un jāklausās definētā port kas ir iekšā app_data
    socket!.broadcastEnabled = true;

    socket!.listen((event) { // palaiž ja dzird kautko 
      if (event == RawSocketEvent.read) {

        final datagram = socket!.receive();

        if (datagram == null) return;

        String message = utf8.decode(datagram.data);

        try { // datu validācija un lietotāju saglabāšana
          var json = jsonDecode(message);

          if (json['type'] == requestMassage) {
            sendResponse(datagram.address);
          } 

          if (json['type'] == responseMassage) {
            if (json['uid'] == myUid) return;

            if(!appData.devices.containsKey(json['uid'])) {
              final device = Device(
                uid: json['uid'],
                username: json['username'],
                ip: json['ip'],
                tcpPort: json['chat_port'],
                status: true
              );

              appData.devices[json['uid']] = device;

              if (onDeviceFound != null) {
                onDeviceFound!(device);
              }
            }
          }
        } catch (e) {
          debugPrint("Errore on message reciving");
        }
      }
    });
  }
  Future<String> getLocalIp() async { // iegūst savu locālo ip
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4) {
          return addr.address;
        }
      }
    }
    return "0.0.0.0";
  }

  void sendResponse(InternetAddress adr) async { // nosūt udp ziņu ka eksistē
    String ip = await getLocalIp();

    Map json = {
      "type": responseMassage,
      "username": myusername,
      "uid": myUid,
      "ip": ip,
      "chat_port": AppData().tcpPort
    };

    List<int> data = utf8.encode(jsonEncode(json));

    socket!.send(
      data,
      adr,
      port,
    );
  }
  void sendRequest() { // nosūta upd pieprasijumu
    Map json = {
      "type": requestMassage,
      "uid": myUid,
      "username": myusername,
    };

    List<int> data = utf8.encode(jsonEncode(json));

    socket!.send(data, InternetAddress("255.255.255.255"), port);
  }
}