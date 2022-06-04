import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '/Providers/university_list_provider.dart';
import '/Models/university_list_model.dart';
import '../base_url.dart';

class AddMerit extends StatefulWidget {
  final int? uniIndex;
  final String? uniId;
  const AddMerit({
    Key? key,
    this.uniIndex,
    this.uniId,
  }) : super(key: key);

  @override
  State<AddMerit> createState() => _AddMeritState();
}

class _AddMeritState extends State<AddMerit> {
  final formKey = GlobalKey<FormState>();
  TextEditingController deptNameController = TextEditingController();
  TextEditingController lastMeritController = TextEditingController();
  TextEditingController lastMeritUrlController = TextEditingController();
  TextEditingController entryTestController = TextEditingController();
  bool isLoadding = false;
  String saveResponse = "";
  meritUpdBtn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoadding = true;
      });
      var url = Uri.https(
          BaseUrl.apiBaseUrl, '${BaseUrl.apiBaseUrlSecond}add_merit.php', {});
      Map object = {
        "university_id": widget.uniId,
        "dept_name": deptNameController.text,
        "last_merit": lastMeritController.text,
        "last_merit_url": lastMeritUrlController.text,
        "entry_test": entryTestController.text
      };
      var source = await http.post(url, body: jsonEncode(object));
      if (source.statusCode == 200) {
        if (jsonDecode(source.body)["status"] == 200) {
          var meritAddObject = jsonDecode(source.body)["result"];
          var meritNewObject = MeritResult(
            id: meritAddObject["id"],
            universityId: meritAddObject["university_id"],
            deptName: meritAddObject["dept_name"],
            lastMerit: meritAddObject["last_merit"],
            lastMeritUrl: meritAddObject["last_merit_url"],
            entryTest: meritAddObject["entry_test"],
          );
          Provider.of<UniversityListProvider>(context, listen: false)
              .addMerit(widget.uniIndex, meritNewObject);
          Navigator.pop(context);
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
      appBar: AppBar(title: Text("Add Merit")),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Add Merit",
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
                        labelText: 'Department Name',
                      ),
                      controller: deptNameController,
                      validator: (val) {
                        return val!.length > 1 ? null : "Min 2 latter";
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
                        labelText: 'Merit',
                      ),
                      controller: lastMeritController,
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
                        labelText: 'Merit List Link',
                      ),
                      controller: lastMeritUrlController,
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
                        hintText: '1,0',
                        labelText: 'Entry Test',
                      ),
                      controller: entryTestController,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        return val!.length == 1 ? null : "Only 1 letter";
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
                            meritUpdBtn();
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
