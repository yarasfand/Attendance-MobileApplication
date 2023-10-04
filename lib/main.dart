import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Backend/AdminApi/AdminRepository/AdminRepository.dart';
import 'Backend/ApiIntegrationFiles/ApiIntegrationBloc.dart';
import 'Backend/EmployeeApi/EmployeeRespository/EmployeeAttendanceStatusRepository.dart';
import 'Backend/EmployeeApi/EmployeeRespository/EmployeeLeaveHistoryRepository.dart';
import 'Backend/EmployeeApi/EmployeeRespository/EmployeeLeaveRequestRepository.dart';
import 'Backend/EmployeeApi/EmployeeRespository/EmployeePostLeaveRequestRepository.dart';
import 'Backend/EmployeeApi/EmployeeRespository/EmployeeProfileRepository.dart';
import 'Backend/EmployeeApi/EmployeeRespository/EmployeeUserRepository.dart';
import 'Controller/AdminBlocInternet/AdminInternetBloc.dart';
import 'UI/AppStartUp/AppStarting.dart';

// main.dart

// ... (imports)

void main() {
  Fluttertoast.showToast;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
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
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: AppStartup(),
        ),
      ),
    );
  }
}
