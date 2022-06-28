import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university_project_admin/Models/university_list_model.dart';
import 'package:university_project_admin/Providers/university_list_provider.dart';
import 'package:url_launcher/link.dart';

import 'add_merit.dart';
import 'update_merit.dart';

class MeritList extends StatefulWidget {
  final List<MeritResult>? meritResult;
  final int? uniIndex;
  final String? uniId;
  const MeritList({
    Key? key,
    this.meritResult,
    this.uniIndex,
    this.uniId,
  }) : super(key: key);

  @override
  State<MeritList> createState() => _MeritListState();
}

class _MeritListState extends State<MeritList> {
  TextEditingController _searchTextController = TextEditingController();
  bool _searchField = false;
  void _searchFiledFun() {
    setState(() {
      _searchField = !_searchField;
    });
  }

  @override
  void initState() {
    nowMeritResult = widget.meritResult!;
    super.initState();
  }

  List<MeritResult>? nowMeritResult;

  void _searchJob(String val) {
    List<MeritResult>? results = [];
    if (val.isEmpty) {
      results = widget.meritResult;
    } else {
      results = widget.meritResult!
          .where((element) =>
              element.deptName!.toLowerCase().contains(val.toLowerCase()))
          .toList();
    }
    setState(() {
      nowMeritResult = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UniversityListProvider>(context, listen: true)
        .getUniversityList();
    return Scaffold(
      appBar: AppBar(title: const Text("Merit List"), actions: [
        GestureDetector(
          onTap: _searchFiledFun,
          child: Container(
            padding: EdgeInsets.only(right: 5),
            child: _searchField ? Icon(Icons.close) : Icon(Icons.search),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AddMerit(
                    uniId: widget.uniId,
                    uniIndex: widget.uniIndex,
                  ),
                ),
              );
            },
            child: Icon(
              Icons.add,
              size: 26.0,
              color: Colors.white,
            ),
          ),
        ),
      ]),
      body: Column(
        children: [
          _searchField
              ? Form(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    margin: EdgeInsets.only(
                      top: 10,
                    ),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      autofocus: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueGrey,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.blueGrey,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueGrey,
                          ),
                        ),
                        hintText: 'Search Department',
                        labelText: 'Search',
                      ),
                      onChanged: (value) {
                        _searchJob(value);
                        setState(() {
                          _searchTextController.text = value;
                        });
                      },
                    ),
                  ),
                )
              : Text(""),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: widget.meritResult!.isNotEmpty
                  ? ListView.builder(
                      itemCount: nowMeritResult!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MeritListTile(
                          id: nowMeritResult![index].id,
                          deptName: nowMeritResult![index].deptName,
                          lastMerit: nowMeritResult![index].lastMerit,
                          lastMeritUrl: nowMeritResult![index].lastMeritUrl,
                          entryTest: nowMeritResult![index].entryTest,
                          index: index,
                          uniIndex: widget.uniIndex,
                        );
                      })
                  : Center(
                      child: Text("No Merit found"),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class MeritListTile extends StatelessWidget {
  final int? index;
  final int? uniIndex;
  final String? id;
  final String? deptName;
  final String? lastMerit;
  final String? lastMeritUrl;
  final String? entryTest;
  const MeritListTile({
    Key? key,
    this.index,
    this.id,
    this.deptName,
    this.lastMerit,
    this.lastMeritUrl,
    this.entryTest,
    this.uniIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
                deptName!,
              ),
              Text(
                style: TextStyle(
                  fontSize: 12.0,
                ),
                entryTest! == "1" ? "Yes Entry Test" : "No Entry Test",
              ),
            ],
          ),
          Column(
            children: [
              Text("Merit ${lastMerit!}%",
                  style: TextStyle(
                    fontSize: 12.0,
                  )),
            ],
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Link(
              target: LinkTarget.blank,
              uri: Uri.parse(lastMeritUrl!),
              builder: (context, followLink) => GestureDetector(
                onTap: followLink,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    "For Merit List",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding: EdgeInsets.all(
                5,
              ),
              child: GestureDetector(
                onTap: () {
                  Provider.of<UniversityListProvider>(context, listen: false)
                      .deleteMerit(uniIndex, index, id!);
                },
                child: Icon(Icons.remove),
              )),
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            padding: EdgeInsets.all(
              5,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MeritUpdate(
                      id: id,
                      deptName: deptName,
                      index: index,
                      uniIndex: uniIndex,
                      lastMerit: lastMerit,
                      lastMeritUrl: lastMeritUrl,
                      entryTest: entryTest,
                    ),
                  ),
                );
              },
              child: Icon(Icons.edit),
            ),
          ),
        ],
      ),
      Divider(
        color: Colors.grey,
      )
    ]);
  }
}
