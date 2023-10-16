import 'package:flutter/Material.dart';
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
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/images/pioneer_logo_app.png",
                height: 180,
              ),
              buildDrawerItems(context),
            ],
          ),
        ),
      );

  Widget buildDrawerItems(BuildContext context) => Column(
        children: EmpDrawerItems.all
            .map(
              (item) => ListTile(
                contentPadding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.height / 30,
                    MediaQuery.of(context).size.height / 22.5,
                    0,
                    0),
                leading: Icon(item.icon, color: Colors.black),
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
