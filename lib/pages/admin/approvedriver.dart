import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moadatydriver/helpers/showtoast.dart';
import 'package:moadatydriver/main.dart';
import 'package:moadatydriver/models/driverdata.dart';
import 'package:url_launcher/url_launcher.dart';

class approvedriver extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _approvedriver();
  }
}
class _approvedriver extends State<approvedriver> {
  static List<driverdata> driverapprovelist = [];
  Future<Null> refresh() async {
    await Future.delayed(Duration(seconds: 2));
    _getdrivertoApprove();
  }
  @override
  void initState() {
    super.initState();
    _getdrivertoApprove();
    Timer(Duration(seconds: 2),(){
      _getdrivertoApprove();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _getdrivertoApprove(),
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
              child: driverapprovelist.length == 0
                  ? new Text("no driver available")
                  : new RefreshIndicator(
                onRefresh: refresh,
                backgroundColor: color,
                color: Colors.white,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: driverapprovelist.length,
                    itemBuilder: (_, index) {
                      return PostsUIapprovedriver(
                        driverapprovelist[index].username,
                        driverapprovelist[index].email,
                        driverapprovelist[index].mobilephone,
                        driverapprovelist[index].city,
                        driverapprovelist[index].status,
                        driverapprovelist[index].approve,
                        driverapprovelist[index].latitude,
                        driverapprovelist[index].longitude,
                        driverapprovelist[index].authid,
                      );
                    }),
              ),
            );
          }),
    );
  }
  Widget PostsUIapprovedriver(
      String username,
      String email,
      String mobilephone,
      String city,
      String status,
      String approve,
      String latitude,
      String longitude,
      String authid) {
    return new Card(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: color)),
        child: new GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'driver name: $username',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 1,
                          fontFamily: 'pacifico'),
                    ),
                  ],
                ),
                Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                  child: new Column(
                    children: <Widget>[
                      ListTile(
                          leading: Icon(
                            Icons.phone,
                            color: Colors.red,
                          ),
                          onTap:() {
                            try{
                              customeLaunch("tel:$mobilephone");
                            }catch(e){
                              print(e);
                              print("erorr call phone");
                            }
                          },
                          title: Text(
                            '$mobilephone',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                          )),
                    ],
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    showAlertDialogapprovedriver(context, authid);
                  },
                  child: Card(
                    color: Colors.white,
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.check,
                        color: Colors.red,
                      ),
                      title: Text(
                        'Approve',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  showAlertDialogapprovedriver(BuildContext context, String authid) {
    AlertDialog alert;
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
        try {
          DatabaseReference petsapprove =
              FirebaseDatabase.instance.reference().child("driver");
          petsapprove.child(authid).child("approve").set("approved");
          showToast("successfully approved");
        } catch (e) {
          print(e.toString());
          showToast("something wrong please try again ");
        }
      },
    );
    Widget canselButton = FlatButton(
      child: Text("cancel"),
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    // set up the AlertDialog
    alert = AlertDialog(
      title: Text("you sure to approve "),
      actions: [okButton, canselButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  _getdrivertoApprove() {
    DatabaseReference postRef =
        FirebaseDatabase.instance.reference().child("driver");
    postRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      driverapprovelist.clear();
      for (var indvidualkey in KEYS) {
        driverdata posts = new driverdata(
          DATA[indvidualkey]['username'],
          DATA[indvidualkey]['email'],
          DATA[indvidualkey]['mobilephone'],
          DATA[indvidualkey]['city'],
          DATA[indvidualkey]['status'],
          DATA[indvidualkey]['approve'],
          DATA[indvidualkey]['latitude'],
          DATA[indvidualkey]['longitude'],
          DATA[indvidualkey]['authid'],
        );
        try {
          if (DATA[indvidualkey]['approve'] == 'approve') {
            setState(() {
              driverapprovelist.add(posts);
            });
          }
        } catch (e) {
          print(e);
        }
      }
        print('length:$driverapprovelist.length ');
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
