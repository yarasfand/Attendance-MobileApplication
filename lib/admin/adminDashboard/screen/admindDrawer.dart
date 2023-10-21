import 'package:flutter/Material.dart';
import 'adminDraweritems.dart';

class AdminDrawerItem {
  final String title;
  final IconData icon;

  const AdminDrawerItem({required this.title, required this.icon});
}

class MyDrawer extends StatelessWidget {
  final ValueChanged<AdminDrawerItem> onSelectedItems;

  const MyDrawer({super.key, required this.onSelectedItems});

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
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 45),
              child: buildDrawerItems(context),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildDrawerItems(BuildContext context) => Column(
        children: AdminDrawerItems.all
            .map(
              (item) => ListTile(
                contentPadding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.height/50 ,
                    MediaQuery.of(context).size.height/43,0,0),
                leading: Icon(item.icon, color: Colors.indigo),
                title: Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.indigo,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.grey,// Color of the shadow
                        offset:
                            Offset(2, 2), // Offset of the shadow from the text
                        blurRadius: 3, // Blur radius of the shadow
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
