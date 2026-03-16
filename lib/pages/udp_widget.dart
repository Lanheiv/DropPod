import 'package:flutter/material.dart';

import 'package:sendrop/sockets/udp_socket.dart';

class UdpWidget extends StatefulWidget {
  const UdpWidget({super.key});

  @override
  State<UdpWidget> createState() => _UdpWidgetState();
}

class _UdpWidgetState extends State<UdpWidget> {
  final UdpService udp = UdpService();

  @override
  void initState() {
    super.initState();
    udp.start();
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
        ),
      ),
    );
  }
}