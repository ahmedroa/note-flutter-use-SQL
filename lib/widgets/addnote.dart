import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:tasks/Screen/home.dart';
import 'package:tasks/database/sqldb.dart';
import '../constants/constants.dart';

class addnote extends StatefulWidget {
  const addnote({Key? key}) : super(key: key);

  @override
  State<addnote> createState() => _addnoteState();
}

class _addnoteState extends State<addnote> {
  @override
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController color = TextEditingController();
  TextEditingController timee = TextEditingController();
  TextEditingController datee = TextEditingController();
  SqlDb sqlDb = SqlDb();
  var timeController = TextEditingController();
  var formkey = GlobalKey<FormState>();
  DateTime date = DateTime(2022, 12, 24);
  String selectedTime = "Pick Time";
  var time;

  @override
  void initState() {
    time = TimeOfDay.now();
    super.initState();
  }

  insert() async {
    int response = await sqlDb.insertData('''
                              INSERT INTO notes ("note" , "title" , 
                                       "color" , "timee" , "datee" ) 
                                      VALUES ( "${note.text}" , "${title.text}" ,
                               "${color.text}" , "${timee.text}" , "${datee.text}"
                                )
                              ''');
    print('respose====================');
    print(response);
    if (response > 0) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => homeapp(),
          ),
          ((route) => false));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F3F7),
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
          'Add  Notes',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Form(
              key: formkey,
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
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then(
                              (value) => {
                                print(value!.format(context)),
                                timee.text = value.format(context).toString(),
                              },
                            );
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
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2030-01-01'))
                                .then((value) => {
                                      datee.text =
                                          DateFormat.yMMMd().format(value!),
                                    });
                          }),
                      IconButton(
                        onPressed: () async {
                          int response = await sqlDb.insertData('''
                              INSERT INTO notes ("note" , "title" , 
                                       "color" , "timee" , "datee" ) 
                                      VALUES ( "${note.text}" , "${title.text}" ,
                               "${color.text}" , "${timee.text}" , "${datee.text}"
                                )
                              ''');
                          print('respose====================');
                          print(response);
                          if (response > 0) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => homeapp(),
                                ),
                                ((route) => false));
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.red,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
