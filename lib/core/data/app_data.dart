import 'dart:math';

class AppData { // pagaidu class kur glabā datus jāpārtaisa
  static final AppData _instance = AppData._internal();
  factory AppData() => _instance;
  AppData._internal();

  String myusername = "test";
  final String myUid = _generateUid();

  int udpPort = 3001;
  int tcpPort = 3002;

  Map<String, Device> devices = {};

  static String _generateUid() { // ID ģenerēšana
    final random = Random();
    return [
      for (int i = 0; i < 10; i++)
        String.fromCharCode('0'.codeUnitAt(0) + random.nextInt(10))
    ].join();
  }
}

class Device { // pārdēvēšo failu un pārlikšu iespējams pārtaisītu visu struktūru
  String uid;
  String username;
  String ip;
  int tcpPort;
  bool status;

  Device({
    required this.uid,
    required this.username,
    required this.ip,
    required this.tcpPort,
    required this.status
  });
}