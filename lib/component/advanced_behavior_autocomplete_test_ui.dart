import 'package:flutter/material.dart';
import 'custom/advanced_behavior_autocomplete.dart';

// void main() {
//   runApp(const AutocompleteSpike());
// }
//
// class AutocompleteSpike extends StatelessWidget {
//   const AutocompleteSpike({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Advanced Autocomplete')),
//         body: Center(
//           child: HomePage(),
//         ),
//       ),
//     );
//   }
// }

// class HomePage extends StatelessWidget {HomePage({Key? key}) : super(key: key);
class AutocompleteTest extends StatelessWidget {
  AutocompleteTest({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static const List<String> _emails = <String>['alice@example.com', 'bob@example.com', 'charlie123@gmail.com'];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Advanced Behavior Autocomplete supports the following:'),
            const Text('1.  Selecting the highlighed item with the mouse, or by pressing ENTER or TAB.'),
            const Text('    On selction focus is moved the next field.'),
            const Text('2.  Entering text, then pressing ENTER or TAB, focus will be moved to the next field.'),
            const Text('3.  This form demonstrates how to supply a fieldViewBuilder; this enables developers to'),
            const Text('    provide a TextFormField that has all the capabilities you are accustomed to, such as'),
            const Text('    validation, maximum length, etc.'),
            const Text('    The code show supplying a Validator and maxLength.'),
            const Text('NOTE: In you real apps, be sure to provide the initialValue.'),
            const SizedBox(height: 24),
            AdvancedBehaviorAutocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return [];
                }
                return _emails.where((String option) {
                  return option.toString().contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                debugPrint('You just selected $selection');
              },

              /// set this in your real apps initialValue: const TextEditingValue(text: 'Hi'),
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                return TextFormField(
                  focusNode: focusNode,
                  controller: textEditingController,
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required Entry';
                    }
                    return null;
                  },
                  maxLength: 50,
                );
              },
            ),
            TextFormField(),
            TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                  }
                },
                child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}
