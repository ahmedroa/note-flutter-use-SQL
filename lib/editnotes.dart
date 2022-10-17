import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:tasks/Screen/home.dart';

import 'constants/constants.dart';
import 'database/sqldb.dart';

class EditNotes extends StatefulWidget {
  final note;
  final title;
  final color;
  final datee;
  final timee;
  final id;
  const EditNotes(
      {Key? key,
      this.note,
      this.title,
      this.id,
      this.color,
      this.datee,
      this.timee})
      : super(key: key);

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  @override
  GlobalKey<FormState> formstate = GlobalKey();

  TextEditingController note = TextEditingController();

  TextEditingController title = TextEditingController();

  TextEditingController color = TextEditingController();

  TextEditingController timee = TextEditingController();
  TextEditingController datee = TextEditingController();
  SqlDb sqlDb = SqlDb();

  @override
  void initState() {
    note.text = widget.note;
    title.text = widget.title;
    color.text = widget.color;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => homeapp())));
            },
            icon: Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.red,
            )),
        elevation: 0.0,
        backgroundColor: Color(0xffF2F3F7),
        title: Text(
          'Edit  Notes',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Scaffold(
        backgroundColor: Color(0xffF2F3F7),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Form(
                  key: formstate,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: TextField(
                          controller: title,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Write a title...',
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: TextField(
                          controller: note,
                          maxLines: 10,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Write a note...',
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2030-01-01'))
                                    .then((value) => {
                                          datee.text =
                                              DateFormat.yMMMd().format(value!),
                                        });
                              },
                              icon: Icon(
                                Icons.notifications_active,
                                color: Colors.red,
                              )),
                          IconButton(
                              icon: Icon(
                                Icons.calendar_month,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then(
                                  (value) => {
                                    print(value!.format(context)),
                                    timee.text =
                                        value.format(context).toString(),
                                  },
                                );
                              }),
                          MaterialButton(
                            textColor: Colors.white,
                            color: Colors.red,
                            onPressed: () async {
                              int response = await sqlDb.updateData('''
                            UPDATE notes SET
                            note = "${note.text}",
                            title = "${title.text}",
                            color = "${color.text}"
                            WHERE id = ${widget.id}
                              ''');
                              if (response > 0) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => homeapp(),
                                    ),
                                    ((route) => false));
                              }
                            },
                            child: Text('Edit Notes'),
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
