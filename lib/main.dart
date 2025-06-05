import 'package:flutter/material.dart';
import 'package:jippin/providers/review_query_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jippin/gen/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jippin/theme/theme.dart';
import 'package:jippin/providers/locale_provider.dart';
import 'package:jippin/models/language.dart';
import 'package:jippin/router.dart';
import 'package:flutter/gestures.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;

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

  await GRecaptchaV3.ready(dotenv.env['GOOGLE_RECAPTCHA_SITE_KEY']!);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ReviewQueryProvider()),
      ],
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
    final TextTheme textTheme = GoogleFonts.notoSansKrTextTheme();
    final MaterialTheme materialTheme = MaterialTheme(textTheme);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      supportedLocales: languages.values.map((lang) => lang.locale).toList(),
      localizationsDelegates: [
        AppLocalizations.delegate, // Generated localization
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: materialTheme.lightHighContrast(),
      //darkTheme: materialTheme.darkHighContrast(),
      themeMode: ThemeMode.light,
      // Disables dark mode
      routerConfig: createRouter(localeProvider), // Use the external router function
    );
  }
}
