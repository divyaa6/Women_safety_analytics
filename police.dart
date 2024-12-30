import 'package:flutter/material.dart';
import 'package:sos/emergency.dart';
import 'package:sos/emergency2.dart';
import 'package:sos/emergency3.dart';
class police extends StatelessWidget {
  const police({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          PoliceEmergency(),
          RailwayEmergency(),
          WomenHelp()
        ],
      ),
    );
  }
}