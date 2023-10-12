import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../../introduction/bloc/bloc_internet/internet_state.dart';


class AdminAttendanceReportMonthly extends StatefulWidget {
  @override
  _AdminAttendanceReportMonthlyState createState() => _AdminAttendanceReportMonthlyState();
}

class _AdminAttendanceReportMonthlyState extends State<AdminAttendanceReportMonthly> {
  var screenSize;
  final List<Employee> employees = [
    Employee(
      name: 'Affan',
      code: 'E123456',
      present: 20,
      absent: 5,
      leaveWithoutHoliday: 3,
      workingDays: 28,
    ),
    Employee(
      name: 'Asfand',
      code: 'E123456',
      present: 20,
      absent: 5,
      leaveWithoutHoliday: 3,
      workingDays: 28,
    ),
    Employee(
      name: 'Abdullah',
      code: 'E123456',
      present: 20,
      absent: 5,
      leaveWithoutHoliday: 3,
      workingDays: 28,
    ),
    // Add more employees here as needed
  ];

  List<Employee> filteredEmployees = [];

  @override
  void initState() {
    filteredEmployees = employees; // Initialize filtered data with all employees
    super.initState();
  }

  void filterEmployees(String keyword) {
    setState(() {
      filteredEmployees = employees.where((employee) {
        return employee.name.toLowerCase().contains(keyword.toLowerCase()) ||
            employee.code.toLowerCase().contains(keyword.toLowerCase()) ||
            employee.present.toString().contains(keyword) ||
            employee.absent.toString().contains(keyword) ||
            employee.leaveWithoutHoliday.toString().contains(keyword) ||
            employee.workingDays.toString().contains(keyword);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return BlocConsumer<InternetBloc, InternetStates>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    if(state is InternetGainedState)
      {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Monthly Attendance Report',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(
                right: screenSize.width * 0.04,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        // For excel export

                      },
                      child: Image.asset(
                        width: 25,
                        height: 25,
                        'assets/images/excel1.png',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: GestureDetector(
                      onTap: () {

                      },
                      child: Image.asset(
                        width: 25,
                        height: 25,
                        'assets/images/pdf1.png',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          centerTitle: true,
          backgroundColor: Color(0xFFE26142),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  filterEmployees(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredEmployees.length,
                itemBuilder: (context, index) {
                  return EmployeeCard(employee: filteredEmployees[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
    else if(state is InternetLostState)
      {
        return Expanded(
          child: Scaffold(
            body: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Internet Connection!",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Lottie.asset('assets/no_wifi.json'),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    else {
      return Expanded(
        child: Scaffold(
          body: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Internet Connection!",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Lottie.asset('assets/no_wifi.json'),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
);
  }
}

class Employee {
  final String name;
  final String code;
  final int present;
  final int absent;
  final int leaveWithoutHoliday;
  final int workingDays;

  Employee({
    required this.name,
    required this.code,
    required this.present,
    required this.absent,
    required this.leaveWithoutHoliday,
    required this.workingDays,
  });
}

class EmployeeCard extends StatelessWidget {
  final Employee employee;

  EmployeeCard({required this.employee});

  Widget buildFieldRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('$value'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.all(16.0),
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.0),
              buildFieldRow('Employee Name', employee.name),
              SizedBox(height: 5.0),
              buildFieldRow('Employee Code', employee.code),
              SizedBox(height: 5.0),
              buildFieldRow('Total Present', '${employee.present}'),
              SizedBox(height: 5.0),
              buildFieldRow('Total Absent', '${employee.absent}'),
              SizedBox(height: 5.0),
              buildFieldRow(
                  'Total Leave-Wo_Holiday', '${employee.leaveWithoutHoliday}'),
              SizedBox(height: 5.0),
              buildFieldRow('Working Days', '${employee.workingDays}'),
            ],
          ),
        ),
      ),
    );
  }
}
