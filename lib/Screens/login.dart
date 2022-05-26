import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:university_project_admin/Screens/uni_list.dart';
import '../Helpers/constants.dart';
import '../Helpers/helper_function.dart';
import '../base_url.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoadding = false;
  String loginResponse = "";
  bool _passwordVisible = true;
  loginBtn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoadding = true;
      });
      var url = Uri.https(
          BaseUrl.apiBaseUrl, '${BaseUrl.apiBaseUrlSecond}admin_login.php', {});
      Map object = {
        "email": emailController.text,
        "password": passwordController.text
      };
      var source = await http.post(url, body: jsonEncode(object));
      if (source.statusCode == 200) {
        if (jsonDecode(source.body)["status"] == 200) {
          var id = jsonDecode(source.body)["result"]["id"];
          var name = jsonDecode(source.body)["result"]["name"];
          var email = jsonDecode(source.body)["result"]["email"];
          HelperFunctions.saveIdSharePreference(id);
          HelperFunctions.saveMobileSharePreference(email);
          HelperFunctions.saveNameSharePreference(name);
          HelperFunctions.saveLogInSharePreference(true);
          Constants.isLogin = true;
          Constants.loginEmail = email;
          Constants.loginId = id;
          Constants.loginName = name;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => UniList(),
            ),
          );
        } else if (jsonDecode(source.body)["status"] == 202) {
          setState(() {
            loginResponse = jsonDecode(source.body)["message"];
            isLoadding = false;
          });
        } else {
          setState(() {
            loginResponse = "sorry try again";
            isLoadding = false;
          });
        }
      } else {
        setState(() {
          loginResponse = "try again";
          isLoadding = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Admin Login"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 150.0),
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xFF2E4053),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 50.0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Admin Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              hintText: 'abc@gmail.com',
                              labelText: 'Email',
                            ),
                            controller: emailController,
                            validator: (val) {
                              return val!.length > 10 ? null : "Min 10 letter";
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              hintText: '*********',
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: _passwordVisible,
                            controller: passwordController,
                            validator: (val) {
                              return val!.length > 6
                                  ? null
                                  : "Password length 6+";
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            loginResponse,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    isLoadding
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  loginBtn();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 50,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                  ),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
