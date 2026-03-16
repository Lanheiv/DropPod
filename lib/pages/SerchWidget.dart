import 'package:flutter/material.dart';

import 'package:sendrop/sockets/udp_socket.dart';
import 'package:sendrop/pages/ChatWidget.dart';

class SerchWidget extends StatefulWidget {
  const SerchWidget({super.key});

  @override
  State<SerchWidget> createState() => _SerchWidgetState();
}

class _SerchWidgetState extends State<SerchWidget> {
  final UdpService udp = UdpService();

  @override // on load run one time sendRequest() [plāns]
  void initState() {
    super.initState();
    udp.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            udp.sendRequest();

            await Future.delayed(Duration(milliseconds: 40));

            final deviceList = udp.devices.values;
            if (deviceList.isNotEmpty) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ChatWidget()));
            }
          }, 
          child: Text("Start searching")
        )
      ),
    );
  }
}