import 'dart:convert';
import 'dart:io';

class UdpService {
  String myusername = "test"; // username can be change later in menu
  String myUid = "12345"; // testing specal uid generator 

  String requestMassage = "DEVICE_REQUEST";
  String responseMassage = "DEVICE_RESPONSE";
  int port = 3001;

  RawDatagramSocket? socket;
  Map<String, Device> devices = {};
  
  Future<void> start() async {
    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    socket!.broadcastEnabled = true;
    
    print("UDP listening on $port");

    socket!.listen((event) {
      if (event == RawSocketEvent.read) {
        Datagram? datagram = socket!.receive();

        if (datagram == null) return;

        String message = utf8.decode(datagram.data);
        String senderIp = datagram.address.address;

        try {
          var json = jsonDecode(message);

          if (json['uid'] == myUid) return;
          
          print("Received ${json['type']} from ${json['username']}");

          if (json['type'] == requestMassage) {
            sendResponse(datagram.address);
          } 
          if (json['type'] == responseMassage) {
            if(!devices.containsKey(json['uid'])) {
              devices[json['uid']] = Device(
                uid: json['uid'],
                username: json['username'],
                ip: senderIp,
                chatPort: json['chat_port'],
              );
              
              print("Device discovered: ${json['username']} at $senderIp");
            }
          }
        } catch (e) {} // ja nav json tad neko
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

    print("Response sent to ${adr.address}");
  }
  void sendRequest() {
    Map json = {
      "type": requestMassage
    };

    List<int> data = utf8.encode(jsonEncode(json));

    socket!.send(
      data,
      InternetAddress("255.255.255.255"),
      port,
    );

    print("Broadcast sent"); 
  }
}

class Device {
  String uid;
  String username;
  String ip;
  int chatPort;

  Device({
    required this.uid,
    required this.username,
    required this.ip,
    required this.chatPort,
  });
}