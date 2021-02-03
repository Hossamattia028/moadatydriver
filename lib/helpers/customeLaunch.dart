import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

void customeLaunch(command)async{
  if(await canLaunch(command)){
    await launch(command);
  }else{
    print("could not launch");
  }
}