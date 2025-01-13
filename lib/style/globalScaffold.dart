import 'package:flutter/material.dart';

class GlobalScaffold extends StatelessWidget {
  final Widget body;
  //final PreferredSizeWidget? appBar;
  //final Widget? floatingActionButton;
  //final Widget? bottomNavigationBar;
  //final Color? backgroundColor;

  const GlobalScaffold({
    Key? key,
    required this.body,
    //this.appBar,
    //this.floatingActionButton,
    //this.bottomNavigationBar,
    //this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0), // Add margins
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1000, // Set your desired maximum width here
            ),
            child: body, // Pass the page body
          ),
        ),
      ),
    );
  }
}
