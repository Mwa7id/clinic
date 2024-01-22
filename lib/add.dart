import 'package:clinic/main.dart';
import 'package:clinic/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String date =
    "${DateTime.now().day.toString()}/${DateTime.now().month.toString()}/${DateTime.now().year.toString()}";

DateTime now = DateTime.now();
String time = DateFormat("hh:mm").format(now);

String name = "d";
String medicine = "d";
String desc = "d";

void main() {
  runApp(addpatient());
}

class addpatient extends StatelessWidget {
  const addpatient({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: addd(),
    );
  }
}

class addd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Text("Add Patient"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
          child: Column(
            children: [
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                    hintText: "$date",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                    hintText: "$time",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                    label: Text("Patient Name"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                onChanged: (value) {
                  name = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                    label: Text("Medicine"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                onChanged: (value) {
                  medicine = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                        EdgeInsets.only(top: 80, left: 10, right: 10),
                    label: Text("Description"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                onChanged: (value) {
                  desc = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              MaterialButton(
                minWidth: 150,
                height: 50,
                color: Colors.blueAccent,
                onPressed: () async {
                  if (name != "d") {
                    if (medicine != "d") {
                      if (desc != "d") {
                        SqlDb db = SqlDb();
                        int saved = await db.insertData(
                            "INSERT INTO pat(date,time,fullname,medicine,desc) VALUES ('$date','$time','$name','$medicine','$desc')");
                        if (saved > 0) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => MyWidget()));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Fill All data"),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Fill All data"),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red,
                      ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Fill All data"),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                child: Text(
                  "save",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
