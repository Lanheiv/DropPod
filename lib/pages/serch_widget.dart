import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sendrop/core/network/services.dart'; 
import 'package:sendrop/pages/chat_widget.dart';

class SerchWidget extends StatefulWidget {
  const SerchWidget({super.key});

  @override
  State<SerchWidget> createState() => _SerchWidgetState();
}

class _SerchWidgetState extends State<SerchWidget> {
  bool hasNavigated = false;
  bool serchingStatus = false;
  Timer? searchTimer;

  final udp = udpService;
  final tcp = tcpService; 

  @override
  
  void initState() { // starte udp un tcp, un pārsūta lietotāju uz chat widget
    super.initState();

    udp.start();
    tcp.start();

    Future.microtask(() {
      serching();
    });

    udp.onDeviceFound = (device) {
      if (hasNavigated) return;
      hasNavigated = true;

      tcp.connectToDevice(device);

      if (searchTimer != null && searchTimer!.isActive) {
        searchTimer!.cancel();
        setState(() => serchingStatus = false);
      }

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatWidget()),
      );
    };
  }
  @override
  Widget build(BuildContext context) { // dizains
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: serchingStatus ? null : serching,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(232, 231, 231, 1),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            serchingStatus ? "Meklē ierīces..." : "Sākt meklēt",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          )
        )
      ),
    );
  }

  void serching() {
    int counter = 0;

    setState(() {
      serchingStatus = true;
    });

    searchTimer = Timer.periodic(Duration(seconds: 1), (t) {
      udp.sendRequest();
      counter++;

      if (counter >= 3) {
        t.cancel();

        setState(() {
          serchingStatus = false;
        });
      }
    }); 
  }
}