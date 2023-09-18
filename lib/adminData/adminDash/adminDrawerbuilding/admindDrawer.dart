import 'package:flutter/Material.dart';
import 'adminDraweritems.dart';

class DrawerItem {
  final String title;
  final IconData icon;

  const DrawerItem({required this.title, required this.icon});
}

class MyDrawer extends StatelessWidget {
  final ValueChanged<DrawerItem> onSelectedItems;

  const MyDrawer({super.key, required this.onSelectedItems});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [

              Image.asset(
                "assets/images/pioneer_logo_app1.png",
                height: 180,
              ),

              buildDrawerItems(context),
            ],
          ),
        ),
      );

  Widget buildDrawerItems(BuildContext context) => Column(
        children: DrawerItems.all
            .map(
              (item) => ListTile(
                contentPadding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.height/30 ,
                    MediaQuery.of(context).size.height/30,0,0),
                leading: Icon(item.icon, color: Colors.black),
                title: Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
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
