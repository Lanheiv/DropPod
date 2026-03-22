import 'package:flutter/material.dart';

import 'package:sendrop/sockets/services.dart'; 
import 'package:sendrop/pages/chat_widget.dart';

class SerchWidget extends StatefulWidget {
  const SerchWidget({super.key});

  @override
  State<SerchWidget> createState() => _SerchWidgetState();
}

class _SerchWidgetState extends State<SerchWidget> {
  final udp = udpService;
  final tcp = tcpService; 

  bool hasNavigated = false;

  @override // on load run one time sendRequest() [plāns]
  void initState() {
    super.initState();

    udp.start();
    tcp.start();

    udp.onDeviceFound = (device) {
      if (hasNavigated) return;

      hasNavigated = true;

      tcp.connectToDevice(device);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatWidget()),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            udp.sendRequest();
          }, 
          child: Text("Start searching")
        )
      ),
    );
  }
}