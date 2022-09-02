import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import 'admindash.dart';
import 'animation/fadeanimation.dart';
import 'package:http/http.dart' as http;

import 'dashboard.dart';

var userfirstname;
var userid;
var rightid;
bool management = false;


class LoginScreeen extends StatefulWidget {
  const LoginScreeen({Key? key}) : super(key: key);

  @override
  _LoginScreeenState createState() => _LoginScreeenState();
}

class _LoginScreeenState extends State<LoginScreeen> {

  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  //final snackBar = SnackBar(content: Text('email ou mot de passe incorrect'));
  var url = "http://larch.in/";
  final _formKey = GlobalKey<FormState>();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double r = (175 / 360); //  rapport for web test(304 / 540);
    final coverHeight = screenWidth * r;
    bool _pinned = false;
    bool _snap = false;
    bool _floating = false;
    bool logged = false;

    checkUser(url) async {
      var response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body);
      for(int i=0;i<data.length;i++){
        if(data[i]['Success'] == 'Success'){
          userfirstname = data[i]['Firstname'];
          userid = data[i]['um_iId'];
          rightid = data[i]['RightsId'];
          if(rightid == '1'){
            setState(() {
              management = true;
            });
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoadingScreen()));
          }
          else{
            setState(() {
              management = false;
            });
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
          }
        }
        else{
          Alert(
            context: context,
            desc: "Wrong Username or Password",
            image: Image.asset("assets/images/error.jpg",height: 80.0,width: 80.0,),
            buttons: [
              DialogButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        }
      }
    }

    return WillPopScope(
      child: Scaffold(
            extendBodyBehindAppBar: true,
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/my_larch.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/images/LarchLogo.png"),
                      SizedBox(
                        height: 100,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Login ',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              InputTextWidget(
                                  controller: _emailController,
                                  labelText: "Username",
                                  icon: Icons.email,
                                  obscureText: false,
                                  keyboardType: TextInputType.emailAddress),
                              SizedBox(
                                height: 12.0,
                              ),
                              InputTextWidget(
                                  controller: _pwdController,
                                  labelText: "Password",
                                  icon: Icons.lock,
                                  obscureText: true,
                                  keyboardType: TextInputType.text),
                              SizedBox(
                                height: 30.0,
                              ),
                              Container(
                                height: 55.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    var url = "http://m.demo.larchvms.com/Home/FetchLoginDetails?LoginId=${_emailController.text}&Password=${_pwdController.text}";
                                    checkUser(url);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    elevation: 0.0,
                                    minimumSize: Size(screenWidth, 150),
                                    padding: EdgeInsets.symmetric(horizontal: 30),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(0)),
                                    ),
                                  ),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.red,
                                              offset: const Offset(1.1, 1.1),
                                              blurRadius: 10.0),
                                        ],
                                        color: Colors.red, // Color(0xffF05945),
                                        borderRadius: BorderRadius.circular(12.0)),
                                    child:
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "LOGIN",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 25.0, top: 10.0),
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          launch(url);
                                        },
                                        child: Text(
                                          "Powered by larch",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[700]),
                                        ),
                                      ),
                                    )),
                              ),
                              SizedBox(height: 50.0,),

                            ],
                          )),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ), onWillPop: () async => false);
  }
}

