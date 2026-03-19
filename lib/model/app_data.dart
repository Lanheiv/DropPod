class AppData { // pagaidu class kur glabā datus jāpārtaisa
  static final AppData _instance = AppData._internal();
  factory AppData() => _instance;
  AppData._internal();

  String myusername = "test";
  String myUid = "12345";
  int port = 3001;
}

class Device { // pārdēvēšo failu un pārlikšu iespējams pārtaisītu visu struktūru
  String uid;
  String username;
  String ip;
  int tcpPort;

  Device({
    required this.uid,
    required this.username,
    required this.ip,
    required this.tcpPort,
  });
}