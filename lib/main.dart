import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import 'core/api/api_client.dart';
import 'core/services/device_service.dart';
import 'core/services/logger_service.dart';
import 'core/storage/database_service.dart';
import 'core/storage/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/bindings/auth_binding.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/datasources/login_sync_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/views/login_screen.dart';
import 'features/main/bindings/main_shell_binding.dart';
import 'features/main/presentation/controllers/main_shell_controller.dart';
import 'features/main/presentation/views/main_shell_screen.dart';
import 'features/menu/bindings/manage_items_binding.dart';
import 'features/menu/presentation/views/manage_items_screen.dart';
import 'features/profile/bindings/profile_binding.dart';
import 'features/profile/presentation/views/profile_screen.dart';
import 'features/share/bindings/share_binding.dart';
import 'features/share/presentation/views/terms_condition_master_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Screen orientation lock
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Firebase initialization
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (_) {}

  // Core Service Dependencies Initialization
  await Get.putAsync(() => LoggerService().init());
  final storageService = await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => DatabaseService().init());
  await Get.putAsync(() => DeviceService(storageService).init());
  final apiClient = Get.put(ApiClient());

  Get.put<AuthRemoteDataSource>(AuthRemoteDataSourceImpl(apiClient));
  Get.put<AuthRepository>(AuthRepositoryImpl(Get.find<AuthRemoteDataSource>(), storageService, apiClient));
  Get.put<LoginSyncRemoteDataSource>(LoginSyncRemoteDataSourceImpl(apiClient));
  Get.put<LoginSyncRepository>(LoginSyncRepositoryImpl(Get.find<LoginSyncRemoteDataSource>(), storageService));

  runApp(const ERestoMenuApp());
}

class ERestoMenuApp extends StatelessWidget {
  const ERestoMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = Get.find<StorageService>();
    final hasToken = storageService.isLoggedIn;

    return ToastificationWrapper(
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: 'eResto Menu',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: hasToken ? '/main' : '/login',
            getPages: [
              GetPage(
                name: '/login',
                page: () => const LoginScreen(),
                binding: AuthBinding(),
              ),
              GetPage(
                name: '/main',
                page: () => const MainShellScreen(),
                binding: MainShellBinding(),
              ),
              GetPage(
                name: '/dashboard',
                page: () {
                  if (Get.isRegistered<MainShellController>()) {
                    Get.find<MainShellController>().changeTab(0);
                  }
                  return const MainShellScreen();
                },
                binding: MainShellBinding(),
              ),
              GetPage(
                name: '/items',
                page: () {
                  if (Get.isRegistered<MainShellController>()) {
                    Get.find<MainShellController>().changeTab(1);
                  }
                  return const MainShellScreen();
                },
                binding: MainShellBinding(),
              ),
              GetPage(
                name: '/menu',
                page: () {
                  if (Get.isRegistered<MainShellController>()) {
                    Get.find<MainShellController>().changeTab(2);
                  }
                  return const MainShellScreen();
                },
                binding: MainShellBinding(),
              ),
              GetPage(
                name: '/menu/manage-items',
                page: () => const ManageItemsScreen(),
                binding: ManageItemsBinding(),
              ),
              GetPage(
                name: '/share',
                page: () {
                  if (Get.isRegistered<MainShellController>()) {
                    Get.find<MainShellController>().changeTab(3);
                  }
                  return const MainShellScreen();
                },
                binding: MainShellBinding(),
              ),
              GetPage(
                name: '/profile',
                page: () => const ProfileScreen(),
                binding: ProfileBinding(),
              ),
              GetPage(
                name: '/terms-master',
                page: () => const TermsConditionMasterScreen(),
                binding: ShareBinding(),
              ),
            ],
          );
        },
      ),
    );
  }
}
