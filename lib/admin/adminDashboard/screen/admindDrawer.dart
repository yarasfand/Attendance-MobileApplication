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
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 55),
        child: buildDrawerItems(context),
      ),
    );
  }

  Widget buildDrawerItems(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: AdminDrawerItems.all
          .map(
            (item) =>
            ListTile(
              contentPadding:  EdgeInsets.fromLTRB(
                  0,
                  screenHeight / 20, 0, 0),
              leading: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, screenWidth / 10, 0),
                child: Icon(item.icon, color: Colors.black87),
              ),
              title: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.grey, // Color of the shadow
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
}

