import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:collabin/core/common/app_navigator.dart';
import 'package:collabin/feature/splash_screen/splash_screen.dart';
import 'package:collabin/core/service/notification_service.dart';
import 'package:collabin/feature/notification/bloc/notification_bloc.dart';
import 'package:collabin/feature/notification/service/notification_service.dart'
    as feature_service;
import 'firebase_options.dart';

Future<void> main() async {
  await _bootstrap();
}

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Font Poppins sudah dibundel di assets/fonts → jangan unduh dari internet.
  GoogleFonts.config.allowRuntimeFetching = false;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final bool crashlyticsSupported =
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  if (crashlyticsSupported) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      kReleaseMode,
    );
  }

  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
    !kIsWeb && kReleaseMode,
  );

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (crashlyticsSupported) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (crashlyticsSupported) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } else {
      debugPrint('Uncaught platform error: $error\n$stack');
    }
    return true;
  };

  // Inisialisasi Firebase Messaging (aman bila gagal di Web)
  try {
    await NotificationService.instance.initialize();
  } catch (e, stack) {
    debugPrint('NotificationService init skipped/failed: $e\n$stack');
  }

  // Inisialisasi Google Sign-In (aman bila gagal di Web)
  try {
    await GoogleSignIn.instance.initialize();
  } catch (e, stack) {
    debugPrint('GoogleSignIn init skipped/failed: $e\n$stack');
  }

  runZonedGuarded(
    () {
      runApp(const MyApp());
    },
    (error, stack) {
      if (crashlyticsSupported) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      } else {
        debugPrint('Uncaught zone error: $error\n$stack');
      }
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationBloc>(
          create: (context) =>
              NotificationBloc(feature_service.NotificationService()),
        ),
      ],
      child: MaterialApp(
        navigatorKey: appNavigatorKey,
        title: 'Collabin',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: false,
          fontFamily: 'Poppins',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
