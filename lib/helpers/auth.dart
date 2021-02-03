import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_translate/global.dart';
import 'package:location/location.dart';
import 'package:moadatydriver/helpers/showtoast.dart';
import 'package:moadatydriver/models/Constants.dart';
import 'package:moadatydriver/pages/signing/login.dart';

Future<User> user() async {
  final User user = (FirebaseAuth.instance.currentUser);
//  print("signed in " + user.email);
  return user;
}
getdetails(String emaill, String uid) {
  try {
    Map<dynamic, dynamic> values;
    DatabaseReference db =
    FirebaseDatabase.instance.reference().child("driver").child(uid);
    db.once().then((DataSnapshot snapshot) async {
      values = snapshot.value;
        Constants.userEmail.value = values["email"];
        Constants.userName.value = values["username"];
        Constants.userPassword.value = values["password"];
        Constants.userPhone.value = values["mobilephone"];
      Constants.driverApprove = values["approve"];
      var location = new Location();
      await location.getLocation().then((onValue) {
        Constants.latitude = onValue.latitude.toString();
        Constants.longitude = onValue.longitude.toString();
        var userdata = {
          "username": Constants.userName.value,
          "email": emaill,
          "password": Constants.userPassword.value,
          "mobilephone": Constants.userPhone.value,
          "city": values["city"],
          "status": Constants.driverStatus,
          "latitude": Constants.latitude,
          "longitude": Constants.longitude,
          "date": values["date"],
          "authid": uid,
          "approve":Constants.driverApprove,
          "helpone": "helpone",
          "helptwo": "helptwo",
          "helpthree": "helpthree",
        };
        db.set(userdata);
        updateDriverLocation("cash", onValue.latitude.toString().trim(), onValue.longitude.toString().trim());
        updateDriverLocation("knet", onValue.latitude.toString().trim(), onValue.longitude.toString().trim());
      });
    });
  } catch (e) {
    print(e);
  }
}
checkUser(BuildContext context) async {
  // ignore: unnecessary_null_comparison
  if (FirebaseAuth.instance.currentUser != null) {
    user().then((User userr) {
      print("uid user now: " + userr.uid);
      getdetails(userr.email, userr.uid);
      Constants.myAuth=userr.uid.toString();
    });
  } else {
    print("user not found ");
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => login()));
    });
    showToast(translate("toast.please_signup"));
  }
}
updateDriverLocation(String kindoforderpay,String lat,String lon) {
  DatabaseReference postRef = FirebaseDatabase.instance
      .reference()
      .child("order")
      .child(kindoforderpay);
  postRef.once().then((DataSnapshot snap) {
    if(snap.value !=null){
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      for (var indvidualkey in KEYS) {
        user().then((user) {
          if(DATA[indvidualkey]['complete'] == 'forcompleted'){
            if(DATA[indvidualkey]['authuiddriverone'].toString().split(":").first == user.uid.toString()){
              String data=DATA[indvidualkey]['authuiddriverone'].toString().trim();
              String d = data.toString().split("&&lat").first.toString().trim();
              postRef.child(DATA[indvidualkey]['uploadid'])
                  .set(d+"lat"+"${lat.toString().trim()}"+"lon"+"${lon.toString().trim()}"+"&&done");
            }
            if(DATA[indvidualkey]['authuiddrivertwo'].toString().split(":").first == user.uid.toString()){
              String data=DATA[indvidualkey]['authuiddrivertwo'].toString().trim();
              String d = data.toString().split("&&lat").first.toString().trim();
              postRef.child(DATA[indvidualkey]['uploadid'])
                  .set(d+"lat"+"${lat.toString().trim()}"+"lon"+"${lon.toString().trim()}"+"&&done");
            }
            if(DATA[indvidualkey]['authuiddriverthree'].toString().split(":").first == user.uid.toString()){
              String data=DATA[indvidualkey]['authuiddriverthree'].toString().trim();
              String d = data.toString().split("&&lat").first.toString().trim();
              postRef.child(DATA[indvidualkey]['uploadid'])
                  .set(d+"lat"+"${lat.toString().trim()}"+"lon"+"${lon.toString().trim()}"+"&&done");
            }
            if(DATA[indvidualkey]['authuiddriverfour'].toString().split(":").first == user.uid.toString()){
              String data=DATA[indvidualkey]['authuiddriverfour'].toString().trim();
              String d = data.toString().split("&&lat").first.toString().trim();
              postRef.child(DATA[indvidualkey]['uploadid'])
                  .set(d+"lat"+"${lat.toString().trim()}"+"lon"+"${lon.toString().trim()}"+"&&done");
            }
          }
        });
      }
    }
  });
}
//on main
//user().then((FirebaseUser user) => print(user.email));