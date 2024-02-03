import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:project/introduction/bloc/bloc_internet/internet_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../No_internet/no_internet.dart';
import '../../../constants/AnimatedTextPopUp.dart';
import '../../../constants/AppBar_constant.dart';
import '../../../constants/globalObjects.dart';
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
        selectedEmployees.clear();
        _uncheckAllCheckboxes(); // Add this line to uncheck all checkboxes
        print(selectedEmployees);
        showLoading = false;
      });
    });
  }

  void _uncheckAllCheckboxes() {
    for (var employee in employees) {
      employee.isSelected = false;
    }
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

  void dispose() {
    addToCartPopUpAnimationController.dispose();
    GlobalObjects.globalDep = "";
    GlobalObjects.globalCompany = "";
    GlobalObjects.globalBranch = "";
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
  void onDepartmentChanged(String value) {
    setState(() {
      // Update the department state in the parent widget
    });
  }

  void onBranchChanged(String value) {
    setState(() {
      // Update the branch state in the parent widget
    });
  }

  void onCompanyChanged(String value) {
    setState(() {
      // Update the company state in the parent widget
    });
  }
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
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: AppColors.primaryColor,
              actions: [
                IconButton(
                  onPressed: () {
                    _navigateToNextScreen();
                  },
                  icon: Icon(
                    Icons.check,
                    color: Colors.white, // Change color to green
                    size: 24,
                  ),
                ),
              ],
              title: Text(
                "Daily Reports",
                style: AppBarStyles.appBarTextStyle,
              ),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search by name or code...',
                                  icon: const Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  ),
                                  hintStyle: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              width: 30,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: IconButton(
                                onPressed: () async {
                                  final selectedValues =
                                  await showModalBottomSheet<
                                      Map<String, String?>>(
                                    context: context,
                                    builder: (context) => FilterBottomSheet(
                                      departmentNames: departmentNames,
                                      branchNames: branchNames,
                                      companyNames: companyNames,
                                      onDepartmentChanged: onDepartmentChanged,
                                      onBranchChanged: onBranchChanged,
                                      onCompanyChanged: onCompanyChanged,
                                      onApplyFilters: () {
                                        // Apply your filter logic here
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );

                                  if (selectedValues != null) {
                                    final Map<String, String> resultMap =
                                    selectedValues.cast<String, String>();
                                    setState(() {
                                      departmentDropdownValue =
                                          resultMap['department'] ?? '';
                                      branchDropdownValue =
                                          resultMap['branch'] ?? '';
                                      companyDropdownValue =
                                          resultMap['company'] ?? '';
                                    });
                                  }
                                },
                                icon: Icon(FontAwesomeIcons.slidersH),
                              ),
                            ),
                            Container(
                              width: 30,
                              margin: EdgeInsets.only(right: 5),
                              child: IconButton(
                                onPressed: _toggleSelectAll,
                                icon: Icon(
                                  color: Colors.black,
                                  selectAll
                                      ? Icons.library_add_check
                                      : Icons.library_add_check_outlined,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                          MediaQuery.of(context).size.height > 720 ? MediaQuery.of(context).size.height* 0.73: MediaQuery.of(context).size.height *0.73;
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

  void _navigateToNextScreen() {
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

  }
}
class FilterBottomSheet extends StatefulWidget {
  final List<String> departmentNames;
  final List<String> branchNames;
  final List<String> companyNames;
  final Function(String)? onDepartmentChanged;
  final Function(String)? onBranchChanged;
  final Function(String)? onCompanyChanged;
  final Function()? onApplyFilters; // Updated callback

  FilterBottomSheet({
    required this.departmentNames,
    required this.branchNames,
    required this.companyNames,
    this.onDepartmentChanged,
    this.onBranchChanged,
    this.onCompanyChanged,
    this.onApplyFilters,
  });

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String departmentDropdownValue = '';
  String branchDropdownValue = '';
  String companyDropdownValue = '';

  @override
  void initState() {
    super.initState();
    // Initialize dropdown values with the values passed from the parent widget
    departmentDropdownValue = GlobalObjects.globalDep;
    branchDropdownValue = GlobalObjects.globalBranch;
    companyDropdownValue = GlobalObjects.globalCompany;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50], // Slightly off-white color
        borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
      ),
      height: MediaQuery.of(context).size.height * 0.9,
      child: DraggableScrollableSheet(
        initialChildSize: 0.99,
        minChildSize: 0.1,
        maxChildSize: 0.99,
        expand: true,
        builder: (BuildContext context, ScrollController scrollController) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 10,
                width: 50,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 30),
                    child: GestureDetector(
                      onTap: () {
                        // Return the selected values when "Apply" is clicked
                        Navigator.of(context).pop({
                          'department': departmentDropdownValue,
                          'branch': branchDropdownValue,
                          'company': companyDropdownValue,
                        });
                      },
                      child: Text(
                        "Apply",
                        style: TextStyle(
                          color: AppColors
                              .primaryColor, // or any other bright color you prefer
                          fontWeight: FontWeight.bold,
                          fontSize: 15, // Adjust the font size as needed
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "FILTERS",
                        style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Department',
                            style: GoogleFonts.nunito(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: SingleChildScrollView(
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: departmentDropdownValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    departmentDropdownValue = newValue!;
                                    GlobalObjects.globalDep =
                                        departmentDropdownValue;
                                  });
                                  widget.onDepartmentChanged!(
                                      newValue!); // Move this outside of setState
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '',
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text(
                                        'All',
                                        style: GoogleFonts.nunito(
                                          textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ...widget.departmentNames
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                          value,
                                          style: GoogleFonts.nunito(
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[
                                              700], // Dark grey text color
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Branch',
                            style: GoogleFonts.nunito(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .grey[200], // Light grey background color

                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: branchDropdownValue,
                              onChanged: (newValue) {
                                setState(() {
                                  branchDropdownValue = newValue!;
                                  GlobalObjects.globalBranch =
                                      branchDropdownValue;
                                });
                                widget.onBranchChanged!(
                                    newValue!); // Move this outside of setState
                              },
                              items: [
                                DropdownMenuItem<String>(
                                  value: '',
                                  child: Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      'All',
                                      style: GoogleFonts.nunito(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ...widget.branchNames.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text(
                                        value,
                                        style: GoogleFonts.nunito(
                                          textStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[
                                            700], // Dark grey text color
                                            fontWeight: FontWeight.bold,
                                          ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Company',
                            style: GoogleFonts.nunito(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .grey[200], // Light grey background color

                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: companyDropdownValue,
                              onChanged: (newValue) {
                                setState(() {
                                  companyDropdownValue = newValue!;
                                  GlobalObjects.globalCompany =
                                      companyDropdownValue;
                                });
                                widget.onCompanyChanged!(
                                    newValue!); // Move this outside of setState
                              },
                              items: [
                                DropdownMenuItem<String>(
                                  value: '',
                                  child: Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      'All',
                                      style: GoogleFonts.nunito(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ...widget.companyNames.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text(
                                        value,
                                        style: GoogleFonts.nunito(
                                          textStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[
                                            700], // Dark grey text color
                                            fontWeight: FontWeight.bold,
                                          ),
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
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
