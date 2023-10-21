import 'package:flutter/Material.dart';
import '../../../constants/AppColor_constants.dart';
import 'empDrawerItems.dart';

class EmpDrawerItem {
  final String title;
  final IconData icon;

  const EmpDrawerItem({required this.title, required this.icon});
}

class EmpDrawer extends StatelessWidget {
  final ValueChanged<EmpDrawerItem> onSelectedItems;

  const EmpDrawer({super.key, required this.onSelectedItems});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.fromLTRB(0, screenHeight / 10, 0, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              // Center the image
              child: Image.asset(
                "assets/images/pioneer_logo_app.png",
                height: screenHeight / 15,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 45),
              child: buildDrawerItems(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItems(BuildContext context) => Column(
        children: EmpDrawerItems.all
            .map(
              (item) => ListTile(
                contentPadding: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(context).size.height / 22.5, 0, 0),
                leading: Icon(item.icon, color: Colors.black87),
                title: Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.grey,
                        offset:
                            Offset(2, 2),
                        blurRadius: 3,
                      ),
                      // You can add more Shadow objects for multiple shadows
                    ],
                  ),
                ),
                onTap: () => onSelectedItems(item),
              ),
            )
            .toList(),
      );
}
