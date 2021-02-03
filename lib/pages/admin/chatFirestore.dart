import 'dart:io';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:moadatydriver/helpers/showtoast.dart';
import 'package:moadatydriver/models/Constants.dart';
import 'package:moadatydriver/repository/databaseFirestoreChat.dart';

class Chat extends StatefulWidget {
  final String chatRoomId,upload_id,paykind;
  Chat({
    this.chatRoomId,
    this.upload_id,
    this.paykind
  });
  @override
  _ChatState createState() => _ChatState();
}
class _ChatState extends State<Chat> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data.documents.length,

            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data.documents[index].data()["message"],
                sendByMe: Constants.myAuth == snapshot.data.documents[index].data()["sendBy"],
              );
            }) : Container();
      },
    );
  }
  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myAuth,
        "message": messageEditingController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
         'upload_id':widget.upload_id,
         'paykind':widget.paykind
      };
      DatabaseMethods().addMessage(widget.upload_id.toString(),chatMessageMap);
      setState(() {
        messageEditingController.text = "";
      });
      DatabaseMethods().getChats(widget.upload_id.toString()).then((val) {
        setState(() {
          chats = val;
        });
      });
    }
  }
  Stream chatRooms;
  @override
  void initState() {
    DatabaseMethods().getUserChats(widget.upload_id.toString()).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${widget.upload_id.toString()}");
      });
    });
    DatabaseMethods().getChats(widget.upload_id.toString()).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title:Text(translate("app_bar.chat"),style: TextStyle(color: Colors.white),),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: chatMessages(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Container(
                  height: 70,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  color: Colors.black45,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: TextField(
                            controller: messageEditingController,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                                hintText: "Message ...",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none
                            ),
                          )),
                      SizedBox(width: 16,),
                      GestureDetector(
                        onTap: () {
                          addMessage();
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: 70,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40)
                            ),
                            child: Icon(Icons.send,color: Theme.of(context).hintColor,)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  MessageTile({@required this.message, @required this.sendByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: sendByMe
              ? EdgeInsets.only(left: 30)
              : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(
              top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: sendByMe ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23)
              ) :
              BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
              color: color
          ),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(message,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ],
          )

      ),
    );
  }
}
