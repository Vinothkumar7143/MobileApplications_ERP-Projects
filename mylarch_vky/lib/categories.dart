import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'attendance.dart';

List categories =
[
  {
    "name": "Meat",
    "icon": FontAwesomeIcons.drumstickBite,
    "items": "Out of Stock",
    "tap" : OutSalesReceivable(),
  },
  {
    "name": "Fish",
    "icon": FontAwesomeIcons.fish,
    "items": 20
  },
  {
    "name": "Chicken",
    "icon": FontAwesomeIcons.drumstickBite,
    "items": 9
  },
  {
    "name": "Red Meat",
    "icon": FontAwesomeIcons.drumstickBite,
    "items": 5
  },
];
