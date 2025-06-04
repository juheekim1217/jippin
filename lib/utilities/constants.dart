import 'package:flutter/material.dart';

/// Simple preloader inside a Center widget
const preloader = Center(child: CircularProgressIndicator(color: Colors.orange));

/// Simple sized box to space out form elements
const formSpacer = SizedBox(width: 16, height: 16);

/// Some padding for all the forms to use
const formPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);

/// Error message to display the user when unexpected error occurs.
const unexpectedErrorMessage = 'Unexpected error occurred.';

/// Simple sized box to space out form elements
const int smallScreenWidth = 600; // Mobile
const int mediumScreenWidth = 1024; // Tablet
const int largeScreenWidth = 1440; // Desktop & Larger Screens
