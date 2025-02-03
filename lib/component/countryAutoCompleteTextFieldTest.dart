import 'package:flutter/material.dart';
import 'package:jippin/utils.dart';

class CountryAutoCompleteTextField extends StatefulWidget {
  final double width;
  final Function(String?) onChanged;
  final String initialValue;

  CountryAutoCompleteTextField({
    required this.width,
    required this.onChanged,
    required this.initialValue,
  });

  @override
  _CountryDropdownTextFieldState createState() => _CountryDropdownTextFieldState();
}

class _CountryDropdownTextFieldState extends State<CountryAutoCompleteTextField> {
  List<String> myList = ["Collections", "Records", "Stream API"];
  late TextEditingController _controller = TextEditingController();
  bool _isValidSelection = false;

  @override
  void initState() {
    super.initState();
    String? initialCountryName = getCountryName(widget.initialValue);
    _controller.text = initialCountryName!;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32, // Match the height of other menu items
      width: widget.width,
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return countries.where((country) => country["name"]!.toLowerCase().contains(textEditingValue.text.toLowerCase())).map((country) => country["name"]!);
        },
        onSelected: (String selection) {
          String? selection_code = getCountryCode(selection);
          setState(() {
            _controller.text = selection;
            _isValidSelection = true; // Mark as valid selection
          });
          widget.onChanged(selection_code);
        },
        fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
          // Listen for focus changes
          focusNode.addListener(() {
            if (!focusNode.hasFocus && !_isValidSelection) {
              FocusScope.of(context).unfocus(); // Remove focus first
              // 🔥 Clear input if the user clicks outside without selecting from the dropdown
              setState(() {
                _controller.clear();
              });
            }
          });
          textEditingController.text = _controller.text;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Align icon and text field properly
            children: [
              Icon(Icons.location_on, color: Colors.black54), // ✅ Icon outside the field
              SizedBox(width: 4), // ✅ Adjust spacing between icon and text field
              Expanded(
                // ✅ Prevents text field from overflowing
                child: TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onSubmitted: (String selection) => onFieldSubmitted(),
                  onChanged: (value) {
                    _isValidSelection = false; // Reset validation when user types manually
                  },
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Select Country",
                    labelStyle: TextStyle(fontSize: 14, color: Colors.grey),

                    // Center text vertically inside the TextFormField
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),

                    // Default border (when not focused)
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide(
                        color: Colors.grey, // 🔹 Change border color when not focused
                        width: 1.5,
                      ),
                    ),

                    // Border when field is focused
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide(
                        color: Colors.blue, // 🔹 Change border color when focused
                        width: 2.0,
                      ),
                    ),

                    // Border when there's an error
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide(
                        color: Colors.red, // 🔹 Change border color for error state
                        width: 2.0,
                      ),
                    ),

                    // Border when user is typing but error is still there
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide(
                        color: Colors.redAccent, // 🔹 Change border color for focused error
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
