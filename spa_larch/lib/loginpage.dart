import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'mat_inward.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var url = "http://larch.in/";
  var username = TextEditingController();
  var password = TextEditingController();
  var uname = 'Larch';
  var pword = 'Larch';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 50, 30, 0),
              height: 150,
              width: 350,
              // ignore: deprecated_member_use
              child: FlatButton(
                onPressed: () {
                  launch(url);
                },
                child: Image.asset('assets/images/LarchLogo.png'),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(90),
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 50, 30, 0),
              height: 400,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(90),
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  )),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 50, 30, 50),
                    child: TextFormField(
                      controller: username,
                      decoration: InputDecoration(
                        hintText: 'EMAIL/MOBILE',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(Icons.email),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 50),
                    child: TextFormField(
                      controller: password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: 'PASSWORD',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(Icons.lock),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: FloatingActionButton(
                      onPressed: () {
                        if (username.text == uname && password.text == pword) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Inward()));
                        } else {
                          // ignore: deprecated_member_use
                          Widget okbutton = FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Colors.red,
                              textColor: Colors.white,
                              child: Text('OK'));

                          AlertDialog dialog = AlertDialog(
                            title: Text('Validation'),
                            content: Text('Wrong Username or Password'),
                            actions: [okbutton],
                          );

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return dialog;
                              });
                        }
                      },
                      backgroundColor: Colors.pinkAccent[400],
                      shape: new CircleBorder(),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
