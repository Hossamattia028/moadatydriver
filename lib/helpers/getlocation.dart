import 'package:location/location.dart';

getLocation(String latitude,String longitude) async {
  var location = new Location();
  try {
    await location.getLocation().then((onValue) {
      print("latitude\n" +
          onValue.latitude.toString() +
          "longitude\n," +
          onValue.longitude.toString());
      latitude=onValue.latitude.toString();
      longitude=onValue.longitude.toString();
      print("latitude: $latitude");
      print("longitude: $longitude");
    });
  } catch (e) {
    print(e);
    if (e.code == 'PERMISSION_DENIED') {
      print('PERMISSION_DENIED');
    }
  }
}