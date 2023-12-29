import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:project/introduction/bloc/bloc_internet/internet_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../No_internet/no_internet.dart';
import '../../../constants/AnimatedTextPopUp.dart';
import '../../../constants/AppBar_constant.dart';
import '../../../introduction/bloc/bloc_internet/internet_bloc.dart';
import '../../adminReportsFiles/bloc/getActiveEmployeeApiFiles/get_active_employee_bloc.dart';
import '../../adminReportsFiles/bloc/getActiveEmployeeApiFiles/get_active_employee_event.dart';
import '../../adminReportsFiles/bloc/getActiveEmployeeApiFiles/get_active_employee_state.dart';
import '../../adminReportsFiles/models/branchModel.dart';
import '../../adminReportsFiles/models/branchRepository.dart';
import '../../adminReportsFiles/models/companyRepository.dart';
import '../../adminReportsFiles/models/departmentModel.dart';
import '../../adminReportsFiles/models/departmentRepository.dart';
import '../../adminReportsFiles/models/getActiveEmployeesModel.dart';
import 'DailyReportsScreen.dart';

class AdminDailyReportEmployeeListPage extends StatefulWidget {
  const AdminDailyReportEmployeeListPage({Key? key}) : super();

  @override
  State<AdminDailyReportEmployeeListPage> createState() =>
      _AdminDailyReportEmployeeListPageState();
}

