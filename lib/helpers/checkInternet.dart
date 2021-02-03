import 'dart:io';

import 'package:flutter_translate/global.dart';
import 'package:moadatydriver/helpers/showtoast.dart';

checkInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
    }
  } on SocketException catch (_) {
    showToast(translate("toast.check_internet"));
    print('not connected');
  }
}