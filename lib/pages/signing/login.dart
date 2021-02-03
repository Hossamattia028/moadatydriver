import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:moadatydriver/helpers/showtoast.dart';
import 'package:moadatydriver/main.dart';
import 'package:moadatydriver/pages/signing/signup.dart';
class login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _login();
  }
}
class _login extends State<login> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: color,
        title: new Text(translate("login.app_bar")),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => new MyApp()));
            },
          )
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
              padding: EdgeInsets.only(right: 33, left: 33, top: 30),
              child: Form(
                key: formkey,
                child: new Column(
                  children: <Widget>[
                    new Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      child: new TextFormField(
                        validator: (value) =>
                        value.isEmpty ? 'Email can\'t be empty' : null,
                        controller: _emailController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        cursorWidth: 2.0,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.black, width: 1.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText:translate("login.email"),
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
                      height: 55,
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
                          hintText: translate("login.password"),
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
                          title: new Text(translate("login.show_pass")),
                          activeColor: color,
                        ),
                      ),
                    ),
                    new SizedBox(
                      height: 47,
                      width: MediaQuery.of(context).size.width,
                      child: new RaisedButton(
                        onPressed: () {
                          if (validateForm()) {
                            showToast(translate("login.toast_wait"));
                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                email: _emailController.text.toString().trim(),
                                password: _passwordController.text
                                    .toString()
                                    .trim())
                                .then((signedInUser) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MyApp()));
                              showToast(translate("login.successefuly"));
                            }).catchError((e) {
                              print(e);
                              showToast(translate("login.not_true"));
                            });
                          } else {
                            showToast(translate("login.not_true"));
                          }
                        },
                        child: new Text(
                          translate("login.login"),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        color: color,
                      ),
                    ),
                    SizedBox(height: 10,),
                    new GestureDetector(
                      onTap: (){
                        setState(() {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> signup()));
                        });
                      },
                      child:  new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment .center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(translate("login.sing_up_now"),style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                              new Text("________________________________",style: TextStyle(color: Colors.black,fontSize: 4,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          SizedBox(width: 10,),
                          new Text(translate("login.dont_have_anaccount"),style: TextStyle(color: Colors.black,fontSize: 17),),
                        ],
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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

}
