import 'package:flutter/material.dart';
import 'package:attendance_viewer/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
String getForDate;
int total = 0;

class DataScreen extends StatefulWidget {
  static const String id = 'data_screen';
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        //print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  String date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('✔ Attendance'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 24,
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter Date (DD-MM-YYYY)',
                        ),
                        onChanged: (value) {
                          date = value;
                        },
                      ),
                    ),
                    // ignore: deprecated_member_use
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          getForDate = date;
                        });
                        print(Text('Getting data for $date'));
                      },
                      child: Text(
                        'Get',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              DataFetch(),
              SizedBox(
                height: 10,
              ),
              Text(
                'Total: $total',
                style: TextStyle(
                  backgroundColor: Colors.white10,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataFetch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection(getForDate == null ? '0' : getForDate)
          .snapshots(),
      //ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final data = snapshot.data.docs;
        List<DataRow> rowData = [];

        for (var content in data) {
          final studentName = content.data()["Name"];
          final time = content.data()["Time"];
          final verification = content.data()["Verification"];
          final status = content.data()["Status"];
          print(Text('getting'));

          final row = DataRow(
            cells: <DataCell>[
              DataCell(Text(
                studentName,
                style: TextStyle(color: Colors.white),
              )),
              DataCell(Text(
                time,
                style: TextStyle(color: Colors.white),
              )),
              DataCell(Text(
                verification,
                style: TextStyle(color: Colors.white),
              )),
              DataCell(Text(
                status,
                style: TextStyle(color: Colors.white),
              )),
            ],
          );
          rowData.add(row);
          total = rowData.length;
        }
        return Container(
          height: 560,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    color: Colors.white10),
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Time',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Verifiaction',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Status',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                rows: rowData,
              ),
            ),
          ),
        );
      },
    );
  }
}
