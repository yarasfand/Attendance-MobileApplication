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
    return Container(

      child: SingleChildScrollView(
        child: Column(
          children: [
            /*
            Center(
              // Center the image
              child: Image.asset(
                "assets/images/pioneer_logo_app.png",
                height: screenHeight / 15,
              ),
            ),

             */

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
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
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 45, 0), // Adjust the padding as needed
                  child: Icon(item.icon, color: Colors.black87),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => onSelectedItems(item),
              ),
            )
            .toList(),
      );
}
