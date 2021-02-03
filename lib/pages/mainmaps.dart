import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:moadatydriver/helpers/auth.dart';
import 'package:moadatydriver/helpers/getlocation.dart';
import 'package:moadatydriver/helpers/showtoast.dart';
import 'package:moadatydriver/main.dart';
import 'package:moadatydriver/models/Constants.dart';
import 'package:moadatydriver/models/orderdata.dart';
import 'package:moadatydriver/pages/order.dart';

bool value = false ;
class mainmaps extends StatefulWidget {
  String longitude,latitude,latorderlocate,lonorderlocate,latuserlocate,lonuserlocate ,upload_id,paykind,machinename,numberofmachine,
      date,note,locatedriver,locateuser,locateorder,distancewitkilometer,authuidnumber,complete;
  mainmaps({
    this.latitude,
    this.longitude,
    this.upload_id,
    this.paykind,
    this.machinename,
    this.numberofmachine,
    this.date,
    this.note,
    this.locatedriver,
    this.locateuser,
    this.locateorder,
    this.latorderlocate,
    this.lonorderlocate,
    this.latuserlocate,
    this.lonuserlocate,
    this.distancewitkilometer,
    this.authuidnumber,
    this.complete
  });
  @override
  State<mainmaps> createState() => _mainmaps();
}
class _mainmaps extends State<mainmaps> {
  final Geolocator geolocator = Geolocator()
    ..forceAndroidLocationManager;
  static List<orderdata> orderdrivelist = [];
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
      }
    });
  }
  _setlocationOrderonMap()async{
    var markerIdVal = widget.lonorderlocate;
    final MarkerId markerId = MarkerId("$markerIdVal");
      Marker marker = Marker(
        markerId: markerId,
        position: LatLng(double.parse(widget.latorderlocate.toString()), double.parse(widget.lonorderlocate.toString())),
        infoWindow: InfoWindow(
          title: translate("activity_wenshmap.order_location"),
        ),
        icon:
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      );
      setState(() {
        markers[markerId] = marker;
      });
  }
  _setlocationUseronMap()async{
    var markerIdVal = widget.lonuserlocate;
    final MarkerId markerId = MarkerId("$markerIdVal");
      Marker marker = Marker(
        markerId: markerId,
        position: LatLng(double.parse(widget.latuserlocate.toString()), double.parse(widget.lonuserlocate.toString())),
        infoWindow: InfoWindow(
          title: translate("activity_wenshmap.order_location"),
        ),
        icon:
        BitmapDescriptor.fromAsset("images/profile.png"),
      );
      setState(() {
        markers[markerId] = marker;
      });
  }
  String latitude,longitude;
  LatLng latLng;
  LatLng lastlocation;
  @override
  void initState() {
    latitude = widget.latitude;
    longitude =widget.longitude;
    latLng = LatLng(double.parse(latitude.toString()),double.parse(longitude.toString()));
    lastlocation = latLng;
    if(Constants.driverStatus.toString().trim() == 'online'){
      setState(() {
        value = true;
      });
    }
    pathimageorder = "images/wenshmain.png";
    setwidgetOnline();
    if(widget.latorderlocate.toString().isNotEmpty&&widget.complete.toString()=='forcompleted'){
      _setlocationOrderonMap();
    }
    if(widget.latuserlocate.toString().isNotEmpty&&widget.complete.toString()=='notcompleted'){
      _setlocationUseronMap();
    }
    setState(() {
      getOrderDriver("cash");
      getOrderDriver("knet");
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: color,
        title: new Text(translate("activity_wenshmap.new_order")),
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(orderdrivelist.length.toString(),style: TextStyle(color: coloryellow,fontWeight: FontWeight.bold),),
              new IconButton(
                icon: new Icon(
                  Icons.business_center,
                  color: Colors.white,
                ),
                onPressed: ()  {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => order(lattitude: widget.latitude,longitude: widget.longitude,)));
                },
              ),
            ],
          ),
          Container(
            width: 100,
            child: Card(
              child: setwidgetOnline(),
            ),
          ),
        ],
        leading:new IconButton(
          icon: new Icon(
            Icons.person,
            color: Colors.white,
          ),
          onPressed: ()  {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp()));
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(target: latLng, zoom: 12),
            onMapCreated: onMapCreated,
            myLocationEnabled: true,
            mapType: MapType.normal,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            markers: Set<Marker>.of(markers.values),
            onCameraMove: _onCameraMoved,
          ),
          Positioned(
            top: 40.0,
            right: 12.0,
            left: 12.0,
            child: widget.upload_id=='null' ? new Text(""):Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: new Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(40.0))),
                        child: Container(
                          height: 128,
                          alignment: Alignment.center,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          padding: EdgeInsets.all(8.0),
                          child:  Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              widget.complete=="forcompleted"?
                              RaisedButton(
                                child: Text("finish - إنهاء"),
                                onPressed: (){
                                sureTofinishthisOrderDialog(context);
                                },
                              ):
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 2.0,
                                  ),
                                  widget.complete=='notcompleted' ?Container(
                                    height: 36,
                                    width: 110,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100.0))),
                                      onPressed: () {
                                        showAlertDialogconfirmorder(context);
                                      },
                                      color: color,
                                      child: Text(
                                        translate("button.go_order"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0),
                                      ),
                                    ),
                                  ):Text(""),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  widget.complete=='notcompleted' ?Container(
                                    height: 36,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                    ),
                                    child: new RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100.0))),
                                      onPressed: () {
                                        sureToremovethisOrder(context);
                                      },
                                      color: colorred,
                                      child: new Text(
                                        translate("button.cancel"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0),
                                      ),
                                    ),
                                  ):Text(""),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  SizedBox(
                                    height: 20,
                                    width: 100,
                                    child: new Text(
                                      widget.date.toString(),
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 4,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        widget.machinename,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(width: 8,),
                                      SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: new Image.asset(pathimageorder),
                                      ),
                                    ],
                                  ),
                                  Text(widget.note==null?"":'${widget.note.toString()}')
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      child: GestureDetector(
                        onTap: () {},
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  30.0))),
                          child: Container(
                              height: 147,
                              alignment: Alignment.topCenter,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              padding: EdgeInsets.all(8.0),
                              child:  Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceAround,
                                children: <Widget>[
                                  new Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      // new Text(widget.distancewitkilometer.toString()+ "km"),
                                      new SizedBox(
                                        height: 20,
                                      ),
                                      new Text("_____________"),
                                      new SizedBox(
                                        height: 6.0,
                                      ),
                                      new Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          new Text(
                                            widget.machinename.toString(),
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          new Icon(
                                            Icons.directions_car,
                                            color: color,
                                            size: 30.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          new Column(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: new Column(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 110,
                                                      child: Text(widget.locateorder.toString().isEmpty ||
                                                          widget.locateorder.toString().trim() == null ||
                                                          widget.locateorder.toString()=='null'
                                                          ? "":widget.locateorder.toString(),
                                                        style: TextStyle(color:Colors.black,fontSize: 13,),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: Alignment
                                                    .bottomRight,
                                                child: new Text(translate("activity_wenshmap.to"),
                                                  style: TextStyle(color:Colors.black,fontSize: 13,fontWeight: FontWeight.bold),),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Align(
                                                alignment: Alignment
                                                    .bottomRight,
                                                child: new SizedBox(
                                                  width: 110,
                                                  child: Text(widget.locateuser==null||
                                                      widget.locateuser.toString().trim()=="null"?"":
                                                  '${widget.locateuser.toString()}',
                                                    style: TextStyle(color:Colors.black,fontSize: 13,),),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          new Column(
                                            children: <Widget>[
                                              new Icon(
                                                Icons.my_location,
                                                color: color,
                                              ),
                                              new Text("|\n|\n|"),
                                              new Icon(
                                                Icons.my_location,
                                                color: coloryellow,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });
  }
  void _onCameraMoved(CameraPosition position) {
    lastlocation = position.target;
  }
  final TextEditingController _orderprice = TextEditingController();
  final TextEditingController _ordertime = TextEditingController();
  showAlertDialogconfirmorder(BuildContext context) {
    AlertDialog alert;
    Widget cancelButton = FlatButton(
      child: Text(translate('button.cancel')),
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget okButton = new Align(
      alignment: Alignment.center,
      child: Container(
        width: 300,
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)),
          color: color,
          child: Text(
            translate("button.approve_driver"),
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0),
          ),
          onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              _sendFinalApprove();
          },
        ),
      ),
    );
    // set up the AlertDialog
    alert = AlertDialog(
      title: Text(
        translate("activity_wenshmap.order_response"),
        style: TextStyle(fontSize: 16, color: Colors.black),
        textAlign: TextAlign.center,
      ),
      content: new Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 160,
                height: 50,
                alignment: Alignment.center,
                child: new TextFormField(
                  validator: (value) =>
                  value.length < 6
                      ? ''
                      : null,
                  controller: _orderprice,
                  keyboardType: TextInputType.number,
                  cursorWidth: 2.0,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.black, width: 1.0),
                    ),
                    hoverColor: Colors.black,
                    hintText:translate("activity_wenshmap.price")+translate("activity_wenshmap.KWD"),
                  ),
                  textAlign: TextAlign.left,
                  textAlignVertical: TextAlignVertical.center,
                  onTap: () {},
                  autofocus: false,
                  cursorColor: Colors.black,
                ),
              ),
              SizedBox(height: 10,),
//              Container(
//                width: 160,
//                height: 50,
//                alignment: Alignment.center,
//                child: new TextFormField(
//                  validator: (value) =>
//                  value.length < 6
//                      ? ''
//                      : null,
//                  controller: _ordertime,
//                  cursorWidth: 2.0,
//                  decoration: InputDecoration(
//                    border: OutlineInputBorder(),
//                    focusedBorder: OutlineInputBorder(
//                      borderSide:
//                      BorderSide(color: Colors.black, width: 1.0),
//                    ),
//                    hoverColor: Colors.black,
//                    hintText:translate("activity_wenshmap.distance"),
//                  ),
//                  textAlign: TextAlign.left,
//                  textAlignVertical: TextAlignVertical.center,
//                  onTap: () {},
//                  autofocus: false,
//                  cursorColor: Colors.black,
//                ),
//              ),

            ],
          ),
        ),
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
  sureToremovethisOrder(BuildContext context) {
    AlertDialog alert;
    Widget cancelButton = FlatButton(
      child: Text(translate('button.cancel')),
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget okButton = new Align(
      alignment: Alignment.center,
      child: Container(
        width: 300,
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)),
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
            _removeMyauthuidfromthisOrder();
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ),
    );
    // set up the AlertDialog
    alert = AlertDialog(
      title: Text(
        translate("activity_wenshmap.sure_remove_myorder"),
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
  _sendFinalApprove(){
    if(_orderprice.text.toString().isNotEmpty){
      user().then((user){
        print("auth number is :  "+widget.authuidnumber+user.uid+"\npay kind :"+widget.paykind);
        DatabaseReference db = FirebaseDatabase.instance.reference();
        db.child("order").child(widget.paykind.toString()).child(widget.upload_id).child(widget.authuidnumber).set(user.uid+":"+_orderprice.text.toString().trim()+"&&"+"lat"+widget.latitude+"lon"+widget.longitude);

      });
     }else{
      showToast(translate("toast.empty_fields"));
    }
  }
  _removeMyauthuidfromthisOrder(){
    DatabaseReference db = FirebaseDatabase.instance.reference();
    db.child("order").child(widget.paykind.toString()).child(widget.upload_id).child(widget.authuidnumber).set("...");
  }
  sureTofinishthisOrderDialog(BuildContext context) {
    AlertDialog alert;
    Widget cancelButton = FlatButton(
      child: Text(translate('button.cancel')),
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget okButton = new Align(
      alignment: Alignment.center,
      child: Container(
        width: 300,
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)),
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
            DatabaseReference db = FirebaseDatabase.instance.reference();
            db.child("order").child(widget.paykind.toString()).child(widget.upload_id).child("complete").set("completed");
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyApp()));
          },
        ),
      ),
    );
    // set up the AlertDialog
    alert = AlertDialog(
      title: Text(
        translate("activity_wenshmap.sure_finish_myorder"),
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
  //start set up map
  Completer<GoogleMapController> _controller = Completer();
  String searchAddr;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String pathimageorder;
  _setOnline() async {
    var location = new Location();
    await location.getLocation().then((onValue) {
      latitude=onValue.latitude.toString();
      longitude=onValue.longitude.toString();
      if (FirebaseAuth.instance.currentUser != null) {
        user().then((User user) async{
        DatabaseReference online =
        FirebaseDatabase.instance.reference().child("driver");
        online.child(user.uid).child("status").set("online");
        online.child(user.uid).child("latitude").set(latitude.toString());
        online.child(user.uid).child("longitude").set(longitude.toString());
        List<Placemark> p = await geolocator.placemarkFromCoordinates(
            double.parse(latitude.toString()),
            double.parse(longitude.toString()));
        Placemark place = p[0];
        String locate ="";
        setState(() {
          locate =
          "${place.locality},${place.postalCode},${place.country}";
          // _getPolyline(double.parse(widget.lattitude), double.parse(widget.longitude), double.parse(point.latitude.toString()), double.parse(point.longitude.toString()));
        });
        online.child(user.uid).child("city").set(locate.toString().trim());
      });
      }
    });

  }
  _setOffline() async {
    if ( FirebaseAuth.instance.currentUser != null) {
      user().then((User user) {
        DatabaseReference offline =
        FirebaseDatabase.instance.reference().child("driver");
        offline.child(user.uid).child("status").set("offline");
      });
    }
  }
  Widget setwidgetOnline(){
    print("switch");
    if(Constants.driverStatus == 'online'){
       value = true;
       return SwitchListTile(
         value: value,
         onChanged: (bool valuee) {
           setState(() {
             value = valuee;
             if (valuee == true) {
               getLocation(latitude, longitude);
               _setOnline();
               Constants.driverStatus = 'online';
               showToast(translate("activity_wenshmap.online"));
               print("you are online");
             } else if(valuee == false){
               _setOffline();
               showToast(translate("activity_wenshmap.offline"));
               Constants.driverStatus = 'offline';
               print("you are offline");
             }
           });
         },
         activeColor: color,
       );
     }else{
       value = false;
       return SwitchListTile(
         value: value,
         onChanged: (bool valuee) {
           setState(() {
             value = valuee;
             if (valuee == true) {
               getLocation(latitude, longitude);
               _setOnline();
               showToast(translate("activity_wenshmap.online"));
               Constants.driverStatus = 'online';
               print("you are online");
             } else if(valuee == false){
               _setOffline();
               showToast(translate("activity_wenshmap.offline"));
               Constants.driverStatus = 'offline';
               print("you are offline");
             }
           });
         },
         activeColor: color,
       );
     }
  }
}
