import 'package:flutter/material.dart';

/// Global page layout scaffold
class GlobalPageLayoutScaffold extends StatelessWidget {
  final Widget body;

  const GlobalPageLayoutScaffold({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      // Enables selecting all text by mouse dragging on the page
      child: SingleChildScrollView(
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
      ),
    );
  }
}
