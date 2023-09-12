import 'package:flutter/Material.dart';

import 'mydraweritems.dart';

class DrawerItem {

  final String title;
  final IconData icon;

  const DrawerItem({
    required this.title,
    required this.icon
  });
}
class MyDrawer extends StatelessWidget {
  final ValueChanged<DrawerItem> onSelectedItems;

  const MyDrawer(
      {super.key, required this.onSelectedItems});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
    child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 35,
          ),

          Image.asset("assets/images/pioneer_logo_app1.png",height: 180,),
          const SizedBox(
            height: 20,
          ),
          buildDrawerItems(context),
        ],
      ),
    ),
  );

  Widget buildDrawerItems(BuildContext context) => Column(
    children: DrawerItems.all.
    map((item) => ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: Icon(item.icon, color: Colors.white70),
      title: (Text(
        item.title,
        style: const TextStyle(color: Colors.white70,fontSize: 18, fontWeight: FontWeight.bold,),
      )),
      onTap: () => onSelectedItems(item),
    ),
    ).toList(),
  );
}