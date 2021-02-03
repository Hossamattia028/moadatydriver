import 'package:maps_toolkit/maps_toolkit.dart';
measurethedistance(var l1lat,var l1long,var l2lat,var l2long){
    LatLng l1 = LatLng(l1lat, l1long);
    LatLng l2 = LatLng(l2lat, l2long);
    final distance = SphericalUtil.computeDistanceBetween(l1, l2) / 1000.0;
    var d = distance.toString().split('.').first;
    print('Distance between two point is $d km.');
    return d;
}