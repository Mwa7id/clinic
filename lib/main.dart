import 'package:clinic/add.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:clinic/sqflite.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

List<Map> list = [];
List<Map> list2 = [];
SqlDb db = SqlDb();
List patients = [];
List coun = [];
List<Map> filt = [];
List filter = [];
List<dynamic> filterr = [];
String queryy = "";
String newmed = "";
int count = 0;
void main() async {
  runApp(MyWidget());
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    patients = [];
    read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: home());
  }

  void read() async {
    list = await db.readData("SELECT * FROM pat");
    patients.addAll(list);

    count =
        Sqflite.firstIntValue(await db.readData("SELECT COUNT (*) FROM pat"))!;
    setState(() {});
  }
}

class home extends StatefulWidget {
  const home({super.key});
  @override
  State<home> createState() => _home2();
}

class _home2 extends State<home> {
  SqlDb db = SqlDb();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          title: Text("Welcome Dr,"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: search());
                },
                icon: Icon(Icons.search))
          ],
          leading: IconButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Patients Number"),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$count",
                            style: TextStyle(color: Colors.blue, fontSize: 25),
                          ),
                        ],
                      ),
                      actions: [
                        MaterialButton(
                          onPressed: Navigator.of(context).pop,
                          child: Text(
                            "Ok",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        )
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.people)),
        ),
        floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          child: Text("Add"),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => addd()));
          },
        ),
        body: ListView.builder(
          itemCount: patients.length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return Slidable(
              startActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) async {
                      db.deleteData(
                          "DELETE FROM pat WHERE id = ${patients[i]['id']}");
                      patients.removeWhere(
                          (element) => element['id'] == patients[i]['id']);
                      setState(() {});
                    },
                    backgroundColor: Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) async {
                      showModalBottomSheet(
                        isDismissible: false,
                        context: context,
                        builder: (context) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, right: 10, left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Patient Name : ${patients[i]['fullname']}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    "medicine : ${patients[i]['medicine']}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    "Date : ${patients[i]['date']}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    "Time : ${patients[i]['time']}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 3),
                                  Center(
                                    child: Text(
                                      "Description ",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.blue),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Center(
                                    child: Text(
                                      "${patients[i]['desc']}",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    backgroundColor: Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.remove_red_eye,
                    label: 'Show',
                  ),
                  SlidableAction(
                    onPressed: (context) async {
                      showModalBottomSheet(
                        isDismissible: false,
                        context: context,
                        builder: (context) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, right: 10, left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                        label: Text("New Medicine"),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    onChanged: (value) {
                                      newmed = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: MaterialButton(
                                      minWidth: 100,
                                      height: 50,
                                      color: Colors.blueAccent,
                                      onPressed: () async {
                                        if (newmed != "") {
                                          db.updateData(
                                              "UPDATE pat SET medicine = '$newmed' WHERE id = ${patients[i]['id']}");
                                          setState(() {});
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyWidget()));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text("Enter New Medicine"),
                                            duration: Duration(seconds: 2),
                                            backgroundColor: Colors.red,
                                          ));
                                        }
                                      },
                                      child: Text(
                                        "Update",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                ],
              ),
              child: Card(
                  shadowColor: Colors.black,
                  elevation: 10.0,
                  color: Colors.white,
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.only(
                        top: 15, left: 10, right: 10, bottom: 15),
                    textColor: Colors.black,
                    title: Text("${patients[i]['fullname']}"),
                    leading: Text("${patients[i]['time']}"),
                    trailing: Text("${patients[i]['date']}"),
                  )),
            );
          },
        ));
  }
}

class search extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          )),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.blue,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    filter.clear();
    return Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == "") {
      return Text("");
    }
    _ref().reff(query);

    return ListView.builder(
      itemCount: filter.length,
      shrinkWrap: true,
      itemBuilder: (context, i) {
        return Slidable(
          startActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  db.deleteData(
                      "DELETE FROM pat WHERE id = ${filter[i]['id']}");
                  filter.removeWhere(
                      (element) => element['id'] == filter[i]['id']);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MyWidget()));
                },
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (context) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 15, right: 10, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Patient Name : ${filter[i]['fullname']}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "medicine : ${filter[i]['medicine']}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Date : ${filter[i]['date']}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Time : ${filter[i]['time']}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 3),
                              Center(
                                child: Text(
                                  "Description ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blue),
                                ),
                              ),
                              SizedBox(height: 3),
                              Center(
                                child: Text(
                                  "${filter[i]['desc']}",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                backgroundColor: Color(0xFF7BC043),
                foregroundColor: Colors.white,
                icon: Icons.remove_red_eye,
                label: 'Show',
              ),
              SlidableAction(
                onPressed: (context) async {
                  showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (context) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 15, right: 10, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                    label: Text("New Medicine"),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onChanged: (value) {
                                  newmed = value;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: MaterialButton(
                                  minWidth: 100,
                                  height: 50,
                                  color: Colors.blueAccent,
                                  onPressed: () async {
                                    if (newmed != "") {
                                      db.updateData(
                                          "UPDATE pat SET medicine = '$newmed' WHERE id = ${patients[i]['id']}");
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyWidget()));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("Enter New Medicine"),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.red,
                                      ));
                                    }
                                  },
                                  child: Text(
                                    "Update",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
              ),
            ],
          ),
          child: Card(
              shadowColor: Colors.black,
              elevation: 10.0,
              color: Colors.white,
              child: ListTile(
                dense: true,
                contentPadding:
                    EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
                textColor: Colors.black,
                title: Text("${filter[i]['fullname']}"),
                leading: Text("${filter[i]['time']}"),
                trailing: Text("${filter[i]['date']}"),
              )),
        );
      },
    );
  }
}

class refresh extends StatefulWidget {
  const refresh(String query, {super.key});

  @override
  State<refresh> createState() => _ref();
}

class _ref extends State<refresh> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  reff(String query) async {
    queryy = query;

    if (queryy != "") {
      filt =
          await db.readData("SELECT * FROM pat WHERE fullname LIKE '$queryy%'");
    } else {
      queryy = "";
      filter.clear();
    }
    filter = filt
        .where((item) =>
            item.toString().toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Text("");
  }
}
