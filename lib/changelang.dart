import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:moadatydriver/helpers/showtoast.dart';

class changelang extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _changelang();
  }
}
class _changelang extends State<changelang>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, opacity: 12, size: 25),
        backgroundColor: color,
        title: Text(
          translate("language.selection.title"),
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'ar');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 5,),
                  Icon(Icons.radio_button_checked,color:translate("language.selection.title").toString().contains("اللغة") ?coloryellow:color,),
                  SizedBox(width: 10,),
                  Image.asset("images/kuwaiticon.png",height: 40,width: 40,),
                  SizedBox(width: 20,),
                  Text("العربية",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                ],
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'en_US');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 5,),
                  Icon(Icons.radio_button_checked,color:translate("language.selection.title").toString().contains("اللغة") ?color: coloryellow,),
                  SizedBox(width: 10,),
                  Image.asset("images/english.png",height: 40,width: 40,),
                  SizedBox(width: 20,),
                  Text("English",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 19),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}