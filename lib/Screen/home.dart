import 'package:flutter/material.dart';

import 'package:tasks/database/sqldb.dart';
import 'package:tasks/editnotes.dart';
import 'package:tasks/widgets/addnote.dart';

class homeapp extends StatefulWidget {
  const homeapp({Key? key}) : super(key: key);

  @override
  State<homeapp> createState() => _homeappState();
}

class _homeappState extends State<homeapp> {
  SqlDb sqlDb = SqlDb();
  int complet = 0;
  bool isloading = true;
  bool isChecked = false;

  List notes = [];

  Future redData() async {
    List<Map> response = await sqlDb.readData('SELECT * FROM notes');
    notes.addAll(response);

    print(response);
    if (this.mounted) {
      isloading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    redData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F3F7),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => addnote())));
          // showModalBottomSheet(
          //     isScrollControlled: true,
          //     context: context,
          //     builder: ((context) => SingleChildScrollView(
          //         child: Container(
          //             padding: EdgeInsets.only(
          //                 bottom: MediaQuery.of(context).viewInsets.bottom),
          //             child: addnote()))));
        },
        child: Icon(Icons.add),
      ),
      body: isloading == true
          ? Center(child: Text('Loading....'))
          : Container(
              // color: kPrimaryColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView(children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          "All notes",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Text(
                          "${notes.length} note",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.grey),
                        ),
                        SizedBox(
                          height: 9,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      itemCount: notes.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => EditNotes(
                                          note: notes[i]['note'],
                                          title: notes[i]['title'],
                                          color: notes[i]['color'],
                                          id: notes[i]['id'],
                                        ))));
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white),
                                child: ListTile(
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${notes[i]['title']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        "${notes[i]['note']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${notes[i]['datee']}",
                                            style: TextStyle(
                                                backgroundColor:
                                                    Color(0xffF2F3F7),
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "${notes[i]['timee']}",
                                            style: TextStyle(
                                                backgroundColor:
                                                    Color(0xffF2F3F7),
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            int response = await sqlDb.deleteData(
                                                'DELETE FROM notes WHERE id = ${notes[i]['id']}');
                                            if (response > 0) {
                                              notes.removeWhere((element) =>
                                                  element['id'] ==
                                                  {notes[i]['id']});
                                              if (response > 0) {
                                                notes.removeWhere((element) =>
                                                    element['id'] ==
                                                    notes[i]['id']);
                                                setState(() {});
                                              }
                                            }
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      })
                ]),
              ),
            ),
    );
  }
}


    // MSHCheckbox(
    //                                   value: isChecked,
    //                                   checkedColor: Colors.red,
    //                                   uncheckedColor: Colors.black12,
    //                                   onChanged: (selected) async {
    //                                     setState(() {
    //                                       isChecked = selected;
    //                                     });
    //                                   },
    //                                 ),