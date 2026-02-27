import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'features/core/data/cache/hive_db_services.dart';
import 'app/flavours/app_config.dart';
import 'features/core/domain/di/service_locator.dart';
import 'features/core/presentation/routes/app_router.dart';
import 'features/core/presentation/routes/app_routes.dart';
import 'features/police_contacts/domain/usecases/police_contacts_usecase.dart';
import 'features/police_contacts/presentation/bloc/police_contacts_bloc.dart';
import 'services/navigation/navigation_service.dart';

RandomAccessFile? _lockFile;

Future<bool> ensureSingleInstance() async {
  if (!Platform.isWindows) {
    return true;
  }
  final appData = Platform.environment['APPDATA'];
  if (appData == null) {
    return true;
  }
  final dir = Directory('$appData\\contact_directory_app');

  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  final file = File('${dir.path}\\app.lock');

  try {
    _lockFile = await file.open(mode: FileMode.write);
    await _lockFile!.lock(FileLock.exclusive);
    return true;
  } catch (e) {
    return false;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Handle single instance on Windows
  if (!await ensureSingleInstance()) {
    exit(0);
  }

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize AppConfig and ServiceLocator
  appConfig.loadData({
    'API_BASE_URL': 'https://api.example.com',
    'API_VERSION': 'v1',
    'APP_DEBUG': 'true',
    'DEFAULT_LOCALE': 'en',
  });
  ServiceLocator().init(appConfig: appConfig);

  // Initialize DB
  await HiveDBServices.instance.init();

  // Optional: Firebase initialization
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase not initialized: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => serviceLocator.get<PoliceContactsUseCase>(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                PoliceContactsBloc(RepositoryProvider.of<PoliceContactsUseCase>(context)),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Police Contacts',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              ),
              initialRoute: AppRoutes.home,
              navigatorKey: NavigationService.navigatorKey,
              onGenerateRoute: AppRouter.generateRoute,
            );
          },
        ),
      ),
    );
  }
}
