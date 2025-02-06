import 'package:flutter/material.dart';
import 'package:jippin/utility/utils.dart';
import 'package:jippin/component/custom/advanced_behavior_autocomplete.dart';

///Enter key
// onChanged e
// onFieldSubmitted e
// onSelected South Korea
// setDefaultCountry KR
// _fetchAllReviews 10
// _applySearchFilter
//
/// Tab Key
// onChanged e
// onSelected South Korea
// setDefaultCountry KR
// _fetchAllReviews 10
// _applySearchFilter
//
//
/// Mouse click
// onChanged e
// onSelected South Korea
// setDefaultCountry KR
// _fetchAllReviews 10
// _applySearchFilter

class CountryAutoCompleteTextField extends StatefulWidget {
  final double width;
  final Function(String?) onChanged;
  final String initialValue;

  const CountryAutoCompleteTextField({
    super.key,
    required this.width,
    required this.onChanged,
    required this.initialValue,
  });

  @override
  State<CountryAutoCompleteTextField> createState() => _CountryDropdownTextFieldState();
}

class _CountryDropdownTextFieldState extends State<CountryAutoCompleteTextField> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32, // Match the height of other menu items
      width: widget.width,
      child: Form(
        key: formKey,
        child: AdvancedBehaviorAutocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return countries.where((country) => country["name"]!.toLowerCase().contains(textEditingValue.text.toLowerCase())).map((country) => country["name"]!);
          },
          // Tab key pressed
          onSelected: (String selection) {
            debugPrint('onSelected $selection');
            String? selectionCode = getCountryCode(selection);
            // ✅ Update controller directly without setState
            // if (selectionCode!.isEmpty) {
            //   _controller.clear();
            // } else {
            //   _controller.text = selection;
            //   widget.onChanged(selectionCode);
            // }
            //_controller.text = selection;
            widget.onChanged(selectionCode);
          },

          moveFocusNext: false,

          /// set this in your real apps initialValue: const TextEditingValue(text: 'Hi'),
          initialValue: TextEditingValue(text: getCountryName(widget.initialValue)!),

          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return Tooltip(
              message: textEditingController.text, // Shows full text on hover
              waitDuration: Duration(milliseconds: 500),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, // Align icon and text field properly
                children: [
                  Icon(Icons.location_on, color: Colors.black54), // ✅ Icon outside the field
                  SizedBox(width: 4), // ✅ Adjust spacing between icon and text field
                  Expanded(
                    // ✅ Prevents text field from overflowing
                    child: TextFormField(
                      focusNode: focusNode,
                      controller: textEditingController,
                      // Enter Key pressed
                      onFieldSubmitted: (String value) {
                        debugPrint('onFieldSubmitted $value');
                        onFieldSubmitted();
                      },
                      onChanged: (value) {
                        //debugPrint('onChanged $value');
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required Entry';
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 12,
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
              ),
            );
          },
        ),
      ),
    );
  }
}
