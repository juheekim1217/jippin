import 'package:flutter/material.dart';
import 'package:jippin/models/country.dart';

class DropdownMenuSample extends StatefulWidget {
  const DropdownMenuSample({super.key});

  @override
  State<DropdownMenuSample> createState() => _DropdownMenuSampleState();
}

class _DropdownMenuSampleState extends State<DropdownMenuSample> {
  final TextEditingController menuController = TextEditingController();

  // Move selectedMenu outside of build method
  Country? selectedMenu;

  @override
  void initState() {
    super.initState();
    // Set initial selection
    selectedMenu = countries.values.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50.0),
          DropdownMenu<Country>(
            initialSelection: selectedMenu,
            controller: menuController,
            width: 200,
            hintText: "Select Menu",
            requestFocusOnTap: true,
            enableFilter: true,
            menuStyle: MenuStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue.shade50),
            ),
            label: const Text('Select Menu'),
            onSelected: (Country? menu) {
              setState(() {
                selectedMenu = menu;
                menuController.text = menu?.nameEn ?? ""; // Update the text field as well
              });
            },
            dropdownMenuEntries: countries.values.map<DropdownMenuEntry<Country>>((Country menu) {
              return DropdownMenuEntry<Country>(
                value: menu,
                label: menu.nameEn,
                //leadingIcon: Icon(menu.icon),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Display the selected menu item
          Text(
            selectedMenu != null ? 'Selected: ${selectedMenu!.nameEn}' : 'No Menu Selected',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
