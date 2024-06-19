//import 'package:again_inventory_project/page/dashboard.dart';
//import 'package:again_inventory_project/page/products_page.dart';
import 'package:flutter/material.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 20);

    return Drawer(
      child: Material(
        color: Colors.grey.shade200,
        child: ListView(
          padding: padding,
          children: [
            // This is a first menu the [Dashboard, Products, Category]
            const SizedBox(height: 50),
            menuListItem(
                text: "Dashboard",
                icon: Icons.dashboard_outlined,
                onClicked: () => selecteditem(context, 0)),
            const SizedBox(height: 15),
            menuListItem(
                text: "Products",
                icon: Icons.task_outlined,
                onClicked: () => selecteditem(context, 1)),
            const SizedBox(height: 15),
            menuListItem(text: "Category", icon: Icons.analytics_outlined),
            // with a devider
            const SizedBox(height: 50),
            const Divider(),
            const SizedBox(height: 26),
            menuListItem(text: "Account", icon: Icons.account_box_outlined),
            const SizedBox(height: 15),
            menuListItem(text: "Settings", icon: Icons.settings_outlined),
            const SizedBox(height: 15),
            menuListItem(text: "Logout", icon: Icons.analytics_outlined),
          ],
        ),
      ),
    );
  }

  Widget menuListItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const hoverColor = Colors.white12;

    return ListTile(
      leading: Icon(icon),
      title: Text(text, style: const TextStyle(fontFamily: "Roboto")),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selecteditem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const Placeholder() /*Dashboard()*/));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const Placeholder() /*ProductsPage()*/));
        break;
      default:
    }
  }
}
