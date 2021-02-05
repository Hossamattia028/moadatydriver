import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:location/location.dart';
import 'package:moadatydriver/elements/signOut.dart';
import 'package:moadatydriver/helpers/auth.dart';
import 'package:moadatydriver/helpers/changeLanguage.dart';
import 'package:moadatydriver/helpers/checkInternet.dart';
import 'package:moadatydriver/helpers/getlocation.dart';
import 'package:moadatydriver/helpers/showtoast.dart';
import 'package:moadatydriver/models/Constants.dart';
import 'package:moadatydriver/models/orderdata.dart';
import 'package:moadatydriver/pages/admin/adminmain.dart';
import 'package:moadatydriver/pages/mainmaps.dart';
import 'package:moadatydriver/pages/order.dart';
import 'package:moadatydriver/pages/signing/login.dart';


bool checkAdmin = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkInternet();
  await Firebase.initializeApp();
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US', supportedLocales: ['en_US', 'ar']);
  runApp(LocalizedApp(delegate, MyApp()));
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'moadaty app',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        home: MyHomePage(),
      ),
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  static List<orderdata> orderdrivelist = [];
  GlobalKey _scaffold = GlobalKey();
  getOrderDriver(String payKind) {
    DatabaseReference postRef = FirebaseDatabase.instance
        .reference()
        .child("order")
        .child(payKind);
    postRef.once().then((DataSnapshot snap) {
      if(snap.value!=null){
        var KEYS = snap.value.keys;
        var DATA = snap.value;
        orderdrivelist.clear();
        for (var indvidualkey in KEYS) {
          orderdata posts = new orderdata(
            DATA[indvidualkey]['username'].toString(),
            DATA[indvidualkey]['userphone'].toString(),
            DATA[indvidualkey]['drivername'].toString(),
            DATA[indvidualkey]['driverphone'].toString(),
            DATA[indvidualkey]['machinename'].toString(),
            DATA[indvidualkey]['machinenumber'].toString(),
            DATA[indvidualkey]['date'].toString(),
            DATA[indvidualkey]['complete'].toString(),
            DATA[indvidualkey]['note'].toString(),
            DATA[indvidualkey]['distancewithkilometer'].toString(),
            DATA[indvidualkey]['distancewitmeter'].toString(),
            DATA[indvidualkey]['locatedriver'].toString(),
            DATA[indvidualkey]['locateuser'].toString(),
            DATA[indvidualkey]['locateorder'].toString(),
            DATA[indvidualkey]['kindoforder'].toString(),
            DATA[indvidualkey]['paykind'].toString(),
            DATA[indvidualkey]['authuiduser'].toString(),
            DATA[indvidualkey]['authuiddriverone'].toString(),
            DATA[indvidualkey]['authuiddrivertwo'].toString(),
            DATA[indvidualkey]['authuiddriverthree'].toString(),
            DATA[indvidualkey]['authuiddriverfour'].toString(),
            DATA[indvidualkey]['latorderlocate'].toString(),
            DATA[indvidualkey]['lonorderlocate'].toString(),
            DATA[indvidualkey]['latuserlocate'].toString(),
            DATA[indvidualkey]['lonuserlocate'].toString(),
            DATA[indvidualkey]['uploadid'].toString(),
            DATA[indvidualkey]['helpone'].toString(),
            DATA[indvidualkey]['helptwo'].toString(),
            DATA[indvidualkey]['helpthree'].toString(),
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
      }
    });
  }
  user()async{
    await checkUser(context);
  }
  @override
  void initState() {
    setState(() {
      user();
      getOrderDriver("cash");
      getOrderDriver("knet");
    });
    Timer(Duration(seconds: 2),(){
      user();
    });
    getLocation(Constants.latitude, Constants.longitude);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffold,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: color,
        title: new Text(translate("app_bar.title")),
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(
            Icons.language,
            color: Colors.white,
          ),
          onPressed: () {
            onActionSheetPress(context);
          },
        ),
        actions: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                orderdrivelist.length.toString(),
                style:
                    TextStyle(color: coloryellow, fontWeight: FontWeight.bold),
              ),
              new IconButton(
                icon: new Icon(
                  Icons.business_center,
                  color: Colors.white,
                ),
                onPressed: () async {
                  if (FirebaseAuth.instance.currentUser != null) {
                    var location = new Location();
                    await location.getLocation().then((value) {
                      try {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => order(
                              lattitude: value.latitude.toString(),
                              longitude: value.longitude.toString(),
                            )));
                      } catch (e) {
                        print(e);
                      }
                    });
                  }else{
                    showToast(translate("toast.please_signup"));
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => login()));
                  }
                },
              ),
            ],
          ),
          new IconButton(
            icon: new Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () async {
              if (FirebaseAuth.instance.currentUser != null) {
                var location = new Location();
                await location.getLocation().then((onValue) {
                  print("latitude\n" +
                      onValue.latitude.toString() +
                      "longitude\n," +
                      onValue.longitude.toString());
                 setState(() {
                   Constants.latitude = onValue.latitude.toString();
                   Constants.longitude = onValue.longitude.toString();
                 });
                  if ( Constants.latitude.toString().isEmpty) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => MyApp()));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => mainmaps(
                          latitude: onValue.latitude.toString(),
                          longitude: onValue.longitude.toString(),
                          upload_id: "null",
                          paykind: "null",
                        )));
                    showToast("◌");
                  }
                });
              }else{
                showToast(translate("toast.please_signup"));
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => login()));
              }
            },
          ),
        ],
      ),
      body:  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                height: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.center,
                    image: AssetImage('images/backmain.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Image.asset(
                      'images/logo.png',
                      height: 125,
                      width: 125,
                    ),
                    new ValueListenableBuilder(
                      builder: (BuildContext context, String userName, Widget child) {
                        return Text(userName.toString(),
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),);
                      },
                      valueListenable: Constants.userName,
                    ),
                  ],
                )),
            SizedBox(
              height: 24,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new GestureDetector(
                    onTap: () {},
                    child: new Card(
                      elevation: 8,
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: new ListTile(
                          title:  new ValueListenableBuilder(
                            builder: (BuildContext context, String userName, Widget child) {
                              return Text(userName.toString());
                            },
                            valueListenable: Constants.userName,
                          ),
                          onTap: () {},
                          leading: new Icon(
                            Icons.person,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  new GestureDetector(
                    onTap: () {},
                    child: new Card(
                      elevation: 8,
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        child: new ListTile(
                          title: new ValueListenableBuilder(
                            builder: (BuildContext context, String userEmail, Widget child) {
                              return Text(userEmail.toString());
                            },
                            valueListenable: Constants.userEmail,
                          ),
                          onTap: () {},
                          leading: new Icon(
                            Icons.email,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  new GestureDetector(
                    onTap: () {},
                    child: new Card(
                      elevation: 8,
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: new ListTile(
                          title: ValueListenableBuilder(
                            builder: (BuildContext context, String userPhone, Widget child) {
                              return Text(userPhone.toString());
                            },
                            valueListenable: Constants.userPhone,
                          ),
                          onTap: () {},
                          leading: new Icon(
                            Icons.phone,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  new GestureDetector(
                    onTap: () {},
                    child: new Card(
                      elevation: 8,
                      child: Container(
                        alignment: Alignment.center,
                        height: 55,
                        width: 200,
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: new ListTile(
                          title: new Text(translate("activity_wenshmap.drawer_signout")),
                          onTap: () {
                            showAlertDialogSignOut(context);
                          },
                          leading: new Icon(
                            Icons.input,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Visibility(
              child: IconButton(icon: Icon(Icons.person_outline,size: 40,), onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> adminmain()));
              }),
              visible: Constants.userEmail.value.toString().trim()=="adminxerooo@gmail.com"?true:false,
            ),
          ],
        ),
      ),
    );
  }

}