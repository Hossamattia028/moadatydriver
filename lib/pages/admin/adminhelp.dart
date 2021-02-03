import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moadatydriver/helpers/customeLaunch.dart';
import 'package:moadatydriver/helpers/showtoast.dart';
import 'package:moadatydriver/main.dart';
import 'package:moadatydriver/models/helpdata.dart';
import 'package:url_launcher/url_launcher.dart';

class adminhelp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _adminhelp();
  }
}
class _adminhelp extends State<adminhelp>{
  static List<helpdata> helplist = [];
  _getHelp(){
    DatabaseReference postRef = FirebaseDatabase.instance
        .reference()
        .child("Help");
    postRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      helplist.clear();
      for (var indvidualkey in KEYS) {
        helpdata posts = new helpdata(
          DATA[indvidualkey]['username'],
          DATA[indvidualkey]['emailuser'],
          DATA[indvidualkey]['mobilephone'],
          DATA[indvidualkey]['note'],
          DATA[indvidualkey]['date'],
          DATA[indvidualkey]['authid'],
          DATA[indvidualkey]['uploadid'],
          DATA[indvidualkey]['helpone'],
          DATA[indvidualkey]['helptwo'],
          DATA[indvidualkey]['helpthree'],
        );
        try {
          setState(() {
            helplist.add(posts);
          });
        } catch (e) {
          print(e);
        }
      }
      print('length:$helplist.length ');
    });
  }
  @override
  void initState() {
    super.initState();
    _getHelp();
    Timer(Duration(seconds: 2),(){
      _getHelp();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
            future: _getHelp(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Center(
                  child: Text(
                    "error fetching",
                  ),
                );
              }
              return Container(
                margin: EdgeInsets.all(5.0),
                color: Colors.white,
                child: helplist.length == 0
                    ? new Text("no help list available")
                    : ListView.builder(
                      shrinkWrap: true,
                      itemCount: helplist.length,
                      itemBuilder: (_, index) {
                        return PostsUIhelp(
                          helplist[index].username,
                          helplist[index].email,
                          helplist[index].phone,
                          helplist[index].note,
                          helplist[index].date,
                        );
                      }),
              );
            })
    );
  }
  Widget PostsUIhelp(
      String usernameorder,
      String emailuser,
      String phoneuser,
      String dateadmin,
      String note,
      ) {
    return new Card(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Colors.white)),
        child: new GestureDetector(
          onTap: () {},
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                  child: ListTile(
                      leading: Icon(
                        Icons.person_pin,
                        color: Colors.red,
                      ),
                      title: Text(
                        'help \n'+'$usernameorder  ' + '$phoneuser ',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      )),
                ),
                Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                  child: ListTile(
                      leading: Icon(
                        Icons.access_time,
                        color: Colors.red,
                      ),
                      title: Text(
                        'date:'+' $dateadmin',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                      )),
                ),
                new Text("user : "+usernameorder+"\n"+note,textAlign: TextAlign.left,),
                SizedBox(height: 17,),
                new GestureDetector(
                  onTap: () {
                    try{
                      customeLaunch("tel:$phoneuser");
                    }catch(e){
                      print(e);
                      print("erorr call phone");
                    }
                  },
                  child:  Card(
                    color: color,
                    margin:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: Colors.red,
                      ),
                      title: Text(
                        'Call to Approve user',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
        ));
  }
}





