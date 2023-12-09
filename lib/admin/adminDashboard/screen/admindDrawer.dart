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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 55),
        child: buildDrawerItems(context),
      ),
    );
  }

  Widget buildDrawerItems(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double optTopDiff;

    if (screenWidth <= 370) {
      optTopDiff = screenHeight / 30;
    } else {
      optTopDiff = screenHeight / 30;
    }

    return Column(
      children: AdminDrawerItems.all
          .map(
            (item) => ListTile(
              contentPadding: EdgeInsets.fromLTRB(0, optTopDiff, 0, 0),
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Icon(item.icon, color: Colors.black87),
              ),
              title: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,

                ),
              ),
              onTap: () => onSelectedItems(item),
            ),
          )
          .toList(),
    );
  }
}
