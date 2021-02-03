import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:moadatydriver/helpers/showtoast.dart';
import 'package:moadatydriver/main.dart';


showAlertDialogSignOut(BuildContext context) {
  AlertDialog alert;
  Widget cancelButton = FlatButton(
    child: Text(translate("button.cancel")),
    onPressed: () async {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );
  Widget okButton = new Align(
    alignment: Alignment.center,
    child: Container(
      width: MediaQuery.of(context).size.width,
      child: FlatButton(
        color: color,
        child: Text(
          translate("button.ok"),
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0),
        ),
        onPressed: () async {
          Navigator.of(context, rootNavigator: true).pop();
          FirebaseAuth.instance.signOut();
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyApp()));

        },
      ),
    ),
  );
  // set up the AlertDialog
  alert = AlertDialog(
    title: Text(
      translate("activity_wenshmap.drawer_sure_signout"),
      style: TextStyle(fontSize: 16, color: Colors.black),
      textAlign: TextAlign.center,
    ),
    actions: [
      okButton,
      cancelButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}