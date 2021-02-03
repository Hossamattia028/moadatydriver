import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moadatydriver/helpers/showtoast.dart';
import 'package:moadatydriver/main.dart';
import 'package:moadatydriver/pages/admin/adminhelp.dart';
import 'package:moadatydriver/pages/admin/approvedriver.dart';
import 'package:moadatydriver/pages/admin/ordermoadat.dart';

class adminmain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _adminmain();
  }
}
class _adminmain extends State<adminmain> with SingleTickerProviderStateMixin {

  TabController _tabController;
@override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: color,
        title: new Text("Admin Panel"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MyApp()));
            },
          ),
        ],
        bottom: new TabBar(
        controller: _tabController,
            tabs: [
          new Tab(
            text: "Admin help",
          ),
          new Tab(
            text: "Approve Drive",
          ),
          new Tab(
            text: "order moadat",
          ),
        ]),
      ),
      body:  TabBarView(
        controller: _tabController,
        children: <Widget>[
          new adminhelp(),
          new approvedriver(),
          new ordermoadat(),
        ],
      ),
    );
  }
}
