import 'dart:async';

import 'package:chatnest/app/pages/status_screen/controllers/status_controller.dart';
import 'package:chatnest/data/repositories/status_repository.dart';
import 'package:chatnest/domain/services/user_safety_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/app/navigators/app_pages.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/app/widgets/floating_call_widget.dart';
import 'package:chatnest/device/repositories/device_repositories.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase and other services
  if (GetPlatform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCvW3Ud64vIqYcsjf7LiZHY3-SFmbfrIys",
        appId: "1:852697551916:android:e4b80eb56f19b84ff22d89",
        messagingSenderId: "852697551916",
        projectId: "co-chat-36393",
        storageBucket: "co-chat-36393.firebasestorage.app",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  await FirebaseApi.initilizeNotification();
  await FirebaseApi().initNotification();

  // Initialize Hive and other services
  await initServices();

  // Determine which route to start with after services are ready
  final Box safetyBox = Hive.box('safety');
  final bool eulaAccepted = safetyBox.get('eulaAccepted', defaultValue: false) as bool;
  final String startRoute = eulaAccepted ? Routes.splashScreen : Routes.eulaScreen;

  runApp(MyApp(initialRoute: startRoute));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.initialRoute = Routes.splashScreen});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: ColorsValue.primaryColor,
      ),
    );
    return ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(375, 745),
      builder: (context, child) => GetMaterialApp(
        locale: const Locale('en'),
        debugShowCheckedModeBanner: false,
        title: StringConstants.appName,
        theme: themeData(context),
        darkTheme: darkThemeData(context),
        themeMode: ThemeMode.light,
        getPages: AppPages.pages,
        // Use the computed initial route.
        initialRoute: initialRoute,
        translations: TranslationsFile(),
        navigatorKey: Get.key,
        enableLog: true,
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              const FloatingCallWidget(),
            ],
          );
        },
      ),
    );
  }
}

Future<void> initServices() async {
  await Hive.initFlutter();
  // Open a dedicated Hive box for safety data (EULA acceptance, reports, blocks)
  var safetyBox = await Hive.openBox('safety');
  // ==== Debug/Version migration ==== //
  // Ensure the EULA screen appears after a fresh install or when the app version changes.
  const String currentAppVersion = '1.0.0'; // keep in sync with pubspec.yaml
  final storedVersion = safetyBox.get('appVersion');
  if (storedVersion != currentAppVersion) {
    // Clear the acceptance flag so the guard will show the EULA again.
    await safetyBox.delete('eulaAccepted');
    await safetyBox.put('appVersion', currentAppVersion);
  }
  // ===================================== //
  // Register the UserSafetyService as a singleton with the opened box
  Get.put(UserSafetyService(safetyBox), permanent: true);

  // Hive.registerAdapter(DownloadTaskModelAdapter());

  // await Hive.openBox<DownloadTaskModel>('download_task_model');

  Get.put(
    Repository(
      Get.put(
        DeviceRepository(),
        permanent: true,
      ),
      Get.put(
          DataRepository(
            Get.put(
              ConnectHelper(),
              permanent: true,
            ),
          ),
          permanent: true),
    ),
  );

  /// 🔥 ADD THIS (STATUS FEATURE)
  Get.put<ApiWrapper>(ApiWrapper(), permanent: true);

  Get.put<StatusRepository>(
    StatusRepository(Get.find<ApiWrapper>()),
    permanent: true,
  );

  Get.put<StatusController>(
    StatusController(Get.find<StatusRepository>()),
    permanent: true,
  );

  /// Services
  await Get.putAsync(() => CommonService().init());
  await Get.putAsync(() => DbService().init());
  Get.put(CallManagerService(), permanent: true);
}

class DbService extends GetxService {
  Future<DbService> init() async {
    await Get.find<DeviceRepository>().init();
    return this;
  }
}
