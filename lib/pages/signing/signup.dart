import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:location/location.dart';
import 'package:moadatydriver/helpers/getlocation.dart';
import 'package:moadatydriver/helpers/showtoast.dart';

import 'package:moadatydriver/main.dart';
import 'package:moadatydriver/models/Constants.dart';
import 'package:moadatydriver/pages/signing/login.dart';

class signup extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _signup();
  }
}
class _signup extends State<signup>{
  @override
  void initState() {
    getLocation(Constants.latitude, Constants.longitude);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: color,
        title: new Text(translate("signup.app_bar")),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyApp()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              width: MediaQuery.of(context).size.width,
              height: 160,
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.center,
                  image: AssetImage('images/backsignup.png'),
                  fit: BoxFit.fill,
                ),
              ),
              alignment: Alignment.center,
              child: new Image.asset(
                'images/logo.png',
                height: 125,
                width: 125,
              ),
            ),
            new Container(
              padding: EdgeInsets.only(right: 33, left: 33, top: 10),
              child: Form(
                key: formkey,
                child: new Column(
                  children: <Widget>[
                    new Container(
                      height: 54,
                      width: MediaQuery.of(context).size.width,
                      child: new TextFormField(
                        validator: (value) =>
                        value.isEmpty ? 'Username can\'t be empty' : null,
                        controller: _usernameController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        cursorWidth: 2.0,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.black, width: 1.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: translate("signup.username"),
                          icon: Icon(Icons.person),
                        ),
                        onTap: () {},
                        autofocus: false,
                        cursorColor: Colors.black,
                        style: TextStyle(
                            color: Colors.black, decorationColor: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    new Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: new TextFormField(
                        validator: (value) => value.length < 15
                            ? 'Email must be more than 10 character'
                            : null,
                        controller: _emailController,
                        cursorWidth: 2.0,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.black, width: 1.0),
                          ),
                          hintText: translate("signup.email"),
                          icon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        onTap: () {},
                        autofocus: false,
                        cursorColor: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    new Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: new TextFormField(
                        controller: _mobilephonecontroller,
//                            validator: (value) => value.length > 12? '' : null,
                        cursorWidth: 2.0,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.black, width: 1.0),
                          ),
                          hintText: translate("signup.phone"),
                          icon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        onTap: () {},
                        autofocus: false,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    new Container(
                      height: 47,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: new TextFormField(
                        validator: (value) => value.length < 6
                            ? 'Paasword must be more than 6 character'
                            : null,
                        controller: _passwordController,
                        cursorWidth: 2.0,
                        obscureText: _passsecur,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.black, width: 1.0),
                          ),
                          hoverColor: Colors.black,
                          hintText:translate("signup.password"),
                          icon: Icon(Icons.lock),
                        ),
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        onTap: () {},
                        autofocus: false,
                        cursorColor: Colors.black,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 200,
                        child: new CheckboxListTile(
                          value: _checkpass,
                          onChanged: onChangedPassShowing,
                          title: new Text(translate("signup.show_pass")),
                          activeColor: color,
                        ),
                      ),
                    ),
                    new SizedBox(
                      height: 47,
                      width: MediaQuery.of(context).size.width,
                      child: new RaisedButton(
                        onPressed: () {
                            if(Constants.latitude.toString().isEmpty){
                              showToast("من فضلك فعل ال gbs");
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>login()));
                            }else{
                              if (_usernameController.text.toString().trim().isEmpty ||
                                  _emailController.text
                                      .toString()
                                      .trim()
                                      .isEmpty ||
                                  _passwordController.text
                                      .toString()
                                      .trim()
                                      .isEmpty ||
                                  _mobilephonecontroller.text
                                      .toString()
                                      .trim()
                                      .isEmpty) {
                                showToast(translate("toast.empty_fields"));
                              } else {
                                signNewUser(
                                    _usernameController.text.toString().trim(),
                                    _emailController.text.toString().trim(),
                                    _passwordController.text.toString().trim(),
                                    _mobilephonecontroller.text
                                        .toString()
                                        .trim());
                              }
                            }
                        },
                        child: new Text(
                          translate("signup.signup"),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  bool _checkpass = false;
  bool _passsecur = true;
  void onChangedPassShowing(bool value) {
    setState(() {
      if (value == true) {
        _checkpass = true;
        _passsecur = false;
      } else {
        _checkpass = false;
        _passsecur = true;
      }
    });
  }
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobilephonecontroller = TextEditingController();
  final formkey = new GlobalKey<FormState>();
  validateForm() {
    print("validate form ...");
    if (formkey.currentState.validate()) {
      print("validate succes");
      return true;
    } else {
      print("validate faield");
      return false;
    }
  }
  DateTime dateToday =
  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Future<void> signNewUser(String _username, String _emailText,
      String _passText, String _mobilephone) async {
    var location = new Location();
      await location.getLocation().then((onValue) {
        Constants.latitude=onValue.latitude.toString();
        Constants.longitude=onValue.longitude.toString();
        if (validateForm()) {
          _username = _usernameController.text.toString().trim();
          _passText = _passwordController.text.toString().trim();
          _emailText = _emailController.text.toString().trim();
          _mobilephone = _mobilephonecontroller.text.toString().trim();
          showToast(translate("signup.toast_wait"));
          try {
            FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                email: _emailText.toString().trim(),
                password: _passText.toString().trim())
                .then((signedInUser) {
                var driverdata = {
                  "username": _username,
                  "email": _emailText,
                  "password": _passText,
                  "mobilephone": _mobilephone,
                  "city":"city",
                  "status":"offline",
                  "approve":"approve",
                  "latitude":onValue.latitude.toString(),
                  "longitude":onValue.longitude.toString(),
                  "date":dateToday.toString(),
                  "authid": signedInUser.user.uid.toString(),
                  "helpone": "helpone",
                  "helptwo": "helptwo",
                  "helpthree": "helpthree",
                };
                DatabaseReference db = FirebaseDatabase.instance.reference();
                db.child("driver").child(signedInUser.user.uid.toString()).set(driverdata);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MyApp()));
                showToast(translate("signup.successefuly"));
                print("uid new driver :" + signedInUser.user.uid.toString());
                signedInUser.user.sendEmailVerification();

            }).catchError((e) {
              print(e.message);
              showToast(translate("login.not_true"));
            });
          } catch (e) {
            print(e.message);
            showToast(translate("login.not_true"));
          }
        } else {
          showToast(translate("login.not_true"));
        }
      });
  }


}