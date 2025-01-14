import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:jippin/component/webNavbar.dart';
import 'package:jippin/style/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jippin/style/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui';

import 'package:jippin/pages/about.dart';
import 'package:jippin/pages/home.dart';
import 'package:jippin/pages/reviews.dart';
import 'package:jippin/pages/submit_review.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(
        fileName:
            ".env"); // This works for assets if configured properly in pubspec.yaml
  } catch (e) {
    print("Error loading .env file: $e");
  }
  String supabaseUrl = dotenv.env['SUPABASE_URL']!;
  String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = const Locale('en'); // Default fallback language

  @override
  void initState() {
    super.initState();
    _setDefaultLocale();
  }

  void _setDefaultLocale() {
    // Get the user's default locale
    //Locale deviceLocale = WidgetsBinding.instance.window.locale;
    Locale deviceLocale = PlatformDispatcher.instance.locale;
    print("Device Locale: $deviceLocale");

    // List of supported locales
    const List<Locale> supportedLocales = [
      Locale('en'), // English
      Locale('ko'), // Korean
    ];

    // Check if the device's locale is supported
    if (supportedLocales
        .any((locale) => locale.languageCode == deviceLocale.languageCode)) {
      _locale = deviceLocale; // Use the device's locale if supported
    } else {
      _locale = const Locale('en'); // Fallback to English if unsupported
    }
  }

  void setLocale(Locale? locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('ko'), // Korean
      ],
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: theme.lightHighContrast(),
      darkTheme: theme.darkHighContrast(),
      initialRoute: "/home",
      routes: {
        "/home": (context) =>
            MainNavigation(currentIndex: 0, onChangeLanguage: setLocale),
        "/reviews": (context) =>
            MainNavigation(currentIndex: 1, onChangeLanguage: setLocale),
        "/submit": (context) =>
            MainNavigation(currentIndex: 2, onChangeLanguage: setLocale),
        "/about": (context) =>
            MainNavigation(currentIndex: 3, onChangeLanguage: setLocale),
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<Locale?> onChangeLanguage;

  const MainNavigation(
      {Key? key, required this.currentIndex, required this.onChangeLanguage})
      : super(key: key);

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  // Web navigation
  final List<Widget> _pages = [
    HomePage(),
    ReviewsPage(),
    SubmitReviewPage(),
    AboutPage(),
  ];

  // Android navigation
  final List<BottomNavigationBarItem> _bottomnav = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.list),
      label: 'Reviews',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add),
      label: 'Submit',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _navigateTo(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: isAndroid
          ? AppBar(
              title: Text(AppLocalizations.of(context)!.appTitle),
              actions: [
                IconButton(onPressed: () => {}, icon: Icon(Icons.search)),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    // Handle menu item selection
                    switch (value) {
                      case 'Settings':
                        // Navigate to settings
                        print('Settings selected');
                        break;
                      case 'Help':
                        // Navigate to help
                        print('Help selected');
                        break;
                      case 'About':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutPage()),
                        );
                        break;
                      case 'Logout':
                        // Perform logout
                        print('Logout selected');
                        break;
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: 'Settings',
                        child: Text('Settings'),
                      ),
                      const PopupMenuItem(
                        value: 'Help',
                        child: Text('Help'),
                      ),
                      const PopupMenuItem(
                        value: 'About',
                        child: Text('About'),
                      ),
                      const PopupMenuItem(
                        value: 'Logout',
                        child: Text('Logout'),
                      ),
                    ];
                  },
                ),
              ],
            )
          : AdaptiveNavBar(
              screenWidth: screenWidth,
              logo: Row(
                children: [
                  Icon(Icons.home, size: 32, color: Colors.black87),
                  const SizedBox(width: 8),
                  MouseRegion(
                    cursor:
                        SystemMouseCursors.click, // Change cursor to pointer
                    child: GestureDetector(
                      onTap: () {
                        _navigateTo(0);
                      }, // Action when the title is clicked
                      child: Text(AppLocalizations.of(context)!.appTitle,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87)),
                    ),
                  ),
                ],
              ),
              navBarItems: [
                NavBarItem(
                    text: AppLocalizations.of(context)!.reviews,
                    onTap: () => _navigateTo(1)),
                if (screenWidth <= smallScreenWidth)
                  NavBarItem(
                      text: AppLocalizations.of(context)!.submitReview,
                      onTap: () => _navigateTo(2)),
                NavBarItem(
                    text: AppLocalizations.of(context)!.about,
                    onTap: () => _navigateTo(3)),
              ],
              onSubmitReview: () => _navigateTo(2),
              onChangeLanguage: widget.onChangeLanguage,
              currentLocale: Localizations.localeOf(context),
            ),
      body: _pages[_currentIndex],
      bottomNavigationBar: isAndroid
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _navigateTo,
              items: _bottomnav,
            )
          : null,
    );
  }
}
