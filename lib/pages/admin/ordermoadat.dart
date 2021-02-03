import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:moadatydriver/helpers/showtoast.dart';
import 'package:moadatydriver/models/orderdata.dart';
import 'package:moadatydriver/pages/admin/chatFirestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ordermoadat extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _ordermoadat();
  }
}
class _ordermoadat extends State<ordermoadat>{
  static List<orderdata> ordermoadatlist = [];
  Future<Null> refresh() async {
    await Future.delayed(Duration(seconds: 2));
    _getOrderdriver();
  }
  @override
  void initState() {
    super.initState();
    _getOrderdriver();
    Timer(Duration(seconds: 2),(){
      _getOrderdriver();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: FutureBuilder(
          future: _getOrderdriver(),
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: ordermoadatlist.length == 0
                  ? new Text("no order available")
                  : new RefreshIndicator(
                onRefresh: refresh,
                backgroundColor: color,
                color: Colors.white,
                child: ListView.builder(
                    itemCount: ordermoadatlist.length,
                    itemBuilder: (_, index) {
                      return PostsUIoldorder(
                        ordermoadatlist[index].username,
                        ordermoadatlist[index].userphone,
                        ordermoadatlist[index].drivername,
                        ordermoadatlist[index].driverphone,
                        ordermoadatlist[index].machinename,
                        ordermoadatlist[index].machinenumber,
                        ordermoadatlist[index].date,
                        ordermoadatlist[index].complete,
                        ordermoadatlist[index].note,
                        ordermoadatlist[index].distancewithkilometer,
                        ordermoadatlist[index].distancewithmeter,
                        ordermoadatlist[index].locatedriver,
                        ordermoadatlist[index].locateuser,
                        ordermoadatlist[index].kindoforder,
                        ordermoadatlist[index].paykind,
                        ordermoadatlist[index].authuiduser,
                        ordermoadatlist[index].authuiddriverone,
                        ordermoadatlist[index].authuiddrivertwo,
                        ordermoadatlist[index].authuiddriverthree,
                        ordermoadatlist[index].authuiddriverfour,
                        ordermoadatlist[index].uploadid,
                      );
                    }),
              ),
            );
          }),
    );
  }
  Widget PostsUIoldorder(
      String username,
      String userphone,
      String drivername,
      String driverphone,
      String machinename,
      String machinenumber,
      String date,
      String complete,
      String note,
      String distancewitkilometer,
      String distancewitmeter,
      String locatedriver,
      String locateuser,
      String kindoforder,
      String paykind,
      String authuiduser,
      String authuiddriverone,
      String authuiddrivertwo,
      String authuiddriverthree,
      String authuiddriverfour,
      String uploadid,
      ) {
    return  Card(
        elevation: 10.0,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.white)),
        child: new GestureDetector(
          onTap: () {},
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(7.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "$machinename",
                    style: TextStyle(color: Colors.black, fontSize: 13.0),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new IconButton(
                            icon: Icon(
                              Icons.chat,
                              color: colorred,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Chat(
                                    upload_id: uploadid,
                                    paykind: paykind,
                                  )));
                            }),
                      ],
                    ),
                    new SizedBox(
                      height: 30,
                      width: 110,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        onPressed: () {
                          try{
                            customeLaunch("tel:$userphone");
                          }catch(e){
                            print(e);
                            print("erorr call phone");
                          }
                        },
                        color: colorred,
                        child: new Text(
                          translate(
                            "activity_admin_order.call_to_approve",
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.2),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    new Container(
                      child: Image.asset("images/wenshmain.png"),
                      height: 50,
                      width: 50,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    ":" + "العدد وملاحظات ",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Text("$machinenumber"),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: new Text("$date"),
                )
              ],
            ),
          ),
        )
    );
  }
  _getOrderdriver() {
    DatabaseReference postRef = FirebaseDatabase.instance
        .reference()
        .child("order")
        .child("cash");
    postRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      ordermoadatlist.clear();
      for (var indvidualkey in KEYS) {
        orderdata posts = new orderdata(
          DATA[indvidualkey]['username'],
          DATA[indvidualkey]['usermobilephone'],
          DATA[indvidualkey]['drivername'],
          DATA[indvidualkey]['driverphone'],
          DATA[indvidualkey]['machinename'],
          DATA[indvidualkey]['machinenumber'],
          DATA[indvidualkey]['date'],
          DATA[indvidualkey]['complete'],
          DATA[indvidualkey]['note'],
          DATA[indvidualkey]['distancewithkilometer'],
          DATA[indvidualkey]['distancewitmeter'],
          DATA[indvidualkey]['locatedriver'],
          DATA[indvidualkey]['locateuser'],
          DATA[indvidualkey]['locateorder'],
          DATA[indvidualkey]['kindoforder'],
          DATA[indvidualkey]['authuiduser'],
          DATA[indvidualkey]['authuiddriverone'],
          DATA[indvidualkey]['authuiddrivertwo'],
          DATA[indvidualkey]['authuiddriverthree'],
          DATA[indvidualkey]['authuiddriverfour'],
          DATA[indvidualkey]['paykind'],
          DATA[indvidualkey]['latorderlocate'],
          DATA[indvidualkey]['lonorderlocate'],
          DATA[indvidualkey]['latuserlocate'],
          DATA[indvidualkey]['lonuserlocate'],
          DATA[indvidualkey]['uploadid'],
          DATA[indvidualkey]['helpone'],
          DATA[indvidualkey]['helptwo'],
          DATA[indvidualkey]['helpthree'],
        );
            if(DATA[indvidualkey]['complete'] == 'notcompleted' && DATA[indvidualkey]['kindoforder'] == 'moadat'){
              setState(() {
                ordermoadatlist.add(posts);
              });
            }
      }

    });
  }
  void customeLaunch(command)async{
    if(await canLaunch(command)){
      await launch(command);
    }else{
      print("could not launch");
    }
  }
}