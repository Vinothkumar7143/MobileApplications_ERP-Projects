import 'package:flutter/material.dart';

import 'inward_rollback.dart';
import 'location_mapping.dart';
import 'loginpage.dart';
import 'mat_inward.dart';
import 'mat_outward.dart';
import 'outward_rollback.dart';

class Contactus extends StatefulWidget {
  const Contactus({Key? key}) : super(key: key);

  @override
  _ContactusState createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset('assets/images/LarchLogo.png',height: 150,width: 150,),
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Image.asset(
                          'assets/images/LarchLogo.png',
                        )),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.login_outlined),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Inward', style: TextStyle(fontSize: 20.0)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Inward()));
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.logout_outlined),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Outward', style: TextStyle(fontSize: 20.0)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Outward()));
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text('Location Mapping',
                              style: TextStyle(fontSize: 20.0)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LocationMapping()));
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.arrow_forward),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Inward Rollback',
                              style: TextStyle(fontSize: 20.0)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InwardRollback()));
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.arrow_back),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Outward Rollback',
                              style: TextStyle(fontSize: 20.0)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OutwardRollback()));
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.contact_support_outlined),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Contact Us', style: TextStyle(fontSize: 20.0)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Contactus()));
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.logout_rounded),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Logout', style: TextStyle(fontSize: 20.0)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    children: [
                      Divider(color: Colors.black),
                      Text('Version 1.0.0.1')
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: Column(
                children: [
                  Text('Contactus',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          decoration: TextDecoration.underline)),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Larch Technologies Private Limited Survey No: 479/4, 200 Feet Road, Madhavaram, Chennai - 600060',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Contact:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      Text(
                        '+91 9884164415',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}
