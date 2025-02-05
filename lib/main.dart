import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:jippin/utility/theme.dart';
import 'package:jippin/locale_provider.dart';
import 'package:jippin/component/main_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env"); // This works for assets if configured properly in pubspec.yaml
  } catch (e) {
    debugPrint("Error loading .env file: $e");
  }
  String supabaseUrl = dotenv.env['SUPABASE_URL']!;
  String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      //_locale,
      supportedLocales: const [
        Locale('en'), // English
        Locale('ko'), // Korean
      ],
      localizationsDelegates: [
        AppLocalizations.delegate, // Generated localization
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: theme.lightHighContrast(),
      darkTheme: theme.darkHighContrast(),
      initialRoute: "/home",
      routes: {
        "/home": (context) => MainNavigation(currentIndex: 0, localeProvider: localeProvider),
        "/reviews": (context) => MainNavigation(currentIndex: 1, localeProvider: localeProvider),
        "/submit": (context) => MainNavigation(currentIndex: 2, localeProvider: localeProvider),
        "/about": (context) => MainNavigation(currentIndex: 3, localeProvider: localeProvider),
      },
    );
  }
}
