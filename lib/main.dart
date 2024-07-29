import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_task/config/app_colors.dart';
import 'package:flutter_task/config/app_page_routes.dart';
import 'package:flutter_task/providers/auth_provider.dart';
import 'package:flutter_task/providers/product_provider.dart';
import 'package:flutter_task/services/remote_config_service.dart';
import 'package:flutter_task/utils/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferenceHelper.preferences = await SharedPreferences.getInstance();

  // Check if the Firebase app is already initialized
  if (Firebase.apps.isNotEmpty) {
    // If the app is already initialized, use the existing instance
    FirebaseApp app = Firebase.apps.first;
  } else {
    // If the app is not initialized, initialize it
    await Firebase.initializeApp();
  }
  final remoteConfigService = RemoteConfigService();
  try {
    await remoteConfigService.initialize();
  } catch (e) {
    log(" remoteConfigService >>$e");
  }

  runApp(
    MyApp(remoteConfigService: remoteConfigService),
  );
}

class MyApp extends StatefulWidget {
  final RemoteConfigService remoteConfigService;

  const MyApp({Key? key, required this.remoteConfigService}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(
            create: (context) => ProductProvider(
              widget.remoteConfigService,
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'E-Shop',
          themeMode: ThemeMode.light,
          theme: ThemeData(
            fontFamily: "Poppins",
            primaryColor: AppColors.primaryColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryColor,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.primaryColor,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              actionsIconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
            useMaterial3: true,
            canvasColor: Colors.white,
            scaffoldBackgroundColor: AppColors.scaffoldBGColor,
          ),
          routerConfig: AppPages.router,
          // routerDelegate: AppPages.router.routerDelegate,
          // routeInformationParser: AppPages.router.routeInformationParser,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
