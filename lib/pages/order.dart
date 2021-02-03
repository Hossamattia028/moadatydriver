import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:moadatydriver/elements/orderUI.dart';
import 'package:moadatydriver/helpers/auth.dart';
import 'package:moadatydriver/helpers/showtoast.dart';
import 'package:moadatydriver/main.dart';
import 'package:moadatydriver/models/orderdata.dart';
import 'package:moadatydriver/pages/mainmaps.dart';

String goThisOrder;
class order extends StatefulWidget {
  String lattitude, longitude;
  order({this.lattitude, this.longitude});
  @override
  State<StatefulWidget> createState() {
    return new _order();
  }
}
class _order extends State<order> {
  static List<orderdata> orderdrivelist = [];
  @override
  void initState() {
    setState(() {
      getOrderDriver("knet");
      getOrderDriver("cash");
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: color,
        title: new Text(translate("activity_order.my_order")),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: new Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyApp()));
            },
          )
        ],
      ),
      body: FutureBuilder(
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
            margin: EdgeInsets.all(10.0),
            color: Colors.white,
            child: orderdrivelist.length == 0
                ? new Text("no order available")
                :  ListView.builder(
                  itemCount: orderdrivelist.length,
                  itemBuilder: (_, index) {
                    return orderUI(
                      orderdrivelist[index].username,
                      orderdrivelist[index].userphone,
                      orderdrivelist[index].drivername,
                      orderdrivelist[index].driverphone,
                      orderdrivelist[index].machinename,
                      orderdrivelist[index].machinenumber,
                      orderdrivelist[index].date,
                      orderdrivelist[index].complete,
                      orderdrivelist[index].note,
                      orderdrivelist[index].distancewithkilometer,
                      orderdrivelist[index].distancewithmeter,
                      orderdrivelist[index].locatedriver,
                      orderdrivelist[index].locateuser,
                      orderdrivelist[index].locateorder,
                      orderdrivelist[index].kindoforder,
                      orderdrivelist[index].paykind,
                      orderdrivelist[index].authuiduser,
                      orderdrivelist[index].authuiddriverone,
                      orderdrivelist[index].authuiddrivertwo,
                      orderdrivelist[index].authuiddriverthree,
                      orderdrivelist[index].authuiddriverfour,
                      orderdrivelist[index].latorderlocate,
                      orderdrivelist[index].lonorderlocate,
                      orderdrivelist[index].latuserlocate,
                      orderdrivelist[index].lonuserlocate,
                      orderdrivelist[index].uploadid,
                      widget.lattitude.toString(),
                      widget.longitude.toString(),context
                    );
                  }),
        );
        }),
    );
  }

  getOrderDriver(String payKind) {
    DatabaseReference postRef = FirebaseDatabase.instance
        .reference()
        .child("order")
        .child(payKind);
    postRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      orderdrivelist.clear();
      for (var indvidualkey in KEYS) {
        orderdata posts = new orderdata(
          DATA[indvidualkey]['username'],
          DATA[indvidualkey]['userphone'],
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
          DATA[indvidualkey]['paykind'],
          DATA[indvidualkey]['authuiduser'],
          DATA[indvidualkey]['authuiddriverone'],
          DATA[indvidualkey]['authuiddrivertwo'],
          DATA[indvidualkey]['authuiddriverthree'],
          DATA[indvidualkey]['authuiddriverfour'],
          DATA[indvidualkey]['latorderlocate'],
          DATA[indvidualkey]['lonorderlocate'],
          DATA[indvidualkey]['latuserlocate'],
          DATA[indvidualkey]['lonuserlocate'],
          DATA[indvidualkey]['uploadid'],
          DATA[indvidualkey]['helpone'],
          DATA[indvidualkey]['helptwo'],
          DATA[indvidualkey]['helpthree'],
        );
          user().then((user) {
            if( DATA[indvidualkey]['authuiddriverone'].toString().split(":").first == user.uid.toString()
                || DATA[indvidualkey]['authuiddrivertwo'].toString().split(":").first == user.uid.toString()
                || DATA[indvidualkey]['authuiddriverthree'].toString().split(":").first == user.uid.toString()
                || DATA[indvidualkey]['authuiddriverfour'].toString().split(":").first == user.uid.toString()
            ){
                if(DATA[indvidualkey]['complete'] == 'notcompleted'){
                 setState(() {
                   orderdrivelist.add(posts);
                 });
                }else if (DATA[indvidualkey]['complete'] == 'forcompleted'){
                  if(DATA[indvidualkey]['authuiddriverone'].toString().split(":").first == user.uid.toString() && DATA[indvidualkey]['authuiddriverone'].toString().contains("done")
                      || DATA[indvidualkey]['authuiddrivertwo'].toString().split(":").first == user.uid.toString() && DATA[indvidualkey]['authuiddrivertwo'].toString().contains("done")
                      || DATA[indvidualkey]['authuiddriverthree'].toString().split(":").first == user.uid.toString() && DATA[indvidualkey]['authuiddriverthree'].toString().contains("done")
                      || DATA[indvidualkey]['authuiddriverfour'].toString().split(":").first == user.uid.toString() && DATA[indvidualkey]['authuiddriverfour'].toString().contains("done")){
                   setState(() {
                     orderdrivelist.add(posts);
                   });
                  }
                }


            }
          });
      }
    });
  }
}
