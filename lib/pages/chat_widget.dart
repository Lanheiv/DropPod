import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sendrop/sockets/tcp_socket.dart';
import 'package:sendrop/model/app_data.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TcpService tcp = TcpService();
  final devices = AppData().devices;
  final TextEditingController controller = TextEditingController();

  List<String> messages = [];

  int onlineCount = AppData().devices.values.where((d) => d.status).length;

  @override
  void initState() {
    super.initState();

    tcp.onMessageReceived = (msg) {
      if (!mounted) return;

      setState(() {
        messages.add("Peer: $msg");
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Container(
        margin: EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: messages.map((msg) {
                  final isMe = msg.startsWith("Me:");

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.green[200] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SelectableText(msg),
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 40,
                    spreadRadius: 0.0,
                  )
                ]
              ),
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (text) {
                  if (text.trim().isEmpty) return;

                  tcp.sendMessage(text);
                  setState(() {
                    messages.add("Me: $text");
                  });

                  controller.clear();
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  hintText: "Type a message...",

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        "DropPod", // pārveido par user serch button
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
      ),
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 15, top: 5, bottom: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                child: SvgPicture.asset(
                  "assets/icons/user.svg",
                  colorFilter: ColorFilter.mode(Colors.green, BlendMode.srcIn),
                )
              ),
              SelectableText(
                onlineCount.toString(),
                style: TextStyle( color: Colors.green),
              ),
            ],
          )
        ),
      ],
    );
  }
}