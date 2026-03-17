import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40, left: 30, right: 30,),
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
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        "DropPod", 
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
      ),
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: Container(
        margin: EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child: GestureDetector(
          onTap: () {
            // šeit pogas darbība
          },
          child: SvgPicture.asset("assets/icons/settings.svg")
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 15, top: 5, bottom: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  // šeit pogas darbība
                },
                child: SvgPicture.asset(
                  "assets/icons/user.svg",
                  colorFilter: ColorFilter.mode(Colors.green, BlendMode.srcIn),
                )
              ),
              Text(
                "1",
                style: TextStyle(
                  color: Colors.green,
                ),
              )
            ],
          )
        ),
      ],
    );
  }
}