class _AdminDailyReportEmployeeListPageState
    extends State<AdminDailyReportEmployeeListPage>
    with TickerProviderStateMixin {
  late AnimationController addToCartPopUpAnimationController;

  String corporateId = '';
  List<GetActiveEmpModel> employees = [];
  List<GetActiveEmpModel> selectedEmployees = [];
  bool selectAll = false;
  final TextEditingController _remarksController = TextEditingController();
  String filterOption = 'Default'; // Initialize with Default
  String filterId = '';
  List<String> departmentNames = [];
  String? departmentDropdownValue;
  String searchQuery = '';
  Department? selectedDepartment;
  String? branchDropdownValue;
  List<String> branchNames = [];
  String? companyDropdownValue;
  List<String> companyNames = [];
  List<Branch> buildCards = [];
  bool showLoading = true;

  @override
  void initState() {
    addToCartPopUpAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    super.initState();
    _fetchCorporateIdFromPrefs();
    _fetchDepartmentNames();
    _fetchBranchNames(); // Fetch department names when the widget initializes
    _fetchCompanyNames(); // Fetch company names when the widget initializes
    companyDropdownValue = null;
    loadData();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showLoading = false;
      });
    });
  }

  Future<void> loadData() async {
    try {
      List<Branch> branches =
          await BranchRepository().getAllActiveBranches();

      setState(() {
        buildCards = branches;
      });
    } catch (e) {
      print('Error: $e');
      // Handle the error appropriately
    }
  }

  @override
  void dispose() {
    addToCartPopUpAnimationController.dispose();
    super.dispose();
  }

  void showPopupWithMessageFailed(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpFailed(addToCartPopUpAnimationController, message);
      },
    );
  }

  void showPopupWithMessageSuccess(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpSuccess(
            addToCartPopUpAnimationController, message);
      },
    );
  }

  void showPopupWithMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addToCartPopUpNoCrossMessage(
            addToCartPopUpAnimationController, message);
      },
    );
  }

  Future<void> _fetchDepartmentNames() async {
    try {
      final departments =
          await DepartmentRepository().getAllActiveDepartments();

      // Extract department names from the departments list and filter out null values
      final departmentNames = departments
          .map((department) => department?.deptName)
          .where((name) => name != null) // Filter out null values
          .map((name) => name!) // Convert non-nullable String? to String
          .toList();

      setState(() {
        this.departmentNames = departmentNames;
      });
    } catch (e) {
      print('Error fetching department names: $e');
    }
  }

  Future<void> _fetchCorporateIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final storedCorporateId = prefs.getString('corporate_id');
    print("Stored corporate id: $storedCorporateId");
    setState(() {
      corporateId = storedCorporateId ?? '';
    });

    context.read<GetEmployeeBloc>().add(FetchEmployees(corporateId));
  }

  Future<void> _fetchBranchNames() async {
    try {
      final branches =
          await BranchRepository().getAllActiveBranches();

      // Extract branch names from the branches list and filter out null values
      final branchNames = branches
          .map((branch) => branch.branchName)
          .where((name) => name != null) // Filter out null values
          .map((name) => name!) // Convert non-nullable String? to String
          .toList();

      setState(() {
        this.branchNames = branchNames;
      });
    } catch (e) {
      print('Error fetching branch names: $e');
    }
  }

  Future<void> _fetchCompanyNames() async {
    try {
      final companies =
          await CompanyRepository().getAllActiveCompanies();

      final companyNames = companies
          .map((company) => company.companyName)
          .where((name) => name != null) // Filter out null values
          .map((name) => name!) // Convert non-nullable String? to String
          .toList();

      setState(() {
        this.companyNames = companyNames;
      });
    } catch (e) {
      print('Error fetching company names: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.watch<GetEmployeeBloc>().state;

    if (state is GetEmployeeLoaded) {
      final employees = state.employees;
      setState(() {
        this.employees = employees;
      });
      _updateSelectAll();
    }
  }

  void _toggleEmployeeSelection(GetActiveEmpModel employee) {
    setState(() {
      employee.isSelected = !employee.isSelected;
      if (employee.isSelected) {
        selectedEmployees.add(employee);
      } else {
        selectedEmployees.remove(employee);
      }
      print('Employee ${employee.empName} isSelected: ${employee.isSelected}');
      print('Selected Employees: $selectedEmployees');
    });
  }

  void _updateSelectAll() {
    bool allSelected = employees.every((employee) => employee.isSelected);
    setState(() {
      selectAll = allSelected;
    });
  }

  void _toggleSelectAll() {
    setState(() {
      selectAll = !selectAll;
      print('Select All: $selectAll');

      for (var employee in employees) {
        employee.isSelected = selectAll;
      }

      if (selectAll) {
        selectedEmployees = List.from(employees);
      } else {
        selectedEmployees.clear();
      }
      print('Selected Employees: $selectedEmployees');
    });
  }

  void _showRemarksDialog(GetActiveEmpModel employee) {
    _remarksController.text = employee.remarks;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Remarks'),
          content: TextField(
            controller: _remarksController,
            decoration: const InputDecoration(
              hintText: 'Enter remarks...',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update the remarks when OK is pressed
                employee.remarks = _remarksController.text;
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  List<GetActiveEmpModel> filterEmployees(
      List<GetActiveEmpModel> employees, String query) {
    return employees.where((employee) {
      bool matchesFilter = true;

      // Check if a department is selected and match it with the employee's department
      if (departmentDropdownValue != null &&
          departmentDropdownValue!.isNotEmpty) {
        matchesFilter =
            matchesFilter && employee.deptNames == departmentDropdownValue;
      }

      // Check if a branch is selected and match it with the employee's branch
      if (branchDropdownValue != null && branchDropdownValue!.isNotEmpty) {
        matchesFilter =
            matchesFilter && employee.branchNames == branchDropdownValue;
      }

      // Check if a company is selected and match it with the employee's company
      if (companyDropdownValue != null && companyDropdownValue!.isNotEmpty) {
        matchesFilter =
            matchesFilter && employee.companyNames == companyDropdownValue;
      }

      // Check if the search query matches employee's name, code, or EmpId
      bool searchMatch = query.isEmpty ||
          (employee.empName?.toLowerCase().contains(query.toLowerCase()) ??
              false) ||
          (employee.empCode?.toLowerCase().contains(query.toLowerCase()) ??
              false) ||
          (employee.empId.toString().contains(query)); // Check for EmpId match

      // Return true if all conditions are met (selected department, branch, company, and search query), otherwise, return false
      return matchesFilter && searchMatch;
    }).toList();
  }

  bool isInternetLost = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetStates>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is InternetLostState) {
          // Set the flag to true when internet is lost
          isInternetLost = true;
          Future.delayed(Duration(seconds: 2), () {
            Navigator.push(
              context,
              PageTransition(
                child: NoInternet(),
                type: PageTransitionType.rightToLeft,
              ),
            );
          });
        } else if (state is InternetGainedState) {
          // Check if internet was previously lost
          if (isInternetLost) {
            // Navigate back to the original page when internet is regained
            Navigator.pop(context);
          }
          isInternetLost = false; // Reset the flag
        }
      },
      builder: (context, state) {
        if (state is InternetGainedState) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: AppColors.primaryColor,
              elevation: 0,
              title: const Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 55.0), // Add right padding
                  child: Text(
                    "Daily Reports",
                    style: AppBarStyles.appBarTextStyle,
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedEmployees != null &&
                              selectedEmployees.isNotEmpty) {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return DailyReportsScreen(
                                  selectedEmployeeIds: selectedEmployees
                                      .where(
                                          (employee) => employee.empId != null)
                                      .map((employee) => employee.empId!)
                                      .toList(),
                                );
                              },
                            ));
                          } else {
                            addToCartPopUpAnimationController.forward();
                            Timer(const Duration(seconds: 2), () {
                              addToCartPopUpAnimationController.reverse();
                              Navigator.pop(context);
                            });
                            showPopupWithMessage("Please Select Employee!");
                          }
                        },
                        style: selectedEmployees != null &&
                                selectedEmployees.isNotEmpty
                            ? ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 24,
                                ),
                              )
                            : ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 24,
                                ),
                              ),
                        child: const Text(
                          "FETCH REPORTS",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      contentPadding: const EdgeInsets.all(
                                          0), // Remove default padding
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      content: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            color: AppColors.primaryColor,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: <Widget>[
                                                  Text(
                                                    "FILTERS",
                                                    style: GoogleFonts.openSans(
                                                      textStyle:
                                                          const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  // Department Dropdown
                                                  // Department Dropdown
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Department:',
                                                        style: GoogleFonts
                                                            .openSans(
                                                          textStyle:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                        ),
                                                        child:
                                                            DropdownButtonFormField<
                                                                String>(
                                                          isExpanded: true,
                                                          value:
                                                              departmentDropdownValue,
                                                          onChanged:
                                                              (newValue) {
                                                            departmentDropdownValue =
                                                                newValue;
                                                          },
                                                          items: [
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: '',
                                                              child: Text(
                                                                'All',
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  textStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            ...departmentNames
                                                                .map((String
                                                                    value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: Text(
                                                                  value,
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 10),
                                                  // Branch Dropdown
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Branch:',
                                                        style: GoogleFonts
                                                            .openSans(
                                                          textStyle:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                        ),
                                                        child:
                                                            DropdownButtonFormField<
                                                                String>(
                                                          isExpanded: true,
                                                          value:
                                                              branchDropdownValue,
                                                          onChanged:
                                                              (newValue) {
                                                            branchDropdownValue =
                                                                newValue!;
                                                          },
                                                          items: [
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: '',
                                                              child: Text(
                                                                'All',
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  textStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            ...branchNames.map(
                                                                (String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: Text(
                                                                  value,
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  // Company Dropdown
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Company:',
                                                        style: GoogleFonts
                                                            .openSans(
                                                          textStyle:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                        ),
                                                        child:
                                                            DropdownButtonFormField<
                                                                String>(
                                                          isExpanded: true,
                                                          value:
                                                              companyDropdownValue,
                                                          onChanged:
                                                              (newValue) {
                                                            companyDropdownValue =
                                                                newValue!;
                                                          },
                                                          items: [
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: '',
                                                              child: Text(
                                                                'All',
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  textStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            ...companyNames.map(
                                                                (String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: Text(
                                                                  value,
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text("Apply"),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text("Close"),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Text("Apply Filters"),
                            ),
                            ElevatedButton(
                              onPressed: _toggleSelectAll,
                              child: Text(
                                selectAll ? 'Deselect All' : 'Select All',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Search:',
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(
                                left: 15, right: 15, bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Change background color to white
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Center(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search by name or code...',
                                  icon: Icon(Icons.search,
                                      color: Colors
                                          .black), // Change icon color to black
                                  hintStyle: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Colors
                                          .black, // Change hint text color to black
                                    ),
                                  ),
                                  // Remove the default border
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Employee List in DataTable form
                      buildCards == null ||
                              filterEmployees(employees, searchQuery).length ==
                                  null || showLoading
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.3),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : LayoutBuilder(
                        builder: (context, constraints) {
                          double cardWidth = constraints.maxWidth > 600
                              ? 600
                              : constraints.maxWidth;
                          double screenHeight =
                              MediaQuery.of(context).size.height * 0.65;
                          double containerHeight = screenHeight;
                          return Container(
                            height: containerHeight,
                            margin: const EdgeInsets.all(10),
                            child: ListView.separated(
                              separatorBuilder: (context, index) => Divider(),
                              itemCount:
                              filterEmployees(employees, searchQuery)
                                  .length,
                              itemBuilder: (context, index) {
                                var employee = filterEmployees(
                                    employees, searchQuery)[index];

                                return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            transform: Matrix4.diagonal3Values(
                                                1.2,
                                                1.2,
                                                1), // Adjust the scale factor as needed
                                            child: Checkbox(
                                              value: employee.isSelected,
                                              onChanged: (_) {
                                                _toggleEmployeeSelection(
                                                    employee);
                                              },
                                              shape: CircleBorder(),
                                              activeColor: Colors.blue,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${employee.empName ?? ""}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'ID: ${employee.empCode}',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${employee.branchNames ?? ""}',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      employee.deptNames ??
                                                          "",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      Container(
                        child: Text("End"),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
