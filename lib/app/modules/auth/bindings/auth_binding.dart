import 'package:get/get.dart';
import 'package:wayaak_delivery/app/modules/auth/providers/auth_provider.dart';
// import 'package:qor3a/app/data/providers/auth_providers.dart';

import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthProviders>(() => AuthProviders());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
