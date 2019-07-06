import 'package:flutter/material.dart';
MaterialColor blue = MaterialColor(0xFF01579B, {
  50:Color(0xFF01579B),
  100:Color(0xFF01579B),
  200:Color(0xFF01579B),
  300:Color(0xFF01579B),
  400:Color(0xFF01579B),
  500:Color(0xFF01579B),
  600:Color(0xFF01579B),
  700:Color(0xFF01579B),
  800:Color(0xFF01579B),
  900:Color(0xFF01579B),
});

class MessageContainer extends StatelessWidget {
  final String text;
  final String who;
  final String me;
  MessageContainer({this.text, this.who, this.me});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(10),
        color: who==me?blue:Colors.red,
        child: Text(
          text,
          textDirection: who==me?TextDirection.rtl:TextDirection.ltr,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
