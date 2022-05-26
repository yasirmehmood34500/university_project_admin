import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university_project_admin/Providers/university_list_provider.dart';
import 'package:university_project_admin/Screens/login.dart';
import 'Helpers/constants.dart';
import 'Helpers/helper_function.dart';
import 'Screens/uni_list.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UniversityListProvider>(
          create: (_) => UniversityListProvider(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loading = true;
  bool isLogin = false;
  @override
  void initState() {
    super.initState();
    getLoginUserInfo();
  }

  getLoginUserInfo() async {
    var isLoginCheck = await HelperFunctions.getLogInSharePreference();
    if (isLoginCheck != null && isLoginCheck == true) {
      Constants.loginName = await HelperFunctions.getNameSharePreference();
      Constants.loginId = await HelperFunctions.getIdSharePreference();
      Constants.isLogin = await HelperFunctions.getLogInSharePreference();
      Constants.loginEmail = await HelperFunctions.getEmailSharePreference();
      setState(() {
        isLogin = true;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : isLogin
              ? const UniList()
              : const Login(),
    );
  }
}
