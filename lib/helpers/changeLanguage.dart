import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:moadatydriver/changelang.dart';

void showDemoActionSheet({BuildContext context, Widget child}) {
  showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child).then((String value) {
    changeLocale(context, value);
  });
}
void onActionSheetPress(BuildContext context) {
  showDemoActionSheet(
      context: context,
      child: changelang()
  );
}