import 'package:flutter/material.dart';

class MenuItem {
  final int id;
  final String label;
  final IconData icon;

  MenuItem(this.id, this.label, this.icon);
}

List<MenuItem> menuItems = [
  MenuItem(1, 'Home', Icons.home),
  MenuItem(2, 'Profile', Icons.person),
  MenuItem(3, 'Settings', Icons.settings),
  MenuItem(4, 'Favorites', Icons.favorite),
  MenuItem(5, 'Notifications', Icons.notifications),
  MenuItem(6, 'Messages', Icons.message),
  MenuItem(7, 'Explore', Icons.explore),
  MenuItem(8, 'Search', Icons.search),
  MenuItem(9, 'Chat', Icons.chat),
  MenuItem(10, 'Calendar', Icons.calendar_today),
];

class DropdownMenuSample extends StatefulWidget {
  const DropdownMenuSample({super.key});

  @override
  State<DropdownMenuSample> createState() => _DropdownMenuSampleState();
}

class _DropdownMenuSampleState extends State<DropdownMenuSample> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 16.0;
    final TextEditingController menuController = TextEditingController();
    // ignore: unused_local_variable
    MenuItem? selectedMenu;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'DropdownMenu',
          ),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50.0,
              ),
              DropdownMenu<MenuItem>(
                //initialSelection: menuItems.first,
                controller: menuController,
                width: width,
                hintText: "Select Menu",
                requestFocusOnTap: true,
                enableFilter: true,
                menuStyle: MenuStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue.shade50),
                ),

                label: const Text('Select Menu'),
                onSelected: (MenuItem? menu) {
                  setState(() {
                    selectedMenu = menu;
                  });
                },
                dropdownMenuEntries: menuItems.map<DropdownMenuEntry<MenuItem>>((MenuItem menu) {
                  return DropdownMenuEntry<MenuItem>(value: menu, label: menu.label, leadingIcon: Icon(menu.icon));
                }).toList(),
              ),
            ],
          ),
        ));
  }
}
