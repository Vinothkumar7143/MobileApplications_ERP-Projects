import 'package:flutter/material.dart';


class HomeCategory extends StatefulWidget {
  final IconData icon;
  final String title;
  String? items;
  final VoidCallback tap;
  final bool isHome;
  final Color color;

  HomeCategory({
    required this.icon,
    required this.title,
    this.items,
    required this.tap, required this.isHome,required this.color});

  @override
  _HomeCategoryState createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.tap,
      child: Card(
        color: widget.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 0.0, right: 10.0),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "${widget.title}",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                  // Text(
                  //    "Items : ${widget.items}",
                  //   style: TextStyle(
                  // fontWeight: FontWeight.w400,
                  // fontSize: 10,
                  // ),
                  // ),,
                ],
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}
