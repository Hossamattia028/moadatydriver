import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:moadatydriver/helpers/auth.dart';
import 'package:moadatydriver/helpers/showtoast.dart';
import 'package:moadatydriver/pages/mainmaps.dart';

Widget orderUI(
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
    String locateorder,
    String kindoforder,
    String paykind,
    String authuiduser,
    String authuiddriverone,
    String authuiddrivertwo,
    String authuiddriverthree,
    String authuiddriverfour,
    String latorderlocate,
    String lonorderlocate,
    String latuserlocate,
    String lonuserlocate,
    String uploadid,
    String latitude,
    String longitude,
    BuildContext context,
    ) {
  return  Card(
      elevation: 10.0,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.white)),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(7.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    complete == 'forcompleted' ? translate("activity_wenshmap.sure_go_driver"):"",
                    style: TextStyle(color: color,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  SizedBox(
                    height: 30,
                    width: 107,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      onPressed: () {
                        print("paykind is: "+paykind);
                        user().then((user) {
                          if(user.uid.toString()==authuiddriverone.toString().split(':').first){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => mainmaps(
                                  upload_id: uploadid,
                                  latitude: latitude,
                                  longitude: longitude,
                                  paykind: paykind,
                                  machinename: machinename,
                                  numberofmachine: machinenumber,
                                  date: date,
                                  note: note,
                                  distancewitkilometer: distancewitkilometer,
                                  locatedriver: locatedriver,
                                  locateuser: locateuser,
                                  locateorder: locateorder,
                                  latorderlocate:latorderlocate,
                                  lonorderlocate:lonorderlocate,
                                  latuserlocate: latuserlocate,
                                  lonuserlocate: lonuserlocate,
                                  complete:complete,
                                  authuidnumber: "authuiddriverone",
                                )));
                          }else if(user.uid.toString()==authuiddrivertwo.toString().split(':').first){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => mainmaps(
                                  upload_id: uploadid,
                                  latitude: latitude,
                                  longitude: longitude,
                                  paykind: paykind,
                                  machinename: machinename,
                                  numberofmachine: machinenumber,
                                  date: date,
                                  note: note,
                                  distancewitkilometer: distancewitkilometer,
                                  locatedriver: locatedriver,
                                  locateuser: locateuser,
                                  locateorder: locateorder,
                                  latorderlocate:latorderlocate,
                                  lonorderlocate:lonorderlocate,
                                  latuserlocate: latuserlocate,
                                  lonuserlocate: lonuserlocate,
                                  complete:complete,
                                  authuidnumber: "authuiddrivertwo",
                                )));
                          }else if(user.uid.toString()==authuiddriverthree.toString().split(':').first){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => mainmaps(
                                  upload_id: uploadid,
                                  latitude: latitude,
                                  longitude: longitude,
                                  paykind: paykind,
                                  machinename: machinename,
                                  numberofmachine: machinenumber,
                                  date: date,
                                  note: note,
                                  distancewitkilometer: distancewitkilometer,
                                  locatedriver: locatedriver,
                                  locateuser: locateuser,
                                  locateorder: locateorder,
                                  latorderlocate:latorderlocate,
                                  lonorderlocate:lonorderlocate,
                                  latuserlocate: latuserlocate,
                                  lonuserlocate: lonuserlocate,
                                  complete:complete,
                                  authuidnumber: "authuiddriverthree",
                                )));
                          }else if(user.uid.toString()==authuiddriverfour.toString().split(':').first){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => mainmaps(
                                  upload_id: uploadid,
                                  latitude: latitude,
                                  longitude: longitude,
                                  paykind: paykind,
                                  machinename: machinename,
                                  numberofmachine: machinenumber,
                                  date: date,
                                  note: note,
                                  distancewitkilometer: distancewitkilometer,
                                  locatedriver: locatedriver,
                                  locateuser: locateuser,
                                  locateorder: locateorder,
                                  latorderlocate:latorderlocate,
                                  lonorderlocate:lonorderlocate,
                                  latuserlocate: latuserlocate,
                                  lonuserlocate: lonuserlocate,
                                  complete:complete,
                                  authuidnumber: "authuiddriverfour",
                                )));
                          }else{
                            print("error when determine user auth");
                          }
                        });
                      },
                      color: colorred,
                      child: new Text(
                        translate(
                          "activity_order.details",
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
                    width: 5.0,
                  ),
                  Container(
                    child: Image.asset("images/wenshmain.png"),
                    height: 50,
                    width: 50,
                  ),
                ],
              ),
              Visibility(
                visible:locateorder.toString().trim()=="null"? false:true,
                child: Text("   "+translate("activity_order.locateorder")+"   "+"$locateorder"),
              ),
              Text(note==null?"":"$note",style: TextStyle(fontWeight: FontWeight.bold),),
              Align(
                alignment: Alignment.bottomLeft,
                child: new Text("$date"),
              ),
            ],
          ),
        ),
      ));
}