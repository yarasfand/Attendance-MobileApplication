import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/admin/adminOptionsReport/adminOptions_bloc/admin_monthly_reports_bloc.dart';
import 'package:project/admin/adminOptionsReport/models/AdminDailyReportsRepository.dart';
import 'package:project/admin/adminOptionsReport/models/AdminMonthlyReportsRepository.dart';
import 'package:project/admin/adminProfile/bloc/admin_profile_bloc.dart';
import 'package:project/admin/adminProfile/models/AdminEditProfileRepository.dart';
import 'package:project/admin/adminReportsFiles/bloc/CustomLeaveRequestApiFiles/custom_leave_request_bloc.dart';
import 'package:project/admin/pendingLeavesApproval/model/ApproveManualPunchRepository.dart';
import 'package:project/admin/pendingLeavesApproval/model/PendingLeavesRepository.dart';
import 'package:project/startup/screens/appStartUp.dart';
import 'admin/adminDashboard/models/adminRepository.dart';
import 'admin/adminGeofence/bloc/admin_geofence_bloc.dart';
import 'admin/adminGeofence/models/adminGeofencePostRepository.dart';
import 'admin/adminOptionsReport/adminOptions_bloc/admin_daily_reports_bloc.dart';
import 'admin/adminOptionsReport/screens/DailyReportsScreen.dart';
import 'admin/adminProfile/bloc/admin_edit_profile_bloc.dart';
import 'admin/adminProfile/models/AdminProfileRepository.dart';
import 'admin/adminProfile/screens/AdminEditProfilePage.dart';
import 'admin/adminProfile/screens/adminProfilePage.dart';
import 'admin/adminReportsFiles/bloc/getActiveEmployeeApiFiles/get_active_employee_bloc.dart';
import 'admin/adminReportsFiles/bloc/leaveRequestApiFiles/leave_request_bloc.dart';
import 'admin/adminReportsFiles/bloc/leaveSubmissionApiFiles/leave_submission_bloc.dart';
import 'admin/adminReportsFiles/bloc/leaveTypeApiFiles/leave_type_bloc.dart';
import 'admin/adminReportsFiles/bloc/unApprovedLeaveRequestApiFiles/un_approved_leave_request_bloc.dart';
import 'admin/adminReportsFiles/models/getActiveEmployeeRepository.dart';
import 'admin/adminReportsFiles/models/leaveRequestRepository.dart';
import 'admin/adminReportsFiles/models/leaveSubmissionRepository.dart';
import 'admin/adminReportsFiles/models/leaveTypeRepository.dart';
import 'admin/adminReportsFiles/models/unApprovedLeaveRequestRepository.dart';
import 'admin/adminReportsFiles/screens/LeaveSubmissionPage.dart';
import 'admin/adminmanualAttendance/bloc/manual_punch_bloc.dart';
import 'admin/adminmanualAttendance/models/punchRepository.dart';
import 'admin/adminmanualAttendance/screens/ManualMarkAttendance.dart';
import 'admin/pendingLeavesApproval/bloc/approve_manual_punch_bloc.dart';
import 'admin/pendingLeavesApproval/bloc/pending_leaves_bloc.dart';
import 'admin/pendingLeavesApproval/screens/PendingLeavesPage.dart';
import 'employee/empDashboard/models/emp_attendance_status_repository.dart';
import 'employee/empDashboard/models/user_repository.dart';
import 'employee/empMap/bloc/attendanceGeoFenceApiFiles/geo_fence_bloc.dart';
import 'employee/empMap/models/attendanceGeoFencingRepository.dart';
import 'employee/empProfilePage/bloc/EmpEditProfileApiFiles/emp_edit_profile_bloc.dart';
import 'employee/empProfilePage/bloc/emProfileApiFiles/emp_profile_api_bloc.dart';
import 'employee/empProfilePage/models/EmpEditProfileRepository.dart';
import 'employee/empProfilePage/models/empProfileRepository.dart';
import 'employee/empReportsOnDash/bloc/MonthlyReports_apiFiles/monthly_reports_bloc.dart';
import 'employee/empReportsOnDash/models/LeaveHistory_repository.dart';
import 'employee/empReportsOnDash/models/MonthlyReports_repository.dart';
import 'employee/empReportsOnDash/models/empLeaveRequestRepository.dart';
import 'employee/empReportsOnDash/models/empPostLeaveRequestRepository.dart';
import 'introduction/bloc/bloc_internet/internet_bloc.dart';
import 'introduction/utilities/api_integration_files/api_intigration_bloc.dart';
import 'login/bloc/loginBloc/loginbloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        BlocProvider<SignInBloc>(
          create: (context) => SignInBloc(), // Create your SignInBloc here
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepository(),
        ),
        RepositoryProvider<AdminRepository>(
          create: (_) => AdminRepository(),
        ),
        RepositoryProvider<EmpAttendanceRepository>(
          create: (_) => EmpAttendanceRepository(),
        ),
        RepositoryProvider<EmpProfileRepository>(
          create: (_) => EmpProfileRepository(),
        ),
        RepositoryProvider<EmpLeaveRepository>(
          create: (_) => EmpLeaveRepository(),
        ),
        RepositoryProvider<SubmissionRepository>(
          create: (_) => SubmissionRepository(),
        ),
        RepositoryProvider<LeaveHistoryRepository>(
          create: (_) => LeaveHistoryRepository(),
        ),
        RepositoryProvider<EmpEditProfileRepository>(
          create: (_) => EmpEditProfileRepository(),
        ),
        RepositoryProvider<GeoFenceRepository>(
          create: (_) => GeoFenceRepository(""),
        ),
        RepositoryProvider<GetActiveEmpRepository>(
          create: (_) => GetActiveEmpRepository(),
        ),
        RepositoryProvider<ManualPunchRepository>(
          create: (_) => ManualPunchRepository(),
        ),
        RepositoryProvider<AdminGeoFenceRepository>(
          create: (_) => AdminGeoFenceRepository(),
        ),

        // Add other repository providers if needed
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<InternetBloc>(
            create: (BuildContext context) {
              return InternetBloc();
            },
          ),
          BlocProvider<ApiIntigrationBloc>(
            create: (BuildContext context) {
              return ApiIntigrationBloc(UserRepository());
            },
          ),
          BlocProvider<EmpProfileApiBloc>(
            create: (context) => EmpProfileApiBloc(
              RepositoryProvider.of<EmpProfileRepository>(
                  context), // Provide the repository
            ),
          ),
          BlocProvider<EmpEditProfileBloc>(
            create: (BuildContext context) {
              return EmpEditProfileBloc(
                empEditProfileRepository: EmpEditProfileRepository(),
              );
            },
          ),
          BlocProvider<GeoFenceBloc>(
            create: (BuildContext context) {
              return GeoFenceBloc(
                geoFenceRepository: GeoFenceRepository(""),
              );
            },
          ),
          BlocProvider<MonthlyReportsBloc>(
            create: (context) =>
                MonthlyReportsBloc(repository: MonthlyReportsRepository()),
          ),
          BlocProvider(
            create: (context) => GetEmployeeBloc(GetActiveEmpRepository()),
            child: ManualMarkAttendance(),
          ),
          BlocProvider<ManualPunchBloc>(
            create: (BuildContext context) {
              return ManualPunchBloc(repository: ManualPunchRepository());
            },
          ),
          BlocProvider(
            create: (context) =>
                LeaveRequestBloc(repository: LeaveRepository()),
            child: LeaveSubmissionPage(
              selectedEmployees: [],
            ),
          ),
          BlocProvider<UnapprovedLeaveRequestBloc>(
            create: (BuildContext context) => UnapprovedLeaveRequestBloc(
                repository: UnApprovedLeaveRepository()),
          ),
          BlocProvider<LeaveTypeBloc>(
            create: (BuildContext context) =>
                LeaveTypeBloc(repository: LeaveTypeRepository()),
          ),
          BlocProvider<InternetBloc>(create: (context) => InternetBloc()),
          BlocProvider<AdminGeoFenceBloc>(
              create: (context) => AdminGeoFenceBloc()),
          BlocProvider(
            create: (context) => LeaveSubmissionBloc(
              repository: LeaveSubmissionRepository(),
            ),
            child: LeaveSubmissionPage(
              selectedEmployees: [],
            ),
          ),
          BlocProvider(
            create: (context) => PendingLeavesBloc(PendingLeavesRepository()),
            child: PendingLeavesPage(
              approveRepository: ApproveManualPunchRepository(),
            ),
          ),
          BlocProvider<ApproveManualPunchBloc>(
            create: (BuildContext context) {
              // Create an instance of the ApproveManualPunchBloc here.
              return ApproveManualPunchBloc();
            },
          ),
          BlocProvider<AdminMonthlyReportsBloc>(
            create: (BuildContext context) {
              return AdminMonthlyReportsBloc(AdminMonthlyReportsRepository());
            },
          ),
          BlocProvider<CustomLeaveRequestBloc>(
            create: (BuildContext context) {
              return CustomLeaveRequestBloc();
            },
          ),
          BlocProvider(
            create: (context) {
              return AdminProfileBloc(
                  AdminProfileRepository());
            },
            child: AdminProfilePage(),
          ),
          BlocProvider(
            create: (context) => AdminEditProfileBloc(
                AdminEditProfileRepository("http://62.171.184.216:9595")),
            child:
                const AdminEditProfilePage(), // Replace with your main UI page
          ),
          BlocProvider(
            create: (context) => AdminReportsBloc(
                AdminReportsRepository('http://62.171.184.216:9595')),
            child: const DailyReportsScreen(
              selectedEmployeeIds: [],
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
            tabBarTheme: const TabBarTheme(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
            ),
          ),
          home: AppStartup(),
        ),
      ),
    );
  }
}
