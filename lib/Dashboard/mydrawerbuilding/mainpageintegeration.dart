import 'package:flutter/Material.dart';
import '../mydash/dashhome.dart';
import 'mydrawer.dart';
import 'mydraweritems.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //Declaring Variables
  late double xoffset;
  late double yoffset;
  late double scaleFactor;
  bool isDragging = false;
  late bool isDrawerOpen;
  DrawerItem item = DrawerItems.home;

  //Init State
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    closeDrawer();
  }

  //When Drawer Open Handler
  void openDrawer() => setState(() {
        xoffset = 230;
        yoffset = 170;
        scaleFactor = 0.6;
        isDrawerOpen = true;
      });

  //When Drawer Closed Handler
  void closeDrawer() => setState(() {
        xoffset = 0;
        yoffset = 0;
        scaleFactor = 1;
        isDrawerOpen = false;
      });

  //HANDLING PAGE INTO TWO PARTS
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(0x80E26142),
        body: Stack(
          children: [
            buildDrawer(), //BUILD CUSTOM DRAWER
            buildPage(), //BUILD OTHER SIDE THAT IS DASHBOARD
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
              onSelectedItems: (item) {
                switch (item) {
                  case DrawerItems.attendance:
                    Navigator.pushNamed(context, '/attendance');
                    return;

                  case DrawerItems.reports:
                    Navigator.pushNamed(context, '/report');
                    return;

                  case DrawerItems.profile:
                    Navigator.pushNamed(context, '/profile');
                    return;
                  case DrawerItems.logout:
                   Navigator.pushNamed(context, '/logout');

                  default:
                    setState(() {
                      this.item = item;
                      closeDrawer();
                    });
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
            )),
      ),
    );
  }

  Widget getDrawerPage() {
    return MyDashboard(openDrawer: openDrawer);
  }
}
