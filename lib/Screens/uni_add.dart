import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university_project_admin/Components/my_drawer_app.dart';
import 'package:http/http.dart' as http;
import 'package:university_project_admin/Providers/university_list_provider.dart';
import '/Models/university_list_model.dart';
import '/Screens/uni_list.dart';
import '../base_url.dart';

class UniAdd extends StatefulWidget {
  const UniAdd({Key? key}) : super(key: key);

  @override
  State<UniAdd> createState() => _UniAddState();
}

class _UniAddState extends State<UniAdd> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController rankingController = TextEditingController();
  TextEditingController registerLinkController = TextEditingController();
  TextEditingController requirementLinkController = TextEditingController();
  bool isLoadding = false;
  String saveResponse = "";
  uniSaveBtn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoadding = true;
      });
      var url = Uri.https(BaseUrl.apiBaseUrl,
          '${BaseUrl.apiBaseUrlSecond}add_university.php', {});
      Map object = {
        "name": nameController.text,
        "ranking": rankingController.text,
        "register_link": registerLinkController.text,
        "requirement_link": requirementLinkController.text
      };
      var source = await http.post(url, body: jsonEncode(object));
      if (source.statusCode == 200) {
        if (jsonDecode(source.body)["status"] == 200) {
          var universityAddedObject = jsonDecode(source.body)["result"];
          var universityNewObject = Result(
            id: universityAddedObject["id"],
            name: universityAddedObject["name"],
            ranking: universityAddedObject["ranking"],
            registerLink: universityAddedObject["register_link"],
            requirementLink: universityAddedObject["requirement_link"],
            meritResult: [],
          );
          Provider.of<UniversityListProvider>(context, listen: false)
              .addUniversity(universityNewObject);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => UniList(),
            ),
          );
        } else if (jsonDecode(source.body)["status"] == 202) {
          setState(() {
            saveResponse = jsonDecode(source.body)["message"];
            isLoadding = false;
          });
        } else {
          setState(() {
            saveResponse = "sorry try again!!";
            isLoadding = false;
          });
        }
      } else {
        setState(() {
          saveResponse = "try again";
          isLoadding = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add University")),
      drawer: MyDrawerApp(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Add New University",
                  style: TextStyle(
                    color: Colors.black,
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        hintText: 'ABC',
                        labelText: 'Name',
                      ),
                      controller: nameController,
                      validator: (val) {
                        return val!.length > 2 ? null : "Min 3 latter";
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        hintText: '1',
                        labelText: 'ranking',
                      ),
                      controller: rankingController,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        return val!.length > 0 ? null : "Min 1 digit";
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        hintText: 'http://abc.com',
                        labelText: 'Registration Link',
                      ),
                      controller: registerLinkController,
                      validator: (val) {
                        return val!.length > 10 ? null : "Min 10 letter";
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        hintText: 'http://abc.com',
                        labelText: 'Requirement Link',
                      ),
                      controller: requirementLinkController,
                      validator: (val) {
                        return val!.length > 10 ? null : "Min 10 letter";
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      saveResponse,
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
                            uniSaveBtn();
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
                              "Save",
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
      ),
    );
  }
}
