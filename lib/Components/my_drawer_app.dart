import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university_project_admin/Providers/university_list_provider.dart';
import 'package:university_project_admin/Screens/uni_add.dart';
import 'package:university_project_admin/Screens/uni_list.dart';

import '../Helpers/constants.dart';
import '../Helpers/helper_function.dart';
import '../Screens/login.dart';

class MyDrawerApp extends StatefulWidget {
  MyDrawerApp({Key? key}) : super(key: key);

  @override
  State<MyDrawerApp> createState() => _MyDrawerAppState();
}

class _MyDrawerAppState extends State<MyDrawerApp> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 0.0,
        child: Column(children: <Widget>[
          Expanded(
              child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountEmail: Text(Constants.loginEmail == null
                    ? "abc@gmail.com"
                    : Constants.loginEmail!),
                accountName: Text(Constants.loginName!),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  // backgroundImage: AssetImage("assets/images/profile.png"),
                  child: Text(Constants.loginName!.substring(0, 1),
                      style: TextStyle(fontSize: 25.0)),
                ),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ),
                // otherAccountsPictures: [
                //   CircleAvatar(
                //     backgroundColor: Colors.white,
                //     child: Text(
                //       Constants.loginName!.substring(0, 1),
                //       style: TextStyle(color: Color(0xFF2E4053)),
                //     ),
                //   )
                // ],
              ),
              ListTile(
                title: Text('Dashboard'),
                trailing: Icon(Icons.dashboard),
                onTap: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => UniList())),
              ),
              ListTile(
                title: Text("Add University"),
                trailing: Icon(Icons.dashboard_customize),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => UniAdd()));
                },
              ),
              ListTile(
                  title: Text('Logout'),
                  trailing: Icon(Icons.logout),
                  onTap: () {
                    HelperFunctions.saveLogInSharePreference(false);
                    Provider.of<UniversityListProvider>(context, listen: false)
                        .isLoadingUniversityListProvider = true;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  }),
            ],
          )),
          Container(
            color: Colors.black,
            width: double.infinity,
            height: 0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    "Develop by Rai",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    "v1.0.1",
                    style: TextStyle(),
                  )),
            ],
          ),
        ]));
    ;
  }
}
