import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university_project_admin/Components/my_drawer_app.dart';
import 'package:university_project_admin/Models/university_list_model.dart';
import 'package:university_project_admin/Providers/university_list_provider.dart';
import 'package:university_project_admin/Screens/merit_list.dart';
import 'package:university_project_admin/Screens/uni_update.dart';
import 'package:url_launcher/link.dart';

class UniList extends StatefulWidget {
  const UniList({Key? key}) : super(key: key);

  @override
  State<UniList> createState() => _UniListState();
}

class _UniListState extends State<UniList> {
  bool dataLoad = false;
  fetchUniversity() async {
    var universityListProvider =
        Provider.of<UniversityListProvider>(context, listen: false);
    if (universityListProvider.isLoadingUniversityListProvider == true) {
      UniversityListModel data =
          await universityListProvider.fetchUniversityListApi();
      universityListProvider.setUniversityData(data);
      setState(() {
        dataLoad = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    fetchUniversity();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Result>? universityList =
        Provider.of<UniversityListProvider>(context, listen: true)
            .getUniversityList();
    bool isHave = Provider.of<UniversityListProvider>(context, listen: false)
        .isLoadingUniversityListProvider;
    return Scaffold(
      appBar: AppBar(title: const Text("All University")),
      drawer: MyDrawerApp(),
      body: universityList == null || isHave == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(5.0),
              child: universityList.isNotEmpty
                  ? ListView.builder(
                      itemCount: universityList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return UniversityListTile(
                          id: universityList[index].id,
                          name: universityList[index].name,
                          ranking: universityList[index].ranking,
                          registerLink: universityList[index].registerLink,
                          requirementLink:
                              universityList[index].requirementLink,
                          index: index,
                          meritResult: universityList[index].meritResult,
                        );
                      })
                  : Center(
                      child: Text("No University found"),
                    ),
            ),
    );
  }
}

class UniversityListTile extends StatelessWidget {
  final int? index;
  final String? id;
  final String? name;
  final String? ranking;
  final String? registerLink;
  final String? requirementLink;
  final List<MeritResult>? meritResult;
  const UniversityListTile({
    Key? key,
    this.index,
    this.id,
    this.name,
    this.ranking,
    this.registerLink,
    this.requirementLink,
    this.meritResult,
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
              Text(style: TextStyle(fontWeight: FontWeight.bold), name!),
              Container(
                child: Link(
                  target: LinkTarget.blank,
                  uri: Uri.parse(registerLink!),
                  builder: (context, followLink) => GestureDetector(
                    onTap: followLink,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "For Registration",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Link(
                  target: LinkTarget.blank,
                  uri: Uri.parse(requirementLink!),
                  builder: (context, followLink) => GestureDetector(
                    onTap: followLink,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "For Requirement",
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
              Text("R ${ranking!}",
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
                      .deleteUniversity(index, id!);
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
                    builder: (BuildContext context) => UniUpdate(
                        id: id,
                        name: name,
                        index: index,
                        ranking: ranking,
                        requirementLink: requirementLink,
                        registerLink: registerLink),
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
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
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
                    builder: (BuildContext context) => MeritList(
                      uniIndex: index,
                      uniId: id,
                      meritResult: meritResult,
                    ),
                  ),
                );
              },
              child: Text(
                "Merit",
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
