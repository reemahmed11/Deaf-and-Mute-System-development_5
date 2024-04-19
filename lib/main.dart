//import 'dart:js';

import 'package:deaf_mute_system/edit_profile/screen.dart';
import 'package:deaf_mute_system/profile/profile_screen.dart';
import 'package:deaf_mute_system/user/app_config_provider.dart';
import 'package:deaf_mute_system/user/setting.dart';
import 'package:provider/provider.dart';

import 'authentication/login_screen.dart';
import 'clerk_screen.dart';
import 'controller/sos_screen.dart';
import 'ministries/civil_protection.dart';
import 'ministries/health.dart';
import 'ministries/interior.dart';
import 'ministries/nas.dart';
import 'authentication/signup_screen.dart';
import 'feedback.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authentication/firebase_options.dart';
import 'splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  cameras = await availableCameras();
  runApp(ChangeNotifierProvider(
      create: (context) => AppConfigProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return MaterialApp(
      title: 'Sign Safe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        SignupScreen.routeName: (context) => const SignupScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SOSScreen.routeName: (context) => const SOSScreen(),
        HealthScreen.routeName: (context) => HealthScreen(),
        InteriorScreen.routeName: (context) => InteriorScreen(),
        CivilProtection.routeName: (context) => CivilProtection(),
        NasScreen.routeName: (context) => NasScreen(),
        ClerkScreen.routeName: (context) => ClerkScreen(),
        FeedbackScreen.routeName: (context) => const FeedbackScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        NewSetting.routeName: (context) => NewSetting(),
        EditProfileScreen.routeName: (context) => const EditProfileScreen(),
      },
      //home: EditProfileScr5een(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      locale: Locale(provider.appLanguage),
    );
  }
}
