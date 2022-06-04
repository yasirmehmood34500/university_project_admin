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
  @override
  Widget build(BuildContext context) {
    Provider.of<UniversityListProvider>(context, listen: true)
        .getUniversityList();
    return Scaffold(
      appBar: AppBar(title: const Text("Merit List"), actions: [
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
            )),
      ]),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: widget.meritResult!.isNotEmpty
            ? ListView.builder(
                itemCount: widget.meritResult!.length,
                itemBuilder: (BuildContext context, int index) {
                  return MeritListTile(
                    id: widget.meritResult![index].id,
                    deptName: widget.meritResult![index].deptName,
                    lastMerit: widget.meritResult![index].lastMerit,
                    lastMeritUrl: widget.meritResult![index].lastMeritUrl,
                    entryTest: widget.meritResult![index].entryTest,
                    index: index,
                    uniIndex: widget.uniIndex,
                  );
                })
            : Center(
                child: Text("No Merit found"),
              ),
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
              Text(style: TextStyle(fontWeight: FontWeight.bold), deptName!),
              SizedBox(
                height: 5,
              ),
              Text(
                style: TextStyle(fontWeight: FontWeight.bold),
                entryTest! == "1" ? "Yes Entry Test" : "No Entry Test",
              ),
              Container(
                child: Link(
                  target: LinkTarget.blank,
                  uri: Uri.parse(lastMeritUrl!),
                  builder: (context, followLink) => GestureDetector(
                    onTap: followLink,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "For Merit List",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(lastMerit!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  )),
            ],
          )
        ],
      ),
      SizedBox(
        height: 10.0,
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
                10,
              ),
              child: GestureDetector(
                onTap: () {
                  Provider.of<UniversityListProvider>(context, listen: false)
                      .deleteMerit(uniIndex, index, id!);
                },
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )),
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            padding: EdgeInsets.all(
              10,
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
              child: Text(
                "Update",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
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
