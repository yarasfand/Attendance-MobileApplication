import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/app_startUp.dart';
import 'api_intigration_files/repository/user_repository.dart';
import 'bloc_internet/internet_bloc.dart';
import 'api_intigration_files/repository/admin_repository.dart';

void main() {
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
        ],
        child: BlocProvider(
          create: (BuildContext context) {
            return InternetBloc();
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            home: AppStartup(),
          ),
        ));
  }
}
