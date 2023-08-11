import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateFormat formatterTime = DateFormat('dd.MM.yyyy hh:mm');
DateFormat formatterDate = DateFormat('dd.MM.yyyy');

String? currentUser="";

String starUnicode = '\u{131f}';

double space = 9;

TextStyle small = TextStyle(fontSize: 14, color: Colors.black87,);

TextStyle normal = TextStyle(fontSize: 18, color: Colors.black);
TextStyle normalWhite = TextStyle(fontSize: 18, color: Colors.white);
TextStyle normalGreen = TextStyle(fontSize: 18, color: Colors.green);
TextStyle normalRed = TextStyle(fontSize: 18, color: Colors.red);
TextStyle normalBlue = TextStyle(fontSize: 18, color: Colors.blue);

TextStyle normalGrey = TextStyle(fontSize: 18, color: Colors.blueGrey.shade500);

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.blueGrey.shade500;
  }

  if (states.contains(MaterialState.disabled)) {
    return Colors.blueGrey.shade100;
  }

  return Colors.blueGrey.shade300;
}