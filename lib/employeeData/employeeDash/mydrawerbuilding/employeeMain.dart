import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../dashboard_bloc/dashboardk_bloc.dart';
import '../drawerPages/attendance.dart';
import '../drawerPages/homepage.dart';
import '../drawerPages/profile_page/profilePage/profilepage.dart';
import '../drawerPages/report.dart';
import '../mydash/dashhome.dart';
import 'mydrawer.dart';
import 'mydraweritems.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final DashboardkBloc dashBloc = DashboardkBloc();

  late double xoffset;
  late double yoffset;
  late double scaleFactor;
  bool isDragging = false;
  bool isDrawerOpen = false;
  DrawerItem item = DrawerItems.home;

  @override
  void initState() {
    super.initState();
    closeDrawer();
  }

  void openDrawer() {
    setState(() {
      xoffset = 230;
      yoffset = 170;
      scaleFactor = 0.6;
      isDrawerOpen = true;
    });
  }

  void closeDrawer() {
    setState(() {
      xoffset = 0;
      yoffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0x80E26142),
    body: Stack(
      children: [
        buildDrawer(),
        buildPage(),
      ],
    ),
  );

  Widget buildDrawer() => SafeArea(
    child: AnimatedOpacity(
      opacity: isDrawerOpen ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        width: xoffset,
        child: MyDrawer(
          onSelectedItems: (selectedItem) {
            setState(() {
              item = selectedItem;
              closeDrawer();
            });

            switch (item) {
              case DrawerItems.home:
                dashBloc.add(NavigateToHomeEvent());
                break;

              case DrawerItems.attendance:
                dashBloc.add(NavigateToAttendanceEvent());
                break;

              case DrawerItems.reports:
                dashBloc.add(NavigateToReportsEvent());
                break;

              case DrawerItems.profile:
                dashBloc.add(NavigateToProfileEvent());
                break;

              case DrawerItems.logout:
                dashBloc.add(NavigateToLogoutEvent());
                break;

              default:
                dashBloc.add(NavigateToLogoutEvent());
                break;
            }
          },
        ),
      ),
    ),
  );

  Widget buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onTap: closeDrawer,
        onHorizontalDragStart: (details) => isDragging = true,
        onHorizontalDragUpdate: (details) {
          const delta = 1;

          if (!isDragging) return;

          if (details.delta.dx > delta) {
            openDrawer();
          } else if (details.delta.dx < -delta) {
            closeDrawer();
          }
          isDragging = false;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.translationValues(xoffset, yoffset, 0)
            ..scale(scaleFactor),
          child: AbsorbPointer(
            absorbing: isDrawerOpen,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
              child: Container(
                color: isDrawerOpen
                    ? Colors.white12.withOpacity(0.23)
                    : const Color(0xFFFDF7F5),
                child: getDrawerPage(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDrawerPage() {
    return BlocBuilder<DashboardkBloc, DashboardkState>(
      bloc: dashBloc,
      builder: (context, state) {
        if (state is NavigateToProfileState) {
          return ProfilePage(openDrawer: openDrawer);
        } else if (state is NavigateToAttendanceState) {
          return attendance(
            openDrawer: openDrawer,
          );
        } else if (state is NavigateToHomeState) {
          return MyDashboard(openDrawer: openDrawer);
        }
        else if (state is NavigateToReportsState) {
          return reports(
            openDrawer: openDrawer,
          );
        }
        else if (state is NavigateToLogoutState) {
          return HomePage();
        }
        else {
          return MyDashboard(openDrawer: openDrawer);
        }
      },
    );
  }
}
