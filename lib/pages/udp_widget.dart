import 'package:flutter/material.dart';

import 'package:sendrop/udp/udp_socket.dart';

class UdpWidget extends StatelessWidget {
  const UdpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: ElevatedButton(
          onPressed: () {},
          child: Text("Start searching")
        ),
      ),
    );
  }
}

