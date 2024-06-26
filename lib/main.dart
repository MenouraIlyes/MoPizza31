import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mopizza/firebase_options.dart';
import 'package:mopizza/models/restaurant_provider.dart';
import 'package:mopizza/screens/splash_screen.dart';
import 'package:mopizza/services/phone_verification_provider.dart';
import 'package:mopizza/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        // theme provider
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        // restaurant provider
        ChangeNotifierProvider(
          create: (context) => Restaurant(),
        ),
        // Auth or Phone number provider
        ChangeNotifierProvider(
          create: (context) => PhoneVerification(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SPlashScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
